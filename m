Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3CMGFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:05:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60694 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3CMGFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:05:49 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 12 Mar 2013 23:05:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [5/6] i2c: Ignore the return value of i2c_del_mux_adapter()
Message-ID: <20130313060547.GA8607@roeck-us.net>
References: <1362853009-20789-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362853009-20789-6-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 06:16:48PM -0000, Lars-Peter Clausen wrote:
> i2c_del_mux_adapter() always returns 0. So all checks testing whether it will be
> non zero will always evaluate to false and the conditional code is dead code.
> This patch updates all callers of i2c_del_mux_adapter() to ignore its return
> value and assume that it will always succeed (which it will). A subsequent
> patch will make the return type of i2c_del_mux_adapter() void.
> 
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> drivers/i2c/muxes/i2c-mux-pca954x.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
> index 8e43872..a531d80 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -262,13 +262,11 @@ static int pca954x_remove(struct i2c_client *client)
>  {
>  	struct pca954x *data = i2c_get_clientdata(client);
>  	const struct chip_desc *chip = &chips[data->type];
> -	int i, err;
> +	int i;
>  
>  	for (i = 0; i < chip->nchans; ++i)
>  		if (data->virt_adaps[i]) {
> -			err = i2c_del_mux_adapter(data->virt_adaps[i]);
> -			if (err)
> -				return err;
> +			i2c_del_mux_adapter(data->virt_adaps[i]);
>  			data->virt_adaps[i] = NULL;
>  		}
>  
