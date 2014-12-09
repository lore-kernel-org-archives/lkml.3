Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaLIGoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:44:25 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:45749 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251AbaLIGoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:44:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3315:3352:3622:3867:3870:3873:4321:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cook13_432f338a0f33f
X-Filterd-Recvd-Size: 1968
Message-ID: <1418107460.15957.9.camel@perches.com>
Subject: Re: [PATCH] input: edt-ft5x06: fixed a macro coding style issue
From: Joe Perches <joe@perches.com>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: dmitry.torokhov@gmail.com, LW@KARO-electronics.de, B38611@freescale.com,
        maksqwe1@ukr.net, jg1.han@samsung.com, linux@rasmusvillemoes.dk,
        fabf@skynet.be, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Dec 2014 22:44:20 -0800
In-Reply-To: <20141209063456.GA15121@ubuntu>
References: <20141209063456.GA15121@ubuntu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 08:34 +0200, Asaf Vertz wrote:
> Fixed a coding style error, macros with complex values should be
> enclosed in parentheses.
[]
> diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
[]
> @@ -849,10 +849,11 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
>  	return 0;
>  }
>  
> -#define EDT_ATTR_CHECKSET(name, reg) \
> +#define EDT_ATTR_CHECKSET(name, reg) { \
>  	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
>  	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
> -		edt_ft5x06_register_write(tsdata, reg, pdata->name)
> +		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
> +}

Any time you see a naked if (foo) bar in a macro
prefer to use a do while (0) like;

#define EDT_ATTR_CHECKSET(name, reg)					\
do {									\
	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
while (0)

