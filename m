Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab3FSPtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:49:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55575 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:49:38 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-49-51c1d30f5bae
Message-id: <51C1D30D.1050907@samsung.com>
Date: Wed, 19 Jun 2013 17:49:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, benoit.cousson@linaro.org,
        mchehab@redhat.com, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v7 1/9] drivers: phy: add generic PHY framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-2-git-send-email-kishon@ti.com>
In-reply-to: <1371113039-5784-2-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xq7r8lw8GGkxaImoxZ/0aNou/k46x
	W3y7vYnZ4uD9eouZn26yWcy6FmQx53wLi8WB2Q9ZLQ782cFo0bx4PZvFhac9bBabHl9jtVjY
	toTF4vKuOWwWs5f0s1gsWtbKbHH7Mq/FnqOH2S32925gsnjWv4fR4vCKA0wW615OZ7F43beG
	2eLpuiXMFjemt7Ba7L/i5SDl0dLcw+bx+9ckRo9vXyexeCz4fIXd48jtGcweW1beZPJ4tXom
	q8eda3vYPE7M+M3isX/uGnaPzUvqPc7PWMjo0dv8js3j/b6rbB7Hb2xn8vi8SS5AIIrLJiU1
	J7MstUjfLoEr4+rJY+wFPwUqbjRqNDD+5uli5OSQEDCRWD53GhuELSZx4d56IJuLQ0hgKaPE
	7M7NrBDOJ0aJ4433WUCqeAW0JGZ+fAnWwSKgKtHXvokRxGYTMJToPdoHZosKBEgsXnKOHaJe
	UOLH5HtgvSJAvad3/mAGGcoscItF4vfsi8wgCWEBZ4kzWx6CDRUSyJeY2HkMqIGDg1PAVmLn
	Ez+QMLOAjsT+VohLmQXkJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGppckFxUnqukV5xYm5x
	aV66XnJ+7iZGSBr4uoNx6TGrQ4wCHIxKPLwzOQ8GCrEmlhVX5h5ilOBgVhLhXXoUKMSbklhZ
	lVqUH19UmpNafIiRiYNTqoHRN/itwLrNxSmRHTzMStxxt+vNHJNOTU73yyiY/Ykn56T65zWu
	XK0lcnuf1Bdft4ta1fnvwIVZt0JLFx67xuetaBMTsH7dthP8KcyRDps/v9/6ySdzivOq3MMt
	zzW8F9nmm1dL7va2mnWHa6dZtXRMs6TxXet4ZSeRFBmduCa39+LzoziWNCuxFGckGmoxFxUn
	AgC4HMdE4QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/13/2013 10:43 AM, Kishon Vijay Abraham I wrote:
> +/**
> + * phy_create() - create a new phy
> + * @dev: device that is creating the new phy
> + * @id: id of the phy
> + * @ops: function pointers for performing phy operations
> + * @label: label given to the phy
> + * @priv: private data from phy driver
> + *
> + * Called to create a phy using phy framework.
> + */
> +struct phy *phy_create(struct device *dev, u8 id, const struct phy_ops *ops,
> +	const char *label, void *priv)
> +{
> +	int ret;
> +	struct phy *phy;
> +
> +	if (!dev) {
> +		dev_WARN(dev, "no device provided for PHY\n");
> +		ret = -EINVAL;
> +		goto err0;
> +	}
> +
> +	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		ret = -ENOMEM;
> +		goto err0;
> +	}
> +
> +	device_initialize(&phy->dev);
> +
> +	phy->dev.class = phy_class;
> +	phy->dev.parent = dev;
> +	phy->dev.of_node = dev->of_node;
> +	phy->id = id;
> +	phy->ops = ops;
> +	phy->label = label;

Perhaps we could make it:

	phy->label = kstrdup(label, GFP_KERNEL);

and free the label in phy_destroy() ?

That way the users would't need to keep the label around. It might
be useful when PHY provider generates the labels dynamically. I guess
it is OK for PHY providers to hard code the labels and having the PHY
user drivers passed labels in platform data ?

> +	dev_set_drvdata(&phy->dev, priv);
> +
> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);
> +	if (ret)
> +		goto err1;
> +
> +	ret = device_add(&phy->dev);
> +	if (ret)
> +		goto err1;
> +
> +	if (pm_runtime_enabled(dev))
> +		pm_runtime_enable(&phy->dev);
> +
> +	return phy;
> +
> +err1:
> +	put_device(&phy->dev);
> +	kfree(phy);
> +
> +err0:
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(phy_create);

> +/**
> + * phy_destroy() - destroy the phy
> + * @phy: the phy to be destroyed
> + *
> + * Called to destroy the phy.
> + */
> +void phy_destroy(struct phy *phy)
> +{
> +	pm_runtime_disable(&phy->dev);
> +	device_unregister(&phy->dev);

Isn't kfree(phy); missing here ?

> +}
> +EXPORT_SYMBOL_GPL(phy_destroy);

Thanks,
Sylwester
