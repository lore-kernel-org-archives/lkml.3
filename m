Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3KOPEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:04:47 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:50543 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3KOPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:04:29 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH RFC] net: of_mdio: Scan PHYs which have device_type set to ethernet-phy
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
In-Reply-To: <1384441556-20674-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384441556-20674-1-git-send-email-srinivas.kandagatla@st.com>
Date: Fri, 15 Nov 2013 10:35:28 +0900
Message-Id: <20131115013528.339CEC40618@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 15:05:56 +0000, Srinivas Kandagatla <srinivas.kandagatla@st.com> wrote:
> According to Documentation/devicetree/bindings/net/phy.txt device_type
> property of PHY nodes is mandatory, which should be set to
> "ethernet-phy". This patch adds check in scanning phys and only scans
> node which have device-type set to "ethernet-phy".
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Hi Srinivas,

Thanks for looking at this. However, there is a high likelyhood that
this patch will break existing platforms since we haven't enforced this
requirement before. Besides, I don't think the ethernet-phy binding is
necessary. The mere fact that it is a child of the MDIO bus node means
that the device is a PHY device for the purposes of the subsystem.

Nacked-by: Grant Likely <grant.likely@linaro.org>

g.

> ---
>  drivers/of/of_mdio.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index d5a57a9..78c53c7 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -57,6 +57,9 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  
>  	/* Loop over the child nodes and register a phy_device for each one */
>  	for_each_available_child_of_node(np, child) {
> +		/* A PHY must have device_type set to "ethernet-phy" */
> +		if (of_node_cmp(child->type, "ethernet-phy"))
> +			continue;
>  		/* A PHY must have a reg property in the range [0-31] */
>  		paddr = of_get_property(child, "reg", &len);
>  		if (!paddr || len < sizeof(*paddr)) {
> @@ -112,6 +115,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  
>  	/* auto scan for PHYs with empty reg property */
>  	for_each_available_child_of_node(np, child) {
> +		/* A PHY must have device_type set to "ethernet-phy" */
> +		if (of_node_cmp(child->type, "ethernet-phy"))
> +			continue;
> +
>  		/* Skip PHYs with reg property set */
>  		paddr = of_get_property(child, "reg", &len);
>  		if (paddr)
> -- 
> 1.7.6.5
> 

