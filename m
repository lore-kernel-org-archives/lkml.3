Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaELIgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaELIgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:36:49 -0400
Date: Mon, 12 May 2014 10:36:46 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Josef Gajdusek <atx@atx.name>
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: fix inverted set_hyst()
Message-ID: <20140512103646.76d64466@endymion.delvare>
In-Reply-To: <20140511124044.GA2730@dashie>
References: <20140511124044.GA2730@dashie>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josef,

On Sun, 11 May 2014 14:40:44 +0200, Josef Gajdusek wrote:
> Fixes inverted set_hyst() (i. e. writing 76000 actually set it to 74000)

This is a rather poor description of the symptoms. The typical result
from the bug is that you can't actually set the hysteresis value, the
driver with fail with "write error: Numerical result out of range".
Writing an hysteresis value above the critical limit to get the driver
to set it below that limit, is the workaround, not the symptom.

Also, the function is called store_hyst(), not set_hyst().

> Signed-off-by: Josef Gajdusek <atx@atx.name>
> ---
> diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
> index 90ec117..61d89d6 100644
> --- a/drivers/hwmon/emc1403.c
> +++ b/drivers/hwmon/emc1403.c
> @@ -163,7 +163,7 @@ static ssize_t store_hyst(struct device *dev,
>  	if (retval < 0)
>  		goto fail;
>  
> -	hyst = val - retval * 1000;
> +	hyst = retval * 1000 - val;
>  	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
>  	if (hyst < 0 || hyst > 255) {
>  		retval = -ERANGE;

Anyway, fix is correct, good catch.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

This should go to stable trees. Guenter, I'll let you deal with this,
thanks.

-- 
Jean Delvare
SUSE L3 Support
