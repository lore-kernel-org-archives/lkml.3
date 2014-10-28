Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaJ1Psv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:48:51 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35763 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJ1Pst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
References: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Oct 2014 09:48:28 -0600
Message-ID: <CAErSpo4zDxhG08FjyV9BJ+=cJLGYkyocz87ZRWndw70ND3g6XA@mail.gmail.com>
Subject: Re: Standard VGA console with DRI/DRM under X?
To: Michael Shell <list1@michaelshell.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc David, Alex, Christian, dri-devel]

On Tue, Oct 28, 2014 at 12:32 AM, Michael Shell <list1@michaelshell.org> wrote:
>
>
>   Greetings,
>
> Well, I want to be able to have my cake and eat it too. I want to be able to
> have the standard VGA/"hardware" classic console (not the framebuffer) but
> I still want the /dev/dri/cardX devices so that I can use DRI under Xorg.
>
> Is this possible and if not, why not?
>
>
> (I do hope I'm not bring up an issue with an obvious fix, but my searching
>  has not yielded an answer yet. For the record, I'm running modern kernel
>  (3.16.3) with much older x86 hardware [r100 Radeon video card].)
>
>
> If I boot with the kernel nomodeset option I can get the classic
> VGA/"hardware" console, but then I lose support for DRI/DRM:
>
> Oct 27 15:11:09 X kernel: [drm] Initialized drm 1.1.0 20060810
> Oct 27 15:11:09 X kernel: [drm] VGACON disable radeon kernel modesetting.
> Oct 27 15:11:09 X kernel: [drm:radeon_init] *ERROR* No UMS support in radeon module
>
> and glxgears et al. turns slow. In more modern Xorg releases, DRI is
> required for all hardware acceleration, so having /dev/dri/cardX is very
> important:
>
> http://askubuntu.com/questions/463142/why-x-is-relying-on-software-instead-of-hardware-with-nomodeset-kernel-paramet
>
>
> One reason I do not wish to use the framebuffer console is because of the
> small font. 160 columns makes it difficult to tell which [OK] belongs with
> which service. The selection of console fonts should always include a
> set that gives us an 80 column screen and the docs should point this out.
>
> And I dislike any blanking or video mode changes during boot.
>
> Can't the kernel just declare that it is capable of setting the video mode,
> provide the /dev/dri/cardX devices and leave the console alone, but still
> allow Xorg to call for a new mode and use /dev/dri/cardX if/when it sees fit?
>
> In an ideal world, there would be some kernel option such as fbcon=no.
>
> In the kernel Documentation fbcon.txt it mentions "fbcon=map:1 tells fbcon not
> to take over the console." But, IIRC, from my tests I wasn't able to use this
> to get a VGA/"hardware" console and still be able to have /dev/dri/cardX devices.
>
>
>
>     Cheers and thank you,
>
>     Mike Shell
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
