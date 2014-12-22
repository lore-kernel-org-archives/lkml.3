Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaLVWsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:48:03 -0500
Received: from plane.gmane.org ([80.91.229.3]:38122 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaLVWsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:48:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Cleaning up the KVM clock
Date: Mon, 22 Dec 2014 23:47:40 +0100
Message-ID: <54989F8C.3030602@redhat.com>
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com> <20141222133430.GA23631@amt.cnet> <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: net-2-35-193-40.cust.vodafonedsl.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/12/2014 17:03, Andy Lutomirski wrote:
> 
> This is wrong.  The guest *kernel* might not see the intermediate
> state because the kernel (presumably it disabled migration while
> reading pvti), but the guest vdso can't do that and could very easily
> observe pvti while it's being written.

No.  kvm_guest_time_update is called by vcpu_enter_guest, while the vCPU
is not running, so it's entirely atomic from the point of view of the guest.

> I'll send patches for the whole mess, complete with lots of comments,
> after I test them a bit today.

Ok, some comments can certainly help the discussion.

Paolo

