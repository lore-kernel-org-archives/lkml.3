Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3FJNy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:54:27 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54019 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3FJNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:54:25 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/2] pinctrl: common handling of generic pinconfig props in dt
Date: Mon, 10 Jun 2013 15:54:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
References: <201306090159.05383.heiko@sntech.de> <201306101506.36098.heiko@sntech.de> <CACRpkdbnf2MJtnYrwGMVWyz4S=7tuDKv84p7eNgveSNCeLv15g@mail.gmail.com>
In-Reply-To: <CACRpkdbnf2MJtnYrwGMVWyz4S=7tuDKv84p7eNgveSNCeLv15g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306101554.21671.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. Juni 2013, 15:39:26 schrieb Linus Walleij:
> On Mon, Jun 10, 2013 at 3:06 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Montag, 10. Juni 2013, 14:52:13 schrieb Linus Walleij:
> >> On Sun, Jun 9, 2013 at 1:59 AM, Heiko Stübner <heiko@sntech.de> wrote:
> >> > following your suggestions for a common handling of things like pulls
> >> > in dt, I've come up with the following solution - hopefully I've
> >> > gotten the correct meaning of your explanaitions.
> >> > 
> >> > It handles all the pinconfigs that either ignore the argument, or have
> >> > very simple one, like PIN_CONFIG_OUTPUT does.
> >> 
> >> OK patches applied. It needs some rough fixes like NULL check
> >> on kmalloc() but it'll do for a starter.
> > 
> > gah, sorry ... I have urge to crawl under a rock now for forgetting
> > something this obvious ;-) .
> > 
> > Apart from the NULL check what more did I mess up? Should I send a fixup
> > patch or do you want to do it?
> 
> I can fix this.
> 
> But now I just wondered about one thing:
> 
> Does this design imply that we will never be able to support any
> more than 32 bits (well, the number of bits in unsigned long)
> i.e. 32 different generic pin configurations?
> 
> In that case I suspect this might not be so wise. :-(

hmm, yes this would be the limit ... so back to the drawing board


> What about instead of using bitstuffed numbers using some
> representation similar to what can be found in
> Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> 
> So instead of using <dt-bindings/pinctrl/pinconfig.h> and
> enumerators it would be more like using node properties
> like this:
> 
> my_config: my_config {
>         bias-disable;
>         drive-push-pull = <6>;
>         output-high;
> };
> 
> It will make the device trees bigger for sure, but maybe more
> readable as well?

There was a discussion about each of the merits of the two approaches 
(bitstuffed vs. individual properties) between Tomasz Figa and Jean-Christophe 
PLAGNIOL-VILLARD a bit back if I remember correctly.


Also I don't think having the configs central like Nomadik does would bloat 
the dt to much, as most of the time most pins share one config or another.

And it still would be possible to write short pin statements as

	pins = <bank pin mux &config_node>;

if I'm not mistaken.
