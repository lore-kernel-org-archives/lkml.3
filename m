Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaI1SQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:16:27 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:46273 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753352AbaI1SQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:16:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12049:12296:12346:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chin73_1a9e92f920b0b
X-Filterd-Recvd-Size: 2737
Message-ID: <1411928181.21874.19.camel@joe-AO725>
Subject: Re: [PATCH] description and restrictions of _shipped
From: Joe Perches <joe@perches.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Michael Elizabeth Chastain <mec@shout.net>,
        Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 28 Sep 2014 11:16:21 -0700
In-Reply-To: <20140928175513.GA5517@opentech.at>
References: <20140928175513.GA5517@opentech.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-28 at 19:55 +0200, Nicholas Mc Guire wrote:
> This patch adds a section on handling of _shipped files
> and their limitations.

Good idea but:

> While it is not actually the right place to rant about binary
> modules, it probably would also be bad not to clearly state that
> this option is not preferred.
[]
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
[]
> @@ -19,6 +19,7 @@ This document describes the Linux kernel Makefiles.
>  	   --- 3.10 Special Rules
>  	   --- 3.11 $(CC) support functions
>  	   --- 3.12 $(LD) support functions
> +	   --- 3.13 _shipped binary blobs

*_shipped files are not just binary.

Perhaps these are better described as "auto-generated" files.

The _shipped files in drivers/scsi/aic7xxx/ should probably
just be renamed.

$ git ls-files -- "*_shipped"
arch/arm/crypto/aesbs-core.S_shipped
arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped
arch/powerpc/platforms/cell/spufs/spu_save_dump.h_shipped
drivers/net/wan/wanxlfw.inc_shipped
drivers/scsi/53c700_d.h_shipped
drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
drivers/tty/vt/defkeymap.c_shipped
scripts/dtc/dtc-lexer.lex.c_shipped
scripts/dtc/dtc-parser.tab.c_shipped
scripts/dtc/dtc-parser.tab.h_shipped
scripts/genksyms/keywords.hash.c_shipped
scripts/genksyms/lex.lex.c_shipped
scripts/genksyms/parse.tab.c_shipped
scripts/genksyms/parse.tab.h_shipped
scripts/kconfig/zconf.hash.c_shipped
scripts/kconfig/zconf.lex.c_shipped
scripts/kconfig/zconf.tab.c_shipped


