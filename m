Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3FGNfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:35:16 -0400
Received: from mail.abilis.ch ([195.70.19.74]:19740 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3FGNfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:35:14 -0400
Date: Fri, 7 Jun 2013 15:34:50 +0200
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
Message-ID: <20130607133448.GJ11875@ab42.lan>
References: <518AAF31.8080502@wwwdotorg.org>
 <20130510082521.GA2125@ab42.lan>
 <51942472.9010402@wwwdotorg.org>
 <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
 <20130522142824.GC4789@ab42.lan>
 <CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
 <20130524115053.GB5203@ab42.lan>
 <CACRpkdbqzSZefYB2jywkkKDE_Qse83+MDJ+D+UNYnQGFUzwQWQ@mail.gmail.com>
 <20130603094204.GC31808@ab42.lan>
 <CACRpkdbuDWBPUC8RKSfzwiMycyf1juC=ivxPi-tz-3-vcScnEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdbuDWBPUC8RKSfzwiMycyf1juC=ivxPi-tz-3-vcScnEg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 01:36:16PM +0200, Linus Walleij wrote:
> On Mon, Jun 3, 2013 at 11:42 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> > Ease of use is also the reason why I added the gpio-base property to the
> > original driver: Finding out the global GPIO number to use in
> > /sys/class/gpio for a given GPIO of a given bank seems to be a recurring
> > headache for our customers and the definition of the bank's base number
> > in the device tree is an attempt to improve this situation.
> 
> What you need to do in that case is to find a way to name the pins
> in sysfs (creating symbolic links with the GPIO pin name) so they
> can use these names in sysfs instead.
> 
> There is no ambition from my side to try to correlate the
> GPIO sysfs interface and device trees. This is because the GPIO
> sysfs is not universally liked. And when you say you want to make the
> sysfs ABI easy to use that lights a big red light on my panel. I will
> explain why.
> 
> What is very important is that your customers understand that
> the GPIO sysfs shall not be used for things like:
> 
> - LEDs
> - Switches
> - Regulators
> - Camera muxes
> - etc
> 
> From the kernel community we have tried (or atleast I have tried)
> that this kind of hardware shall be handled by the apropriate linux
> subsystems, and not by obscure userspace code.

I totally agree with that and we already declare the LEDs etc. on our
PCBs in the device trees. However, we have at least one customer who has
a user space driver for some peripheral on i2c which needs to be reset
through GPIO. I'm not sure which framework to use for this sort of
applications.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
