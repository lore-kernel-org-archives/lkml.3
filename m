Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbaCSAr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:47:58 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:36011 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756662AbaCSAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:47:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2110:2393:2559:2562:2691:2828:2904:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3872:3873:4321:4605:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13071:13311:13357:13972:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL
X-HE-Tag: print18_ac524d8f3027
X-Filterd-Recvd-Size: 2418
Message-ID: <1395190072.8649.2.camel@joe-AO722>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
From: Joe Perches <joe@perches.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Date: Tue, 18 Mar 2014 17:47:52 -0700
In-Reply-To: <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	 <1395148051.2812.51.camel@joe-AO722>
	 <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-03-19 at 10:14 +1100, Finn Thain wrote:
> As for side-effects, chip register accesses would be affected if dprintk() 
> expanded to no_printk() when NDEBUG & flg == 0.
> 
> E.g. NCR5380.c line 1213:
> dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n",
>                      basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
> 
> I don't want to re-introduce side-effects into a dozen different NCR5380 
> drivers on three different architectures when I can test only one of those 
> drivers. It's difficult to get good code coverage even for one driver.

Hi again Finn.

If dprintk expanded directly to no_printk, then true.

But using "if (0)" prevents the no_printk from
occurring at all so there would be no side-effects
and the format & args would still be verified by the
compiler.

So I believe you shouldn't worry about side-effects.

cheers, Joe


