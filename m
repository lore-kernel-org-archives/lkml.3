Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3LRIKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:10:10 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47710 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3LRIKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:10:07 -0500
X-Greylist: delayed 155184 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 03:10:07 EST
MIME-Version: 1.0
In-Reply-To: <1387352226.32378.3.camel@nilsson.home.kraxel.org>
References: <1387299887-22754-1-git-send-email-kraxel@redhat.com>
	<CAPM=9twP1PNFq5OPPeXm_-B3LqGhV777icnL=6tBo+C5n4ydwg@mail.gmail.com>
	<1387352226.32378.3.camel@nilsson.home.kraxel.org>
Date: Wed, 18 Dec 2013 09:10:06 +0100
Message-ID: <CANq1E4QR5s=Uke3qB8k56dR0oorjedT7wezU+wY6F_Qpi95C8A@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bochs: new driver
From: David Herrmann <dh.herrmann@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Dec 18, 2013 at 8:37 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> On Mi, 2013-12-18 at 11:52 +1000, Dave Airlie wrote:
>> On Wed, Dec 18, 2013 at 3:04 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>> > DRM driver for (virtual) vga cards using the bochs dispi
>> > interface, such as the qemu standard vga (qemu -vga std).
>> >
>> > Don't bother supporting anything but 32bpp for now, even
>> > though the virtual hardware is able to do that.
>>
>> Hi Gerd,
>>
>> just took a quick look over this and it seems in pretty good shape,
>> the one worry I have is if you've tested with vesafb loaded, since you
>> do some pci_request_regions and fail hard, if vesafb has some of the
>> resources this can end up failing the driver load for no good reason.
>> I haven't verified there is a problem here its just something we've
>> had in the past.
>
> Tested, works.  bochs_pci_probe handles it before calling
> drm_get_pci_dev, simliar to cirrus.

It fails with CONFIG_X86_SYSFB=y and CONFIG_FB_SIMPLE=y. But imho that
should get fixed in sysfb, not the drivers loaded on top.

Thanks
David
