Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3HAQfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:35:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51365 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab3HAQfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:35:23 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Matt Sealey <neko@bakuhatsu.net>
Subject: Re: [PATCH v4 2/6] misc: sram: add ability to mark sram sections as reserved
Date: Thu, 1 Aug 2013 18:35:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307291510.31679.heiko@sntech.de> <1375106520.4223.24.camel@pizza.hi.pengutronix.de> <CAHCPf3vSQHtRkk-_cs3monHfrF-hVx3vTDt1ctcax_bspXDmsg@mail.gmail.com>
In-Reply-To: <CAHCPf3vSQHtRkk-_cs3monHfrF-hVx3vTDt1ctcax_bspXDmsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308011835.22186.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Juli 2013, 23:39:45 schrieb Matt Sealey:
> On Mon, Jul 29, 2013 at 9:02 AM, Philipp Zabel <p.zabel@pengutronix.de> 
wrote:
> > Hi Heiko,
> > 
> > Am Montag, den 29.07.2013, 15:12 +0200 schrieb Heiko Stübner:
> >> Some SoCs need parts of their sram for special purposes. So while being
> >> part of the peripheral, it should not be part of the genpool
> >> controlling the sram.
> >> 
> >> Therefore add an option mmio-sram-reserved to keep arbitrary portions of
> >> the sram from being part of the pool.
> >> 
> >> Suggested-by: Rob Herring <robherring2@gmail.com>
> >> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> >> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
> >> ---
> >> Philipp: I didn't carry the ack, because the loop changed significantly
> >> again. So if it looks ok, could you re-ack it please?
> > 
> > I'd prefer the first loop to contain the magic and produce a list of
> > useable chunks, instead of a list of reserved blocks. The second loop
> > could then iterate over the array and just call gen_pool_add_virt
> > repeatedly.
> > 
> > regards
> > Philipp
> 
> Agreed, however specifying chunks of memory should probably match the
> format of the standard memory@ node "available" property - mostly
> because it would be the same syntax and definition as defining any
> other chunk of memory, as OpenFirmware and device trees have been
> doing since the dark ages. In this case, why not re-use the
> "available" property name instead of creating a new one? Standard OF
> memory parsing code is then free for you to use to pull the chunks
> out.

Sound interesting, but could you give me a pointer to some sort of docs about 
this "available" property in memory nodes?

Documentation/devicetree/booting-without-of.txt seems to be the only file 
describing the memory node at all but only required properties, and not any 
"available" property.

I've found a document  on power.org describing the memory node, but also not 
mentioning any "available" property.

And devicetree.org does not seem to handle the memory node at all.


Thanks for any hints
Heiko
