Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaESMqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:46:53 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57928 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESMqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:46:50 -0400
Message-ID: <5379FD39.7020605@cogentembedded.com>
Date: Mon, 19 May 2014 16:46:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
CC: kernel-janitors@vger.kernel.org, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/13] wimax/i2400m: make return of 0 explicit
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-5-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1400473875-22228-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-05-2014 8:31, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.

> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)

> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
>
> -ret = 0;
> ... when != ret = e
> return
> - ret
> + 0
>    ;
> // </smpl>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> Alternatively, is an error code wanted under the if?

>   drivers/net/wimax/i2400m/driver.c |    7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)

> diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
> index 9c34d2f..901a534 100644
> --- a/drivers/net/wimax/i2400m/driver.c
> +++ b/drivers/net/wimax/i2400m/driver.c
> @@ -500,26 +500,23 @@ int i2400m_pm_notifier(struct notifier_block *notifier,
>    */
>   int i2400m_pre_reset(struct i2400m *i2400m)
>   {
> -	int result;
>   	struct device *dev = i2400m_dev(i2400m);
>
>   	d_fnstart(3, dev, "(i2400m %p)\n", i2400m);
>   	d_printf(1, dev, "pre-reset shut down\n");
>
> -	result = 0;
>   	mutex_lock(&i2400m->init_mutex);
>   	if (i2400m->updown) {
>   		netif_tx_disable(i2400m->wimax_dev.net_dev);
>   		__i2400m_dev_stop(i2400m);
> -		result = 0;
>   		/* down't set updown to zero -- this way
>   		 * post_reset can restore properly */
>   	}
>   	mutex_unlock(&i2400m->init_mutex);
>   	if (i2400m->bus_release)
>   		i2400m->bus_release(i2400m);
> -	d_fnend(3, dev, "(i2400m %p) = %d\n", i2400m, result);
> -	return result;
> +	d_fnend(3, dev, "(i2400m %p) = %d\n", i2400m, 0);

    Again, why not just "(i2400m %p) = 0\n"?

> +	return 0;

WBR, Sergei

