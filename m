Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3HMVEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:04:38 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58062 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab3HMVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 14:04:14 -0700
Message-ID: <CAK5ve-KzJa9QXDXWehUsqrs5E_NeSkHsbktfzPrOtfHducyMQw@mail.gmail.com>
Subject: Re: [PATCH 00/10] leds: lp5521,5523: restore device attributes for
 running LED patterns
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> This patch-set resolves the application conflict by restoring sysfs files.
>
> For LP5521
>   engine1/2/3_mode
>   engine1/2/3_load
>
> For LP5523
>   engine1/2/3_mode
>   engine1/2/3_load
>   engine1/2/3_leds
>
> Those attributes are accessed when LED pattern is run by custom application.
> Those were removed when LED pattern interface was changed to generic firmware
> interface. Please refer to commits below.
>
>   git commit 9ce7cb170f97f83a78dc948bf7d25690f15e1328
>   (leds-lp5521: use generic firmware interface)
>
>   git commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
>   (leds-lp5523: use generic firmware interface)
>
> Necessary attributes are restored in this patch-set.
>
> (Other changes)
> New data structure is added for handling values from/to an application.
> Few code fixes for reducing writing I2C commands.
> Add LP55xx common macros for code refactoring.
> Documentation updates.
>
> You can also pull from the location below
> This branch is based on 'for-next' of linux-leds.
>
>   https://github.com/milokim/lp55xx.git resolve-missing-sysfs
>

Thanks, I've already merged the whole patchset in my -devel branch [1].

Pali, could you please help to test it on your hardware? Just grab my
-devel branch and build then run.

Thanks,
-Bryan

[1]: http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/log/?h=devel

> Milo Kim (10):
>   leds: lp55xx: add common data structure for program
>   leds: lp55xx: add common macros for device attributes
>   leds: lp5521: restore legacy device attributes
>   leds: lp5521: remove unnecessary writing commands
>   leds: lp5523: make separate API for loading engine
>   leds: lp5523: LED MUX configuration on initializing
>   leds: lp5523: restore legacy device attributes
>   leds: lp5523: remove unnecessary writing commands
>   Documentation: leds-lp5521,lp5523: update device attribute
>     information
>   leds: lp5562: use LP55xx common macros for device attributes
>
>  Documentation/leds/leds-lp5521.txt |   20 ++-
>  Documentation/leds/leds-lp5523.txt |   21 ++-
>  drivers/leds/leds-lp5521.c         |  114 +++++++++++--
>  drivers/leds/leds-lp5523.c         |  321 ++++++++++++++++++++++++++++++++++--
>  drivers/leds/leds-lp5562.c         |    4 +-
>  drivers/leds/leds-lp55xx-common.h  |   66 ++++++++
>  6 files changed, 511 insertions(+), 35 deletions(-)
>
> --
> 1.7.9.5
>
