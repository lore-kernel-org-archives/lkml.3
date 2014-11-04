Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaKDNLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:11:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64987 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751732AbaKDNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:10:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Timur Tabi <timur@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Tue, 04 Nov 2014 14:31:41 +0100
Message-ID: <4832015.R1NooRni06@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141104093907.GH1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <20141104082056.GG1618@lahna.fi.intel.com> <20141104093907.GH1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 11:39:07 AM Mika Westerberg wrote:
> On Tue, Nov 04, 2014 at 10:20:56AM +0200, Mika Westerberg wrote:
> > On Mon, Nov 03, 2014 at 05:24:55PM -0600, Timur Tabi wrote:
> > > On Mon, Nov 3, 2014 at 5:01 AM, Mika Westerberg
> > > <mika.westerberg@linux.intel.com> wrote:
> > > > Hi,
> > > >
> > > > This is second version of the patch series adding pinctrl/GPIO support
> > > > for Intel Braswell and Cherrryview. The previous version can be found here:
> > > >
> > > > https://lkml.org/lkml/2014/10/27/118
> > > >
> > > > I've dropped patches [2/4] and [3/4] as they are already applied to the
> > > > pinctrl tree.
> > > 
> > > Mika,
> > > 
> > > I am also trying to add ACPI enablement to my pinctrl driver (not yet
> > > submitted), but I'm new to ACPI and pin control drivers, so I have a
> > > lot of catching up to do.
> > > 
> > > In reviewing this patchset, it appears to me that pinctrl-cherryview.c
> > > is a normal pinctrl driver that has an acpi_match_table entry, and
> > > nothing more.
> > 
> > Indeed, it just a normal platform driver that can be enumerated from
> > ACPI using the .acpi_match_table entry.
> > 
> > > Assuming that this driver is booting on an ACPI system, what is the
> > > mechanism that calls into the driver to configure the pins?  Is there
> > > a definition for pin control in ASL that provides similar
> > > functionality as the pinctrl nodes in a device tree?
> > 
> > There is nothing like that yet in ACPI world but with the ACPI _DSD
> > patches we are getting properties similar to DT which means that we can
> > provide pinctrl bindings from ACPI systems as well. Typically it has
> > been the BIOS that configures things but it cannot get everything 100%
> > right.
> > 
> > Currently I've been testing the muxing functionality so that I have a
> > small board file that sets mappings and the driver core handles
> > everything from there. For example I have development board where SPI
> > pins are muxed as GPIOs by the BIOS and with the mappings when the SPI
> > device appears the core will mux SPI out of those pins.
> 
> For reference the latest ACPI _DSD patches can be found here
> 
> https://lkml.org/lkml/2014/10/21/762

Actually, it's better to pull the device-properties branch:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties

because that contains the lastest changes.  It will be rebased in the future,
though, so don't merge it into your "immutable" branches.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
