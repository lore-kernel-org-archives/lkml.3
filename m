Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaCRNHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:49 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:36077 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755334AbaCRNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hen83_8266b41f835e
X-Filterd-Recvd-Size: 2007
Message-ID: <1395148051.2812.51.camel@joe-AO722>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Date: Tue, 18 Mar 2014 06:07:31 -0700
In-Reply-To: <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 13:55 +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 18, 2014 at 1:45 PM, Joe Perches <joe@perches.com> wrote:

Hi Geert.

> > #define dprintk(flg, fmt, ...) \
> > do { if (0) pr_debug(fmt, ##__VA_ARGS__); } while (0)
> 
> Na, no_printk():
> 
> #define dprintk(flg, fmt, ...) no_printk(fmt, ##__VA_ARGS__)

Fine, but with a correction.

no_printk keeps all side effects like
performing any function calls made by the
statement or accessing any volatiles.

Using

do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)

does not have any side-effects.


