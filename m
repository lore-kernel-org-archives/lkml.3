Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3IPMzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:55:32 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:54849 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3IPMza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130915124325.B1DF2C42C5C@trevor.secretlab.ca>
References: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar>
	<1379032225-6425-1-git-send-email-emilio@elopez.com.ar>
	<CAOesGMiUMniKRLRgGPsimR0bXWQFbx+SL5dUJXOb8t0JfEcHsg@mail.gmail.com>
	<52326ADC.8040703@elopez.com.ar>
	<CAL_JsqJACEtSRaDg0TcYODzhpsHFGa4mFSYa_R3qspypEKH+hQ@mail.gmail.com>
	<CAOesGMj=b5c_1v-nAejUzuOMfx44AHr2=yfoPepHYsh0=t0wOQ@mail.gmail.com>
	<20130915124325.B1DF2C42C5C@trevor.secretlab.ca>
Date: Mon, 16 Sep 2013 07:55:29 -0500
Message-ID: <CAL_Jsq+iYJBCKoM7S2wC1PVVM1sktmX6dWDpoKzYAvB7Q7j_8A@mail.gmail.com>
Subject: Re: [PATCH] memory: add a basic OF-based memory driver
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 7:43 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Fri, 13 Sep 2013 08:49:06 -0700, Olof Johansson <olof@lixom.net> wrote:
>> On Fri, Sep 13, 2013 at 7:00 AM, Rob Herring <robherring2@gmail.com> wrote:
>> > On Thu, Sep 12, 2013 at 8:31 PM, Emilio López <emilio@elopez.com.ar> wrote:

[snip]

>> > Better, but this is still wrong. DT describes the hardware. There is
>> > no such h/w as a simple-memory-controller. The fact that you have a
>> > simple-memory-ctrlr kernel driver is a kernel
>> > feature/artifact/limitation. Describe the h/w with a meaningful
>> > compatible string and put that string in the simple memory controller
>> > driver match table. If someday we have a real driver for said memory
>> > controller, then it is only a kernel change to use a different driver.
>>
>>
>> We discussed this over IRC last night -- I still think it makes more
>> sense to make the clock driver for sunxi aware of this and just add a
>> reference to the clock at init time.
>>
>> This is never going to differ from board to board (today the clock
>> name is the same on all sunxi platforms -- pll5_ddr. And the need will
>> likewise be there for all platforms at this time.
>>
>> If and when it changes in the future, we can reevaluate. But this
>> doesn't have to be driven by device tree at this time, it seems to
>> just make things overly complicated and contrived.
>
> I agree. Creating a new platform driver + device tree binding just to
> claim a clock that must not be disables does not look like the right
> approach to me either.

Maybe a driver is overkill, but fully describing the h/w would be a
good thing. Only defining the h/w that Linux currently uses is not a
good practice (although admittedly hard to avoid).

Rob
