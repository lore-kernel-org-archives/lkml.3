Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaFEL4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:56:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaFEL4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:56:16 -0400
Message-ID: <53905ADB.8000100@suse.de>
Date: Thu, 05 Jun 2014 13:56:11 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>	 <1401953144-19186-4-git-send-email-aik@ozlabs.ru>	 <1401953908.3247.121.camel@pasglop> <539037DB.5080706@ozlabs.ru> <1401964037.3247.129.camel@pasglop>
In-Reply-To: <1401964037.3247.129.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.06.14 12:27, Benjamin Herrenschmidt wrote:
> On Thu, 2014-06-05 at 19:26 +1000, Alexey Kardashevskiy wrote:
>> No trees yet. For 64GB window we need (64<<30)/(16<<20)*8 = 32K TCE table.
>> Do we really need trees?
> The above is assuming hugetlbfs backed guests. These are the least of my worry
> indeed. But we need to deal with 4k and 64k guests.

What if we ask user space to give us a pointer to user space allocated 
memory along with the TCE registration? We would still ask user space to 
only use the returned fd for TCE modifications, but would have some 
nicely swappable memory we can store the TCE entries in.

In fact, the code as is today can allocate an arbitrary amount of pinned 
kernel memory from within user space without any checks.


Alex

