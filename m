Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3BFFRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:17:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3BFFRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:17:15 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [GIT PULL] ARM part of USB patches
Thread-Topic: [GIT PULL] ARM part of USB patches
Thread-Index: AQHOA8X4MwwET/F4MkCgwumbyff5LJhrNwKAgAETD5A=
Date: Wed, 6 Feb 2013 05:16:55 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC04FF8@DBDE01.ent.ti.com>
References: <51112418.5020000@ti.com> <51112495.4060908@ti.com>
 <20130205172724.GA1601@kroah.com> <20130205181947.GI25185@atomide.com>
In-Reply-To: <20130205181947.GI25185@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 23:49:47, Tony Lindgren wrote:
> * gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> [130205 09:28]:
> > On Tue, Feb 05, 2013 at 08:56:13PM +0530, kishon wrote:
> > > Hi Tony, Greg,
> > > 
> > > On Tuesday 05 February 2013 08:54 PM, kishon wrote:
> > > >Hi Tony,
> > > >
> > > >As discussed, I'm sending a pull request for the arch/arm part of my USB
> > > >patches. These patches are necessary to get MUSB functional in both dt
> > > >and non-dt boot. Also added dt data for dwc3 present in OMAP. This patch
> > > >series *depends* on some of the patches which are merged in usb-next.
> > > 
> > > This patch series should go in only after USB. Or else it will break
> > > compilation.
> > 
> > Then it probably should go through the USB tree, right?  We don't want
> > to break bisectability.
> 
> Looks like this branch needs to be based on at least 01658f0f (usb: phy:
> add a new driver for usb part of control module) to compile. Probably
> needs other USB patches too to make sense.
> 
> This branch has a high likelihood of conflicting with .dts files, so
> Kishon, I suggest you do two branches:
> 
> 1. A branch for Greg based on top of the USB changes
> 
>    This branch should contain:
> 
>    ARM: OMAP4: remove control module address space from PHY and OTG
>    ARM: OMAP: devices: create device for usb part of control module
>    ARM: OMAP2: MUSB: Specify omap4 has mailbox
>    ARM: OMAP: USB: Add phy binding information
> 
>    Naturally please make sure they compile and boot on their own.
>    Looks like this will only cause few trivial include merge conflicts
>    with what I have queued up.
> 
>    You can add my Acked-by: Tony Lindgren <tony@atomide.com> for those.
> 
> 2. A branch for Benoit based on v3.8-rc6
> 
>    That branch should contain all the .dts changes as those will
>    most likely cause nasty merge conflicts otherwise with what
>    Benoit has queued up.
> 

Tony/Benoit,

There are few AM33xx DTS patches pending from long time, how do you want to 
take it forward? You want me to put it into one branch and share? OR just 
provide the list of all patches to you?

Thanks,
Vaibhav
> Regards,
> 
> Tony
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

