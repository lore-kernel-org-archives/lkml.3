Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaEPT4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:56:37 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:40315 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756606AbaEPT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:56:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12295:12517:12519:12663:12740:13069:13311:13357:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge47_1c45250b6f762
X-Filterd-Recvd-Size: 1594
Message-ID: <1400270191.12373.12.camel@joe-AO725>
Subject: Re: Replace strings across all the files using script
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Date: Fri, 16 May 2014 12:56:31 -0700
In-Reply-To: <CAK7N6vqS7rNewOLR0aUpTHzNmOXtunwjzTu6oGM1OJ8xPWSp8g@mail.gmail.com>
References: <CAK7N6vqS7rNewOLR0aUpTHzNmOXtunwjzTu6oGM1OJ8xPWSp8g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 12:07 -0700, anish singh wrote:
> I am planning to do some cleanup and want to
> replace some string as below across all the files
> in kernel.
>   pr_err("%s "
> TO
>   pr_err("%s: "
> 
> Basically adding semicolon after the %s.
> How can i do it across all the files? I don't
> want to individually go to each file and do it.

Presumably, this would be done only for files that use
__func__ as the first argument to printk.

Something like this might work moderately well.

$ git ls-files | grep '\.[ch]$' | \
  xargs perl -i -e 'local $/; while (<>) { s/\b(printk|pr_(?:emerg|crit|alert|err|notice|warn|warning|info))\s*\(\s*\"\%s(?:\s*\(\s*\)\s*)?(?:\s*:\s*)?\s*(?:\-\s*)?([^"]+)"\s*,(\s*)__func__\b/$1("%s: $2",$3__func__/g; print; }'


