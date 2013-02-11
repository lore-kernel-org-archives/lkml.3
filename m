Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3BKWjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:39:36 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37949 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3BKWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
Date: Mon, 11 Feb 2013 22:39:32 +0000
Message-ID: <CALW4P+LH55JPRi=bzzt85H0Qv8OGBcbW3Jt5+5QNv1BhLjnk-Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Driver for Si476x series of chips
From: Alexey Klimov <klimov.linux@gmail.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrey, Mauro, Hans,

On Tue, Oct 23, 2012 at 6:44 PM, Andrey Smirnov
<andrey.smirnov@convergeddevices.net> wrote:
> This is a third version of the patchset originaly posted here:
> https://lkml.org/lkml/2012/9/13/590
>
> Second version of the patch was posted here:
> https://lkml.org/lkml/2012/10/5/598
>
> To save everyone's time I'll repost the original description of it:
>
> This patchset contains a driver for a Silicon Laboratories 476x series
> of radio tuners. The driver itself is implemented as an MFD devices
> comprised of three parts:
>  1. Core device that provides all the other devices with basic
> functionality and locking scheme.
>  2. Radio device that translates between V4L2 subsystem requests into
> Core device commands.
>  3. Codec device that does similar to the earlier described task, but
> for ALSA SoC subsystem.
>
> v3 of this driver has following changes:
>  - All custom ioctls were moved to be V4L2 controls or debugfs files
>  - Chip properties handling was moved to regmap API, so this should
>    allow for cleaner code, and hopefully more consistent behaviour of
>    the driver during switch between AM/FM(wich involevs power-cycling
>    of the chip)
>
> I was hoping to not touch the code of the codec driver, since Mark has
> already appplied the previous version, but because of the last item I
> had to.
>
> Unfotunately, since my ARM setup runs only 3.1 kernel, I was only able
> to test this driver on a standalone USB-connected board that has a
> dedicated Cortex M3 working as a transparent USB to I2C bridge which
> was connected to a off-the-shelf x86-64 laptop running Ubuntu with
> custom kernel compile form git.linuxtv.org/media_tree.git. Which means
> that I was unable to test the change in the codec code, except for the
> fact the it compiles.
>
>
> Here is v4l2-compliance output for one of the tuners(as per Hans'
> request):
[]

> Andrey Smirnov (6):
>   Add header files and Kbuild plumbing for SI476x MFD core
>   Add the main bulk of core driver for SI476x code
>   Add commands abstraction layer for SI476X MFD
>   Add chip properties handling code for SI476X MFD
>   Add a V4L2 driver for SI476X MFD
>   Add a codec driver for SI476X MFD

What is the final destiny of this patch series?
I found that only "codec driver for SI476X MFD" is pushed in kernel
3.8 by Mark Brown and that's all, is it? I can't find this patch
series on patchwork.linuxtv.org or in media git trees, for example,
scheduled for 3.9.

I also see that comments for this patches aren't answered and looks
like v4 is necessary.
Andrey, do you plan to make v4 series? May be it was already emailed
but i can't find it. Maybe review or comments from alsa and mfd
communities are missed?

So, without v4 it will not find its way into kernel, right?

-- 
Best regards, Klimov Alexey
