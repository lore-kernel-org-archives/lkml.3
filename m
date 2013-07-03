Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3GCOoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:44:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3GCOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:44:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Date: Wed, 3 Jul 2013 16:44:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: vincent.stehle@freescale.com, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
References: <20130625163902.GA2973@katana> <20130703143835.GD3929@ab42.lan> <201307031642.30380.arnd@arndb.de>
In-Reply-To: <201307031642.30380.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031644.09669.arnd@arndb.de>
X-Provags-ID: V02:K0:tgpQroqkzdhCT29S/w3v67tGpYOIQj1YE7vh0In5XO3
 KeLNf9X6hyEAcNcy8dsAZmNvtlmys6PbOND9EoV64H4HOufN9d
 H1IX2Sdq/FDMTkamRzJFOv8R+1e/1N/FHUY3fM0l4HfqHytpwi
 DdvNK3lNDDoz9SNKct2WjdILw5cmb1JxBbYFDjzCUTDVAPcNi2
 PDod4cSOLogAfC2Ldu8885hZQJDsvLggVbdkxW5HUAVkPq0oK4
 UNBZ8reVGyhWiCMR44Ig5mlTTcFOiKMMyl6mdWmgQ7Ygdb4a9q
 RAxXhnQGgle6eRMfrp6obl23YoNIib6xAQ0bnHu9j9SXiOlfRt
 UMSFaFxAYVJ9H0zbHiQw=
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
 

