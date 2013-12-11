Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3LKHP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:15:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57314 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKHP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:15:57 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net: of_mdio: Scan PHYs which have device_type set to ethernet-phy
Date: Wed, 11 Dec 2013 07:15:54 +0000
Message-ID: <1695129.4QIGmmVPkX@lenovo>
User-Agent: KMail/4.11.2 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1384441556-20674-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384441556-20674-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 novembre 2013, 15:05:56 Srinivas Kandagatla a écrit :
> According to Documentation/devicetree/bindings/net/phy.txt device_type
> property of PHY nodes is mandatory, which should be set to
> "ethernet-phy". This patch adds check in scanning phys and only scans
> node which have device-type set to "ethernet-phy".

Please CC netdev@vger.kernel.org as there might be networking folks not 
actively following devicetree-discuss.

> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  drivers/of/of_mdio.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index d5a57a9..78c53c7 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -57,6 +57,9 @@ int of_mdiobus_register(struct mii_bus *mdio, struct
> device_node *np)
> 
>  	/* Loop over the child nodes and register a phy_device for each one */
>  	for_each_available_child_of_node(np, child) {
> +		/* A PHY must have device_type set to "ethernet-phy" */
> +		if (of_node_cmp(child->type, "ethernet-phy"))
> +			continue;

As already stated by Grant this will break quite a lot of platforms out there. 
Technically speaking, ePAPR v1.1 only specifies that "cpu" and "memory" nodes 
should have a "device_type" property for compatibility. Altough I do agree 
that it is nice to have a properly set "device_type", we can't always rely on 
that. 
-- 
Florian
