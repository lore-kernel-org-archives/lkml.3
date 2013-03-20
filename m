Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3CTL3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:29:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab3CTL3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:29:13 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: RE: [PATCH v2 1/3] ARM: davinci: clk framework support for
 enable/disable functionality
Thread-Topic: [PATCH v2 1/3] ARM: davinci: clk framework support for
 enable/disable functionality
Thread-Index: AQHOJTXrQntlBfzNkU6hmfhPkccPxZiuExKAgABd2sA=
Date: Wed, 20 Mar 2013 11:28:02 +0000
Deferred-Delivery: Wed, 20 Mar 2013 11:28:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA99DF5@DBDE01.ent.ti.com>
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com>
 <1363761714-15034-2-git-send-email-avinashphilip@ti.com>
 <51499B5B.7020105@ti.com>
In-Reply-To: <51499B5B.7020105@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2KBTDJc031675

On Wed, Mar 20, 2013 at 16:49:55, Nori, Sekhar wrote:
> On 3/20/2013 12:11 PM, Philip Avinash wrote:
> > DAVINCI clock framework currently not supporting clock enable/disable
> > functionality on clock nodes. In DAVINCI platform EHRPWM module requires
> 
> Wrong. clock enable/disable is supported in the DaVinci clock
> implementation, but just for PSC clocks.
> 
> > support for clock enable/disable for TBCLK support. Hence this patch
> > adds support for enabling/disabling clocks depends on the availability
> > of the functionality.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > Changes since v1:
> > 	- Add support for clock enable/disable functionality.
> > 
> > :100644 100644 d458558... aa89e5e... M	arch/arm/mach-davinci/clock.c
> > :100644 100644 8694b39... 1e4e836... M	arch/arm/mach-davinci/clock.h
> >  arch/arm/mach-davinci/clock.c |    4 ++++
> >  arch/arm/mach-davinci/clock.h |    2 ++
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
> > index d458558..aa89e5e 100644
> > --- a/arch/arm/mach-davinci/clock.c
> > +++ b/arch/arm/mach-davinci/clock.c
> > @@ -35,6 +35,8 @@ static void __clk_enable(struct clk *clk)
> >  {
> >  	if (clk->parent)
> >  		__clk_enable(clk->parent);
> > +	if (clk->clk_enable)
> > +		clk->clk_enable(clk);
> 
> Why ignore usecount in this case?

Will check usecount & do enable. 

> 
> >  	if (clk->usecount++ == 0 && (clk->flags & CLK_PSC))
> 
> if clk->enable is available, no need to check for 'clk->flags & CLK_PSC'

I will correct it.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
