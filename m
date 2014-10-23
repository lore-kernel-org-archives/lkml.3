Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaJWEk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:40:57 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48972 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaJWEkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <1414037002-25528-12-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-12-git-send-email-linux@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 22 Oct 2014 21:40:14 -0700
Message-ID: <CAGVrzcbfkSK58iCPouMc4g8MBrAPBemi8QyP6_33xtYiRWFCHg@mail.gmail.com>
Subject: Re: [PATCH 11/14] net: dsa: Add support for reading switch registers
 with ethtool
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
> Add support for reading switch registers with 'ethtool -d'.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

[snip]

>
> +static int dsa_slave_get_regs_len(struct net_device *dev)
> +{
> +       struct dsa_slave_priv *p = netdev_priv(dev);
> +       struct dsa_switch *ds = p->parent;
> +
> +       if (ds->drv->get_regs_len != NULL)
> +               return ds->drv->get_regs_len(ds, p->port);

Most of the checks in this file are just:

if (ds->drv->callback)
     return ds->drv->callback(...)

> +
> +       return -EOPNOTSUPP;
> +}
> +
> +static void
> +dsa_slave_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *_p)
> +{
> +       struct dsa_slave_priv *p = netdev_priv(dev);
> +       struct dsa_switch *ds = p->parent;
> +
> +       ds->drv->get_regs(ds, p->port, regs, _p);

We need to check that the driver does implement this callback here as well.
-- 
Florian
