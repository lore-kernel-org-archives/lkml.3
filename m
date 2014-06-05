Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFEMcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:32:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaFEMct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:32:49 -0400
Message-ID: <5390636D.2090809@suse.de>
Date: Thu, 05 Jun 2014 14:32:45 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>	 <1401953144-19186-4-git-send-email-aik@ozlabs.ru>	 <1401953908.3247.121.camel@pasglop> <539037DB.5080706@ozlabs.ru>	 <1401964037.3247.129.camel@pasglop> <53905ADB.8000100@suse.de> <1401971411.3247.132.camel@pasglop>
In-Reply-To: <1401971411.3247.132.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.06.14 14:30, Benjamin Herrenschmidt wrote:
> On Thu, 2014-06-05 at 13:56 +0200, Alexander Graf wrote:
>> What if we ask user space to give us a pointer to user space allocated
>> memory along with the TCE registration? We would still ask user space to
>> only use the returned fd for TCE modifications, but would have some
>> nicely swappable memory we can store the TCE entries in.
> That isn't going to work terribly well for VFIO :-) But yes, for
> emulated devices, we could improve things a bit, including for
> the 32-bit TCE tables.
>
> For emulated, the real mode path could walk the page tables and fallback
> to virtual mode & get_user if the page isn't present, thus operating
> directly on qemu memory TCE tables instead of the current pinned stuff.
>
> However that has a cost in performance, but since that's really only
> used for emulated devices and PAPR VIOs, it might not be a huge issue.
>
> But for VFIO we don't have much choice, we need to create something the
> HW can access.

But we need to create separate tables for VFIO anyways, because these 
TCE tables contain virtual addresses, no?


Alex

>
>> In fact, the code as is today can allocate an arbitrary amount of pinned
>> kernel memory from within user space without any checks.
> Right. We should at least account it in the locked limit.
>
> Cheers,
> Ben.
>
>

