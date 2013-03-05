Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3CESCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:02:39 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:37923 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab3CESCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:02:38 -0500
Date: Tue, 5 Mar 2013 19:02:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: dove: Fix typo "COMMON_CLK_DOVE"
Message-ID: <20130305190232.0b1a5e29@armhf>
In-Reply-To: <20130305140025.GO23237@titan.lakedaemon.net>
References: <1362476098.16460.65.camel@x61.thuisdomein>
	<20130305140025.GO23237@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Mar 2013 09:00:25 -0500
Jason Cooper <jason@lakedaemon.net> wrote:

> On Tue, Mar 05, 2013 at 10:34:58AM +0100, Paul Bolle wrote:
> > Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
> > DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
> > Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
> > makes this select statement a nop. Since the Marvell Dove code includes
> > <linux/clk-provider.h> we can assume that this entry needs to select
> > COMMON_CLK instead.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested.
> > 
> >  arch/arm/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)  
> 
> Nice catch, thanks for the patch.  Sebastian, could you test this and
> report back?

I also have a Cubox and I generated a kernel 3.9-rc1 for it (not tested
yet).

The .config contains CONFIG_COMMON_CLK=y naturally because MACH_DOVE
selects PLAT_ORION_LEGACY which selects PLAT_ORION which selects
COMMON_CLK.

So, "select COMMON_CLK" is not needed in ARCH_DOVE.

BTW, why is there a PLAT_ORION_LEGACY?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
