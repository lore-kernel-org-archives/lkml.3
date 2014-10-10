Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaJJFrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:47:52 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46547 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaJJFrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:47:49 -0400
Message-ID: <543772F9.1010304@st.com>
Date: Fri, 10 Oct 2014 07:47:37 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Bridgers <vbridger@opensource.altera.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <vbridger@altera.com>
Subject: Re: [PATCH net] stmmac: correct mc_filter local variable in set_filter
 and set_mac_addr call
References: <1412867436-22153-1-git-send-email-vbridger@opensource.altera.com>
In-Reply-To: <1412867436-22153-1-git-send-email-vbridger@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.72]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-10_04:2014-10-10,2014-10-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/2014 5:10 PM, Vince Bridgers wrote:
> Testing revealed that the local variable mc_filter was dimensioned
> incorrectly for all possible configurations and get_mac_addr should
> have been set_mac_addr (a typo). Make sure mc_filter is dimensioned
> to 8 32-bit unsigned longs - the largest size of the Synopsys
> multicast filter register set.
>
> Signed-off-by: Vince Bridgers <vbridger@opensource.altera.com>

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

> ---
>   drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> index 5efe60e..0adcf73 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> @@ -134,7 +134,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
>   	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
>   	unsigned int value = 0;
>   	unsigned int perfect_addr_number = hw->unicast_filter_entries;
> -	u32 mc_filter[2];
> +	u32 mc_filter[8];
>   	int mcbitslog2 = hw->mcast_bits_log2;
>
>   	pr_debug("%s: # mcasts %d, # unicast %d\n", __func__,
> @@ -182,7 +182,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
>   		struct netdev_hw_addr *ha;
>
>   		netdev_for_each_uc_addr(ha, dev) {
> -			stmmac_get_mac_addr(ioaddr, ha->addr,
> +			stmmac_set_mac_addr(ioaddr, ha->addr,
>   					    GMAC_ADDR_HIGH(reg),
>   					    GMAC_ADDR_LOW(reg));
>   			reg++;
>

