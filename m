Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3KURIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:08:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35792 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KURIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:08:53 -0500
Message-ID: <528E3D56.5010908@ti.com>
Date: Thu, 21 Nov 2013 19:05:26 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-i2c@vger.kernel.org>, <linaro-networking@linaro.org>
Subject: Re: [PATCH] i2c: davinci: raw read and write endian fix
References: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
In-Reply-To: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 08:23 PM, Taras Kondratiuk wrote:
> I2C IP block expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
> Based on Linus' master tip (b4789b8).
> Tested on Keystone2 EVM.
>
>   drivers/i2c/busses/i2c-davinci.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 132369f..a629447 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -125,12 +125,12 @@ static struct davinci_i2c_platform_data davinci_i2c_platform_data_default = {
>   static inline void davinci_i2c_write_reg(struct davinci_i2c_dev *i2c_dev,
>   					 int reg, u16 val)
>   {
> -	__raw_writew(val, i2c_dev->base + reg);
> +	writew_relaxed(val, i2c_dev->base + reg);
>   }
>
>   static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
>   {
> -	return __raw_readw(i2c_dev->base + reg);
> +	return readw_relaxed(i2c_dev->base + reg);
>   }
>
>   /* Generate a pulse on the i2c clock pin. */
>

