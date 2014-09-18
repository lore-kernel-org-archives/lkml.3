Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaIRO6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:58:32 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46906 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbaIRO6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <541AE737.8070009@odi.ch>
References: <541AE737.8070009@odi.ch>
Date: Thu, 18 Sep 2014 10:58:30 -0400
X-Google-Sender-Auth: ZkIdpNIcYmPo1oUV-AUcFScaQQc
Message-ID: <CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:07 AM, Ortwin Glück <odi@odi.ch> wrote:
> Hi,
>
> Since 3.16 an external monitor stays dark after resume from sleep. I didn't manage to activate it
> again with xrand. According to xrandr it is "connected" and configured with a mode, but I get no signal.
>
> Happens since 3.16 and is still broken with 3.17-rc5.
>
> Hardware:
> HP EliteBook 8540w
> 01:00.0 VGA compatible controller: NVIDIA Corporation GT215GLM [Quadro FX 1800M] (rev a2)
> 0
>
> External Monitor connected via DVI on the docking station.

This has been reported a few times already -- probably the same thing
as bug https://bugs.freedesktop.org/show_bug.cgi?id=83550

Sorry, no resolution as of yet. If you could verify that the commit
that got bisected to in that bug indeed causes your problem, it would
be nice to have before and after logs from a kernel compiled with
NOUVEAU_DEBUG set to 7 (spam) booted with
nouveau.debug=trace,PDISP=spam . That should hopefully help isolate
the issue. (Don't use a kernel with NOUVEAU_DEBUG set that high for
daily use -- it introduces a ton of debug code everywhere.) If the
commit that got bisected to in the bug is not the cause of your
issues, you'll need to do your own bisect.

Cheers,

  -ilia

>
> XRandR before amd after suspend looks the same:
>
> $ xrandr
> Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
> LVDS-1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 345mm x 194mm
>    1920x1080      59.9*+   60.0
>    1680x1050      60.0
>    1400x1050      60.0
>    1280x1024      59.9
>    1280x960       59.9
>    1152x864       60.0
>    1024x768       59.9
>    800x600        59.9
>    640x480        59.4
>    720x400        59.6
>    640x400        60.0
>    640x350        59.8
> DP-1 disconnected (normal left inverted right x axis y axis)
> DP-2 disconnected (normal left inverted right x axis y axis)
> eDP-1 disconnected (normal left inverted right x axis y axis)
> DP-3 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 598mm x 336mm
>    1920x1080      60.0*+
>    1680x1050      59.9
>    1280x1024      75.0     60.0
>    1440x900       75.0     59.9
>    1024x768       75.1     60.0
>    800x600        75.0     60.3
>    640x480        75.0     72.8     66.7     60.0
>    720x400        70.1
> VGA-1 disconnected (normal left inverted right x axis y axis)
>
> dmesg output of a suspend/resume cycle attached.
