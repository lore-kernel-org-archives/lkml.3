Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaGGMPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:15:16 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36364 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaGGMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:15:13 -0400
Date: Mon, 7 Jul 2014 15:15:05 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it is
 migrated.
Message-ID: <20140707121505.GQ18167@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com>
 <20140703135507.GM18167@minantech.com>
 <53B60EF1.6030307@cn.fujitsu.com>
 <20140704101310.GE4399@minantech.com>
 <53BA6DD3.9040400@cn.fujitsu.com>
 <53BA87A3.5020205@gmail.com>
 <20140707115446.GP18167@minantech.com>
 <53BA8E2F.9000200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BA8E2F.9000200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:10:23PM +0300, Nadav Amit wrote:
> On 7/7/14, 2:54 PM, Gleb Natapov wrote:
> >On Mon, Jul 07, 2014 at 02:42:27PM +0300, Nadav Amit wrote:
> >>Tang,
> >>
> >>Running some (unrelated) tests I see that KVM does not handle APIC base
> >>relocation correctly. When the base is changed, kvm_lapic_set_base just
> >>changes lapic->base_address without taking further action (i.e., modifying
> >>the VMCS apic address in VMX).
> >>
> >>This patch follows KVM bad behavior by using the constant
> >>VMX_APIC_ACCESS_PAGE_ADDR instead of lapic->base_address.
> >There is no OS out there that relocates APIC base (in fact it was not always
> >relocatable on real HW), so there is not point in complicating the code to support
> >it. In fact current APIC_ACCESS_ADDR handling relies on the fact that all vcpus
> >has apic mapped at the same address.
> >
> >>
> >>Anyhow, I didn't see anything that would make my life (in fixing the lapic
> >>base issue) too difficult. Yet, feel free in making it more "fix-friendly".
> >>
> >Why would you want to fix it?
> >
> If there is no general need, I will not send a fix. However, I think the
It is much more works that it may look like for no apparent gain.

> very least a warning message should be appear if the guest relocates the
> APIC base.
> 
Warning is fine. Make it _once().

--
			Gleb.
