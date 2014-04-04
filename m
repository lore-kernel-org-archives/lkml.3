Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaDDNSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:18:48 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42160 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaDDNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:18:46 -0400
Message-ID: <533EB13F.5010406@cogentembedded.com>
Date: Fri, 04 Apr 2014 17:18:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: davinci-linux-open-source@linux.davincidsp.com, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 2/2] net: davinci_mdio: use devm_* api
References: <1396618825-4241-1-git-send-email-grygorii.strashko@ti.com> <1396618825-4241-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1396618825-4241-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-04-2014 17:40, Grygorii Strashko wrote:

> Use devm_* API for memory allocation and to get device's clock
> to simplify driver's code.

> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   drivers/net/ethernet/ti/davinci_mdio.c |   21 ++++-----------------
>   1 file changed, 4 insertions(+), 17 deletions(-)

> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
> index 0cca9de..f0f7128 100644
> --- a/drivers/net/ethernet/ti/davinci_mdio.c
> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
[...]
> @@ -425,16 +417,11 @@ static int davinci_mdio_remove(struct platform_device *pdev)
>
>   	if (data->bus) {
>   		mdiobus_unregister(data->bus);
> -		mdiobus_free(data->bus);
>   	}

    Remove {} please, it's not needed anymore, according to 
Documentation/CodingStyle.

WBR, Sergei

