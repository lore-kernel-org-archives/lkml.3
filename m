Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbaCSBqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:46:44 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40130 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682AbaCSBqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:46:43 -0400
Date: Wed, 19 Mar 2014 12:46:16 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
In-Reply-To: <1395190072.8649.2.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1403191240001.23002@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>  <1395112756.20860.1.camel@joe-AO722>  <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>  <1395146702.2812.47.camel@joe-AO722>  <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
  <1395148051.2812.51.camel@joe-AO722>  <alpine.LNX.2.00.1403190925550.6652@nippy.intranet> <1395190072.8649.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Mar 2014, Joe Perches wrote:

> But using "if (0)" prevents the no_printk from occurring at all so there 
> would be no side-effects and the format & args would still be verified 
> by the compiler.

I'd prefer this (for symmetry and clarity):

#if NDEBUG
#define dprintk(flg, fmt, ...) \
        do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#else
#define dprintk(flg, fmt, ...) \
        do { if (0) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#endif

But you seem to be asking for this instead:

#if NDEBUG
#define dprintk(flg, fmt, ...) \
        do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#else
#define dprintk(flg, fmt, ...) \
        do { if (0) no_printk(fmt, ## __VA_ARGS__); } while (0)
#endif

Why is that better?

-- 
