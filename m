Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3KWPmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:42:49 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:61717 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3KWPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:42:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131123015034.GP10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
	<20131123005509.GJ16735@n2100.arm.linux.org.uk>
	<20131123010850.GN10023@atomide.com>
	<20131123011515.GO10023@atomide.com>
	<20131123015034.GP10023@atomide.com>
Date: Sat, 23 Nov 2013 09:42:44 -0600
Message-ID: <CAL_JsqKV7K+QdLHS+3LtfcVx5Dpc7n6A8UwwNWKBP33Gs19c8g@mail.gmail.com>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
From: Rob Herring <robherring2@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 7:50 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [131122 17:16]:
>> * Tony Lindgren <tony@atomide.com> [131122 17:09]:
>> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
>> > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
>> > > > +               /* See of_device_resource_notify for populating interrupts */
>> > > > +               for (i = 0; i < num_irq; i++, res++) {
>> > > > +                       res->flags = IORESOURCE_IRQ;
>> > > > +                       res->start = -EPROBE_DEFER;
>> > > > +                       res->end = -EPROBE_DEFER;
>> > >
>> > > NAK.  Definitely a bad idea to start introducing magic values other into
>> > > resources.  Please don't do this.
>> >
>> > Do you have any better ideas on how to sort out this issue then?
>>
>> I guess we could allocate all the resources lazily here, I'll take a look
>> at that.
>
> Here's a version that allocates the resources lazily with the notifier.
> Seems to boot, need to play with it a bit more though to make sure we're
> not overwriting resources for any legacy devices.

Have you seen Thierry's series[1]? While your approach is certainly
more concise, it seems like a work-around for the problem. I don't
think a notifier is the right long term solution.

Rob

[1] http://www.spinics.net/lists/arm-kernel/msg274110.html
