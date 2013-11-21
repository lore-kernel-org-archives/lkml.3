Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3KUVTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:19:48 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59888 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3KUVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:19:45 -0500
Date: Thu, 21 Nov 2013 21:19:40 +0000
From: Mark Einon <mark.einon@gmail.com>
To: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 3/5] staging: et131x: stop read when hit max delay in
 et131x_phy_mii_read
Message-ID: <20131121211939.GD10691@einon.net>
References: <cover.1384933520.git.gamerh2o@gmail.com>
 <943804b6ad98cdabb3a51bf88c3a8f59617627e9.1384933520.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <943804b6ad98cdabb3a51bf88c3a8f59617627e9.1384933520.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 03:56:32PM +0800, ZHAO Gang wrote:
> stop read and return error when hit max delay time.
> 
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>

Acked-by: Mark Einon <mark.einon@gmail.com>

> ---
>  drivers/staging/et131x/et131x.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index cda037a..6254a6b 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -1392,6 +1392,7 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
>  			    mii_indicator);
>  
>  		status = -EIO;
> +		goto out;
>  	}
>  
>  	/* If we hit here we were able to read the register and we need to
> @@ -1399,6 +1400,7 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
>  	 */
>  	*value = readl(&mac->mii_mgmt_stat) & ET_MAC_MIIMGMT_STAT_PHYCRTL_MASK;
>  
> +out:
>  	/* Stop the read operation */
>  	writel(0, &mac->mii_mgmt_cmd);
>  
> -- 
> 1.8.3.1
> 
