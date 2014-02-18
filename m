Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaBRRag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:30:36 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63866 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaBRRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:30:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<20140218005217.GJ1706@sonymobile.com>
	<CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
Date: Tue, 18 Feb 2014 09:30:31 -0800
Message-ID: <CAJAp7Oi2sa0VeEOVaSi2B1fsxzcnNRohvRf_r2k44XX9+83tgA@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Bjorn Andersson <bjorn@kryo.se>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:06 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> Hi Courtney,
>
> On 18 February 2014 06:22, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
>> On Sat, Feb 15, 2014 at 07:25:27PM +0100, Jassi Brar wrote:
[...]
>>> +struct ipc_client {
>>
>> I'm not so sure about the naming scheme here.  This header is
>> mailbox_client.h, and drivers are expected to go in drivers/mailbox, yet the
>> structs and functions have an ipc_ prefix.  Please standardize this,
>> preferably to mbox_ or mailbox_.
>>
> Yeah Loic already pointed that out.
> The term 'mailbox' is specific to what ARM calls the IPC links in
> their manuals. Perhaps we should rename the directory to drivers/ipc/.
>  'Mailbox' is too symbolic. Though I am OK either way.

In this world IPC means "Inter-process communication", so I'm afraid it's taken.

[...]
>>> +request_token_t ipc_send_message(void *channel, void *mssg);
>>
>> In the case of the blocking use-case, the function's return type is odd.
>> Perhaps, instead of my recommendation above, this could be turned into
>> two separate functions: ipc_send_message() and ipc_send_message_async()?
>>
> In blocking use case, the call will return success (a valid token).
> The client sees a valid token and understands that the request was
> accepted. And because the client asked it to be a blocking call, it
> also understands the TX is successfully completed.  What's odd here?
>

I've tried to figure out why you return your magic type here, from
what I can see it's just indicating to the consumer if the tx
succeeded (and maybe was put on the fifo?). When constructing this
number you have a comment that says "aid for debugging", which
indicates that it really doesn't hold any value...

There is already a convention for this in the kernel, return
descriptive negative numbers on failures; 0 on success.


How do you plan to support probe deferral here?

What is the plan to support references in Device Tree?

[...]
>> Although I will admit that I didn't go looking at random code on the
>> internet before submitting my series, I did take a look at the previous
>> iterations of this submitted for upstream.
>>
> But you objections (except cosmetic ones) sound like you are not aware
> of all use-cases that have been taken care of.

Your argument in the discussion of Courtneys proposal was "I have code
that depends on my code, let me show it to you first".

So please enlighten us on what use cases it is that you do support;
that are actually seen in real life.

Regards,
Bjorn
