Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaGFQXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:23:12 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:51383 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaGFQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:23:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:3872:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seat40_72c245868d057
X-Filterd-Recvd-Size: 1669
Message-ID: <1404663787.27043.33.camel@joe-AO725>
Subject: Re: [PATCH 2/4] Staging: rts5208: Use standard print_hex_dump_debug
From: Joe Perches <joe@perches.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Sun, 06 Jul 2014 09:23:07 -0700
In-Reply-To: <1404663138-21333-3-git-send-email-fabio.falzoi84@gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
	 <1404663138-21333-3-git-send-email-fabio.falzoi84@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 18:12 +0200, Fabio Falzoi wrote:
> Use print_hex_dump_debug to have memory properly dumped only when dynamic
> debug is enabled.

Not true.
Now it prints all the time when !CONFIG_DYNAMIC_DEBUG
and CONFIG_PRINTK.

> diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
[]
> -#ifdef CONFIG_RTS5208_DEBUG
> -#define RTSX_DUMP(buf, buf_len)					\
> -	print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",		\
> -		       DUMP_PREFIX_NONE, 16, 1, (buf), (buf_len), false)
> -#else
> -#define RTSX_DUMP(buf, buf_len)
> -#endif
> -
>  #endif  /* __REALTEK_RTSX_TRACE_H */

Before it would not print at all if !CONFIG_RTS5208_DEBUG.

