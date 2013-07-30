Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3G3CPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:15:17 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:54496 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3G3CPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130730014453.GJ29970@voom.fritz.box>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<2007664.vYsECFSKrV@flatron>
	<51F39FD8.6080808@broadcom.com>
	<2460092.aLmjrOVh1g@flatron>
	<51F3A82E.2000907@broadcom.com>
	<CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
	<CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
	<CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com>
	<CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
	<1374988276.1973.29.camel@dabdike>
	<20130730014453.GJ29970@voom.fritz.box>
Date: Mon, 29 Jul 2013 22:15:12 -0400
Message-ID: <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 9:44 PM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> On Sat, Jul 27, 2013 at 10:11:16PM -0700, James Bottomley wrote:
>> On Sat, 2013-07-27 at 21:28 -0600, Grant Likely wrote:
>> > On Sat, Jul 27, 2013 at 2:25 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > > On Sat, Jul 27, 2013 at 2:01 PM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
>> > >> On Sat, Jul 27, 2013 at 3:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > >>> On Sat, Jul 27, 2013 at 4:59 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> > >>>> Let's see how many people go and scream if I say this: Too bad .dts files
>> > >>>> are not done using XML format as DT bindings could be described using XML
>> > >>>> Schema.
>> > >>>
>> > >>> Draft an example and show us how it would look!  :-)  There is
>> > >>> absolutely nothing preventing us from expressing a DT in XML format,
>> > >>> or even using XSLT to define DT schema while still using our current
>> > >>> .dts syntax. It would be trivial to do lossless translation between
>> > >>> .dts syntax and xml.
>> > >>>
>> > >>> The problem that I have with XML and XSLT is that it is very verbose
>> > >>> and not entirely friendly to mere-mortals. However, I'm more than
>> > >>> willing to be proved wrong on this point.
>> > >>
>> > >> I considered this approach a while ago and discarded it. It would work
>> > >> but it is just too much of a Frankenstein monster.
>> > >>
>> > >> Much cleaner to modify dtc to take a schema as part of the compilation
>> > >> process. The schema language itself has no requirement to look like
>> > >> DTS syntax. Whoever wrote dtc probably has a favorite language that
>> > >> would be good for writing schemas in.
>> > >
>> > > Making it part of dtc is a required feature as far as I'm concerned.
>> > > Using XML/XSLT and dtc-integration are not mutually exclusive, but I
>> > > digress.
>> >
>> > Oops, ignore the XSLT bit. XSLT isn't schema and has no bearing on the
>> > discussion of schema. Sorry for the noise.
>>
>> XSLT is a transform language ... you'd use it say to transform xml to
>> dtc, so it would be an integral component of an xml/xslt based schema.
>>
>> If you want actually to describe and have validated the xml schema
>> itself, then you'd use xsd (XML schema description language) and its
>> associated tools.
>>
>> I'm not saying you *should* do this, just that it's possible (plus I've
>> just blown my kernel cred by knowing about xml, sigh).
>
> Heh.  So, it was said in jest, but that actually raises an important
> point.
>
> There are basically two criteria to keep in mind for our
> representation of schemas:
>    1) Adequate expressiveness to validate a sufficiently large part,
> of a sufficiently large number of bindings to be useful.
>    2) Ease of use and ease of learning **for the target audience**.
>
> To the best of my knowledge xsd would do well on (1), but I'm not
> convinced it does very well on (2).  In an environment where XML was
> already widely used, XSD would make perfect sense.  Here, I think it
> would be pretty ugly to wire onto the existing DT tools and
> infrastructure, and unpleasantly unfamiliar for many kernel and board
> developers trying to work with DT schemas.
>
>
> So, by way of investigation, let me propose an alternative expression
> of schemas, that I'm also not convinced we should do, but is possible
> and expressive.  It's illustrative, because it's kind of the polar
> opposite approach to XSD: just use C.
>
> dtc already has a (so far limited) "checks" mechanism which verifies
> various aspects of DT content.  These are implemented by C functions
> in checks.c.  There's obviously ample expressiveness - you can express
> any constraint you want that way.  It can be pretty verbose, and
> fiddly.  A good library of helper functions can mitigate that, but
> it's not clear how much.  On the other hand, a very good fraction of
> people working with this will already be familiar with C, which is a
> big plus.  This is, after all, the reason that the dts syntax is
> chiefly C inspired.
>
> Now, in practice, I think we will want a more convenient schema
> language (just as we wanted dts, rather than manually constructing
> FDTs as C structures).  But I absolutely do think, that the schema
> handling should be handled as plugins to the checks mechanism -
> basically we'd have a validate_schemas() check function.
>
> I also think we should consider the option of having a simple and
> straightforward schema language which handles, say, 80% of cases with
> a fall back to C for the 20% of curly cases.  That might actually be
> simpler to work with in practice than a schema language which can
> express absolutely anything, at the cost of being awkward for simple
> cases or difficult to get your head around.

Would C++ work? You can use operating overloading and templates to
change the syntax into something that doesn't even resemble C any
more.

>
> Remember, a schema language is only a win if it is - for the target
> audience - more convenient to express schemas in than C.
>
> --
> David Gibson                    | I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au  | minimalist, thank you.  NOT _the_ _other_
>                                 | _way_ _around_!
> http://www.ozlabs.org/~dgibson



-- 
Jon Smirl
jonsmirl@gmail.com
