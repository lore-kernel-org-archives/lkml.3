Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3AYOgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:36:01 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47521 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3AYOf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:35:59 -0500
MIME-Version: 1.0
In-Reply-To: <1359123276-15833-10-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359123276-15833-10-git-send-email-arnd@arndb.de>
Date: Fri, 25 Jan 2013 14:35:59 +0000
Message-ID: <CAP245DXybs0dgg8B=5+28WJXd15s+CsHvXYpc0891wuLUWrpgQ@mail.gmail.com>
Subject: Re: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return code
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 2:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> If the twl4030_write_script function gets called with
> a zero length argument, its return value does not
> get set. We know that all scripts have a nonzero
> length, but returning an error in case they ever
> do is probably appropriate.
>
> Without this patch, building omap2plus_defconfig results in:
>
> drivers/mfd/twl4030-power.c: In function 'load_twl4030_script':
> drivers/mfd/twl4030-power.c:414:5: error: 'err' may be used uninitialized in this function

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> ---
>  drivers/mfd/twl4030-power.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 4dae241..dd362c1 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -159,7 +159,7 @@ out:
>  static int twl4030_write_script(u8 address, struct twl4030_ins *script,
>                                        int len)
>  {
> -       int err;
> +       int err = -EINVAL;
>
>         for (; len; len--, address++, script++) {
>                 if (len == 1) {
> --
> 1.8.0
>
