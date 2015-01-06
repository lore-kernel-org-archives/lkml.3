Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbbAFOiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:38:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55987 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbbAFOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:38:20 -0500
From: "Charles Garcia-Tobin" <charles.garcia-tobin@arm.com>
To: "Catalin Marinas" <Catalin.Marinas@arm.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>, <hanjun.guo@linaro.org>,
        "Mark Rutland" <Mark.Rutland@arm.com>, <linaro-acpi@lists.linaro.org>,
        "Will Deacon" <Will.Deacon@arm.com>, "Lv Zheng" <lv.zheng@intel.com>,
        "Rob Herring" <robh@kernel.org>,
        "Lorenzo Pieralisi" <Lorenzo.Pieralisi@arm.com>,
        "Al Stone" <al.stone@linaro.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Robert Moore" <robert.moore@intel.com>, <linux-acpi@vger.kernel.org>,
        <jcm@redhat.com>, <grant.likely@linaro.org>,
        "Robert Richter" <rric@kernel.org>,
        "Jason Cooper" <jason@lakedaemon.net>,
        "Marc Zyngier" <Marc.Zyngier@arm.com>,
        "Liviu Dudau" <Liviu.Dudau@arm.com>, "Mark Brown" <broonie@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <graeme.gregory@linaro.org>,
        <Kangkang.Shen@huawei.com>, "Randy Dunlap" <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-kernel@vger.kernel.org>, "Sudeep Holla" <Sudeep.Holla@arm.com>,
        "Olof Johansson" <olof@lixom.net>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <54ABC2CB.6@linaro.org> <20150106112929.GB8829@e104818-lin.cambridge.arm.com> <2647669.mQf6pODdjV@wuerfel> <20150106141630.GG8829@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150106141630.GG8829@e104818-lin.cambridge.arm.com>
Subject: RE: [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Tue, 6 Jan 2015 14:37:58 -0000
Message-ID: <000d01d029be$5ff967d0$1fec3770$@arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdApu2dAQ/qk54t+R8WKJdX+vWVJcwAAg8kQ
Content-Language: en-gb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: 06 January 2015 14:17
> To: Arnd Bergmann
> Cc: linux-arm-kernel@lists.infradead.org; hanjun.guo@linaro.org; Mark
> Rutland; linaro-acpi@lists.linaro.org; Will Deacon; Lv Zheng; Rob
> Herring; Lorenzo Pieralisi; Al Stone; Daniel Lezcano; Robert Moore;
> linux-acpi@vger.kernel.org; jcm@redhat.com; grant.likely@linaro.org;
> Charles Garcia-Tobin; Robert Richter; Jason Cooper; Marc Zyngier; Liviu
> Dudau; Mark Brown; Bjorn Helgaas; graeme.gregory@linaro.org;
> Kangkang.Shen@huawei.com; Randy Dunlap; Rafael J. Wysocki; linux-
> kernel@vger.kernel.org; Sudeep Holla; Olof Johansson
> Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
> 
> On Tue, Jan 06, 2015 at 02:05:12PM +0000, Arnd Bergmann wrote:
> > On Tuesday 06 January 2015 11:29:29 Catalin Marinas wrote:
> > > > >> We will work on this both on ASWG and linux ACPI driver side,
> as Dong
> > > > >> and Charles pointed out, _OSI things can be solved in ACPI
> spec, when
> > > > >> that is done, we can modify the kernel driver to fix the
> problems above.
> > > > >
> > > > > Which driver?
> > > >
> > > > the ACPICA core driver as you suggested, sorry for the confusion.
> > > >
> > > > > What about ACPI_OS_NAME? Would you suggest it is fine to report
> > > > > "Microsoft Windows NT" on an ARM system? That _OS_ not _OSI.
> > > >
> > > > No, not at all. I prefer "Linux"
> > > > In include/acpi/acconfig.h, when ACPI_OS_NAME defined, it says:
> > > > "OS name, used for the _OS object.  The _OS object is essentially
> > > > obsolete,..."
> > > > for some legacy reasons, we needed  "Microsoft Windows NT", but
> ACPI
> > > > for ARM64 on linux is totally new, I think we can change it to
> > > > "Linux" when CONFIG_ARM64 as you suggested.
> > >
> > > We could ignore this change for now if we don't expect the _OS
> object to
> > > be used at all. But do we have any other way to check the AML code
> for
> > > this? Would FWTS catch such obsolete cases?
> >
> > How about just leaving it out? It's clearly not used for anything
> > good, so I don't see the point in passing either Linux or "Microsoft
> > Windows NT" here.
> 
> Do you mean defining it to NULL (so it ends up as NULL in
> acpi_gbl_pre_defined_names) or removing "_OS_" entirely from that
> array?
> I really can't tell what the implications are.

To me, given that we don't want to use it in ARM64, it would make sense to
have some method to configurably:
0. Leave as is
1. Warn for usage
2. Panic
With a configurability method that allows FWTS to make use of it, and
therefore catch usages of the method.

Cheers

Charles


> 
> --
> Catalin



