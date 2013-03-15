Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3COQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:21:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3COQVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:21:42 -0400
Date: Fri, 15 Mar 2013 17:21:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
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
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <20130315154739.GA1024@kroah.com>
Message-ID: <alpine.LNX.2.00.1303151720400.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz> <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz> <20130315153249.GA32425@kroah.com> <alpine.LNX.2.00.1303151636481.9529@pobox.suse.cz> <20130315154739.GA1024@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Greg KH wrote:

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

Ah, that one. I believe that should be irrelevant for GM chipsets, as they 
don't have AUX line, right?

> > (I am seeing this with a2362d247 still).
> 
> Ok, I guess it isn't still fixed properly, just was guessing :)

Seems like this is a different issue.

Thanks,

-- 
Jiri Kosina
SUSE Labs
