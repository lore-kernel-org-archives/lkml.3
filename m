Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929Ab3DCSKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:10:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759679Ab3DCSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:10:08 -0400
Date: Wed, 3 Apr 2013 14:10:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Florian Fainelli <florian@openwrt.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
In-Reply-To: <20130403122150.GZ25837@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1304031409360.2027-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Felipe Balbi wrote:

> On Wed, Apr 03, 2013 at 02:18:20PM +0200, Florian Fainelli wrote:
> > Le 04/03/13 14:15, Felipe Balbi a écrit :
> > >On Wed, Apr 03, 2013 at 02:11:13PM +0200, Florian Fainelli wrote:
> > >>Le 04/02/13 20:06, Alan Stern a écrit :
> > >>>On Tue, 2 Apr 2013, Florian Fainelli wrote:
> > >>>
> > >>>>This patch removes the depends on USB from all config symbols in
> > >>>>drivers/usb/host/Kconfig and replace that with an if USB / endif block
> > >>>>as suggested by Alan Stern. Some source ... Kconfig lines have been
> > >>>>shuffled around to permit a better regroupment of the Kconfig files
> > >>>>depending on "config USB" item. No functionnal change is introduced.
> > >>>
> > >>>This looks almost right.  The only problem I see is in
> > >>>drivers/usb/core/Kconfig.  The USB_OTG_WHITELIST and
> > >>>USB_OTG_BLACKLIST_HUB symbols don't have to depend on USB or USB_OTG,
> > >>>because they can be set if EXPERT is enabled.
> > >>>
> > >>>To avoid these issues, I think the best approach is to move all the
> > >>>USB_OTG* entries over to drivers/usb/otg/Kconfig, where by rights they
> > >>>should have been all along.
> > >>>
> > >>>Felipe, do you agree?
> > >>
> > >>Make sense, I will make this a sixth patch to this serie if this
> > >>sounds right with you?
> > >
> > >Pleae don't. Look at my 'next' branch. I deleted drivers/usb/otg/
> > >completely. OTG should be part of usbcore and I have plans of adding
> > >generic (and optional) OTG hooks in there.
> > 
> > Ok, then I will leave it as it is now and simply address the comment
> > your made initially, does that fit both you and Alan? Thanks!
> 
> Fine by me, if something else needs to go, then we can tackle it during
> -rc or for v3.11.

As long as it's okay with Felipe, it's okay with me.

Alan Stern

