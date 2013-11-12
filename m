Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3KLMbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:31:01 -0500
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:8949
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab3KLMa6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:30:58 -0500
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
Subject: RE: [PATCH 1/4] phylib: Add Clause 45 read/write functions
Thread-Topic: [PATCH 1/4] phylib: Add Clause 45 read/write functions
Thread-Index: AQHO3tiLs19l/z/zlEG78+nbLumxJZohh5dw
Date: Tue, 12 Nov 2013 12:30:48 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C915117378@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1384167864-2457-1-git-send-email-shh.xie@gmail.com>
In-Reply-To: <1384167864-2457-1-git-send-email-shh.xie@gmail.com>
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
> Sent: Monday, November 11, 2013 7:04 PM
> To: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Cc: Bucur Madalin-Cristian-B32716; Kanetkar Shruti-B44454; Xie Shaohui-B21989
> Subject: [PATCH 1/4] phylib: Add Clause 45 read/write functions
> 
> From: Andy Fleming
> 
> You need an extra parameter to read or write Clause 45 PHYs, so we need a
> different API with the extra parameter.
> 
> Signed-off-by: Andy Fleming
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> ---
>  include/linux/phy.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h index 64ab823..684925a
> 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -498,6 +498,21 @@ static inline int phy_read(struct phy_device *phydev, u32
> regnum)  }
> 
>  /**
> + * phy_read_mmd - Convenience function for reading a register
> + *   from an MMD on a given PHY.
> + * @phydev: The phy_device struct
> + * @devad: The MMD to read from
> + * @regnum: The register on the MMD to read
> + *
> + * Same rules as for phy_read();
> + */
> +static inline int phy_read_mmd(struct phy_device *phydev, int devad,
> +u32 regnum) {
> +	return mdiobus_read(phydev->bus, phydev->addr,
> +		MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff)); }
> +
> +/**
>   * phy_write - Convenience function for writing a given PHY register
>   * @phydev: the phy_device struct
>   * @regnum: register number to write
> @@ -533,6 +548,24 @@ static inline bool phy_is_internal(struct phy_device
> *phydev)
>  	return phydev->is_internal;
>  }
> 
> +/**
> + * phy_write_mmd - Convenience function for writing a register
> + *   on an MMD on a given PHY.
> + * @phydev: The phy_device struct
> + * @devad: The MMD to read from
> + * @regnum: The register on the MMD to read
> + * @val: value to write to @regnum
> + *
> + * Same rules as for phy_write();
> + */
> +static inline int phy_write_mmd(struct phy_device *phydev, int devad,
> +		u32 regnum, u16 val)
> +{
> +	regnum = MII_ADDR_C45 | ((devad & 0x1f) << 16) | (regnum & 0xffff);
> +
> +	return mdiobus_write(phydev->bus, phydev->addr, regnum, val); }
> +
>  struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
>  		bool is_c45, struct phy_c45_device_ids *c45_ids);  struct
> phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
> --
> 1.8.4.1


