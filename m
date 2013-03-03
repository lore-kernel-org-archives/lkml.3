Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3CCWt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:49:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57032 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3CCWt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:49:26 -0500
Date: Sun, 03 Mar 2013 17:49:25 -0500 (EST)
Message-Id: <20130303.174925.982387903456722818.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CAIF: fix sparse warning for caif_usb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362316188-2927-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362316188-2927-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 03 Mar 2013 14:49:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Sun,  3 Mar 2013 15:09:48 +0200

> This fixes the following sparse warning:
> net/caif/caif_usb.c:84:16: warning: symbol 'cfusbl_create' was not
> declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  net/caif/caif_usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
> index 3ebc8cb..cbae9b0 100644
> --- a/net/caif/caif_usb.c
> +++ b/net/caif/caif_usb.c
> @@ -81,7 +81,7 @@ static void cfusbl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
>  		layr->up->ctrlcmd(layr->up, ctrl, layr->id);
>  }
>  
> -struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
> +static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
>  					u8 braddr[ETH_ALEN])

You need to fix up the indentation of the second line of
function arguments if you move the location of the openning
parenthesis on the first line, because all arguments on the
second and subsequent line must line up exactly at the first
column after the openning parenthesis of the first line.

Thanks.
