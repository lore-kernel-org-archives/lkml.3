Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3IVUDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:03:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51852 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3IVUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:03:22 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <523F2390.5030702@math.tu-berlin.de>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
	<alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
	<4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
	<523F2390.5030702@math.tu-berlin.de>
Date: Sun, 22 Sep 2013 22:03:21 +0200
Message-ID: <CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com>
Subject: Re: i835GM flicker on panning
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, that sounds a bit more like the ddx is having fun with rendering.
Have you tried switching the backed from to either SNA or UXA? Also
adding relevant mailing lists ...
-Daniel

On Sun, Sep 22, 2013 at 7:06 PM, Thomas Richter <thor@math.tu-berlin.de> wrote:
> Hi folks, hi Daniel,
>
> there is still an issue with flicker on panning with the 835GM chipset. As
> already explained, the flicker only appears if the panning position
> satisfies certain alignment constraints, in specific. As long as the plane
> pointer is aligned to 64 byte boundaries, everything works correctly.
>
> I tried now to add a parameter to the kernel to adjust the watermark level
> of the chipset and see whether this makes any difference with regards to the
> flicker. However, it does not. It seems that the trouble is not there.
>
> However, I noticed something interesting: If I use a non-native mode of the
> display, i.e. enable the scaling feature of the DVO, everything works, and
> no flicker ever appears. However, in these situations the resolution is also
> lower than that of the native display, and hence the issue may also be
> related to the PLL clock.
>
> I also noticed that if I invert the display, i.e. use the rotation feature,
> even in the native resolution, nothing flickers, though panning is rather
> slow.
>
> Does this somehow ring a bell? Can I somehow force the driver to use the
> same logic for the regular display as for the inverted display to avoid the
> flicker?
>
> Any help would be appreciated.
>
> Greetings,
>         Thomas
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
