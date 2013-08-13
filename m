Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3HMLhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:37:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31793 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3HMLhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:37:16 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-a9-520a1a69d2b7
From: Tomasz Figa <t.figa@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, kyungmin.park@samsung.com,
        jg1.han@samsung.com, s.nawrocki@samsung.com, kgene.kim@samsung.com,
        grant.likely@linaro.org, tony@atomide.com, arnd@arndb.de,
        swarren@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Tue, 13 Aug 2013 13:37:07 +0200
Message-id: <2034985.S0danJZqk4@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <520A0E1C.5000306@ti.com>
References: <20130720220006.GA7977@kroah.com> <20130731061538.GC13289@radagast>
 <520A0E1C.5000306@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xq7qZUlxBBs9vcljMWb+GzeLvpGPs
	FlMnb2ezOHi/3uLA7IesFqcOLme1OPBnB6NF8+L1bBaXF15itehdcJXN4sLTHjaLs01v2C02
	Pb7GarGwbQmLxYm+D6wWl3fNYbPo2bCV1WL2kn4Wixnn9zFZLFrWymyxv3cDk8XhN+2sFhN+
	X2CzuDG9hdVi1a4/jBb7r3g5SHn8/jWJ0ePb10ksHjtn3WX3uHNtD5vHiRm/WTz2z13D7rF5
	Sb3H+RkLGT16m9+xecy++4PRo2/LKkaP4ze2M3l83iQXwBvFZZOSmpNZllqkb5fAldHV7Vqw
	Q7Hi/bUPbA2Mc6W6GDk5JARMJDZvaGSFsMUkLtxbzwZiCwksZZTYcN6zi5ELyO5ikjhy4x4L
	SIJNQE3ic8MjsCIRAS2J0zt/MIPYzALrWSX+PlECsYUFnCTetr4Bi7MIqEocnL0fqJ6Dg1dA
	U2LpO1eQML+AusS7bU+ZQMKiAm4SEz7mg4Q5gabvnT6HEeKEbIn1My6zg9i8AoISPyZDXMAs
	IC+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLz
	czcxQuL/6w7GpcesDjEKcDAq8fBmfOQIEmJNLCuuzD3EKMHBrCTCG8fIFSTEm5JYWZValB9f
	VJqTWnyIkYmDU6qBUfENh8EBwQWPGwLcPJsdy26W3G1Nu/Xj5qYw6z3G19euOrw64eWeHukJ
	IfOqn2u51vUGy/7hv/5KwvPabZazh7Qbfa7PC6vZ9+aTsOGp8MpjUxUlQxt6siV/HVb8kr+a
	J941114745TCty1VTxLeGwTMta9WUHsyzdGiPv7lrJQzs5+8XxZSqsRSnJFoqMVcVJwIAPzS
	U/PdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of August 2013 16:14:44 Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 31 July 2013 11:45 AM, Felipe Balbi wrote:
> > Hi,
> > 
> > On Wed, Jul 31, 2013 at 11:14:32AM +0530, Kishon Vijay Abraham I wrote:
> >>>>>>> IMHO we need a lookup method for PHYs, just like for clocks,
> >>>>>>> regulators, PWMs or even i2c busses because there are complex
> >>>>>>> cases
> >>>>>>> when passing just a name using platform data will not work. I
> >>>>>>> would
> >>>>>>> second what Stephen said [1] and define a structure doing things
> >>>>>>> in a
> >>>>>>> DT-like way.
> >>>>>>> 
> >>>>>>> Example;
> >>>>>>> 
> >>>>>>> [platform code]
> >>>>>>> 
> >>>>>>> static const struct phy_lookup my_phy_lookup[] = {
> >>>>>>> 
> >>>>>>> 	PHY_LOOKUP("s3c-hsotg.0", "otg", "samsung-usbphy.1", "phy.2"),
> >>>>>> 
> >>>>>> The only problem here is that if *PLATFORM_DEVID_AUTO* is used
> >>>>>> while
> >>>>>> creating the device, the ids in the device name would change and
> >>>>>> PHY_LOOKUP wont be useful.
> >>>>> 
> >>>>> I don't think this is a problem. All the existing lookup methods
> >>>>> already
> >>>>> use ID to identify devices (see regulators, clkdev, PWMs, i2c,
> >>>>> ...). You
> >>>>> can simply add a requirement that the ID must be assigned manually,
> >>>>> without using PLATFORM_DEVID_AUTO to use PHY lookup.
> >>>> 
> >>>> And I'm saying that this idea, of using a specific name and id, is
> >>>> frought with fragility and will break in the future in various ways
> >>>> when
> >>>> devices get added to systems, making these strings constantly have
> >>>> to be
> >>>> kept up to date with different board configurations.
> >>>> 
> >>>> People, NEVER, hardcode something like an id.  The fact that this
> >>>> happens today with the clock code, doesn't make it right, it makes
> >>>> the
> >>>> clock code wrong.  Others have already said that this is wrong there
> >>>> as
> >>>> well, as systems change and dynamic ids get used more and more.
> >>>> 
> >>>> Let's not repeat the same mistakes of the past just because we
> >>>> refuse to
> >>>> learn from them...
> >>>> 
> >>>> So again, the "find a phy by a string" functions should be removed,
> >>>> the
> >>>> device id should be automatically created by the phy core just to
> >>>> make
> >>>> things unique in sysfs, and no driver code should _ever_ be reliant
> >>>> on
> >>>> the number that is being created, and the pointer to the phy
> >>>> structure
> >>>> should be used everywhere instead.
> >>>> 
> >>>> With those types of changes, I will consider merging this subsystem,
> >>>> but
> >>>> without them, sorry, I will not.
> >>> 
> >>> I'll agree with Greg here, the very fact that we see people trying to
> >>> add a requirement of *NOT* using PLATFORM_DEVID_AUTO already points
> >>> to a
> >>> big problem in the framework.
> >>> 
> >>> The fact is that if we don't allow PLATFORM_DEVID_AUTO we will end up
> >>> adding similar infrastructure to the driver themselves to make sure
> >>> we
> >>> don't end up with duplicate names in sysfs in case we have multiple
> >>> instances of the same IP in the SoC (or several of the same PCIe
> >>> card).
> >>> I really don't want to go back to that.
> >> 
> >> If we are using PLATFORM_DEVID_AUTO, then I dont see any way we can
> >> give the correct binding information to the PHY framework. I think we
> >> can drop having this non-dt support in PHY framework? I see only one
> >> platform (OMAP3) going to be needing this non-dt support and we can
> >> use the USB PHY library for it.> 
> > you shouldn't drop support for non-DT platform, in any case we lived
> > without DT (and still do) for years. Gotta find a better way ;-)
> 
> hmm..
> 
> how about passing the device names of PHY in platform data of the
> controller? It should be deterministic as the PHY framework assigns its
> own id and we *don't* want to add any requirement that the ID must be
> assigned manually without using PLATFORM_DEVID_AUTO. We can get rid of
> *phy_init_data* in the v10 patch series.

What about slightly altering the concept of v9 to pass a pointer to struct 
device instead of device name inside phy_init_data?

Best regards,
Tomasz

