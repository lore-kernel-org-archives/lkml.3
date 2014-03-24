Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaCXEZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:25:38 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:57457 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714AbaCXEZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:25:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: body72_13ac9c3c2e107
X-Filterd-Recvd-Size: 1473
Message-ID: <1395635132.13968.40.camel@joe-AO722>
Subject: Re: [PATCH] thermal: Fix KELVIN_TO_CELSIUS macro
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Date: Sun, 23 Mar 2014 21:25:32 -0700
In-Reply-To: <1395634496-25040-1-git-send-email-linux@roeck-us.net>
References: <1395634496-25040-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-23 at 21:14 -0700, Guenter Roeck wrote:
> It is always a good idea to use paranthesis around macro parameters
> to avoid undesired side effects.
> 
> In this specific case, KELVIN_TO_CELSIUS() is used in
> drivers/platform/x86/asus-wmi.c with parameter "value & 0xFFFF",
> which due to operator evaluation order causes more or less random
> results.

Maybe it's better to use a statement expression to avoid
multiple calculations of t

Maybe;

#define KELVIN_TO_CELSIUS(t)				\
({							\
	long _t = (long)(t) - 2732;			\
	_t >= 0 ? (_t + 5) / 10 : (_t - 5) / 10;	\
})


