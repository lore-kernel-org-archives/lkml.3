Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaELMib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:38:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37394 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaELMia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:38:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 12 May 2014 14:38:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fix NULL derefencing in fwnet_probe()
Message-ID: <20140512143818.2ae752e6@kant>
In-Reply-To: <20140429094947.GA11409@devel>
References: <20140429094947.GA11409@devel>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 29 Daeseok Youn wrote:
> "dev" and "net" are NULL when alloc_netdev() is failed.
> So just unlock and return an error.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Pushed to linux1394.git.  Thank you.

> ---
>  drivers/firewire/net.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
> index 4af0a7b..c398645 100644
> --- a/drivers/firewire/net.c
> +++ b/drivers/firewire/net.c
> @@ -1462,8 +1462,8 @@ static int fwnet_probe(struct fw_unit *unit,
>  
>  	net = alloc_netdev(sizeof(*dev), "firewire%d", fwnet_init_dev);
>  	if (net == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> +		mutex_unlock(&fwnet_device_mutex);
> +		return -ENOMEM;
>  	}
>  
>  	allocated_netdev = true;

-- 
Stefan Richter
-=====-====- -=-= -==--
http://arcgraph.de/sr/
