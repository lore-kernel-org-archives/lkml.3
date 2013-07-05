Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3GEOXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:23:47 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34342 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3GEOXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:23:44 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v3 2/6] misc: sram: add ability to mark sram sections as reserved
Date: Fri, 5 Jul 2013 16:23:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <201307051440.19428.heiko@sntech.de> <201307051441.27605.heiko@sntech.de> <CAOMZO5AHX0UpeKQh+faPT=MfCf53eo=kXigtOZd7iuKrz-sFeA@mail.gmail.com>
In-Reply-To: <CAOMZO5AHX0UpeKQh+faPT=MfCf53eo=kXigtOZd7iuKrz-sFeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201307051623.33991.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Juli 2013, 14:55:40 schrieb Fabio Estevam:
> On Fri, Jul 5, 2013 at 9:41 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > Some SoCs need parts of their sram for special purposes. So while being
> > part of the periphal, it should not be part of the genpool controlling
> > the sram.
> > 
> > Threfore add an option mmio-sram-reserved to keep arbitary portions of
> > the sram from being part of the pool.
> > 
> > Suggested-by: Rob Herring <robherring2@gmail.com>
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
> > ---
> > 
> >  Documentation/devicetree/bindings/misc/sram.txt |    8 +++
> >  drivers/misc/sram.c                             |   80
> >  +++++++++++++++++++++-- 2 files changed, 82 insertions(+), 6
> >  deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/misc/sram.txt
> > b/Documentation/devicetree/bindings/misc/sram.txt index 4d0a00e..eae080e
> > 100644
> > --- a/Documentation/devicetree/bindings/misc/sram.txt
> > +++ b/Documentation/devicetree/bindings/misc/sram.txt
> > 
> > @@ -8,9 +8,17 @@ Required properties:
> >  - reg : SRAM iomem address range
> > 
> > +Optional properties:
> > +
> > +- mmio-sram-reserved: ordered list of reserved chunks inside the sram
> > that +  should not become part of the genalloc pool.
> > +  Format is <base size>, <base size>, ...; with base being relative to
> > the +  reg property base.
> 
> Isn't it a typo?
> 
> I think you meant:
> Format is <base start>, <reserved size>,

no, the intended format is like

<0x0 0x100>, <0x1000 0x100>, ...

base + size, base + size, and so on


> 
> > +
> > 
> >  Example:
> >  
> >  sram: sram@5c000000 {
> >  
> >         compatible = "mmio-sram";
> >         reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000
> >         */
> > 
> > +       mmio-sram-reserved = <0x0 0x100>; /* reserve
> > 0x5c000000-0x5c000100 */
>
> > 
> >  };

