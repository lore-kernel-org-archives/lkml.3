Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3GZJnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:43:20 -0400
Received: from mail.abilis.ch ([195.70.19.74]:28602 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab3GZJnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:43:16 -0400
Date: Fri, 26 Jul 2013 11:42:29 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130726094228.GA3232@ab42.lan>
References: <20130626115051.GC7095@ab42.lan>
 <51CB279A.1090404@wwwdotorg.org>
 <20130705094859.GA27196@ab42.lan>
 <51D71337.6030409@wwwdotorg.org>
 <20130708130222.GA6402@ab42.lan>
 <51DDB5B8.5060909@wwwdotorg.org>
 <20130716084755.GB10914@ab42.lan>
 <51E56EF3.5040506@wwwdotorg.org>
 <20130718160700.GA14482@ab42.lan>
 <51E847EA.9060302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51E847EA.9060302@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:54:18PM -0600, Stephen Warren wrote:
> On 07/18/2013 10:07 AM, Christian Ruppert wrote:
> ...
> > Well, perhaps my definition of "inside"/"outside" pins was not quite
> > clear: The pin groups define the set of (kernel internal) pin numbers of
> > "outside" pins which are used by pin controller to map a given
> > interface. Inside pins are not numbered and the inside interfaces are
> > only used to determine which outside pins are part of the same group
> > (namely those for which the pin controller hardware provides a mux
> > connection to the same inside interface):
> > 
> >                        4
> >                 4  /|--/-- SPI
> >    PINS[0..3] --/--||  4
> >                    \|--/-- GPIO[0..3]
> > 
> >                    4
> >    PINS[4..7] -----/------ GPIO[4..7]
> > 
> >                        2
> >                 2  /|--/-- I2C
> >    PINS[8..9] --/--||  2
> >                    \|--/-- GPIO[8..9]
> > 
> > Pins 0..3 are in the SPI group because on the "inside" they can be muxed
> > to the SPI interface.
> > Pins 8..9 are in the I2C group because on the "inside" they can be muxed
> > to the I2C interface.
> > Pins 0..9 are in the GPIO group because on the "inside" they can be
> > muxed to the GPIO controller.
> > 
> > All pin numbers are relative to the "outside", however, or conflict
> > management would not be possible. I hope this is more understandable
> > than my previous explanations.
> > Both muxes are controlled by the same register. In our overly simplistic
> > example this is not strictly necessary but in reality you might have pin
> > conflicts between the different interfaces.
> 
> Same register, or same field/bits in that register?
> 
> If it's the same field/bits, I would expect to see the following pin groups:
> 
> 1) PINS[0..3], PINS[8..9]
> 2) PINS[4..7]
> 
> ... since those are the things that are independently muxable.
> Otherwise, I'd expect to see the following groups:
> 
> 1) PINS[0..3]
> 2) PINS[4..7]
> 3) PINS[8..9]
> 
> > After the discussion we had so far I'm not so sure if extending the
> > pinctrl system with this kind of features is a very good idea.
> 
> That makes things simple:-)
> 
> One thing I still don't understand; in a previous mail, you'd mentioned
> 3 DT properties for configuring the pinmux; one represented the pin
> group, one represented the mux function that was selected for that pin
> group, and there was a third ("config"?) property. I still don't
> understand that third property. I only see pins/pingroups and mux
> functions in the diagram I quoted above.

In my proposal, pin groups represent interfaces instead of ports: All
three pin groups are configured through the same bit field in the same
register but they represent _logically_ independent functionalities.
The three DT properties are:

1. interface (which pins are we actually interested in when requesting
   this)
2. port (which bit field/register is used to configure this)
3. configuration of that port (which mux function(s) in that bit
   field/register are possible to make the interface available)

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
