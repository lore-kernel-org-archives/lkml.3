Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBMHTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:19:14 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32696 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbaBMHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:19:13 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh19b6n1155h)
Date: Thu, 13 Feb 2014 08:19:02 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Michal Simek <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Srikanth Thokala <srikanth.thokala@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/14] net: axienet: Removed checkpatch errors/warnings
References: <cover.1392220536.git.michal.simek@xilinx.com>  <75b669c0a947effe74b291093abfa8c71f83736a.1392220536.git.michal.simek@xilinx.com> <1392251494.2214.11.camel@joe-AO722>
In-Reply-To: <1392251494.2214.11.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <ff5b1f6a-a6a7-405c-9e83-59ad33852b93@TX2EHSMHS044.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 02/13/2014 01:31 AM, Joe Perches wrote:
> On Wed, 2014-02-12 at 16:55 +0100, Michal Simek wrote:
>> From: Srikanth Thokala <srikanth.thokala@xilinx.com>
> 
> trivia:
> 
>> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> 
>> +			netdev_err(lp->ndev,
>> +				"axienet_device_reset DMA reset timeout!\n");
> 
> could you please align multi-line arguments to the
> appropriate open parenthesis?
> 
> 			netdev_err(lp->ndev,
> 				   "axienet_device_reset DMA reset timeout!\n");
> 
> or maybe:
> 
> 			netdev_err(lp->ndev, "%s: "DMA reset timeout!\n",
> 				   __func__);

ok.

> 
>> @@ -484,8 +484,8 @@ static void axienet_device_reset(struct net_device *ndev)
>>  	}
>>
>>  	if (axienet_dma_bd_init(ndev)) {
>> -		dev_err(&ndev->dev, "axienet_device_reset descriptor "
>> -			"allocation failed\n");
>> +		netdev_err(ndev,
>> +			"axienet_device_reset descriptor allocation failed\n");
> 
> etc, et al.


ok.

> 
>> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> []
>> @@ -161,19 +161,19 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
>>
>>  	np1 = of_find_node_by_name(NULL, "cpu");
>>  	if (!np1) {
>> -		printk(KERN_WARNING "%s(): Could not find CPU device node.",
>> -		       __func__);
>> -		printk(KERN_WARNING "Setting MDIO clock divisor to "
>> -		       "default %d\n", DEFAULT_CLOCK_DIVISOR);
>> +		netdev_warn(lp->ndev, "Could not find CPU device node.");
> 
> missing trailing "\n" to terminate message.

ok.

> 
>> +		netdev_warn(lp->ndev,
>> +			 "Could not find clock ethernet controller property.");
> 
> here too. (and alignment)

This is problematic. I would like to keep 80 char limits and keeping
this align just break it. That's why I was using tab alignment.
Probably the solution is just to shorten message.

Thanks for your comments,
Michal


