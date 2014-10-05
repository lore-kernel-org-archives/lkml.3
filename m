Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaJEVUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:20:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54673 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751596AbaJEVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:20:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Date: Sun, 05 Oct 2014 23:40:44 +0200
Message-ID: <2046452.dH5gnGeAQK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <25153910.sxFpRXQ3aL@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1817639.W8PYrU1iOP@vostro.rjw.lan> <25153910.sxFpRXQ3aL@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 04, 2014 12:56:21 PM Arnd Bergmann wrote:
> On Saturday 04 October 2014 01:58:30 Rafael J. Wysocki wrote:
> > On Friday, October 03, 2014 05:02:13 PM Arnd Bergmann wrote:
> > > On Friday 03 October 2014 14:56:10 Mark Rutland wrote:
> > > > On Thu, Oct 02, 2014 at 03:55:56PM +0100, Arnd Bergmann wrote:
> > > > I'd certainly not like to see #foo-cells in _DSD given it should be
> > > > possible with a package to have a package description like the
> > > > following:
> > > > 
> > > >         Package () {
> > > >                 Package () { ^ref1, data, data }, 
> > > >                 Package () { ^ref2, dta, data, data },
> > > >         }
> > > > 
> > > > Where the #foo-cells is implicit in each instance. That makes variadic
> > > > properties possible, and makes it possible to perform validation on each
> > > > tuple even in the binary format, which we can't do with a DTB
> > > > 
> > > > I'm not so sure on foo-names unless we made names an explicit
> > > > requirement from the start (which I wish was the case on the DT side).
> > > > Even then we might need other parallel properties anyway (think
> > > > clock-indicies).
> > > 
> > > I suppose it might even be possible to define the ACPI references to
> > > have an optional string, so you can do
> > > 
> > >          Package () {
> > >                  Package () { ^ref1, data, data }, 
> > >                  Package () { "foo", ^ref2, data, data, data },
> > >          }
> > > 
> > > The parser should be able to interpret both anonymous and named
> > > references just by looking at the type of the first member.
> > > You might not want to allow mixing them in a single property, but
> > > that is more a style question than a technical requirement.
> > 
> > Yes, that only is a matter of implementing the parser.
> > 
> > For now, it simply is easier for us to parse the
> > 
> >         Package () { ^ref1, data, data }
> > 
> > format only, because we have functions for parsing lists of strings,
> > lists of numbers etc. for other purposes anyway and we can re-use them
> > for the names etc.  I don't see a reason why the parser cannot be extended in
> > the future to handle "all in one" packages, but not necessarily at the moment.
> 
> It only really makes sense to do it that way though if it's used
> consistently, and all references do naming like this rather than
> the foo-names method.

This almost sounds like "this will only makes sense if it's beautiful"
which I'm not sure I agree with. :-)

As long as it is clear what information is represented, I have no problems
with having multiple ways of expressing it and using them however people
like.  In fact, we don't even really know at this point which way will turn
out to be most convenient eventually.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
