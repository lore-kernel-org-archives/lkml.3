Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3J2IbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:31:10 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:46682 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510Ab3J2IbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:31:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3871:3873:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12517:12519:12740:13019:13069:13095:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: body12_435b2cf2db938
X-Filterd-Recvd-Size: 1532
Message-ID: <1383035461.2713.1.camel@joe-AO722>
Subject: Re: [PATCH v2] can: c_can: Speed up rx_poll function
From: Joe Perches <joe@perches.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Tue, 29 Oct 2013 01:31:01 -0700
In-Reply-To: <1383035267-19604-1-git-send-email-mpa@pengutronix.de>
References: <1383035267-19604-1-git-send-email-mpa@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 09:27 +0100, Markus Pargmann wrote:
> This patch speeds up the rx_poll function by reducing the number of
> register reads.
[]
> The third change is to replace the for-loop by a find_next_bit loop.

You need to update the commit message.

> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
[]
> @@ -798,17 +798,19 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
[]
> +	while (quota > 0 && (val = priv->read_reg(priv, C_CAN_INTPND1_REG))) {
> +		while ((msg_obj = ffs(val)) && quota > 0) {
> +			val &= ~BIT(msg_obj - 1);



