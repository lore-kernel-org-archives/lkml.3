Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaLBO3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:29:49 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36942 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaLBO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
	<1416527684-19017-2-git-send-email-bparrot@ti.com>
	<CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
	<20141201163639.GI25249@lukather>
	<CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
Date: Tue, 2 Dec 2014 15:29:46 +0100
Message-ID: <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:

>> The only thing I'd like to have would be that the request here would
>> be non-exclusive, so that a later driver would still be allowed later
>> on to request that GPIO later on and manage it itself (ideally using
>> the usual gpiod_request function).
>
> Actually we have a plan (and I have some code too) to allow multiple
> consumers per GPIO. Although like Benoit I wonder why you would want
> to hog a GPIO and then request it properly later. Also, that probably
> means we should abandon the hog since it actively drives the line and
> would interfere with the late requested. How to do that correctly is
> not really clear to me.

I don't get the usecase. A hogged GPIO is per definition hogged.
This sounds more like "initial settings" or something, which is another
usecase altogether.

Yours,
Linus Walleij
