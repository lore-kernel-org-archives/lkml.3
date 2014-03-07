Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaCGAev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:34:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCGAet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:34:49 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-1c-531914272319
Message-id: <53191428.1090900@samsung.com>
Date: Fri, 07 Mar 2014 09:34:48 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] iio: cm36651: Fix i2c client leak and possible NULL
 pointer dereference
References: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQFddRDLYYMFHNYsHTauYLF6/MLRY
	Mnk+q8W8I+9YLC7vmsPmwOqxaVUnm8eSN4dYPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj
	1OFXrAVfBCv6zmxkbGD8wtfFyMkhIWAi0fTkCwuELSZx4d56ti5GLg4hgaWMEhN/72GDKfr9
	voEVIrGIUWLZ7++MEM5rRokX73ezg1TxCmhJtLx8CWazCKhKbN7wmhXEZhPQlHg/5QrYClGB
	CIm5EzezQdQLSvyYfA8sLiIwmVHi0gFeEJtZQENiyv9tYHFhgTiJ9V8uM4LYQgLuEjta3jOB
	2JwCHhKXmx6zQNTrSOxvncYGYctLbF7zlhnkOAmBbewS3Z+mMkMcJCDxbfIhoAYOoISsxKYD
	zBCfSUocXHGDZQKj2CwkJ81CMnYWkrELGJlXMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgRG
	1ul/zybuYLx/wPoQYzLQyonMUqLJ+cDIzCuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGxoTnlamMzA31jvI7lFesu/F2Q6ip7nfBoF9yt1/FeCSL
	ry3fObFSvebdzRtfN25o2Zx14qvbs+grfar/lGeprmt77eBmZeS6llmr4vGV2//rDj7xOfbe
	im320XvnLz3fwVwSwiOaOaWvVNpm8dH9zA/YY89bs3x+25tRwPRJdsOKSrmK+dMCnyqxFGck
	GmoxFxUnAgCQ2iYEwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK66iGSwwZ618hYPmlYxWbx+YWix
	ZPJ8Vot5R96xWFzeNYfNgdVj06pONo8lbw6xevRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYQ1jxqnDr1gLvghW9J3ZyNjA+IWvi5GTQ0LAROL3+wZWCFtM
	4sK99WxdjFwcQgKLGCWW/f7OCOG8ZpR48X43O0gVr4CWRMvLl2A2i4CqxOYNr8G62QQ0Jd5P
	ucICYosKREjMnbiZDaJeUOLH5HtgcRGByYwSlw7wgtjMAhoSU/5vA4sLC8RJrP9ymRHEFhJw
	l9jR8p4JxOYU8JC43PSYBaJeR2J/6zQ2CFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEx+0zqR2MKxssDjEKcDAq8fB2LJIIFmJNLCuuzD3EKMHB
	rCTC6/8dKMSbklhZlVqUH19UmpNafIgxGRgCE5mlRJPzgSklryTe0NjEzMjSyNzQwsjYnDRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYkzPuvpnLHrcj2kn7jex9NuOIwI19/R2yl+J/
	Mx86Mu3Wf5USj4+6Vvdl4zQd2W3E1x5bdKXM7o+dfYMN47Yby3T5JmUoeOd9OCZyPHnh9x0e
	rmvyJPf8qN8vohZTrv6rcmO39fJjn3nvH3+99BR3pUV7TPqmF3Ny7CZ4dFZz8SR3q3ouX8us
	xFKckWioxVxUnAgAz6vAwB8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 06:33 PM, Krzysztof Kozlowski wrote:
> During probe the driver allocates dummy I2C devices (i2c_new_dummy())
> but they aren't unregistered during driver remove or probe failure.
> 
> Additionally driver does not check the return value of i2c_new_dummy().
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later
> dereferenced by i2c_smbus_{read,write}_data() functions.
> 
> Fix issues by properly checking for i2c_new_dummy() return value and
> unregistering I2C devices on driver remove or probe failure.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Thanks,

Acked-by: Beomho Seo <beomho.seo@samsung.com>

> ---
>  drivers/iio/light/cm36651.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
> index a45e07492db3..e7e9a597159f 100644
> --- a/drivers/iio/light/cm36651.c
> +++ b/drivers/iio/light/cm36651.c
> @@ -653,6 +653,11 @@ static int cm36651_probe(struct i2c_client *client,
>  	cm36651->ps_client = i2c_new_dummy(client->adapter,
>  						     CM36651_I2C_ADDR_PS);
>  	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
> +	if (!cm36651->ps_client || !cm36651->ara_client) {
> +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> +		ret = -ENODEV;
> +		goto error_i2c_unregister;
> +	}
>  	mutex_init(&cm36651->lock);
>  	indio_dev->dev.parent = &client->dev;
>  	indio_dev->channels = cm36651_channels;
> @@ -687,6 +692,11 @@ error_free_irq:
>  	free_irq(client->irq, indio_dev);
>  error_disable_reg:
>  	regulator_disable(cm36651->vled_reg);
> +error_i2c_unregister:
> +	if (cm36651->ps_client)
> +		i2c_unregister_device(cm36651->ps_client);
> +	if (cm36651->ara_client)
> +		i2c_unregister_device(cm36651->ara_client);
>  	return ret;
>  }
>  
> @@ -698,6 +708,8 @@ static int cm36651_remove(struct i2c_client *client)
>  	iio_device_unregister(indio_dev);
>  	regulator_disable(cm36651->vled_reg);
>  	free_irq(client->irq, indio_dev);
> +	i2c_unregister_device(cm36651->ps_client);
> +	i2c_unregister_device(cm36651->ara_client);
>  
>  	return 0;
>  }
> 


-- 
Best Regards,
