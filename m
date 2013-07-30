Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3G3Ef0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:35:26 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33353 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3G3EfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130730032926.GL29970@voom.fritz.box>
References: <51F39FD8.6080808@broadcom.com> <2460092.aLmjrOVh1g@flatron>
 <51F3A82E.2000907@broadcom.com> <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
 <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
 <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com>
 <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
 <1374988276.1973.29.camel@dabdike> <20130730014453.GJ29970@voom.fritz.box>
 <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com> <20130730032926.GL29970@voom.fritz.box>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Jul 2013 22:35:03 -0600
X-Google-Sender-Auth: P4-7rp4NnjGYNpHpKAVR3czRMaA
Message-ID: <CACxGe6sUFmLZMT+dvCbpmPrzR3DNMjw64LbD3n=JsjXsmrM-qg@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 1:31 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Sun, Jul 28, 2013 at 03:19:03PM +0200, Richard Cochran wrote:
>> On Sun, Jul 28, 2013 at 11:12:53AM +0200, Tomasz Figa wrote:
>>
>> > I'm not really sure what effect on users this has. Maybe you should define
>> > "users".
>>
>> ...
>>
>> > Care to explain this reasoning?
>>
>> Use Case
>> ~~~~~~~~
>>
>> User acquires a machine running ARM Linux version 3.x, with u-boot
>> and dtb in a read only flash partition. The board boots and works just
>> fine. However, for his application, the user requires a new kernel
>> feature that appeared in version 3.y where y > x. He compiles the new
>> kernel, and it also works.
>
> I'm afraid this kind of use case will never be properly supported, DT
> stable ABI or not.

Why? New kernel features should be no problem at all.

New driver features /might/ not be available, but only if the new
feature requires additional data that isn't present in the tree and
cannot be obtained elsewhere.

>
> Think about this: what kernel will actually be shipped in that board?
> Most likely, it will be a BSP kernel from the vendor. Does the vendor
> will have made that commitment to have a stable ABI for the DT? Will it
> use the same bindings than mainline? Do we want to support all the crazy
> bindings every vendor will come up with?

That's not a DT issue. That an out-of-tree board/SoC support issue. DT
doesn't make that any better or worse.

g.
