Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3FEIFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:05:39 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41332 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3FEIF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:05:27 -0400
Date: Wed, 5 Jun 2013 09:05:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 21/21] clk: ux500: Supply provider look-up functionality
 to support Device Tree
Message-ID: <20130605080522.GP3370@gmail.com>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
 <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdaNMR=6JT+pi+9aqOJXW3gK9Yb4hztx3rOiY3c+f3UTRA@mail.gmail.com>
 <201306042252.03340.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306042252.03340.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jun 2013, Arnd Bergmann wrote:

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

As already discussed, in the PRCMU case I'm going to make 'enum
prcmu_clock {' look like register PRCM_YYCLKEN0_MGT_SET as described
by the design specification, and use that as our indexer.

> I hope Mike can give some better insight to what his preferences are.
> 
> 	Arnd

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
