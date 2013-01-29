Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3A2Hrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:47:53 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36001 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3A2Hru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:47:50 -0500
Date: Tue, 29 Jan 2013 08:47:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
Message-ID: <20130129074746.GA594@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Jan 28, 2013 at 2:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >> HP has systems that work with x2apic phys mode and BIOS set
> >> ACPI_FADT_APIC_PHYSICAL in FADT table, and all cpuid < 255,
> >> the spec requires BIOS only put system on xapic mode. Kernel
> >
> > Which spec?
> >
> >> will set to x2apic logical mode instead of x2apic phys mode.
> >
> > Which has exactly what bad effect on users of these systems?
> >
> > You left out the most important information from the changelog:
> > why do users care, what good does the patch do?
> 
> please check you are happy with this:
> 
> ---
> From:   Stoney Wang <song-bo.wang@hp.com>
> Subject: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
> 
> HP has systems that only work with x2apic phys mode and BIOS set
> ACPI_FADT_APIC_PHYSICAL in FADT table. But all apicid < 255,
> according to x2apic-spec, chapter 2.9, BIOS need to pass the control
> to the OS with xapic mode.
> Kernel will set apic driver wrong to x2apic cluster instead of x2apic phys.
> 
> The user will have to append nox2apic in boot command line to stay xapic mode,
> or append x2apic_phys to switch to x2apic phys mode.

This still does not explain what happens if none of this user 
action is taken. I.e. what exact _user visible problem_ does the 
patch fix?

Is this really so unimportant to you? Almost everyone will start 
a changelog with explaining what badness happens. Not you - you 
explain everything from how the fix works to how to work around 
the bug - except describing the most important thing: theuser 
visible problem itself ... Weird.

Thanks,

	Ingo
