Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbbADR0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 12:26:40 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:64836 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbbADR0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 12:26:38 -0500
MIME-Version: 1.0
In-Reply-To: <1791051420215815@web16j.yandex.ru>
References: <1791051420215815@web16j.yandex.ru>
Date: Sun, 4 Jan 2015 12:26:38 -0500
Message-ID: <CADnq5_NwNLCaN-aoULaZxnjwxP+PAn6b8ngUsfwNAv4v2vxM2g@mail.gmail.com>
Subject: Re: Radeon R9 290 problem
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Kuznetsoff <dri-devel@yandex.ru>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2015 at 11:23 AM, Alex Kuznetsoff <dri-devel@yandex.ru> wrote:
> I have an AMD Radeon R9 290 video card, and since commit https://github.com/torvalds/linux/commit/96212fe8c27b I cannot boot into the system any more with CONFIG_DRM_RADEON turned on ([m]). These are the symptoms: the screen either reports NO SIGNAL (sometimes all the LEDs, scroll lock, caps lock and num lock start to blink synchronously) - I had a lot of this while bisecting v3.12.0 to v3.13.0, or, in newer kernels, including v3.18, the image just freezes somewhere around "Waiting for uevents to be processed" and nothing more happens on the screen. In both cases I have to use the reboot button.
>
> Here's the output of lspci | grep ATI:
>
> 01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290]
> 01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Device aac8
>
> Here's my kernel config:
>
> https://bpaste.net/show/8c353c80e37e
>
> It works in 3.12 series up to 3.12.34 (it is the last version I checked) and doesn't work in 3.13 to v3.18 (b2776bf).

That commit is the first commit to enable hawaii support in the driver
so prior to that, the driver was not loaded on your hardware.  X was
probably using vesa or some firmware fbdev interface.  Please file a
bug (https://bugs.freedesktop.org) and attach your xorg log and dmesg
output.

Alex

> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
