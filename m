Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3JONgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:36:46 -0400
Received: from mail.abilis.ch ([195.70.19.74]:10995 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664Ab3JONgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:36:44 -0400
Date: Tue, 15 Oct 2013 15:36:22 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20131015133621.GA7461@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
 <1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
 <20131009132837.GA23021@ab42.lan>
 <CACRpkdbo9MOuCY_UWhzbWwEAom_Z3=Vi575ELix9j3hsZdBzZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbo9MOuCY_UWhzbWwEAom_Z3=Vi575ELix9j3hsZdBzZw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 04:01:05PM +0200, Linus Walleij wrote:
> On Wed, Oct 9, 2013 at 3:28 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> > On Wed, Oct 09, 2013 at 01:58:35PM +0200, Linus Walleij wrote:
> >> On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
> >> <christian.ruppert@abilis.com> wrote:
> >> > +In addition, named groups of pins can be mapped to pin groups of a given
> >> > +pin controller using the gpio-ranges property as described below:
> >> > +
> >> > +       gpio-range-list ::= <single-gpio-range> [gpio-range-list]
> >> > +       single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
> >> > +       numeric-gpio-range ::=
> >> > +                       <pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
> >> > +       named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
> >> > +       pinctrl-phanle : phandle to pin controller node.
> >>
> >> phanle really?
> >
> > Yes, this is actually identical to the numeric ranges. It specifies the
> > pin controller which is "responsible" for the pins/pin group in
> > question.
> 
> I was more thinking about the speling, should it not be "phandle"?
> 
> > The named pin groups actually are a physical property of the pin
> > controller hardware (well, at least the pin groups are, the names are
> > not ;).
> 
> OK.
> 
> It would be good if the names of the group could match, as close
> as possible, the names given to the same identity in the data
> sheet or similar documentation.

This is the idea. In many cases, the names are more coherent over
several product/package variants than the numbers and it is much easier
to make names coherent with (at least our) hardware documentation than
numbers.

[An updated patch with all the other comments integrated will follow]
