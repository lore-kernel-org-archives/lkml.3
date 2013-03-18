Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3CRITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:19:17 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36738 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3CRITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:19:13 -0400
Date: Mon, 18 Mar 2013 09:21:57 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor
 interrupt responses)
Message-ID: <20130318082156.GO9021@phenom.ffwll.local>
Mail-Followup-To: Greg KH <greg@kroah.com>, Jiri Kosina <jkosina@suse.cz>,
	Harald Arnesen <skogtun.linux@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Peter Hurley <peter@hurleysoftware.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Meyer <thomas@m3y3r.de>,
	Shawn Starr <shawn.starr@rogers.com>,
	USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org>
 <1460519.ejNFI1DrGk@vostro.rjw.lan>
 <1363280764.26318.4.camel@thor.lan>
 <5657408.cYX6iimiA4@vostro.rjw.lan>
 <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
 <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <20130315153249.GA32425@kroah.com>
 <alpine.LNX.2.00.1303151636481.9529@pobox.suse.cz>
 <20130315154739.GA1024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315154739.GA1024@kroah.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:47:39AM -0700, Greg KH wrote:
> On Fri, Mar 15, 2013 at 04:37:56PM +0100, Jiri Kosina wrote:
> > On Fri, 15 Mar 2013, Greg KH wrote:
> > 
> > > > > I have the same problem on my Lenovo T500. I think the graphics card is
> > > > > involved.
> > > > > 
> > > > > This laptop has "hybrid graphics" - one Intel GMA 4500MHD and one ATI
> > > > > Mobility Radeon HD 3650. When I boot with the Intel card, I get "irq 16:
> > > > > nobody cared" during boot, not when I boot with the ATI card.
> > > > 
> > > > Confirming this. After a lot of hassle, I have bisected this reliably to
> > > > 
> > > > 	commit 28c70f162a315bdcfbe0bf940a740ef8bfb918d6
> > > > 	Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > 	Date:   Sat Dec 1 13:53:45 2012 +0100
> > > > 
> > > > 	    drm/i915: use the gmbus irq for waits
> > > > 
> > > > Adding Daniel, Imre and Daniel to CC while I will try to figure out what's 
> > > > happening in parallel.
> > > 
> > > Wasn't this fixed by the merge from David
> > > (2cc79544bd0aabb4b3cf467ead5df526d9134c64)?
> > 
> > Why do you think it should, please?
> 
> The line:
> 	- Fix PCH irq handling race which resulted in missed gmbus/dp
> 	  aux irqs and subsequent fallout (Paulo)
> 
> > (I am seeing this with a2362d247 still).
> 
> Ok, I guess it isn't still fixed properly, just was guessing :)

Yeah, the above fix is for pch split platforms, whereas these reports here
are for gm45 (which doesn't have the pch display split). Acking of gmbus
interrupts works differently on those, I'm testing right now whether I can
reproduce this fail.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
