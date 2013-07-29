Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3G2Tot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:44:49 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49884 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753075Ab3G2Tor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:44:47 -0400
Date: Mon, 29 Jul 2013 16:44:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>
Subject: Re: [PATCH] ATA: sata_mv: Remove uneeded CONFIG_HAVE_CLK ifdefs
Message-ID: <20130729194452.GA31864@localhost>
References: <1375111282-22624-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1375111282-22624-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130729190431.GJ24782@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130729190431.GJ24782@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Jul 29, 2013 at 09:04:31PM +0200, Andrew Lunn wrote:
> On Mon, Jul 29, 2013 at 12:21:22PM -0300, Ezequiel Garcia wrote:
> > If CONFIG_HAVE_CLK is not selected, then all the clk API turn out
> > into stubs, so there's no need to have the ifdefs.
> > The only side-effect of this patch is the extra tiny kmalloc,
> > but that's not enough reason to have such ugly ifdefs all around
> > the code.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> What architectures did you compile this for? PowerPC and x86 as well
> as ARM? I _think_ this driver is also used there, and i _think_
> without some #ifdef, it failed to build. But maybe since then, the
> common clock is now available on all architectures?
> 

Using COMPILE_TEST=y, I've compiled with a working ARM config,
as well as with a MMU-less ARM (with COMMON_CLK=n).

And now that you mention x86, I've compiled it with an x86 config
(with COMMON_CLK=n).

I'm not sure this particular change is architecture dependent (at least
nowadays), since by looking at include/linux/clk.h it seems pretty
straightforward that all the operations are no-ops if HAVE_CLK=n.

Am I missing something?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
