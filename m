Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDUUyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:54:17 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36678 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDUUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140421203207.GA27025@milliways>
References: <20140421203207.GA27025@milliways>
Date: Mon, 21 Apr 2014 16:54:15 -0400
Message-ID: <CADnq5_OhN7B2FG_tHSJq-FCnqVUz4Bwh1EDXwTqCtv0zrAiDKQ@mail.gmail.com>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
From: Alex Deucher <alexdeucher@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 4:32 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>  I've just built 3.15.0-rc2 on this box, and discovered that I get a
> blank screen.  The boot appears to complete (it sends me information
> from SMART which is from my last bootscript), and it responds to
> MagicSysRQ to reboot.  I tried to login and run startx, but that
> didn't seem to make any difference - possibly something went wrong,
> it wasn't in my history when I booted a good kernel.
>
>  This machine uses a regular old VGA cable to connect it, the
> following lines in dmesg make me think it has chosen the wrong
> connector:

VGA is implemented as a DP to VGA bridge on APUs.

>
> Apr 21 19:32:45 bluesbreaker kernel: [    1.273246]
> [drm:radeon_dp_link_train_cr] *ERROR* displayport link status failed
> Apr 21 19:32:45 bluesbreaker kernel: [    1.273247]
> [drm:radeon_dp_link_train_cr] *ERROR* clock recovery failed
> Apr 21 19:32:45 bluesbreaker kernel: [    1.295116] Console:
> switching to colour frame buffer device 85x34
>
>  On a boot with 3.14.0 and earlier I get a different console size -
> Apr 21 20:42:44 bluesbreaker kernel: [    1.445992] Console:
> switching to colour frame buffer device 133x54
>
>  My console font is 12x22, and my screen is 1600x1200 but it looks
> as if 3.15-rc2 has fallen back to trying to use 1024x768.
>
>  I'm attaching what look like the relevant parts of the messages
> from the system logs for 3.15-rc2 and 3.14.0.
>
>  Any ideas, please ?  This is an AMD A4-5300 APU and not the world's
> fastest machine for bisecting :-(

I'd guess it's either the pll rework patches or the switch to the
common dp helper code patches.  It would be helpful if you could
bisect.

Alex
