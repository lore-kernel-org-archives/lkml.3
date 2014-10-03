Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaJCPCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:02:35 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59855 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaJCPC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:02:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Date: Fri, 03 Oct 2014 17:02:13 +0200
Message-ID: <2784760.Rf0vOml5OQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141003135610.GM26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2072038.Vir4futZot@wuerfel> <20141003135610.GM26643@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hEGB7uF6jW+hdAC/pXdkkPATClUqHjrlNJ6Wojur1Qy
 KAJt798ajvKSCgTD4Yp9QVpBcxu0h56fpQjQAV/TrB5w0Fb3LX
 wqDfM/ehQpOeifUm7JvIpC0yc18cwc1rgmkBusz8l5KixWiaFJ
 5vonHcVUGKkoMomvNBG+DS53bvib4ENS90yuYMAK85C0wJI7up
 MdNV7Tu8BXdfD/XaNu0gsyOzih5jWk9Fgl+BidugpG4A/0SRYW
 1CcuKeUjzL7T72mo/VYTVjapq1pLz9FztPdTe7IW6Agcwax/Ex
 z2wpwz49wT6S9pJ5EPy9Yn5u86/KIYANOLQ1Pu8t8uX+8UeH4Y
 wY4bQEButdv+xbzct/XI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2014 14:56:10 Mark Rutland wrote:
> On Thu, Oct 02, 2014 at 03:55:56PM +0100, Arnd Bergmann wrote:
> > On Thursday 02 October 2014 17:38:09 Mika Westerberg wrote:
> > > On Thu, Oct 02, 2014 at 04:29:03PM +0200, Arnd Bergmann wrote:
> > > > Is this a limitation in the way that the AML syntax and compiler works,
> > > > or is this a decision you made specifically for the _DSD syntax and that
> > > > could still be changed if there is an overwhelming interest?
> > > 
> > > It is only limitation of the _DSD device property UUID specification and
> > > our implementation. It can be changed if needed.
> > 
> > Ok, I see. I think it would be nice if this could be changed in order
> > to avoid having to copy the #xxx-cells and xxx-names properties from
> > DT, by providing a more natural syntax.
> 
> I'd certainly not like to see #foo-cells in _DSD given it should be
> possible with a package to have a package description like the
> following:
> 
>         Package () {
>                 Package () { ^ref1, data, data }, 
>                 Package () { ^ref2, dta, data, data },
>         }
> 
> Where the #foo-cells is implicit in each instance. That makes variadic
> properties possible, and makes it possible to perform validation on each
> tuple even in the binary format, which we can't do with a DTB
> 
> I'm not so sure on foo-names unless we made names an explicit
> requirement from the start (which I wish was the case on the DT side).
> Even then we might need other parallel properties anyway (think
> clock-indicies).

I suppose it might even be possible to define the ACPI references to
have an optional string, so you can do

         Package () {
                 Package () { ^ref1, data, data }, 
                 Package () { "foo", ^ref2, data, data, data },
         }

The parser should be able to interpret both anonymous and named
references just by looking at the type of the first member.
You might not want to allow mixing them in a single property, but
that is more a style question than a technical requirement.

	Arnd
