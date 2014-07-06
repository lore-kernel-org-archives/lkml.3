Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaGFQkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:40:05 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:51163 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542AbaGFQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:40:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3872:3873:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12740:13069:13071:13095:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dust85_74962e8c4b407
X-Filterd-Recvd-Size: 1590
Message-ID: <1404664799.27043.41.camel@joe-AO725>
Subject: Re: [PATCH 2/4] Staging: rts5208: Use standard print_hex_dump_debug
From: Joe Perches <joe@perches.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Sun, 06 Jul 2014 09:39:59 -0700
In-Reply-To: <CACar8Ln_8+EQGf8z7kNqRPxOcheUuKj5bOg3TJ+xTF_SQFVGQQ@mail.gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
	 <1404663138-21333-3-git-send-email-fabio.falzoi84@gmail.com>
	 <1404663787.27043.33.camel@joe-AO725>
	 <CACar8Ln_8+EQGf8z7kNqRPxOcheUuKj5bOg3TJ+xTF_SQFVGQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 18:32 +0200, Fabio Falzoi wrote:
> Have I to fix just the commit message or is this behaviour not suitable?
> In the latter case, could you please suggest a way to fix this?

Hi Fabio.

I think it's not appropriate.
I'd've changed it to something like:

#if DEBUG
#define rtsx_hex_dump(buf, len)						\
	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE,	\
			     buf, len)
#else
#define rtsx_hex_dump(buf, len)
	do {;} while (0)
#endif


