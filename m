Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3KLMcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:32:17 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:42438
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab3KLMcO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:32:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: "shh.xie@gmail.com" <shh.xie@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Madalin-Cristian Bucur <madalin.bucur@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/4] phylib: Add of_phy_attach
Thread-Topic: [PATCH 4/4] phylib: Add of_phy_attach
Thread-Index: AQHO3tkSZ+12Qlfbv0OCIJbA8h6r75ohiJog
Date: Tue, 12 Nov 2013 12:32:09 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C9151173AB@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1384168100-3046-1-git-send-email-shh.xie@gmail.com>
In-Reply-To: <1384168100-3046-1-git-send-email-shh.xie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added more people and list.

Best Regards, 
Shaohui Xie


> -----Original Message-----
> From: shh.xie@gmail.com [mailto:shh.xie@gmail.com]
> Sent: Monday, November 11, 2013 7:08 PM
> To: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Cc: Bucur Madalin-Cristian-B32716; Kanetkar Shruti-B44454; Xie Shaohui-B21989
> Subject: [PATCH 4/4] phylib: Add of_phy_attach
> 
> From: Andy Fleming
> 
> 10G PHYs don't currently support running the state machine, which is implicitly
> setup via of_phy_connect(). Therefore, it is necessary to implement an OF
> version of phy_attach(), which does everything except start the state machine.
> 
> Signed-off-by: Andy Fleming
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> ---
>  drivers/of/of_mdio.c    | 22 ++++++++++++++++++++--
>  include/linux/of_mdio.h |  8 ++++++++
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c index d5a57a9..a748274
> 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -221,8 +221,7 @@ EXPORT_SYMBOL(of_phy_connect);
>   * not call this function from new drivers.
>   */
>  struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
> -					     void (*hndlr)(struct net_device *),
> -					     phy_interface_t iface)
> +		void (*hndlr)(struct net_device *), phy_interface_t iface)
>  {
>  	struct device_node *net_np;
>  	char bus_id[MII_BUS_ID_SIZE + 3];
> @@ -247,3 +246,22 @@ struct phy_device *of_phy_connect_fixed_link(struct
> net_device *dev,
>  	return IS_ERR(phy) ? NULL : phy;
>  }
>  EXPORT_SYMBOL(of_phy_connect_fixed_link);
> +
> +/**
> + * of_phy_attach - Attach to a PHY without starting the state machine
> + * @dev: pointer to net_device claiming the phy
> + * @phy_np: Node pointer for the PHY
> + * @flags: flags to pass to the PHY
> + * @iface: PHY data interface type
> + */
> +struct phy_device *of_phy_attach(struct net_device *dev,
> +		struct device_node *phy_np, u32 flags, phy_interface_t iface) {
> +	struct phy_device *phy = of_phy_find_device(phy_np);
> +
> +	if (!phy)
> +		return NULL;
> +
> +	return phy_attach_direct(dev, phy, flags, iface) ? NULL : phy; }
> +EXPORT_SYMBOL(of_phy_attach);
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h index
> 8163107..dcda44d 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -19,6 +19,8 @@ extern struct phy_device *of_phy_connect(struct net_device
> *dev,
>  					 struct device_node *phy_np,
>  					 void (*hndlr)(struct net_device *),
>  					 u32 flags, phy_interface_t iface);
> +extern struct phy_device *of_phy_attach(struct net_device *dev,
> +		struct device_node *phy_np, u32 flags, phy_interface_t iface);
>  extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>  					 void (*hndlr)(struct net_device *),
>  					 phy_interface_t iface);
> @@ -44,6 +46,12 @@ static inline struct phy_device *of_phy_connect(struct
> net_device *dev,
>  	return NULL;
>  }
> 
> +static inline struct phy_device *of_phy_attach(struct net_device *dev,
> +		struct device_node *phy_np, u32 flags, phy_interface_t iface) {
> +	return NULL;
> +}
> +
>  static inline struct phy_device *of_phy_connect_fixed_link(struct net_device
> *dev,
>  							   void (*hndlr)(struct net_device
> *),
>  							   phy_interface_t iface)
> --
> 1.8.4.1


