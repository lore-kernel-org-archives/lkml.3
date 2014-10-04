Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaJDK4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:56:42 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62392 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaJDK4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:56:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
Date: Sat, 04 Oct 2014 12:56:21 +0200
Message-ID: <25153910.sxFpRXQ3aL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1817639.W8PYrU1iOP@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2784760.Rf0vOml5OQ@wuerfel> <1817639.W8PYrU1iOP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NEMCkUImpH11oI3AFMjKyUDHdIrz1cSVsdruJnUYBFJ
 QEKqMcVQcgqovMW9SSbsQvu/ms2+Je3SXqny4KYyd6pLo9uZph
 T5zFjNTaA/p/9GTvezfWPQhSrOweDzJ8f+BqrAnihOds10tPw6
 WCGb09QbVBW7rVVgw2cIOu0kmtNNLYyCsXW/ozgoHpBzANkqYD
 KkpCC+1zEbcOt0h8N0TM7vvWjHnY+W0mPhUYDcToBUYGxCNozV
 FhRGU0N67g25h4vfgFlfBAuV43n511i8XqrJwwO8BDZaR70VjW
 6aUP0JfyTz8eKrIGMoLTLdDUo71CBpJOOGPJH7XDOVOxULSBfK
 pMJrIaoyZwoWr8YrFqOk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2014 01:58:30 Rafael J. Wysocki wrote:
> On Friday, October 03, 2014 05:02:13 PM Arnd Bergmann wrote:
> > On Friday 03 October 2014 14:56:10 Mark Rutland wrote:
> > > On Thu, Oct 02, 2014 at 03:55:56PM +0100, Arnd Bergmann wrote:
> > > I'd certainly not like to see #foo-cells in _DSD given it should be
> > > possible with a package to have a package description like the
> > > following:
> > > 
> > >         Package () {
> > >                 Package () { ^ref1, data, data }, 
> > >                 Package () { ^ref2, dta, data, data },
> > >         }
> > > 
> > > Where the #foo-cells is implicit in each instance. That makes variadic
> > > properties possible, and makes it possible to perform validation on each
> > > tuple even in the binary format, which we can't do with a DTB
> > > 
> > > I'm not so sure on foo-names unless we made names an explicit
> > > requirement from the start (which I wish was the case on the DT side).
> > > Even then we might need other parallel properties anyway (think
> > > clock-indicies).
> > 
> > I suppose it might even be possible to define the ACPI references to
> > have an optional string, so you can do
> > 
> >          Package () {
> >                  Package () { ^ref1, data, data }, 
> >                  Package () { "foo", ^ref2, data, data, data },
> >          }
> > 
> > The parser should be able to interpret both anonymous and named
> > references just by looking at the type of the first member.
> > You might not want to allow mixing them in a single property, but
> > that is more a style question than a technical requirement.
> 
> Yes, that only is a matter of implementing the parser.
> 
> For now, it simply is easier for us to parse the
> 
>         Package () { ^ref1, data, data }
> 
> format only, because we have functions for parsing lists of strings,
> lists of numbers etc. for other purposes anyway and we can re-use them
> for the names etc.  I don't see a reason why the parser cannot be extended in
> the future to handle "all in one" packages, but not necessarily at the moment.

It only really makes sense to do it that way though if it's used
consistently, and all references do naming like this rather than
the foo-names method.

	Arnd
