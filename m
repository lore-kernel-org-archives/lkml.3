Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaGQN5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:57:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:52837 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaGQN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:57:13 -0400
Date: Thu, 17 Jul 2014 16:57:08 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, mtosatti@redhat.com, nadav.amit@gmail.com,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in
 memory.
Message-ID: <20140717135707.GP4399@minantech.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
 <20140712080442.GH4399@minantech.com>
 <53C38D55.2040307@cn.fujitsu.com>
 <20140714145822.GK4399@minantech.com>
 <53C51608.4080109@web.de>
 <20140715120921.GT18167@minantech.com>
 <53C51E66.7030208@cn.fujitsu.com>
 <20140715124048.GU18167@minantech.com>
 <53C7D0DC.1020001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7D0DC.1020001@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:34:20PM +0800, Tang Chen wrote:
> Hi Gleb,
> 
> On 07/15/2014 08:40 PM, Gleb Natapov wrote:
> ......
> >>
> >>And yes, we have the problem you said here. We can migrate the page while L2
> >>vm is running.
> >>So I think we should enforce L2 vm to exit to L1. Right ?
> >>
> >We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
> >if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
> >
> 
> Sorry, I think I don't quite understand the procedure you are talking about
> here.
> 
> Referring to the code, I think we have three machines: L0(host), L1 and L2.
> And we have two types of vmexit: L2->L1 and L2->L0.  Right ?
> 
> We are now talking about this case: L2 and L1 shares the apic page.
> 
> Using patch 5/5, when apic page is migrated on L0, mmu_notifier will notify
> L1,
> and update L1's VMCS. At this time, we are in L0, not L2. Why cannot we
Using patch 5/5, when apic page is migrated on L0, mmu_notifier will notify
L1 or L2 VMCS depending on which one happens to be running right now.
If it is L1 then L2's VMCS will be updated during vmentry emulation, if it is
L2 we need to request reload during vmexit emulation to make sure L1's VMCS is
updated.

--
			Gleb.
