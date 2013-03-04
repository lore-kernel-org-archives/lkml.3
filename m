Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3CDUSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:18:08 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52413 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3CDUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130228110611.3ed77e92@endymion.delvare>
References: <20130228110611.3ed77e92@endymion.delvare>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Mon, 4 Mar 2013 14:17:32 -0600
Message-ID: <CAM0nabH8Ad7dg3gNgAGJWz3k2NVFtaB_mXPreE-2tmyaNy0rhA@mail.gmail.com>
Subject: Re: [PATCH RESEND] char/tpm: Convert struct i2c_msg initialization to
 C99 format
To: Jean Delvare <khali@linux-fr.org>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 4:06 AM, Jean Delvare <khali@linux-fr.org> wrote:
> From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
>
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
>
> Thanks to Julia Lawall for automating the conversion.

Staged here:

https://github.com/shpedoikal/linux.git tpmdd-03-04-13

Thanks,
Kent

> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Peter Huewe <peter.huewe@infineon.com>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> v2: removed zero initialization of flags.
>
> Patch already sent by Shubhrajyoti Datta on 2012-10-10.
>
>  drivers/char/tpm/tpm_i2c_infineon.c |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> --- linux-3.9-rc0.orig/drivers/char/tpm/tpm_i2c_infineon.c      2013-02-28 09:54:50.184560055 +0100
> +++ linux-3.9-rc0/drivers/char/tpm/tpm_i2c_infineon.c   2013-02-28 10:59:08.639682373 +0100
> @@ -90,8 +90,17 @@ static struct i2c_driver tpm_tis_i2c_dri
>  static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>  {
>
> -       struct i2c_msg msg1 = { tpm_dev.client->addr, 0, 1, &addr };
> -       struct i2c_msg msg2 = { tpm_dev.client->addr, I2C_M_RD, len, buffer };
> +       struct i2c_msg msg1 = {
> +               .addr = tpm_dev.client->addr,
> +               .len = 1,
> +               .buf = &addr
> +       };
> +       struct i2c_msg msg2 = {
> +               .addr = tpm_dev.client->addr,
> +               .flags = I2C_M_RD,
> +               .len = len,
> +               .buf = buffer
> +       };
>
>         int rc;
>         int count;
> @@ -138,7 +147,11 @@ static int iic_tpm_write_generic(u8 addr
>         int rc = -EIO;
>         int count;
>
> -       struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
> +       struct i2c_msg msg1 = {
> +               .addr = tpm_dev.client->addr,
> +               .len = len + 1,
> +               .buf = tpm_dev.buf
> +       };
>
>         if (len > TPM_BUFSIZE)
>                 return -EINVAL;
>
>
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
