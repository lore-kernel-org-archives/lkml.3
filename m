Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3CKFms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:42:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3CKFmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:42:47 -0400
Message-ID: <513D6F40.6080202@ti.com>
Date: Mon, 11 Mar 2013 11:14:32 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Subject: Re: [PATCH 6/8] memory: emif: fix timings initialization issue
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-7-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-7-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject is too vague. What issue ?
Some thing like "Fix the incorrect 'size' parameter in memcpy' etc

On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
> From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
> 
> The issue was that only the first timings table was added to the
> emif platform data at the emif driver registration. All other
> timings tables was filled with zeros. Now all emif timings table
> are added to the platform data.
>
Luckily, most of the cases, first table has been re-used for
symmetric configuration.
 
> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/memory/emif.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
> index 02a94fc..f75806a 100644
> --- a/drivers/memory/emif.c
> +++ b/drivers/memory/emif.c
> @@ -1463,7 +1463,7 @@ static struct emif_data *__init_or_module get_device_details(
>  	if (pd->timings) {
>  		temp = devm_kzalloc(dev, size, GFP_KERNEL);
>  		if (temp) {
> -			memcpy(temp, pd->timings, sizeof(*pd->timings));
> +			memcpy(temp, pd->timings, size);
>  			pd->timings = temp;
>  		} else {
>  			dev_warn(dev, "%s:%d: allocation error\n", __func__,
> 
Patch as such looks good to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
