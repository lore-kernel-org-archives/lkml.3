Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3JBGfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:35:44 -0400
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:54074 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752410Ab3JBGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:35:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7903:8985:9025:10004:10400:10450:10455:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:13894:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,
X-HE-Tag: kick68_6b9a9125cc55d
X-Filterd-Recvd-Size: 1898
Message-ID: <1380695738.2081.33.camel@joe-AO722>
Subject: Re: [PATCH] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Mathieu =?ISO-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>,
        gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 23:35:38 -0700
In-Reply-To: <524BAC04.30501@gmail.com>
References: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
	 <524BAC04.30501@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 15:15 +1000, Ryan Mallon wrote:
> On 02/10/13 11:57, Mathieu Rhéaume wrote:
> > This patch changes seq_printf for seq_puts in binder.c.
> > It fixes the warnings emitted by checkpatch.pl.
[]
> Umm, this won't compile. seq_puts() is defined as:
> 
>   int seq_puts(struct seq_file *m, const char *s);
> 
> checkpatch.pl does indeed complain about uses of seq_printf() in
> drivers/staging/android/binder.c which are passing formatted strings. At
> a quick glance it looks like checkpatch.pl is only checking for the
> format string on the same line as seq_printf(), so this files ugly
> coding style confuses the check. Joe?

True.

This patch should have fixed it.  It's in -next already.

https://lkml.org/lkml/2013/9/13/698

> Anyway, please don't blindly change things in the kernel without at
> least compile testing them.

Yes, please.

