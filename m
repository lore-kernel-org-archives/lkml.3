Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaE1Ske (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:40:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbaE1Skd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:40:33 -0400
Date: Wed, 28 May 2014 11:44:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Satish Patel <satish.patel@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        rob@landley.net, tony@atomide.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC
 controller
Message-ID: <20140528184408.GC30031@kroah.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
 <1401267437-22489-2-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401267437-22489-2-git-send-email-satish.patel@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
> +/**
> + * struct sc_phy - The basic smart card phy structure
> + *
> + * @dev: phy device
> + * @pdata: pointer to phy's private data structure
> + * @set_config: called to set phy's configuration
> + * @get_config: called to get phy's configuration
> + * @activate_card: perform smart card activation
> + * @deactivate_card: perform smart card de-activation
> + * @warm_reset: execute smart card warm reset sequence
> + * @register_card_activity_cb: register call back to phy device.
> + * This call back will be called on card insert or remove event
> + *
> + * smart card controller uses this interface to communicate with
> + * smart card via phy.Some smart card phy has multiple slots for
> + * cards. This inerface also enables controller to communicate with
> + * one or more smart card connected over phy.
> + */
> +struct sc_phy {
> +	/* phy's device pointer */
> +	struct device *dev;

So this is the "parent", right?  Why not embed a struct device into this
structure as well, further streaching out the device tree.

> +
> +	/* phy's private data */
> +	void *pdata;

If you do the above, then this pointer is not needed.


> +
> +	/* notify data, passed by interface user as a part of
> +	 * register_notify API. Data should be passed back when
> +	 * notification raised to the interface user
> +	 */
> +	void *notify_data;

What makes this different from the pdata?


> +
> +	int	(*set_config)(struct sc_phy *phy, u8 slot,
> +			enum sc_phy_config attr, int value);
> +	int	(*get_config)(struct sc_phy *phy, u8 slot, enum
> +			sc_phy_config attr);
> +	int	(*activate_card)(struct sc_phy *phy, u8 slot);
> +	int	(*deactivate_card)(struct sc_phy *phy, u8 slot);
> +	int	(*get_syncatr)(struct sc_phy *phy, u8 slot, u8 len, char *atr);
> +	int	(*warm_reset)(struct sc_phy *phy, u8 slot);
> +	int	(*register_notify)(struct sc_phy *phy,
> +			 struct	notifier_block *nb, void *notify_data);
> +	int	(*unregister_notify)(struct sc_phy *phy,
> +			struct	notifier_block *nb);
> +};
> +
> +#endif /* __SC_PHY_H__ */
> -- 
> 1.7.9.5
