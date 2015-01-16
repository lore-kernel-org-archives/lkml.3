Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbbAPKVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:21:02 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39996 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbbAPKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLF7EVR-Xta=eNegmGWX9AFu9xmyhXisGCTwc1ds3t1cA@mail.gmail.com>
References: <1419019671-25377-1-git-send-email-bparrot@ti.com>
	<1419019671-25377-3-git-send-email-bparrot@ti.com>
	<CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
	<20150112163902.GE5834@ti.com>
	<CAAVeFuLF7EVR-Xta=eNegmGWX9AFu9xmyhXisGCTwc1ds3t1cA@mail.gmail.com>
Date: Fri, 16 Jan 2015 11:20:56 +0100
Message-ID: <CACRpkdbkBt5o1hZhJf4ao9f=nBdCupP45-YLvxym7gB7H5h_Bg@mail.gmail.com>
Subject: Re: [Patch v5 2/2] gpio: Document GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Benoit Parrot <bparrot@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:43 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Jan 13, 2015 at 1:39 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> Linus Walleij <linus.walleij@linaro.org> wrote on Mon [2015-Jan-12 11:20:14 +0100]:

>>> line_b {
>>>     gpio-hog;
>>>     gpios = <6 0>;
>>>     output-low;
>>>     line-name = "foo-bar-gpio";
>>> }
>>>
>>> Then use of_property_read_bool() in the code to check which
>>> state is to be selected intially. You can check that no mutually
>>> exclusive state are selected, I don't like that an arbitrary string
>>> select the state like that, if we do it that way an enumerator would
>>> be better, I prefer bools.
>>
>> I am sorry but that is how it was originally in the first patch.
>> Alexandre's review comment suggested this method in [1] and [2] (below).
>>
>> Alexandre, any comments?
>>
>> [1] http://marc.info/?l=linux-gpio&m=141456662426151&w=2
>>
>> [2] http://marc.info/?l=linux-gpio&m=141715982424744&w=2
>
> When Linus and I are in conflict, follow Linus. Arnd's suggestion of
> having enums defined in (IIUC) include/dt-bindings/gpio and using them
> sounds good to me too and might make everyone happy (no possibility of
> conflicting definitions + no strings). Linus, could you comment on it?

I'm fine with bools or enums, just not strings, sorry for the mess.

Yours,
Linus Walleij
