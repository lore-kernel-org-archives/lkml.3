Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaB0PWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:22:42 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44537 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaB0PWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:22:41 -0500
Date: Thu, 27 Feb 2014 15:22:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Denis Carikli <denis@eukrea.com>
Cc: Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv12] video: backlight: gpio-backlight: Add DT support.
Message-ID: <20140227152229.GB24910@lee--X1>
References: <1393511313-18756-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393511313-18756-1-git-send-email-denis@eukrea.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Denis Carikli wrote:

> Signed-off-by: Denis Carikli <denis@eukrea.com>
> ---
> ChangeLog v11-resend->v12:
> - Moved the Cc from the commit message to the "email patch".
> - The documentation is now more clear.
> - The unnecessary default_on variable was removed.
> - gbl->fbdev was already NULL and didn't need to be re-assigned,
>   so the re-assignement was removed.
> - The of_device_id struct and .of_match_table are now guarded
>   against the driver beeing compiled without CONFIG_OF.
> 
> ChangeLog v11->v11-resend:
> - Removed the Cc list because it's only one patch.
> 
> ChangeLog v10->v11:
> - Shrinked the Cc list.
> - Fixed the of_match_table warning.
> 
> ChangeLog v9->v10:
> - Only the respective maintainers, or people who responded to the patch
>   were kept in the Cc.
> - The unnecessary of_match_ptr in of_match_table was removed.
> 
> ChangeLog v8->v9:
> - Added Shawn Guo in the Cc list.
> - The default-brightness-level is now a boolean default-on property,
>   the gpio is only touched if the gpio-backlight driver instance probes.
> - The code and documentation was updated accordingly.
> 
> ChangeLog v7->v8:
> - The default-state was renamed to default-brightness-level.
> - default-brightness-level is now mandatory, like for backlight-pwm,
>   That way we avoid having to handle the case where it's not set,
>   which means that we would need not to set the gpio, but still
>   report a brightness value for sysfs, when not all gpio controllers are
>   able to read the gpio value.
> - switched the default-brightness-level to boolean values (0 or 1) instead
>   of using strings ("on", "off", "keep").
> - The documentation was updated accordingly.
> - The example in the documentation now uses the dts gpio defines.
> - The "backlight: gpio_backlight: Use a default state enum." patch was then
>   dropped, becuase it is not necessary anymore.
> 
> ChangeLog v6->v7:
> - removed a compilation warning with the removal of the useless ret declaration.
> 
> ChangeLog v5->v6:
> - The default state handling was reworked:
>   - it's now called default-state, and looks like the gpio-leds default-state.
>   - it now has a "keep" option, like for the gpio-leds.
>   - that "keep" option is the default when the default-state property is not set.
> - The documentation was updated accordingly.
> 
> ChangeLog v4->v5:
> - The default-brightness property now defaults to 0 in the driver.
> - def_value int becomes a bool.
> - The check for the gpio validity has been reworked.
> ---
>  .../bindings/video/backlight/gpio-backlight.txt    |   16 ++++++
>  drivers/video/backlight/gpio_backlight.c           |   58 +++++++++++++++++---
>  2 files changed, 67 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt

Patch looks good to me now, I just want to see if Jingoo and/or Bryan
with to add anything. If they don't respond within the next couple of
days I'll apply the patch.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
