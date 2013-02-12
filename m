Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3BLRTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:19:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab3BLRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:19:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
Date: Tue, 12 Feb 2013 17:18:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-arch" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <CACRpkdaHuv7CXCy15-o94G0r0+2BStsi34ZVbBAhyGj=U3xgOg@mail.gmail.com> <20130212155927.GE6088@linux-sh.org>
In-Reply-To: <20130212155927.GE6088@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121718.48244.arnd@arndb.de>
X-Provags-ID: V02:K0:Mt2YkcoVjtL0S8RtBFXqeSiooxt/u7SAdfLAd0o79B3
 lN3UuiiRkJTxvUqwQ0QP/Gp6bHtsT5S7yA5Ym/rKbGxn1HZx/N
 ZxkdYU7BTuJrmBAZr0QpRDaZMpUxdpROwg9ApMEdxkGGHh6J6D
 33jjILBawrQxswlasyZIT/y+bP+72mmR9IRKYz4BbmYM8YURFS
 3Hnl9xlvtCYX9llqmd9VEC3PRBus8R1hA7XDHsXA4Y5D1xt6bh
 WpD7k9QIjAdTYGQ84cdSKy3KyjIlr1k35P/Q6R52gGnghWQy3o
 Vaw0kCDIIYrM0322JqF4N1nLfSKFeZLo/mQoXSRRcEvEhQK4W3
 NmS9UU8LfaXMWkA8IdKA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Paul Mundt wrote:
> > While I do get the point... I chatted with Grant about it and
> > I want to talk to some toolchain people about this to see if
> > pointers containing potential error codes can somehow be
> > "flagged" by the compiler so we can enforce error checking on
> > them. (It may sound a bit utopic...)
> > 
> At the very least you can __must_check annotate, although that's probably
> still a bit coarser grained than what you're after.

There is an idea: we could have variants of __must_check for different
classes of returns: NULL error, ERR_PTR, negative integer on error, ...

	Arnd
