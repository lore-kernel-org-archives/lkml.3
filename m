Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3IQRLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 13:11:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3IQRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 13:11:04 -0400
Date: Tue, 17 Sep 2013 19:10:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: sh-pfc: r8a7790: add pin definitions for
 the I2C3 interface
In-Reply-To: <CACRpkdbDa5Smpfyneq-SAPYvbxB-ju7-X8kkZ7RFpNcYrcBggg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1309171907220.25596@axis700.grange>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
 <1378742636-11215-2-git-send-email-g.liakhovetski@gmx.de>
 <CACRpkdbDa5Smpfyneq-SAPYvbxB-ju7-X8kkZ7RFpNcYrcBggg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Ti17r86uaP1tldNWkG4sjI2Vd/WICIpJKoFXsTzP3N+
 QeNu3lWxsgjuFmYPOk5LxGsruJaGnynFDtL6RNBKOSWsgOCEOd
 EL4z/wwx4U9ssMjd9uF0xIJqoxn/9up79jvajFyo4l0i8dGDzi
 IDq1VEBZQ89LRJDwIMIOsxKZTWMdxVSR+EsQLY1BUYEjzqtYWa
 SWbjXoJr47JasJO0kC+PFYwBMj4du6CDzbDa+DzLgTSU3o/t4K
 AU7cTX9VVyMa0pCoTsMT349iuwO7Z9cPUPkXGAeqvdyZ/wNv+z
 4FMPN/ku3fUl4jFaUXCsgUXFE4XSa4pSY5tEBLezy25lxZ/A6q
 63jWoYPaiHbX5AsarPg+k6dl9fBBSZ9jkKgzy5MwF8twyFC3B8
 2bwrGDhOidi5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

On Tue, 17 Sep 2013, Linus Walleij wrote:

> On Mon, Sep 9, 2013 at 6:03 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> 
> > There are four I2C interfaces on r8a7790, each of them can be connected to
> > one of the two respective I2C controllers, e.g. interface #0 can be
> > configured to work with I2C0 or with IIC0. Additionally some of those
> > interfaces can also use one of several pin sets. Interface #3 is special,
> > because it can be used in automatic mode for DVFS. It only has one set
> > of pins available and those pins cannot be used for anything else, they
> > also lack the GPIO function.
> >
> > This patch uses the sh-pfc ability to configure pins, not associated with
> > GPIOs and adds support for I2C3 to the r8a7790 PFC set up.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> 
> Pls CC Laurent who is main reviewer on all sh-pfc stuff.

Sure, sorry, thanks for adding him.

> > +/* R8A7790 has 6 banks with 32 GPIOs in each = 192 GPIOs */
> > +#define ROW_GROUP_A(r) ('Z' - 'A' + 1 + (r))
> > +#define PIN_NUMBER(r, c) (((r) - 'A') * 16 + (c) + 200)
> > +#define PIN_A_NUMBER(r, c) PIN_NUMBER(ROW_GROUP_A(r), c)
> 
> You add these #defines but do not use them.

ehm, actually I do:

+/* - I2C3 ------------------------------------------------------------------- */
+static const unsigned int i2c3_pins[] = {
+	/* SCL, SDA */
+	PIN_A_NUMBER('J', 15), PIN_A_NUMBER('H', 15),
+};

Besides, the PIN_NUMBER() macro is used in sh_pfc.h in the definition of 
SH_PFC_PIN_NAMED(), and that macro is also used in this patch:

+	/* Pins not associated with a GPIO port */
+	SH_PFC_PIN_NAMED(ROW_GROUP_A('J'), 15, AJ15),
+	SH_PFC_PIN_NAMED(ROW_GROUP_A('H'), 15, AH15),


> Yours,
> Linus Walleij

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
