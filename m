Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaFWNyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:54:23 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:46599 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753806AbaFWNyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:54:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3867:3868:3871:3873:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: touch54_5fe967dac6020
X-Filterd-Recvd-Size: 1450
Message-ID: <1403531657.18747.53.camel@joe-AO725>
Subject: Re: [PATCH] staging: lirc: fix coding style problems
From: Joe Perches <joe@perches.com>
To: Raphael Poggi <poggi.raph@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2014 06:54:17 -0700
In-Reply-To: <1403530859-3341-1-git-send-email-poggi.raph@gmail.com>
References: <1403530859-3341-1-git-send-email-poggi.raph@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 15:40 +0200, Raphael Poggi wrote:
> This patch fix some coding style problems.
[]
> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
[]
> @@ -626,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
>  	if (debug) {
>  		dev_info(dev, "raw packet: ");
>  		for (i = 0; i < len; ++i)
> -			printk("%02x ", buf[i]);
> -		printk("\n");
> +			dev_dbg(dev, "%02x ", buf[i]);
> +		dev_dbg(dev, "\n");

This chunk is not correct and causes output problems.

These printks should either use pr_cont or
you want to use something like print_hex_dump


