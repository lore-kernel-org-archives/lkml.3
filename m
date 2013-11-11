Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3KKO5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:57:24 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43098 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab3KKO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:57:16 -0500
Date: Mon, 11 Nov 2013 14:57:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add MDIO bus node to PHY binding
 document
Message-ID: <20131111145711.GH21201@e106331-lin.cambridge.arm.com>
References: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 01:00:25PM +0000, Jonas Jensen wrote:
> Add MDIO bus node segment and update the example,
> allowing trivial bindings to break out boilerplate.

Hi, I have a couple of (minor) comments.

> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes per reply from Grant [0]
>     
>     [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/208851.html
>     
>     Applies to next-20131111
> 
>  Documentation/devicetree/bindings/net/phy.txt | 37 +++++++++++++++++++++------
>  1 file changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
> index 7cd18fb..4e58a5d 100644
> --- a/Documentation/devicetree/bindings/net/phy.txt
> +++ b/Documentation/devicetree/bindings/net/phy.txt
> @@ -1,3 +1,13 @@
> +MDIO Bus Nodes
> +
> +MDIO bus nodes describe an MDIO bus. It is a container for PHY nodes as
> +described below.

Jumping between pllural and singular is a bit jarring, and I assume the
node name is important (i.e. it should be named "mdio").

How about something like:

An MDIO bus node describes an MDIO bus, and is a container for PHY nodes
as described below. An MDIO bus node should be named "mdio".

Given it seems that the MDIO node is expected to live under the node for
the MAC, it would be nice to have a statement to that effect here.

> +
> +Required properties:
> +- #address-cells = <1>;
> +- #size-cells = <0>;

It would be nice to say what the address cell represents (the PHY
address on the MDIO bus, I think?). Also this looks like a fragment of
dts rather than a description. How about:

- #address-cells: Should be <1> - the PHY address on the MDIO bus
- #size-cells: Should be <0>

Otherwise, this looks fine to me.

Thanks,
Mark.
