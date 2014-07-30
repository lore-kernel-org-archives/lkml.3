Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaG3Grf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:47:35 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19585 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaG3Grd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:47:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19c6AFg9sKkypFbBqZS7QlR
Date: Tue, 29 Jul 2014 23:46:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
        marek.belisko@gmail.com, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Message-ID: <20140730064605.GZ29045@atomide.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
 <20140721151557.GH6852@saruman.home>
 <53CF7978.4090709@ti.com>
 <14357891.vooz1N5zDC@avalon>
 <20140729163935.GH17808@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729163935.GH17808@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140729 09:42]:
> Hi,
> 
> On Tue, Jul 29, 2014 at 02:38:24PM +0200, Laurent Pinchart wrote:
> > On Wednesday 23 July 2014 14:29:36 Kishon Vijay Abraham I wrote:
> > > On Monday 21 July 2014 08:45 PM, Felipe Balbi wrote:
> > > > On Mon, Jul 21, 2014 at 05:04:57PM +0200, Laurent Pinchart wrote:
> > > >> Hi Felipe,
> > > >> 
> > > >> What happened to these two patches ?
> > > > 
> > > > looks like I lost them.
> > > > 
> > > >> On Monday 16 December 2013 17:48:29 Felipe Balbi wrote:
> > > >>> On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> > > >>>> * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> > > >>>>> On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I 
> > wrote:
> > > >>>>>> After the platform devices are created using PLATFORM_DEVID_AUTO, the
> > > >>>>>> device names given in usb_bind_phy (in board file) does not match
> > > >>>>>> with the actual device name causing the USB PHY library not to return
> > > >>>>>> the PHY reference when the MUSB controller request for the PHY in the
> > > >>>>>> non-dt boot case.
> > > >>>>>> So removed creating platform devices using PLATFORM_DEVID_AUTO in
> > > >>>>>> omap2430.c.
> > > >>>>>> 
> > > >>>>>> Did enumeration testing in omap3 beagle.
> > > >>>>>> 
> > > >>>>>> Changes from v2:
> > > >>>>>> * Fixed the commit log
> > > >>>>>> 
> > > >>>>>> Changes from v1:
> > > >>>>>> * refreshed to the latested mainline kernel
> > > >>>>>> * added musb_put_id from omap2430 remove.
> > > >>>>> 
> > > >>>>> Tony, how do you want to handle this ? You want me to provide you a
> > > >>>>> branch which we both merge ?
> > > >>>> 
> > > >>>> Yes that would be great thanks. For the mach-omap2 touching parts:
> > > >>>> 
> > > >>>> Acked-by: Tony Lindgren <tony@atomide.com>
> > > >>> 
> > > >>> Here it is, let me know if you prefer a signed tag:
> > > >>> 
> > > >>> The following changes since commit 
> > 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> > > >>>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> > > >>> 
> > > >>> are available in the git repository at:
> > > >>>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> > > >>> 
> > > >>> usb-phy-binding-omap3
> > > >>> 
> > > >>> for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d52d18:
> > > >>>   arm: omap: remove *.auto* from device names given in usb_bind_phy
> > > >>> 
> > > >>> (2013-12-16 17:44:43 -0600)
> > > >>> 
> > > >>> ----------------------------------------------------------------
> > > >>> 
> > > >>> Kishon Vijay Abraham I (2):
> > > >>>       usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
> > > >>>       arm: omap: remove *.auto* from device names given in usb_bind_phy
> > > > 
> > > > Kishon, are these still valid ?
> > > 
> > > Looks like board-2430sdp.c got removed. Apart from that the reset of the
> > > patch series is still applicable for non-dt boot.
> > 
> > Felipe, do you plan to apply the patch without the baord-2430sdp.c change, or 
> > would you like Kishon to rebase and resubmit it ?
> 
> Not sure if Tony still wants board-* modifications. Tony ?

Well omap2 is DT only already, so sounds like you can just ignore
board-2430sdp.c as it no longer exists.

If there are other minimal board-*.c file changes needed, then that's
fine as long as they fix things or are needed to keep things working.

Regards,

Tony

