Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3FCJmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:42:33 -0400
Received: from mail.abilis.ch ([195.70.19.74]:18450 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3FCJma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:42:30 -0400
Date: Mon, 3 Jun 2013 11:42:05 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
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
Message-ID: <20130603094204.GC31808@ab42.lan>
References: <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
 <20130508164123.GA10248@ab42.lan>
 <518AAF31.8080502@wwwdotorg.org>
 <20130510082521.GA2125@ab42.lan>
 <51942472.9010402@wwwdotorg.org>
 <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
 <20130522142824.GC4789@ab42.lan>
 <CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
 <20130524115053.GB5203@ab42.lan>
 <CACRpkdbqzSZefYB2jywkkKDE_Qse83+MDJ+D+UNYnQGFUzwQWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdbqzSZefYB2jywkkKDE_Qse83+MDJ+D+UNYnQGFUzwQWQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 02:21:05PM +0200, Linus Walleij wrote:
> On Fri, May 24, 2013 at 1:50 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> > I haven't understood how to associate GPIOs to
> > other functions, however: Our hardware pin controller makes GPIO pins
> > available depending on the configuration of the non-GPIO interfaces.
> > This means that in many configurations, GPIO banks are only partially
> > available because some pins are used for other purposes. We can't expect
> > our customers to manually change the pin assignments in the device tree
> > in order to take this into account for every PCB.
> 
> But what is it your customers do when customizing a board then?

Ideally, they just select the pin functions they would like to use on
their PCB using the phandle mechanism outlined in
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt.
We will prepare the nodes to point to in our SOC .dtsi files. Obviously,
customers will look at these files, in particular the nodes they point
to. The simpler these nodes are (and the easier to understand) the
better.

> Part of the promise of the device tree is to make it easy for downstream
> users to customize the kernel, *especially* for different boards/systems
> using the same SoC, for example. It is very much intended as a
> customization tools for embedded developers getting boards from
> a chipset vendor.

Yes, this is our understanding as well. This is why we would like to
avoid confusion through the exposure of obscure number spaces, even
if a customer is not supposed to modify them.

Ease of use is also the reason why I added the gpio-base property to the
original driver: Finding out the global GPIO number to use in
/sys/class/gpio for a given GPIO of a given bank seems to be a recurring
headache for our customers and the definition of the bank's base number
in the device tree is an attempt to improve this situation. I am looking
forward to the patch you said Alexandre is working on which will
probably be a much better solution.

> Maybe I don't understand what is meant by changing the pin
> assignments above ...

Every pin can have exactly one function at a time and is thus assigned
to that function. Ideally, conflicts are cleanly managed in the pinmux
driver and an error message is generated so customers can understand why
something doesn't work and how to fix it.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
