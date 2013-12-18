Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3LRBwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:52:19 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46743 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LRBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:52:18 -0500
MIME-Version: 1.0
In-Reply-To: <1387299887-22754-1-git-send-email-kraxel@redhat.com>
References: <1387299887-22754-1-git-send-email-kraxel@redhat.com>
Date: Wed, 18 Dec 2013 11:52:16 +1000
Message-ID: <CAPM=9twP1PNFq5OPPeXm_-B3LqGhV777icnL=6tBo+C5n4ydwg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bochs: new driver
From: Dave Airlie <airlied@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: David Airlie <airlied@linux.ie>, open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 3:04 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> DRM driver for (virtual) vga cards using the bochs dispi
> interface, such as the qemu standard vga (qemu -vga std).
>
> Don't bother supporting anything but 32bpp for now, even
> though the virtual hardware is able to do that.

Hi Gerd,

just took a quick look over this and it seems in pretty good shape,
the one worry I have is if you've tested with vesafb loaded, since you
do some pci_request_regions and fail hard, if vesafb has some of the
resources this can end up failing the driver load for no good reason.
I haven't verified there is a problem here its just something we've
had in the past.

Dave.
