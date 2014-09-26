Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaIZNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:52:30 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44084 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753908AbaIZNw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:52:29 -0400
Date: Fri, 26 Sep 2014 14:52:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlo Caione <carlo@caione.org>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140926135210.GU5182@n2100.arm.linux.org.uk>
References: <20140926112344.3ee87d2f@canb.auug.org.au> <20140926081804.GH5182@n2100.arm.linux.org.uk> <54253195.5040003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54253195.5040003@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 10:27:49AM +0100, Daniel Thompson wrote:
> On 26/09/14 09:18, Russell King - ARM Linux wrote:
> > On Fri, Sep 26, 2014 at 11:23:44AM +1000, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Today's linux-next merge of the arm-soc tree got a conflict in
> >> arch/arm/Kconfig.debug between commits 0889a9e35bd3 ("ARM: 8142/1:
> >> ks8695: Migrate debug_ll macros to shared directory"), e38c399ca584
> >> ("ARM: 8144/2: netx: Migrate DEBUG_LL macros to shared directory"),
> >> 6741cacfa3f1 ("ARM: 8145/1: sa1100: Migrate DEBUG_LL macros to shared
> >> directory") and debf843bf7ee ("ARM: 8146/1: Seperate DEBUG_UART_PHYS
> >> from DEBUG_LL on EP93XX") from the arm tree and commits d8a00916b303
> >> ("ARM: meson: debug: add debug UART for earlyprintk support"),
> >> b125170a39ea ("CNS3xxx: Fix debug UART") and b51312bebfa4 ("ARM:
> >> BCM63XX: add low-level UART debug support") from the arm-soc tree.
> >>
> >> I fixed it up (hopefully - see below) and can carry the fix as
> >> necessary (no action is required).
> >>
> >> You may be able to clean some of this up by using intermediate config
> >> symbols that are selected by the low level symbols and depended upon by
> >> the higher level config symbols.
> > 
> > Actually, I'll drop the patch set I have.  I didn't spot this earlier,
> > but people seem to have a hard time sorting stuff numerically:
> > 
> >         default 0xffd82340 if ARCH_IOP13XX
> > +       default 0xfffb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
> > +       default 0xfffb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
> > +       default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
> >         default 0xfff36000 if DEBUG_HIGHBANK_UART
> 
> Oops. This is disappointing from my point-of-view but there's no one to
> blame but me.
> 
> I have fixed this in my tree and will requeue for 3.19.

Okay, I've dropped 8141/1 onwards, so the only patches I have from your
series are:

ep93xx: Enable DEBUG_LL_UART_PL01X
versatile: Enable DEBUG_LL_UART_PL01X

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
