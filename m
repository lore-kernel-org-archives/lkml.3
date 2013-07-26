Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3GZOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:14:39 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50688 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <1374846070.14574.92.camel@i7.infradead.org>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<51F168FC.9070906@wwwdotorg.org>
	<20130725182920.GA24955@e106331-lin.cambridge.arm.com>
	<20130725184834.GA8296@netboy>
	<20130725213753.GC17616@obsidianresearch.com>
	<20130726080115.GA5436@netboy>
	<1374831744.2923.42.camel@shinybook.infradead.org>
	<20130726130927.GC4219@netboy>
	<20130726132709.GH29916@titan.lakedaemon.net>
	<1374846070.14574.92.camel@i7.infradead.org>
Date: Fri, 26 Jul 2013 10:14:32 -0400
Message-ID: <CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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

On Fri, Jul 26, 2013 at 9:41 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2013-07-26 at 09:27 -0400, Jason Cooper wrote:
>>
>> The other dynamic change that bears mentioning here is attributes which
>> have been configured by the bootloader.  For example, in mvebu, we have
>> the Schrodinger's Cat register.  It allows you to reconfigure the base
>> address of the registers from *within* that register range.  If the
>> bootloader does this, the DT needs to be updated to reflect the current
>> hardware configuration.  Otherwise, the kernel is stuck poking around at
>> memory addresses hoping to find something sane.
>>
>> But this falls into the same category as you mentioned, but outside of
>> chosen {};.
>
> Yeah, /chosen was given as an example of stuff that's almost
> *exclusively* "configuration" stuff.
>
> But there's plenty outside there that can reasonably change.
>
> It's OK to change the data, and of *course* the base address reported in
> the DT should actually match reality *today*, if it changes on the fly.
>
> It's not OK to change the *schema*  in which those data are expressed.
> That's the ABI we're talking about.

Yes, yes - that's why the schema should be written down and used as a
validation input to dtc. Then dtc can spit out errors for non-standard
items. There would be two versions - the standard one and a legacy one
that includes the standard one plus the hacks that can't be undone.

But more importantly it provides a framework for people creating new
node definitions. Now they can't work in a vacuum and come up with
random names and structure for everything.

Most of the problems express in the thread would go away if the schema
was written down and discussed. The rule going forward would be no new
nodes that aren't part of the standard schema.

>
> --
> dwmw2
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>



-- 
Jon Smirl
jonsmirl@gmail.com
