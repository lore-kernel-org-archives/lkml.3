Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3AYOZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:25:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41364 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3AYOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:25:11 -0500
Message-ID: <510295BF.80709@ti.com>
Date: Fri, 25 Jan 2013 15:25:03 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@list.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return
 code
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-10-git-send-email-arnd@arndb.de>
In-Reply-To: <1359123276-15833-10-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 03:14 PM, Arnd Bergmann wrote:
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

I've fixed up Kevin's email since he is no longer with TI and added Tero to
the CC list since this is *something*-power on OMAP platforms ;)

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

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
>  				       int len)
>  {
> -	int err;
> +	int err = -EINVAL;
>  
>  	for (; len; len--, address++, script++) {
>  		if (len == 1) {
> 


-- 
Péter
