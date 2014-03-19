Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbaCSByr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:54:47 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:41631 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758552AbaCSByp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:54:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7652:7903:8985:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:
X-HE-Tag: trip02_c18c0affd708
X-Filterd-Recvd-Size: 2701
Message-ID: <1395194081.8649.7.camel@joe-AO722>
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
Date: Tue, 18 Mar 2014 18:54:41 -0700
In-Reply-To: <alpine.LNX.2.00.1403191240001.23002@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	 <1395148051.2812.51.camel@joe-AO722>
	 <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
	 <1395190072.8649.2.camel@joe-AO722>
	 <alpine.LNX.2.00.1403191240001.23002@nippy.intranet>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 12:46 +1100, Finn Thain wrote:
> On Tue, 18 Mar 2014, Joe Perches wrote:
> 
> > But using "if (0)" prevents the no_printk from occurring at all so there 
> > would be no side-effects and the format & args would still be verified 
> > by the compiler.
> 
> I'd prefer this (for symmetry and clarity):
> 
> #if NDEBUG
> #define dprintk(flg, fmt, ...) \
>         do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
> #else
> #define dprintk(flg, fmt, ...) \
>         do { if (0) pr_debug(fmt, ## __VA_ARGS__); } while (0)
> #endif
> 
> But you seem to be asking for this instead:
> 
> #if NDEBUG
> #define dprintk(flg, fmt, ...) \
>         do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
> #else
> #define dprintk(flg, fmt, ...) \
>         do { if (0) no_printk(fmt, ## __VA_ARGS__); } while (0)
> #endif
> 
> Why is that better?

It's not to me.

I suggested exactly your first block with if (0) pr_debug...
in the first thing I wrote.

https://lkml.org/lkml/2014/3/18/216

Geert suggested no_printk.

cheers, Joe


