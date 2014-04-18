Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161002AbaDRVjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:39:41 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39763 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaDRVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140418205213.GA21823@atomide.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
	<1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
	<1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
	<CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
	<20140418205213.GA21823@atomide.com>
Date: Fri, 18 Apr 2014 16:39:33 -0500
Message-ID: <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
From: Rob Herring <robherring2@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 3:52 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Rob Herring <robherring2@gmail.com> [140411 10:33]:
>> On Fri, Mar 21, 2014 at 9:46 AM, Jean-Jacques Hiblot
>> <jjhiblot@traphandler.com> wrote:
>> > The goal of this patch is to allow drivers to be probed even if at the time of
>> > the DT parsing some of their IRQ ressources are not available yet.
>> >
>> > In the current situation, the IRQ resources of a platform device are filled from
>> > the DT at the time the device is created (of_device_alloc()). The drawback of
>> > this is that a device sitting close to the top of the DT (ahb for example) but
>> > depending on ressources that are initialized later (IRQ domain dynamically
>> > created for example) will fail to probe because the ressources don't exist
>> > at this time.
>>
>> s/ressources/resources/
>
> While I've tested these two patches and they fix the issue for me. I have
> some serious doubts again about this whole ------ up string parsing
> pile of ---- called device tree.
>
> Do we really need to sprinkle more of_* hacks to the irq subsystem?
>
> There's nothing wrong with with the irq subsystem. Platform bus is just
> calling the irq subsystem at the wrong time with uninitialized data.

This patch doesn't even touch the irq subsystem.

> It seems that we're again papering over the fact that there's nothing
> coordinating the setting up of various resources with device tree.
> That seems to be the repeating never ending pattern as we've already
> seen with GPIOs, pinctrl, and IRQchips. We end up adding all kinds of
> cross subsystem calls that were never needed earlier.

This problem may be made worse with DT, but this problem has existed
for as long as I have worked on the kernel. It is worse with DT since
platforms have less control over the init ordering and loose some
ability to do tricks like changing the initcall levels. We didn't even
try to do pinctrl in any generic way before DT.

Rob
