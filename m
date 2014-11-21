Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaKUTic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:38:32 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:64311 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKUTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:38:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Karol Wrona <k.wrona@samsung.com>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/5] misc: sensorhub: Add sensorhub driver
Date: Fri, 21 Nov 2014 20:38:25 +0100
Message-ID: <3489864.y2krC9T9rK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416593957-19788-2-git-send-email-k.wrona@samsung.com>
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com> <1416593957-19788-2-git-send-email-k.wrona@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GJOryK/fBAo0F1YQ4OujfkPTW4/pzSIQehJbPeqUN5s
 uYqlWpdzlfP22q4W2nhG8IARgWIqIzhvBKlTFB0SxFil1DC2xt
 ZyBqRa57CxwR9SzysDgVc8oTdzm3slpjvlSRvstTtDWouLqqa9
 awwCmzlmWKug/XK7fk6zXU0RYxgoy/X/zbHGVsZYS7jKkKayv3
 lVIye9QNk5LQ4boolbNdcw7Z/pgDqb/8XeD5xbHp5bq/ERJEbv
 lTjdfraghx/NIzgsyfY9SU3F5HG0CF+hRtnAaEKfg0vrIsnz19
 YiFMhVnpQeWwwPUcYi9Z2yfFQqcyGTLRkrAhh1YItp3DOfLJbF
 738AN9ow/cPTPDqeVSgo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 19:19:13 Karol Wrona wrote:
> Sensorhub  is MCU dedicated to collect data and manage several sensors.
> Sensorhub is a spi device which provides a layer for IIO devices. It provides
> some data parsing and common mechanism for sensorhub sensors.
> 
> Adds common sensorhub library for sensorhub driver and iio drivers
> which uses sensorhub MCU to communicate with sensors.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/misc/Kconfig                   |    1 +
>  drivers/misc/Makefile                  |    1 +
>  drivers/misc/sensorhub/Kconfig         |   13 +
>  drivers/misc/sensorhub/Makefile        |    6 +
>  drivers/misc/sensorhub/ssp.h           |  279 +++++++++++
>  drivers/misc/sensorhub/ssp_dev.c       |  828 ++++++++++++++++++++++++++++++++
>  drivers/misc/sensorhub/ssp_spi.c       |  653 +++++++++++++++++++++++++
>  include/linux/iio/common/ssp_sensors.h |   79 +++

You seem to provide infrastructure for other drivers here, so I don't think
drivers/misc is a good place. Have you considered making this a regular
mfd driver? If that doesn't fit, is there possibly some place in the iio
framework for this kind of driver?

	Arnd
