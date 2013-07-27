Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3G0Thl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:37:41 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60351 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3G0Thj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130726142140.GR24642@n2100.arm.linux.org.uk>
References: <51F168FC.9070906@wwwdotorg.org> <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy> <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy> <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy> <20130726132709.GH29916@titan.lakedaemon.net>
 <1374846070.14574.92.camel@i7.infradead.org> <CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
 <20130726142140.GR24642@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 27 Jul 2013 13:37:19 -0600
X-Google-Sender-Auth: 7x4915sHawyelWT4kqfVK1i0jys
Message-ID: <CACxGe6v9G0aeAHQoymhg1=aTyNqf2w9OEcuK06GR=8rXCbB+fQ@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
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

On Fri, Jul 26, 2013 at 8:21 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jul 26, 2013 at 10:14:32AM -0400, jonsmirl@gmail.com wrote:
>> Yes, yes - that's why the schema should be written down and used as a
>> validation input to dtc. Then dtc can spit out errors for non-standard
>> items. There would be two versions - the standard one and a legacy one
>> that includes the standard one plus the hacks that can't be undone.
>>
>> But more importantly it provides a framework for people creating new
>> node definitions. Now they can't work in a vacuum and come up with
>> random names and structure for everything.
>>
>> Most of the problems express in the thread would go away if the schema
>> was written down and discussed. The rule going forward would be no new
>> nodes that aren't part of the standard schema.
>
> So this is why I'm seeing patches just a short time ago removing existing
> compatible strings from the DT descriptions and associated driver, and
> replacing them with new ones... meaning that the old DT files won't work
> with newer kernels.
>
> What that means is using the descriptions as the schema won't catch that
> because they're changing those as well to match.
>
> There's a solution to that: dtc becomes a separate project external to
> the kernel which also contains the schemas that it verifies against.
> That way, if you want to make changes such as that above, you need to
> get it past not only kernel people but also past dtc maintainers -
> which increases the chances of such stuff being caught.

+1

dtc has always been a separate project that happens to be mirrored in
the kernel tree, but the bindings need to come out be turned into
schema that can be validated.

g.
