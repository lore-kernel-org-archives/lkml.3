Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3FTJ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:57:29 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44457 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab3FTJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5F2F56@DE02WEMBXB.internal.synopsys.com>
References: <1371629537-8076-1-git-send-email-abrodkin@synopsys.com>
 <CAHp75Vc-Aza03ZLJj3CkLP2YhvdRi94bfutxKbV34hTc1_6k4g@mail.gmail.com> <4881796E12491D4BB15146FE0209CE643F5F2F56@DE02WEMBXB.internal.synopsys.com>
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 20 Jun 2013 10:56:46 +0100
X-Google-Sender-Auth: b75K3pXAUE0-mFx36JRcomTNAws
Message-ID: <CAGVrzcYoz-pGG46otLjZDHs=xek-qpPEWxUtDQV1CcWCPs8WYg@mail.gmail.com>
Subject: Re: [PATCH v5] ethernet/arc/arc_emac - Add new driver
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/20 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
[snip]

>
> In general MDIO register gets polled by "libphy" once in a couple of
> seconds, so delay of 25 milliseconds IMHO is fine.
>
>>> +int arc_mdio_probe(struct device_node *dev_node, struct arc_emac_priv *priv)
>>> +{
>>
>>> +       snprintf(bus->id, MII_BUS_ID_SIZE, "%.8x", (unsigned int)priv->regs);
>>
>> Is bus->id exposed to user-space somehow?
>
> Well as a boot-up message from "libphy":
> ====
> libphy: Synopsys MII Bus: probed
> ====

Well not only as a boot-up message, this serves as unique identifer in
the entire system for your MDIO bus. It is crucial that you have an
unique MDIO bus identifier for at least the two following reasons:

- the corresponding kobject/sysfs node that is going to be created
also needs to be unique in the system
- you may have multiple MDIO bus in the system (e.g: the one for your
specific driver and the fixed MDIO bus)

Since you are using Device Tree already, you may just turn this into:

snprintf(bus->id, MII_BUS_ID_SIZE, "%s", pdev->name);

assuming that your node is already properly labelleled (e.g:
mdio@deadbeef) which would be exactly equivalent to what you are doing
with priv->regs;
--
Florian
