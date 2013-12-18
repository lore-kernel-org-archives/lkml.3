Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3LRHhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:37:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3LRHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:37:12 -0500
Message-ID: <1387352226.32378.3.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v2] drm/bochs: new driver
From: Gerd Hoffmann <kraxel@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>
Date: Wed, 18 Dec 2013 08:37:06 +0100
In-Reply-To: <CAPM=9twP1PNFq5OPPeXm_-B3LqGhV777icnL=6tBo+C5n4ydwg@mail.gmail.com>
References: <1387299887-22754-1-git-send-email-kraxel@redhat.com>
	 <CAPM=9twP1PNFq5OPPeXm_-B3LqGhV777icnL=6tBo+C5n4ydwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2013-12-18 at 11:52 +1000, Dave Airlie wrote:
> On Wed, Dec 18, 2013 at 3:04 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> > DRM driver for (virtual) vga cards using the bochs dispi
> > interface, such as the qemu standard vga (qemu -vga std).
> >
> > Don't bother supporting anything but 32bpp for now, even
> > though the virtual hardware is able to do that.
> 
> Hi Gerd,
> 
> just took a quick look over this and it seems in pretty good shape,
> the one worry I have is if you've tested with vesafb loaded, since you
> do some pci_request_regions and fail hard, if vesafb has some of the
> resources this can end up failing the driver load for no good reason.
> I haven't verified there is a problem here its just something we've
> had in the past.

Tested, works.  bochs_pci_probe handles it before calling
drm_get_pci_dev, simliar to cirrus.

cheers,
  Gerd


