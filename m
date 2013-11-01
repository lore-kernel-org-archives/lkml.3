Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3KANVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:21:10 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63918 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3KANVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <20131101130702.GA3348@8bytes.org>
References: <CA+MoWDqoBxuFhBsf_rVBT1C8=mwj02hXgPfuWnjY4yeVa-84cA@mail.gmail.com>
	<20131101130702.GA3348@8bytes.org>
Date: Fri, 1 Nov 2013 14:21:07 +0100
Message-ID: <CA+MoWDoDTFarOLUHgNmUFksRvV-R+7jufUwLbsS8ecaO+_m2kQ@mail.gmail.com>
Subject: Re: VT-d and x2apic: broken resume after suspend to ram
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 2:07 PM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Peter,
>
> On Fri, Nov 01, 2013 at 01:37:36PM +0100, Peter Senna Tschudin wrote:
>> I have one notebook that is failing to resume after suspend to ram.
>> I've filled a bug report back on the 2.6.41 days:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=787299
>>
>> The issue is that trying to resume after suspending to ram freezes the
>> computer. The resume starts well, but then it hangs.
>>
>> Yesterday I found that this may be related to VT-d / x2apic. If I
>> disable VT-d on the BIOS, suspend / resume works fine. If I enable
>> VT-d and pass nox2apic as boot parameter to Kernel suspend and resume
>> works fine. I would like some pointers to fix this issue. Can you help
>> me?
>>
>> Only when I have VT-d enabled, dmesg gives me additional output:
>> [    0.023913] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
>> [    0.024080] Enabled IRQ remapping in x2apic mode
>> [    0.024081] Enabling x2apic
>> [    0.024082] Enabled x2apic
>> [    0.024087] Switched APIC routing to cluster x2apic.
>>
>> The notebook is Toshiba R830-10p with i7-2620M.
>
> Which kernels have you tried? Does it happen with all of them or is
> there a kernel-version where this started?

I'm using 3.11.6-200.fc19.x86_64. I always had VT-d enabled, and
suspend / resume never worked on Linux. I did not know that disabling
VT-d could be a workaround to the resume issue until yesterday.

Does this have anything in common to:
https://bugzilla.redhat.com/show_bug.cgi?id=752613

>
>
>         Joerg
>
>



-- 
Peter
