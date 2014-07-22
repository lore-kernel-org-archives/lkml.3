Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaGVM6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:58:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17657 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaGVM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:58:44 -0400
Date: Tue, 22 Jul 2014 15:58:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn, joe@perches.com
Subject: Re: [PATCH v4 1/3] Staging: rts5208: Replace custom macro with
 dev_dbg
Message-ID: <20140722125820.GO25880@mwanda>
References: <1405978564-11343-1-git-send-email-fabio.falzoi84@gmail.com>
 <1405978564-11343-2-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405978564-11343-2-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:36:02PM +0200, Fabio Falzoi wrote:
> @@ -3664,7 +3672,7 @@ static int mg_set_tpc_para_sub(struct rtsx_chip *chip, int type,
>  	int retval;
>  	u8 buf[6];
>  
> -	RTSX_DEBUGP("--%s--\n", __func__);
> +	dev_dbg(rtsx_dev(chip), "--%s--\n", __func__);

All of these debug printks to mark when we have called a function should
be deleted.  We have ftrace for that.

> -static inline void free_zone(struct zone_entry *zone)
> +static inline void free_zone(const struct rtsx_chip *chip,
> +			     struct zone_entry *zone)
>  {
> -	RTSX_DEBUGP("free_zone\n");
> +	dev_dbg(rtsx_dev(chip), "free_zone\n");
>  
>  	if (!zone)
>  		return;

Don't add a parameter to free_zone() just for this debug printk which
should be deleted.

regards,
dan carpenter

