Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3CLTKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:10:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48766 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933319Ab3CLTKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:10:32 -0400
Message-ID: <1363115431.2125.13.camel@joe-AO722>
Subject: Re: [PATCH] ethernet: nxp: use resource_size()
From: Joe Perches <joe@perches.com>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, stigge@antcom.de,
        edumazet@google.com, gregkh@linuxfoundation.org, jiri@resnulli.us,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 12:10:31 -0700
In-Reply-To: <1363113035-11269-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363113035-11269-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 20:30 +0200, Silviu-Mihai Popescu wrote:
> Use resource_size() instead of explicit calculation. This was found via
> make coccicheck.
[]
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
[]
> @@ -1421,7 +1421,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
>  	netdev_dbg(ndev, "IO address start     :0x%08x\n",
>  			res->start);
>  	netdev_dbg(ndev, "IO address size      :%d\n",
> -			res->end - res->start + 1);
> +			resource_size(res));

This might be better as

	netdev_dbg(ndev, "IO resource    :%pR\n", res);


