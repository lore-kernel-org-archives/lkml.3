Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3GCOjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:39:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:14377 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab3GCOjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:39:20 -0400
Date: Wed, 3 Jul 2013 16:38:37 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vincent.stehle@freescale.lan, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Message-ID: <20130703143835.GD3929@ab42.lan>
References: <20130625163902.GA2973@katana>
 <201307031343.11647.arnd@arndb.de>
 <20130703132905.GC3929@ab42.lan>
 <201307031620.03785.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201307031620.03785.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:20:03PM +0200, Arnd Bergmann wrote:
> On Wednesday 03 July 2013, Christian Ruppert wrote:
> > On Wed, Jul 03, 2013 at 01:43:11PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 26 June 2013, Wolfram Sang wrote:
> > > >   On Wed, Jun 26, 2013 at 10:55:06AM +0200, Christian Ruppert wrote:
> > > > > This patch makes the SDA hold time configurable through device tree.
> > > > > 
> > > > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> > > > 
> > > > Applied to for-next, thanks for keeping at it and providing lots of
> > > > useful information. Much appreciated!
> > > 
> > > Sorry, but I got a regression that I didn't find reported elsewhere
> > > so far, even though it breaks a lot of the ARM defconfig builds:
> > > 
> > > drivers/built-in.o: In function `dw_i2c_probe':
> > > /git/arm-soc/drivers/i2c/busses/i2c-designware-platdrv.c:125: undefined reference to `__udivdi3'
> > > 
> > > I suspect you want something like the change below.
> > 
> > This looks similar to a patch Vincent Stehle submitted yesterday, see
> > https://lkml.org/lkml/2013/7/2/145
> 
> Thanks for the link. Actually his patch looks wrong to me, because
> 
>  dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000, 1000000); 
> 
> assigns the division remainder to sda_hold_time, not the quotient.

Hrmmm... At least when I tested it this morning on an ARC architecture
it worked as intended and returned the quotient. Does that mean we have
an issue with this function on ARC? Can anyone who knows these functions
better than I comment?

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
