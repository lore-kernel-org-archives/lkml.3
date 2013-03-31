Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3CaJYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 05:24:09 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:29531 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3CaJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 05:24:07 -0400
Date: Sun, 31 Mar 2013 11:23:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 5/6] i2c: Ignore the return value of
 i2c_del_mux_adapter()
Message-ID: <20130331112357.030b9310@endymion.delvare>
In-Reply-To: <1362853009-20789-6-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	<1362853009-20789-6-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Mar 2013 19:16:48 +0100, Lars-Peter Clausen wrote:
> i2c_del_mux_adapter() always returns 0. So all checks testing whether it will be
> non zero will always evaluate to false and the conditional code is dead code.
> This patch updates all callers of i2c_del_mux_adapter() to ignore its return
> value and assume that it will always succeed (which it will). A subsequent
> patch will make the return type of i2c_del_mux_adapter() void.
> 
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/i2c/muxes/i2c-mux-pca954x.c | 6 ++----
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

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
