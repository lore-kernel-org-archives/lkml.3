Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3FKU22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:28:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55456 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FKU2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:28:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201306042252.03340.arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
 <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdaNMR=6JT+pi+9aqOJXW3gK9Yb4hztx3rOiY3c+f3UTRA@mail.gmail.com>
 <201306042252.03340.arnd@arndb.de>
Message-ID: <20130611202821.8816.86653@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 21/21] clk: ux500: Supply provider look-up functionality to
 support Device Tree
Date: Tue, 11 Jun 2013 13:28:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2013-06-04 13:52:03)
> On Tuesday 04 June 2013, Linus Walleij wrote:
> > The whole thing is very different from other DT clock things
> > I've seen, usually you add a compatible node for each
> > clock type, and a node for each physical gate. But there
> > may be several ways to skin this cat...
> > 
> 
> Based on the IRC discussion we had, I would think that the "prcc" clocks
> would best be represented using multiple clock-cells since you can describe
> them easily a tuple of register index, bit number some way to distinguish
> the two types.
> 
> The "prcmu" clocks are harder, and we probably need either a more verbose
> representation using one node per clock there, or have a single node
> for the entire prcmu and not bother to describe them in DT but hardcode
> everything in the source. The current patch does the latter, which is
> easier now but means we cannot simplify the code much in the future
> when we remove ATAGS boot support.
> 
> I hope Mike can give some better insight to what his preferences are.

I'm still learning about DT so my inputs should be weighed, measured and
then promptly thrown out. With that said I recently published an RFC to
convert the OMAP4 PRCM clocks to DT and my approach was a single node
per clock.

The register mapping for those clocks is mostly orderly, but not so
orderly that a neat and tidy tuple would suffice.  Also the recent MMP
clock series represents many of the clocks as single nodes.

I am not opposed to this design choice and it removes more data from C
files.  Some concerns were brought up about impacts to boot time but no
one has quantified that yet.

Regards,
Mike

> 
>         Arnd
