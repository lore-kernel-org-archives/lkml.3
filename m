Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbaHZKNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:13:52 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39457 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932235AbaHZKNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:13:50 -0400
Message-ID: <53FC5DCF.4060202@st.com>
Date: Tue, 26 Aug 2014 12:13:35 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: <lftan.linux@gmail.com>, Vince Bridgers <vbridger@altera.com>
Subject: Re: [PATCH (net-next) v2] net: stmmac: fix warning from Sparse for
 socfpga
References: <1409046479-18546-1-git-send-email-lftan@altera.com>
In-Reply-To: <1409046479-18546-1-git-send-email-lftan@altera.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.46]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_03:2014-08-26,2014-08-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2014 11:47 AM, Ley Foon Tan wrote:
> Warning:
> drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:41:
> sparse: cast removes address space of expression
> drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:38:
> sparse: incorrect type in assignment (different address spaces)
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> index cd613d7..ff54a1f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> @@ -119,7 +119,7 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
>   			return -EINVAL;
>   		}
>
> -		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
> +		dwmac->splitter_base = devm_ioremap_resource(dev,
>   			&res_splitter);

can the ioremap call stay in a single line ? or pls review indent looks
NOK

peppe

>   		if (!dwmac->splitter_base) {
>   			dev_info(dev, "Failed to mapping emac splitter\n");
>

