Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaANDQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:16:38 -0500
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:39743 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751322AbaANDQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:16:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3872:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: place49_36cd174435b1d
X-Filterd-Recvd-Size: 1657
Message-ID: <1389669374.24849.30.camel@joe-AO722>
Subject: Re: [PATCH] Staging: comedi: move trailing statement to next line
 in ni_mio_common.c
From: Joe Perches <joe@perches.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Mon, 13 Jan 2014 19:16:14 -0800
In-Reply-To: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 21:13 -0600, Chase Southwood wrote:
> This patch for ni_mio_common.c silences a checkpatch error due to a
> trailing statement.
[]
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
[]
> @@ -692,7 +692,8 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>  		/*  Flush the 6143 data FIFO */
>  		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>  		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		while (ni_readl(AIFIFO_Status_6143) & 0x10)
> +			;	/*  Wait for complete */

It's generally better to use timeouts too.



