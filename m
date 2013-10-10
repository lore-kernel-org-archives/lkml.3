Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JJOB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:01:29 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:45110 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751979Ab3JJOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:01:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:4321:5007:7652:7875:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12517:12519:12740:13069:13095:13181:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: town85_6393600e1931e
X-Filterd-Recvd-Size: 2517
Message-ID: <1381413683.14017.9.camel@joe-AO722>
Subject: Re: [PATCH v3 1/3] i2c: xilinx: Fix i2c checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        Kedareswara rao Appana <appanad@xilinx.com>, linux-i2c@vger.kernel.org
Date: Thu, 10 Oct 2013 07:01:23 -0700
In-Reply-To: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 12:39 +0200, Michal Simek wrote:
> Code changes to fix checkpatch warnings listed below.
> - WARNING: quoted string split across lines
[]
> diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
[]
> @@ -271,11 +271,8 @@ static void xiic_read_rx(struct xiic_i2c *i2c)
> 
>  	bytes_in_fifo = xiic_getreg8(i2c, XIIC_RFO_REG_OFFSET) + 1;
> 
> -	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d"
> -		", SR: 0x%x, CR: 0x%x\n",
> -		__func__, bytes_in_fifo, xiic_rx_space(i2c),
> -		xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
> -		xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));
> +	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d",
> +		__func__, bytes_in_fifo, xiic_rx_space(i2c));

This is a pretty odd way of silencing checkpatch
by eliminating content.  Aren't the register values
useful information?

You've also removed the terminating newline.
It's necessary to avoid possible dmesg output log
message interleaving.  Please put it back.

A more normal style fix would be to coalesce the
format.  checkpatch will ignore lines exceeding
80 columns for these formats.

	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d, SR: 0x%x, CR: 0x%x\n",
		__func__, bytes_in_fifo, xiic_rx_space(i2c),
		xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
		xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));

This passes checkpatch cleanly.

etc...


