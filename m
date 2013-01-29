Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3A2Int (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:43:49 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31402 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3A2Ins convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:43:48 -0500
From: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
To: "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: RE: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Topic: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Index: AQHN8sLbtrSsPj2mD0qoH/EbzuNDVZheOwHggAAo+YCAADY0gIAAhbwAgADkawCAAAizQA==
Date: Tue, 29 Jan 2013 08:43:10 +0000
Message-ID: <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
 <20130129074746.GA594@gmail.com>
In-Reply-To: <20130129074746.GA594@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Tuesday, January 29, 2013 3:48 PM
> To: Yinghai Lu
> Cc: Wang, Song-Bo (Stoney); H. Peter Anvin; Ingo Molnar; Thomas
> Gleixner; Zhang, Lin-Bao (Linux Kernel R&D); Pearson, Greg; linux-
> kernel@vger.kernel.org; suresh.b.siddha@intel.com
> Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
> 
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > On Mon, Jan 28, 2013 at 2:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > >> HP has systems that work with x2apic phys mode and BIOS set
> > >> ACPI_FADT_APIC_PHYSICAL in FADT table, and all cpuid < 255, the
> > >> spec requires BIOS only put system on xapic mode. Kernel
> > >
> > > Which spec?
> > >
> > >> will set to x2apic logical mode instead of x2apic phys mode.
> > >
> > > Which has exactly what bad effect on users of these systems?
> > >
> > > You left out the most important information from the changelog:
> > > why do users care, what good does the patch do?
> >
> > please check you are happy with this:
> >
> > ---
> > From:   Stoney Wang <song-bo.wang@hp.com>
> > Subject: [PATCH] x86, apic: Check fadt x2apic phys in
> > x2apic_phys_probe()
> >
> > HP has systems that only work with x2apic phys mode and BIOS set
> > ACPI_FADT_APIC_PHYSICAL in FADT table. But all apicid < 255,
> according
> > to x2apic-spec, chapter 2.9, BIOS need to pass the control to the OS
> > with xapic mode.
> > Kernel will set apic driver wrong to x2apic cluster instead of x2apic
> phys.
> >
> > The user will have to append nox2apic in boot command line to stay
> > xapic mode, or append x2apic_phys to switch to x2apic phys mode.
> 
> This still does not explain what happens if none of this user action is
> taken. I.e. what exact _user visible problem_ does the patch fix?
> 
> Is this really so unimportant to you? Almost everyone will start a
> changelog with explaining what badness happens. Not you - you explain
> everything from how the fix works to how to work around the bug -
> except describing the most important thing: theuser visible problem
> itself ... Weird.
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

The HW requires x2apic physical mode, and if we do not apply this patch, the OS will follow into x2apic cluster mode by default.
Due to this mode mismatch, with specific HW configurations, there will be intermittent lost interrupts, which could result in a hang or data loss.

Logically, there is a mismatch because the kernel missed detection on HW configurations, and we should fix it, right?
Do we need more detailed information?

Thanks,

    Stoney
