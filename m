Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbaJaTeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:34:20 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:54692 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaJaTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:34:17 -0400
Date: Fri, 31 Oct 2014 12:34:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Lower priorit of constraint logging
Message-ID: <20141031193409.GA11608@roeck-us.net>
References: <1414782761-15372-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414782761-15372-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5453E438.0166,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On Fri, Oct 31, 2014 at 07:12:41PM +0000, Mark Brown wrote:
> Some systems have very large numbers of regulators so the constraint
> logging done at startup can end up being a very big part of the boot
> output which is both verobse and slows things down if the console is

	s/verobse/verbose/

> a serial console. Lower to dev_dbg() instead, we may want to provide
> a boot parameter to raise this in future but for now people can edit
> the source.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

You might want to run 's/priorit/priority/' on the subject.

Otherwise

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/regulator/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 55a87a2722d8..bbf93c9caca3 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -828,7 +828,7 @@ static void print_constraints(struct regulator_dev *rdev)
>  	if (!count)
>  		sprintf(buf, "no parameters");
>  
> -	rdev_info(rdev, "%s\n", buf);
> +	rdev_dbg(rdev, "%s\n", buf);
>  
>  	if ((constraints->min_uV != constraints->max_uV) &&
>  	    !(constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE))
> -- 
> 2.1.1
> 
