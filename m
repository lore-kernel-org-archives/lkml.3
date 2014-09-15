Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaIOKHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:07:47 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:57329 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721AbaIOKHp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:07:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.001
X-Spam-Languages: en
Message-ID: <5416BA6E.4080507@topic.nl>
Date: Mon, 15 Sep 2014 12:07:42 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v3] net/phy: micrel: Disable asymmetric pause for KSZ9031
References: <20140912.181820.1440041146938289489.davem@davemloft.net> <1410775594-3129-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1410775594-3129-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿I based this patch on the 3.17rc5 state. Hope this applies cleanly now?


On 09/15/2014 12:06 PM, Mike Looijmans wrote:
> The KSZ9031 appears to suffer from the same hardware bug as described
> for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577
> ("net/phy: micrel: Disable asymmetric pause for KSZ9021")
> you have to unplug the cable and plug it back to get it to work.
>
> Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>   drivers/net/phy/micrel.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index fd0ea7c..011dbda 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -592,8 +592,7 @@ static struct phy_driver ksphy_driver[] = {
>   	.phy_id		= PHY_ID_KSZ9031,
>   	.phy_id_mask	= 0x00fffff0,
>   	.name		= "Micrel KSZ9031 Gigabit PHY",
> -	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause
> -				| SUPPORTED_Asym_Pause),
> +	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause),
>   	.flags		= PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
>   	.config_init	= ksz9031_config_init,
>   	.config_aneg	= genphy_config_aneg,
>



Met vriendelijke groet / kind regards,

Mike Looijmans

TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

