Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3EXMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:03:18 -0400
Received: from mail.abilis.ch ([195.70.19.74]:21647 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3EXMDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:03:16 -0400
Date: Fri, 24 May 2013 14:03:00 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130524120259.GC5203@ab42.lan>
References: <20130429161725.GB30136@ab42.lan>
 <5182B557.4040804@wwwdotorg.org>
 <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
 <20130508164123.GA10248@ab42.lan>
 <518AAF31.8080502@wwwdotorg.org>
 <20130510082521.GA2125@ab42.lan>
 <51942472.9010402@wwwdotorg.org>
 <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
 <20130522142824.GC4789@ab42.lan>
 <CACRpkdYsSwJeVPcLFT7pMjyRsgvoEc+302Zah1Zy2sDOBvVwEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdYsSwJeVPcLFT7pMjyRsgvoEc+302Zah1Zy2sDOBvVwEg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 11:20:31AM +0200, Linus Walleij wrote:
> On Wed, May 22, 2013 at 4:28 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> > On Mon, May 20, 2013 at 10:10:33AM +0200, Linus Walleij wrote:
> 
> >> It's not even pinctrl-simple-centric it is completely generic.
> >> The code is in drivers/gpio/gpiolib-of.c.
> >>
> >> It was written by Shiraz Hashin and Haojian Zhuang.
> >> At the time I augmented the core code quite a bit to make
> >> a good fit.
> >
> > I agree. Unluckily, it uses pinctrl-internal pin numbering which we
> > would have to make coherent with the physical pin numbers of the
> > individual packaging variants of the chip in order to expose them to
> > customers (see my previous mail at https://lkml.org/lkml/2013/5/22/207).
> 
> Again, the Linux pin numberspace is sparse, you can use whatever
> pin number you like as long as it fits in a u32 and does not overlap
> with other pins.
> 
> If you have a problem that the physical pin numbers and the
> bank offsets or bits you need to poke or something doesn't
> match, that is an issue for the *driver* not for the pin control
> subsystem. However the pin control core may provide
> cross-mapping helpers as discussed elsewhere, but the
> pin control internal numbering is *not* an issue. Those are
> just "some number" on a certain pin controller, use the number
> from the datasheet if you like.

Understood. What I'm looking for is a way to support different products
with different physical pin numbering, ideally without changing Linux
internal pin numbers from one product variant under the constraints
highlighted in the thread you call "elsewhere".

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
