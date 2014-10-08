Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaJHWeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:34:15 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:57559 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJHWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:34:11 -0400
Date: Wed, 8 Oct 2014 15:34:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
Message-ID: <20141008223403.GA24828@roeck-us.net>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412806199-5363-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5435BBE2.0119,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:09:59PM +0100, Mark Brown wrote:
> Description of regulators should generally be optional so if there is no
> DT node for the regulators container then we shouldn't print an error
> message. Lower the severity of the message to debug level (it might help
> someone work out what went wrong) and while we're at it say what we were
> looking for.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Excellent.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Would it also be possible to lower the severity of the "no parameters"
message ?

Thanks,
Guenter

> ---
>  drivers/regulator/of_regulator.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
> index 7a51814abdc5..5a1d4afa4776 100644
> --- a/drivers/regulator/of_regulator.c
> +++ b/drivers/regulator/of_regulator.c
> @@ -211,7 +211,8 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
>  		search = dev->of_node;
>  
>  	if (!search) {
> -		dev_err(dev, "Failed to find regulator container node\n");
> +		dev_dbg(dev, "Failed to find regulator container node '%s'\n",
> +			desc->regulators_node);
>  		return NULL;
>  	}
>  
> -- 
> 2.1.1
> 
