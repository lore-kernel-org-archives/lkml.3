Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaBJRwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:52:09 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:35674 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBJRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:52:06 -0500
MIME-Version: 1.0
In-Reply-To: <4706525.lB7VmvWQMJ@wuerfel>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
	<1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
	<4706525.lB7VmvWQMJ@wuerfel>
Date: Mon, 10 Feb 2014 11:52:05 -0600
Message-ID: <CAL_JsqKa6nyPOa0M67svUR20Y3JNZcFhsTZE=ooV-eg6_ZBaMw@mail.gmail.com>
Subject: Re: [RFC 1/6] mailbox: add core framework
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>, s-anna@ti.com,
        Rob Herring <rob.herring@calxeda.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Tony Lindgren <tony@atomide.com>, omar.ramirez@copitl.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 8:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 07 February 2014 16:50:14 Courtney Cavin wrote:
>> The mailbox drivers are fragmented, and some implement their own core.
>> Unify the drivers and implement common functionality in a framework.
>>
>> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>

[snip]

>> +int mbox_channel_notify(struct mbox_channel *chan,
>> +             const void *data, unsigned int len)
>> +{
>> +     return atomic_notifier_call_chain(&chan->notifier, len, (void *)data);
>> +}
>> +EXPORT_SYMBOL(mbox_channel_notify);
>
> What is the reason to use a notifier chain here? Isn't a simple
> callback function pointer enough? I would expect that each mailbox
> can have exactly one consumer, not multiple ones.

It probably can be a callback, but there can be multiple consumers. It
was only a notifier on the pl320 as there was no framework at the time
and to avoid creating custom interfaces between drivers. On highbank
for example, we can asynchronously receive the events for temperature
change, power off, and reset. So either there needs to be an event
demux somewhere or callbacks have to return whether they handled an
event or not.

Rob
