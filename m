Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3G3Qkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:40:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38620 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3G3Qkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:40:41 -0400
Message-ID: <51F7EC84.90005@wwwdotorg.org>
Date: Tue, 30 Jul 2013 10:40:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com> <2460092.aLmjrOVh1g@flatron> <51F3A82E.2000907@broadcom.com> <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com> <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com> <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com> <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com> <1374988276.1973.29.camel@dabdike> <20130730014453.GJ29970@voom.fritz.box>
In-Reply-To: <20130730014453.GJ29970@voom.fritz.box>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:44 PM, David Gibson wrote:
...
> So, by way of investigation, let me propose an alternative
> expression of schemas, that I'm also not convinced we should do,
> but is possible and expressive.  It's illustrative, because it's
> kind of the polar opposite approach to XSD: just use C.

That actually sounds reasonable.

But, I think there's a difference between a schema, which defines
what's legal in an abstract fashion, and a validator, which defines
that the data conforms to the schema.

I can see that codding a validator in C would be pretty easy, and even
potentially quite simple/clean given a suitable set of library
functions as you say.

However, I'm not so convinced that expressing the schema itself as C
would work out so well. I think the code/data-structures would end up
being pretty stylized so they could actually be read as a schema. At
that point, a specific schema language would probably be simpler? Of
course, this is all somewhat conjecture; perhaps the only way to tell
would be to prototype various ideas and see how well they work.

Equally, I'm not sure I want to bind the schema definition to a
particular language. I'd like to be able to programatically generate
or manipulate *.dts files in arbitrary languages. Integrating a C
interpreter into those languages in order to handle the schema would
be annoying, whereas directly handling a special-purpose schema
language seems like it'd be more tangible.

As an aside, in the past I toyed with the idea of using Python data
structures as a *.dts syntax, and hence allowing
macros/auto-generation using custom Python code, and I'm sure Forth
will come up sometime in this thread:-)
