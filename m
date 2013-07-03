Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3GCOmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:42:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3GCOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:42:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Date: Wed, 3 Jul 2013 16:42:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <20130625163902.GA2973@katana> <201307031620.03785.arnd@arndb.de> <20130703143835.GD3929@ab42.lan>
In-Reply-To: <20130703143835.GD3929@ab42.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031642.30380.arnd@arndb.de>
X-Provags-ID: V02:K0:fmUdVldf1upjuC/rDO5lrajOzKf8LXjrG9svGWu8t0v
 oNIvIdNpqR/2lDZC7wuiw2pSgOPoCztd7idITm+lla/6k79/sc
 adsuJoHZzK57KEKIYBfJIHOQ2j5MV2yXoyMBKX3kaTLQVQzCE2
 asUb6dm6p0pbxKSRu8nmEmQkDU8s4haOmuP3X5bgofWUufB3zn
 a7E31h4O44ZWvgnFXjBsGB7uy+NGqtsdfDJ2xm+tYi17qR+U+t
 3+CQ2YCQ60zY5qJMjOoz6Dj3M8QQ7H/bheIBBpmNt+UO/H5OxA
 5HMaf7PIdVfeg5V8cyQ7tkg/p9MK1jsbU3QbYrU9nS+S3ALCZX
 ZM6f+GOyxs8MwPFWIzYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013, Christian Ruppert wrote:
> On Wed, Jul 03, 2013 at 04:20:03PM +0200, Arnd Bergmann wrote:
> > On Wednesday 03 July 2013, Christian Ruppert wrote:
> > > On Wed, Jul 03, 2013 at 01:43:11PM +0200, Arnd Bergmann wrote:
> > > > On Wednesday 26 June 2013, Wolfram Sang wrote:
> > > > >   On Wed, Jun 26, 2013 at 10:55:06AM +0200, Christian Ruppert wrote:
> > > > > > This patch makes the SDA hold time configurable through device tree.
> > > > > > 
> > > > > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > > > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> > > > > 
> > > > > Applied to for-next, thanks for keeping at it and providing lots of
> > > > > useful information. Much appreciated!
> > > > 
> > > > Sorry, but I got a regression that I didn't find reported elsewhere
> > > > so far, even though it breaks a lot of the ARM defconfig builds:
> > > > 
> > > > drivers/built-in.o: In function `dw_i2c_probe':
> > > > /git/arm-soc/drivers/i2c/busses/i2c-designware-platdrv.c:125: undefined reference to `__udivdi3'
> > > > 
> > > > I suspect you want something like the change below.
> > > 
> > > This looks similar to a patch Vincent Stehle submitted yesterday, see
> > > https://lkml.org/lkml/2013/7/2/145
> > 
> > Thanks for the link. Actually his patch looks wrong to me, because
> > 
> >  dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000, 1000000); 
> > 
> > assigns the division remainder to sda_hold_time, not the quotient.
> 
> Hrmmm... At least when I tested it this morning on an ARC architecture
> it worked as intended and returned the quotient. Does that mean we have
> an issue with this function on ARC? Can anyone who knows these functions
> better than I comment?

ARC just uses the generic version of div_u64, which is defined in lib/div64.c.

I suspect that the division remainder just happens to work well enough for
you to not cause any run-time error. You could try adding a printk
in that function to show the values you get on ARC.

	Arnd
