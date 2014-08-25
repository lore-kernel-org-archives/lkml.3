Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbaHYUaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:30:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56176 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:30:10 -0400
Date: Mon, 25 Aug 2014 16:18:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/19] iwl4965: fix %d confusingly prefixed with 0x in
 format string
Message-ID: <20140825201801.GH1966@tuxdriver.com>
References: <1407111605-15005-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407111605-15005-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 05:20:05PM -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> index c159c05..7d6fd59 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -4633,7 +4633,7 @@ il4965_store_tx_power(struct device *d, struct device_attribute *attr,
>  	else {
>  		ret = il_set_tx_power(il, val, false);
>  		if (ret)
> -			IL_ERR("failed setting tx power (0x%d).\n", ret);
> +			IL_ERR("failed setting tx power (0x%x).\n", ret);
>  		else
>  			ret = count;
>  	}

It seems like that should be "0x%08x" or similar, no?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
