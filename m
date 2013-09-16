Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3IPXtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:49:01 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:50035 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751044Ab3IPXs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:48:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:3874:4321:5007:7208:7652:7903:7904:8603:9113:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cast88_30a7999337646
X-Filterd-Recvd-Size: 1558
Message-ID: <1379375332.7083.3.camel@joe-AO722>
Subject: Re: [PATCH] dvb: fix potential format string leak
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Date: Mon, 16 Sep 2013 16:48:52 -0700
In-Reply-To: <20130916233720.GA3967@www.outflux.net>
References: <20130916233720.GA3967@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 16:37 -0700, Kees Cook wrote:
> Make sure that a format string cannot accidentally leak into the printk
> buffer.
[]
> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
[]
> @@ -649,7 +649,7 @@ static int dib9000_risc_debug_buf(struct dib9000_state *state, u16 * data, u8 si
>  	b[2 * (size - 2) - 1] = '\0';	/* Bullet proof the buffer */
>  	if (*b == '~') {
>  		b++;
> -		dprintk(b);
> +		dprintk("%s", b);
>  	} else
>  		dprintk("RISC%d: %d.%04d %s", state->fe_id, ts / 10000, ts % 10000, *b ? b : "<emtpy>");
>  	return 1;

This looks odd.

Perhaps this should be:

	if (*b == '~')
		b++;
	dprintk("etc...);

It'd be nice to fix the <empty> typo too.


