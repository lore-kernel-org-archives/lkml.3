Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaA0WSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:18:54 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62322 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaA0WSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:18:52 -0500
MIME-Version: 1.0
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Date: Mon, 27 Jan 2014 23:18:51 +0100
Message-ID: <CANq1E4S=+ixMQRMfX2-DXh3ZDO0jNAdWrUe6=z9aTdOSfR-SDA@mail.gmail.com>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
From: David Herrmann <dh.herrmann@gmail.com>
To: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jan 23, 2014 at 3:14 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> Another round of SimpleDRM patches. I somehow lost track of the last ones and as
> this is a major rewrite, I'll just start at v1 again.
>
> Some comments up-front:
>
>  - @Ingo: Patch #1 and #2 are unchanged from the previous ML discussions. I
>    included them in this series as the other patches depend on them. Could you
>    pick them up for the x86 tree? The other 9 patches won't make it in 3.14 so
>    no reason to put them through the DRM tree.
>    All mentioned issues should be addressed. If there's still sth missing,
>    please let me know.
>
>  - The DRM patches depend on my "DRM Anonymous Inode" patches. But it should be
>    trivial to apply them on drm-next (I think only one line needs to be changed:
>    i_mapping => dev_mapping).
>
>  - I tested the SimpleDRM fbdev fallback with linux-console+Xorg and it works
>    fine. The DRM backend is only tested with some DRM tests I have locally. I
>    have no idea how to make Xorg pick up a specific /dev/dri/card0 card. It
>    always tells me "no screens found" (as the underlying device is not marked as
>    boot_vga..). If someone knows how to tell Xorg to use card0, I'd gladly test
>    this. But I'm no longer used to writing xorg.confs..

For completeness, I tested this with Xorg+xf86-video-modesetting and
it works just fine. The xorg.conf I used can be found below. If this
driver gets upstreamed, I will try to make the X11 auto-loader detect
it just like any other platform-device.

Thanks
David


Section "ServerLayout"
    Identifier     "MyLayout"
    Screen         0 "MyScreen" 0 0
EndSection

Section "Device"
    Identifier     "MyDevice"
    Driver         "modesetting"
    BusID          "platform:/sys/devices/platform/simple-framebuffer.0"
    Screen         0
EndSection

Section "Screen"
    Identifier     "MyScreen"
    Device         "MyDevice"
EndSection
