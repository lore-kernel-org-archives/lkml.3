Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3LKHNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:13:13 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38100 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3LKHLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:18 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: devicetree@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add MDIO bus node to PHY binding document
Date: Wed, 11 Dec 2013 07:11:14 +0000
Message-ID: <3125212.eYMMS8pR1J@lenovo>
User-Agent: KMail/4.11.2 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1384351669-8325-1-git-send-email-jonas.jensen@gmail.com>
References: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com> <1384351669-8325-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 13 novembre 2013, 15:07:49 Jonas Jensen a écrit :
> Add MDIO bus node segment and update the example,
> allowing trivial bindings to break out boilerplate.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Thanks Mark,
> 
>     This should have the changes from your comments. It also adds optional
> properties "compatible" and "reg", were those overlooked or left out
> intentionally?

Please CC netdev@vger.kernel.org too as there might be some interest from 
networking folks not actively following devicetree-discuss.

This does looks good to me, there is not much to be said to the point where I 
wonder if this even deserves such an example, but it cannot hurt.

> 
>     Changes since v1:
> 
>     1. reformat "MDIO bus node" description and add, node name should be
> "mdio" 2. reformat property descriptions, describe what the cells represent
> 3. add optional properties
>     4. add a description after "PHY nodes"
> 
>     Applies to next-20131113
> 
>  Documentation/devicetree/bindings/net/phy.txt | 48
> ++++++++++++++++++++++----- 1 file changed, 40 insertions(+), 8
> deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/phy.txt
> b/Documentation/devicetree/bindings/net/phy.txt index 7cd18fb..4179a70
> 100644
> --- a/Documentation/devicetree/bindings/net/phy.txt
> +++ b/Documentation/devicetree/bindings/net/phy.txt
> @@ -1,5 +1,26 @@
> +MDIO Bus Nodes
> +
> +An MDIO bus node describes an MDIO bus, and is a container for PHY nodes
> +as described below. An MDIO bus node should be named "mdio".
> +
> +Required properties:
> +
> +- #address-cells = Should be <1>, specifies the number of cells needed
> +  to encode the PHY address
> +- #size-cells = Should be <0>
> +
> +Optional Properties:
> +
> +- compatible : Should contain a specific name for the MDIO bus,
> +  if known, followed by "-mdio"
> +- reg : Should contain register location and length
> +
> +
>  PHY nodes
> 
> +Describes the PHY chip. A MAC connecting the PHY may use a phandle to
> +this node.
> +
>  Required properties:
> 
>   - device_type : Should be "ethernet-phy"
> @@ -23,13 +44,24 @@ Optional Properties:
>    assume clause 22. The compatible list may also contain other
>    elements.
> 
> +
>  Example:
> 
> -ethernet-phy@0 {
> -	compatible = "ethernet-phy-ieee802.3-c22";
> -	linux,phandle = <2452000>;
> -	interrupt-parent = <40000>;
> -	interrupts = <35 1>;
> -	reg = <0>;
> -	device_type = "ethernet-phy";
> -};
> +mdio {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	ethernet-phy@0 {
> +		device_type = "ethernet-phy";
> +		compatible = "...", "ethernet-phy-ieee802.3-c22";
> +		reg = <0>;
> +		interrupts = <24 0>;
> +	}
> +
> +	ethernet-phy@1 {
> +		device_type = "ethernet-phy";
> +		compatible = "...";
> +		reg = <1>;
> +		interrupts = <35 1>;
> +	}
> +}

-- 
Florian
