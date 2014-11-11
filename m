Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaKKM0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:26:43 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39965 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaKKM0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:26:40 -0500
Date: Tue, 11 Nov 2014 13:26:36 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: lee.jones@linaro.org, laurentiu.palcu@intel.com, johan@kernel.org,
        wsa@the-dreams.de, julia.lawall@lip6.fr, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: dln2: simplify return flow for dln2_i2c_enable
Message-ID: <20141111122636.GF29789@localhost>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
 <1415708457-18798-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415708457-18798-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:20:57PM +0200, Octavian Purdila wrote:
> This fixes the following kbuild test robot warning:
> 
> >> drivers/i2c/busses/i2c-dln2.c:70:1-4: WARNING: end returns can be simplified if negative or 0 value
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/i2c/busses/i2c-dln2.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-dln2.c b/drivers/i2c/busses/i2c-dln2.c
> index 010a5fa..b3fb86a 100644
> --- a/drivers/i2c/busses/i2c-dln2.c
> +++ b/drivers/i2c/busses/i2c-dln2.c
> @@ -54,7 +54,6 @@ struct dln2_i2c {
>  
>  static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
>  {
> -	int ret;
>  	u16 cmd;
>  	struct {
>  		u8 port;
> @@ -67,11 +66,7 @@ static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
>  	else
>  		cmd = DLN2_I2C_DISABLE;
>  
> -	ret = dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));

This looks like a bogus warning. It's not generally equivalent (ret > 0)
and is not mandated by any style guide lines.

Johan
