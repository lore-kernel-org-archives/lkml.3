Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaJFQMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:12:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2281 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaJFQMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:12:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 06 Oct 2014 09:10:52 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
Thread-Topic: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
Thread-Index: AQHP1o7ln/2GHwUnqkWm/7z0JBMChZwNg2cAgApja8CAAGS6AIADOSDwgAANwwCAB0QhwIAAcnyAgAAJtpA=
Date: Mon, 6 Oct 2014 16:12:30 +0000
Message-ID: <20d267b9f02645828af53c72110a4bcb@bgmail104.nvidia.com>
References: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
 <5420731E.6040104@wwwdotorg.org>
 <1862760b05184b95948b5e4952db010d@bgmail103.nvidia.com>
 <54297E7E.1030306@wwwdotorg.org>
 <96955607a8414f75bb4110ebef5daa37@bgmail103.nvidia.com>
 <542C3E34.2060505@wwwdotorg.org>
 <bd1591558b59409faf9edfd3eba2523e@bgmail104.nvidia.com>
 <20141006153456.GB23362@ulmo>
In-Reply-To: <20141006153456.GB23362@ulmo>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.25.3.150]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thierry Reding [mailto:thierry.reding@gmail.com]
> Sent: Monday, October 06, 2014 9:05 PM
> To: Vidya Sagar
> Cc: Stephen Warren; Laxman Dewangan; Krishna Thota; linux-
> tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
> tree
> 
> * PGP Signed by an unknown key
> 
> On Mon, Oct 06, 2014 at 08:49:35AM +0000, Vidya Sagar wrote:
> >
> >
> > > -----Original Message-----
> > > From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > > Sent: Wednesday, October 01, 2014 11:18 PM
> > > To: Vidya Sagar
> > > Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
> > > tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > > kernel@vger.kernel.org
> > > Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1
> > > device tree
> > >
> > > On 10/01/2014 11:13 AM, Vidya Sagar wrote:
> > > >
> > > >
> > > >> -----Original Message-----
> > > >> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > > >> Sent: Monday, September 29, 2014 9:15 PM
> > > >> To: Vidya Sagar
> > > >> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota;
> > > >> linux- tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > > >> kernel@vger.kernel.org
> > > >> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson
> > > >> TK1 device tree
> > > >>
> > > >> On 09/29/2014 04:25 AM, Vidya Sagar wrote:
> > > >>>
> > > >>>> -----Original Message-----
> > > >>>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > > >>>> Sent: Tuesday, September 23, 2014 12:36 AM
> > > >>>> To: Vidya Sagar
> > > >>>> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota;
> > > >>>> linux- tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > > >>>> kernel@vger.kernel.org
> > > >>>> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson
> > > >>>> TK1 device tree
> > > >>>>
> > > >>>> On 09/22/2014 11:57 AM, Vidya Sagar wrote:
> > > >>>>> sd4 is an always on regulator which is turned on at boot time.
> > > >>>>> It is externally controller through gpio. This change reflects
> > > >>>>> the same in Jetson TK1 device tree
> > > >>>>
> > > >>>> In the schematics, the "Power Sequencing" timing diagram says
> > > >>>> "S/W controlled" for SD4/+1.05V_RUN. I also don't see an
> > > >>>> "ENABLE1" pin on the AS3722, which would be required for ...
> > > >>
> > > >> Can you please comment on this aspect of the issue?
> > > >>
> > > >>>>> +					ams,ext-control = <1>;
> > > >>>>
> > > >>>> ... to be valid.
> > > >>>>
> > > >>>> What's the source of information behind this change?
> > > >>>>
> > > >>>> What symptoms does this patch correct?
> > > >>>
> > > >>> I'm seeing one issue when I add support for PCIe suspend/resume
> > > >> functionality.
> > > >>> The issue is that, when regulator_bulk_diable() is called,
> > > >>> disabling one of
> > > >> the power rails (which is deriving its voltage from SD4) of PCIe is
> failing.
> > > >>> The reason being, I2C controller is getting power gated
> > > >>
> > > >> Why is the fix being applied to SD4 if the issue is with a power
> > > >> rail derived from SD4? Shouldn't any fix be applied directly to
> > > >> the problematic rail rather than some parent rail?
> > > >>
> > > >> Since the I2C controller is part of the SoC and we don't have
> > > >> power domain support yet, the only way the I2C controller can get
> > > >> power gated is when the SoC as a whole is turned off.
> > > >>
> > > >>   > before power rail disable is called.
> > > >>
> > > >> ... so without making SD4 dependant on ext-control, since no SW
> > > >> can be running at this point, the only way SD4 could get turned
> > > >> off is that the PMIC turns it off itself at the appropriate point
> > > >> in the system power sequence based on its OTP programming, or the
> > > >> board HW is already set up to turn off
> > > >> SD4 at the appropriate time somehow. Is that not happening?
> > > >> That would imply incorrect PMIC programming wouldn't it?
> > > >>
> > > >
> > > > After some debugging, found that the I2C driver's suspend is
> > > > getting called before the suspend of PCIe is called (BTW, PCie has
> > > > suspend_noirq..!) Hence, when PCIe driver wants to disable
> > > > regulators it
> > > fails because of I2C write failure, which is expected given I2C is
> > > already suspended.
> > >
> > > Ah. It sounds like the PCIe driver should have a regular suspend
> > > function not a suspend_noirq function then. It's certainly expected
> > > that resources behind an I2C bus (i.e. most regulators) can't be
> > > manipulated in a suspend_noirq function.
> > >
> >
> > PCIe host controller driver can't have regular suspend function,
> > because, PCI subsystem has its own suspend_noirq which tries to read
> > Config registers of the connected PCIe devices, which in turn results
> > in hang (because host controller would have been suspended by
> > then...!)
> 
> I'd consider it a bug for the PCI core to try to access configuration space when
> the host controller has been suspended, so I'd say this needs to be fixed
> somewhere else.
> 
> Can you point out which function does this so that I can help coming up with
> a more suitable fix?
> 

This is the flow causing Config reads to take place in suspend_noirq path.
pm_suspend -> suspend_devices_and_enter -> dpm_suspend_end ->
dpm_run_callback -> pci_pm_suspend_noirq -> pci_save_state -> pci_bus_read_config_dword


> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
