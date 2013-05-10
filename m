Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3EJLS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:18:27 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46192 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3EJLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:18:24 -0400
Message-ID: <518CD784.1030709@cogentembedded.com>
Date: Fri, 10 May 2013 15:18:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: r58129@freescale.com, davem@davemloft.net, peppe.cavallaro@st.com,
        chohnstaedt@innominate.com, timur@freescale.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net: phy: realtek: cleanup code
References: <201305081910.27203.neidhard.kim@lge.com> <1368170967-20589-4-git-send-email-neidhard.kim@lge.com>
In-Reply-To: <1368170967-20589-4-git-send-email-neidhard.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-05-2013 11:29, Jongsung Kim wrote:

> This patch cleans up the drivers code by:

> - using a consistent way to reference functions
> - removing unused macro-definitions
> - removing unnecessary new-lines
> - making ack_interrupt functions shorter.

> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
> ---
>   drivers/net/phy/realtek.c |   29 ++++++++++-------------------
>   1 files changed, 10 insertions(+), 19 deletions(-)

> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 6f0726a..fd09844 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
[...]
> @@ -112,8 +103,8 @@ static struct phy_driver realtek_drv[] = {
>   		.read_status	= &genphy_read_status,
>   		.ack_interrupt	= &rtl8201f_ack_interrupt,
>   		.config_intr	= &rtl8201f_config_intr,
> -		.suspend	= genphy_suspend,
> -		.resume		= genphy_resume,
> +		.suspend	= &genphy_suspend,
> +		.resume		= &genphy_resume,

    Contrariwise, you should have dropped & from the other functions. 
It's completely superfluous.

WBR, Sergei

