Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3BHEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:25:29 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49058 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759869Ab3BHEZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:25:28 -0500
Date: Fri, 8 Feb 2013 09:55:04 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 15/49] ARM: ux500: Add supply for the L3G4200D Gyroscope
Message-ID: <20130208042503.GA18611@bnru10>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-16-git-send-email-lee.jones@linaro.org>
 <CACRpkdZH1YWfbxY8yEwZ=ko8GAbPG=3ejS1Rt_yUD9ZsXeZ5Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdZH1YWfbxY8yEwZ=ko8GAbPG=3ejS1Rt_yUD9ZsXeZ5Dw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 16:36:03 +0100, Linus Walleij wrote:
> On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch lists the L3G4200D Gyroscope as a consumer of the
> > AB8500 VAUX1 regulator.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-ux500/board-mop500-regulators.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
> > index dbbeb20..097cf65 100644
> > --- a/arch/arm/mach-ux500/board-mop500-regulators.c
> > +++ b/arch/arm/mach-ux500/board-mop500-regulators.c
> > @@ -73,6 +73,8 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
> >         REGULATOR_SUPPLY("avdd", "3-005d"),
> >         /* Synaptics RMI4 Touchscreen device */
> >         REGULATOR_SUPPLY("vdd", "3-004b"),
> > +       /* L3G4200D Gyroscope device */
> > +       REGULATOR_SUPPLY("vdd", "l3g4200d"),
> 
> Hmmm isn't this an I2C device? Better check with Srinidhi about that
> device name.

Yes, it is. If you want to maintain consistency in the above table, it should be
rather.. 

REGULATOR_SUPPLY("vdd", "2-0068")

srinidhi

> 
> Yours,
> Linus Walleij
