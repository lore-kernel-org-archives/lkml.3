Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031361Ab3HIWYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:24:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62938 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031329Ab3HIWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:24:08 -0400
Date: Fri, 9 Aug 2013 15:19:31 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Balint Czobor <czoborbalint@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: power: Add support for BATTERY_ARIESVE
Message-ID: <20130809221931.GH12638@lizard.sbx05730.santaca.wayport.net>
References: <1374676030-4534-1-git-send-email-czoborbalint@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374676030-4534-1-git-send-email-czoborbalint@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:27:10PM +0200, Balint Czobor wrote:
> Add initial support for the battery in Samsung ARIESVE.
> 
> Signed-off-by: Balint Czobor <czoborbalint@gmail.com>
> ---
>  arch/arm/mach-msm/include/mach/msm_battery.h   |   31 +
>  arch/arm/mach-msm/include/mach/msm_rpcrouter.h |  376 ++++
>  drivers/power/Kconfig                          |   14 +
>  drivers/power/Makefile                         |    1 +
>  drivers/power/ariesve_battery.c                | 2710 ++++++++++++++++++++++++
>  drivers/power/fuelgauge_max17043.c             |  434 ++++
>  drivers/power/power_supply_sysfs.c             |   19 +-
>  include/linux/earlysuspend.h                   |   56 +
>  include/linux/leds-pmic8058.h                  |   40 +
>  include/linux/mfd/pm8xxx/batt-alarm.h          |  201 ++
>  include/linux/mfd/pm8xxx/gpio.h                |  162 ++
>  include/linux/mfd/pm8xxx/misc.h                |  284 +++
>  include/linux/mfd/pm8xxx/mpp.h                 |  263 +++
>  include/linux/mfd/pm8xxx/nfc.h                 |   79 +
>  include/linux/mfd/pm8xxx/tm.h                  |   42 +
>  include/linux/mfd/pm8xxx/upl.h                 |   65 +
>  include/linux/mfd/pm8xxx/vibrator.h            |   39 +
>  include/linux/mfd/pmic8058.h                   |  137 ++
>  include/linux/pmic8058-othc.h                  |  146 ++
>  include/linux/pmic8058-pwm.h                   |  148 ++
>  include/linux/pmic8058-xoadc.h                 |  121 ++
>  include/linux/power_supply.h                   |   13 +-
>  include/linux/regulator/pm8058-xo.h            |   31 +
>  include/linux/regulator/pmic8058-regulator.h   |   89 +
>  include/linux/wakelock.h                       |   90 +

Thanks for the driver! There are a lot of issues with the patch, though.

Most of the header files are not needed for this driver. The patch should
also be split into several parts (i.e. power_supply_sysfs.c changes should
be aside). In the patch there is a lot of dead (commented-out) code and
code that completely violates Linux coding standards.

I would say that for now, drivers/staging/ is more appropriate place for
the driver. Meanwhile, be sure to read Documentation/CodingStyle and
Documentation/SubmittingPatches. And a special url about #ifdefs in .c
files, typedefs, etc.:

http://kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/

Thanks,

Anton
