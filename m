Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3K2Vpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:45:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3K2Vp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:45:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v6] gpio: Add MOXA ART GPIO driver
Date: Fri, 29 Nov 2013 22:45:16 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com> <201311281737.32696.arnd@arndb.de> <CACRpkda3bEmL+WRX1ct9SoUQOPXOT2mru0uz3-04nZB8G3DsvA@mail.gmail.com>
In-Reply-To: <CACRpkda3bEmL+WRX1ct9SoUQOPXOT2mru0uz3-04nZB8G3DsvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311292245.16573.arnd@arndb.de>
X-Provags-ID: V02:K0:CtflffEFhA2swUfon/0z/ybQE6zRKzLdiVSOoPmt1DO
 Fp829r4amCr9ZpZJMltvx1+6judxoG+wno7jlGZrZ31CVt67Sj
 Wsz3n8tDNA9KCmc28ML6N6z7KQf4NHMymVvvL0COJLSV57Iid8
 TgqOQL4PmOx550pUn41mb85gBp6soAQy3hOkoPDtoJL7TvcwqG
 ACNX5tZ+/SgVYN3C+VOpGwJ48v4cqg83GNyxrZ2xkXotaznlrz
 dpyTD1+Jqc2MZeNEhanlj8TCwo1traPtZjALPrOMC0XMrpVVWz
 Z/E6pPQFsjQRLz1/pqPfcYuGRkAIcNJpedSzToAfYR2smaVkHW
 wOdepFjMaWfBshA9MSd4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 November 2013, Linus Walleij wrote:
> On Thu, Nov 28, 2013 at 5:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 28 November 2013, Jonas Jensen wrote:
> >> +static void __iomem *moxart_gpio_base;
> >
> > Just one comment: the usual way to do such a driver is to have
> > a derived data structure like
> >
> > struct moxart_gpio_chip {
> >         struct gpio_chip chip;
> >         void __iomem *moxart_gpio_base;
> > };
> >
> > and dynamically allocate that from probe(), using container_of() to
> > get from the gpio_chip pointer to your own structure.
> 
> I see we make this comment a lot.
> 
> On my TODO there is an item to create
> Documentation/driver-model/design-patterns.txt
> 
> And document things like this. And other fun stuff like
> container_of().
> 
> What do you think about this idea?

Great idea!

	Arnd
