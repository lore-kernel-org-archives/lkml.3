Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbaGWPHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:07:19 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:36747 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757804AbaGWPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:07:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:5007:6117:6119:7652:7903:10004:10400:10848:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shape70_4c77ecea424f
X-Filterd-Recvd-Size: 1640
Message-ID: <1406128031.2755.21.camel@joe-AO725>
Subject: Re: [PATCH V2] SYSV: logging update
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Date: Wed, 23 Jul 2014 08:07:11 -0700
In-Reply-To: <1406127018-15953-1-git-send-email-fabf@skynet.be>
References: <1406127018-15953-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 16:50 +0200, Fabian Frederick wrote:
> -use current logging functions
> -replace no level printk by pr_err
> -add debug.c / sysv_err function to include sb->s_id
> -standardize prefix: "sysv (sb id): " and remove sb id from various logging at different places.
> -use __func__
> -coalesce formats

Seems fine but:

> diff --git a/fs/sysv/debug.c b/fs/sysv/debug.c
[]
> @@ -0,0 +1,15 @@
> +#define pr_fmt(fmt) KBUILD_MODNAME " " fmt

Please use KBUILD_MODNAME ": " fmt

> +
> +#include "sysv.h"
> +
> +void sysv_err(struct super_block *sb, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	pr_err("(%s): %pV\n", sb->s_id, &vaf);

This trailing \n is not necessary and causes
blank lines in the log.

All callers already use it.


