Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3KPJ2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 04:28:51 -0500
Received: from mout.gmx.net ([212.227.17.22]:50212 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab3KPJ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 04:28:43 -0500
Date: Sat, 16 Nov 2013 10:28:38 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT
 signature)
Message-ID: <20131116092838.GA2564@thinkpad.fritz.box>
References: <20131113183418.GA1593@thinkpad.fritz.box>
 <20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
 <20131114182523.GA2133@thinkpad.fritz.box>
 <20131114205758.78c0788d@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114205758.78c0788d@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:JNUiHjKclbpG5WPSct8n7keYNluPeyMDmOQYEpIjUV71ZSi25TD
 onz3PFjYTp+esNyh4Q5hIHLUr/ZSAcAks62kG+yhWGNbdmIjrelJ4sUnNj8qrxjL2xUpYDz
 vfC03WmWzL1eSZh2qhwNbRTXRZ+o68UGwuCHPnwVSzdb95vnuoXL3L7TG4qQBoiXV/IwHyH
 W+ZnROzG3+00752qRq8Lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 08:57:58PM +0000, One Thousand Gnomes wrote:
> > but if you checkout the PCI table in the driver, there is the device
> > and vendor ID mentioned, that means for me that the driver supports
> > the Graphic core in E680.
> > And after loading the driver, it will parse for $VBT.
> > I just find a comment in the PCI table with "E620" but
> > the device and vendor id is the same for E680.
> > 
> > What do you mean with "Moorestown style" ?
> 
> There are essentially two styles of configuration table used with PVR
> graphics. One is basically the same as that used on 'real' Intel graphics
> the other first introduced with one of the SoC devices is a firmware
> table in a completely different format.
> 
> The netbook and PC oriented devices use the VBT, the tablet SoC
> devices and embedded ones seem to vary and have a VBT/GCT in different
> form that is found via config 0xFC on the chipset - see mid_bios.c
> 
> Alan
Hi,
if i dump the memory on 0xFC of the config space, there is just some from the
BIOS vendor with a BIOS Version, but nothing like $GCT.

In the Datasheet the 0xFC is described as "storage" does it mean there should
be the settings for the Graphic like VBT?
I did not find more information abaout GCT and how to implement it.


The board uses sdvo->vga for the output, the second board
uses sdvo->DVI and LVDS but there is always a  black screen on each
output interface. So i think there is wether a VBT not a GCT.

Regards 
andy
