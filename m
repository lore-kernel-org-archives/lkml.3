Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaGQKXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:23:52 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36547 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaGQKXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:23:48 -0400
Date: Thu, 17 Jul 2014 11:23:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v3 0/7] i2c: Relax mandatory I2C ID table passing
Message-ID: <20140717102342.GD30888@lee--X1>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Are you going to take a lot at this set?

> As previously discussed I believe it should be okay for an I2C device
> driver _not_ supply an I2C ID table to match to.  The I2C subsystem
> should be able to match via other means, such as via OF tables.  The
> blocking factor during our previous conversation was to keep
> registering via sysfs up and running.  This set does that.
> 
> After thinking more deeply about the problem, it occurred to me that
> any I2C device driver which uses the sysfs method and issues an
> of_match_device() would also fail their probe().  Bolted on to this
> set is a new, more generic way for these devices to match against
> either of the I2C/OF tables.
> 
> I hope this ticks all of your boxes.
> 
> v3:
>   - Insist on passing 'struct i2c_client' instead of 'struct device'
>   - Remove hook from of_match_device()
> 
> v2:
>   - Removal of ACPI support (this is really an OF issue).
>   - Add a new .probe2( with will seamlessly replace
>   - Supply a warning on devices matching via OF without a suitable compatible
>   - Remove unified match_device() - bad idea as it subverts type-safe behaviour
>   - Provide examples of the kind of clean-up possible after this set.
>     - I already have the full support from the maintainer of these drivers =;-)
> 
> Kind regards,
> Lee
> 
>  arch/arm/configs/multi_v7_defconfig |  1 +
>  drivers/i2c/i2c-core.c              | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  drivers/mfd/88pm860x-core.c         |  5 ++---
>  drivers/mfd/as3722.c                | 12 ++----------
>  include/linux/i2c.h                 | 22 +++++++++++++++++++++-
>  5 files changed, 89 insertions(+), 23 deletions(-)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
