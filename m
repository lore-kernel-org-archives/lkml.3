Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaBSVRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:17:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:34648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaBSVRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:17:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,507,1389772800"; 
   d="scan'208";a="458383391"
Date: Wed, 19 Feb 2014 18:17:13 -0300
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Mark Jackson <mpfj-list@newflow.co.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 2/2] misc: add missing minor nodes
Message-ID: <20140219211712.GB2341@intel.com>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
 <1392701245-4645-3-git-send-email-lucas.demarchi@intel.com>
 <20140218185228.GC29209@kroah.com>
 <530509FA.9070800@newflow.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <530509FA.9070800@newflow.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Originating-IP: [10.218.97.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 07:46:02PM +0000, Mark Jackson wrote:
> On 18/02/14 18:52, Greg Kroah-Hartman wrote:
> > On Tue, Feb 18, 2014 at 02:27:25AM -0300, Lucas De Marchi wrote:
> >> From: Lucas De Marchi <lucas.demarchi@intel.com>
> >>
> >> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> >> ---
> >>  Documentation/devices.txt | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> >> index 04356f5..0ea1cc2 100644
> >> --- a/Documentation/devices.txt
> >> +++ b/Documentation/devices.txt
> >> @@ -329,6 +329,7 @@ Your cooperation is appreciated.
> >>  		filesystem across multiple physical disks.
> >>  
> >>   10 char	Non-serial mice, misc features
> >> +		  0 = /dev/fram
> >>  		  0 = /dev/logibm	Logitech bus mouse
> >>  		  1 = /dev/psaux	PS/2-style mouse port
> >>  		  2 = /dev/inportbm	Microsoft Inport bus mouse
> > 
> > That's not ok at all, and probably a bug, someone must have thought that
> > minor 0 ment "give me a dynamic number."  No one caught this when the
> > driver was first merged in a arch-specific tree in 2008 :(
> > 
> > In looking at the driver, it probably should just be a UIO driver, or
> > something else, all it does it map frame buffer memory to userspace,
> > given the hardware involved, odds are no one even uses it anymore...
> > 
> > Mark and Haavard, any thoughts about the
> > arch/avr32/boards/mimc200/fram.c driver?  Can I fix up the minor number
> > here, or just delete the driver entirely if it's not being used anymore?
> 
> I think it's safe to delete the driver.
> 
> The mimc200 unit is now basically obsolete and there'll be no new development on it.

Ok, thanks.

Greg,

So it looks like only 197 and 239 need to be updated in
the documentation.  Below is the updated patch.

Lucas De Marchi

---------8<---------
Subject: [PATCH] misc: add missing minor nodes

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 Documentation/devices.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 04356f5..d154147 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -411,6 +411,7 @@ Your cooperation is appreciated.
 		194 = /dev/zkshim	Zero-Knowledge network shim control
 		195 = /dev/elographics/e2201	Elographics touchscreen E271-2201
 		196 = /dev/vfio/vfio	VFIO userspace driver interface
+		197 = /dev/pxa3xx-gcu	PXA3xx graphics controller unit driver
 		198 = /dev/sexec	Signed executable interface
 		199 = /dev/scanners/cuecat :CueCat barcode scanner
 		200 = /dev/net/tun	TAP/TUN network device
@@ -452,6 +453,7 @@ Your cooperation is appreciated.
 		236 = /dev/mapper/control	Device-Mapper control device
 		237 = /dev/loop-control Loopback control device
 		238 = /dev/vhost-net	Host kernel accelerator for virtio net
+		239 = /dev/uhid		User-space I/O driver support for HID subsystem
 
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
-- 
1.9.0

