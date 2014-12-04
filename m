Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaLDPAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:00:48 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:55058 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbaLDPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:00:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141204145206.GR30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com> <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather> <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
 <20141202161227.GH30256@lukather> <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
 <20141204145206.GR30256@lukather>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 5 Dec 2014 00:00:26 +0900
Message-ID: <CAAVeFuJkZrmrQSb=63yDWjgZieT_hnutZkuO2WTENfb+72rayQ@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 11:52 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi again,
>
> It looks like I missed some part of it.
>
> On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
>> > GPIO hogging needs to be the ideal solution for that, since we can
>> > just enforce the GPIO14 value as the driver is probed, which provides
>> > the guarantee that any driver using the bank B will actually drive the
>> > GPIO it might use.
>>
>> At this point I start wondering if such initial setup should not be
>> the job of the bootloader? GPIO hogging ought to be simple and
>> definitive, adding the possibility to have it just as an initial value
>> would considerably complexify it. E.g. when is the gpio chip driver
>> supposed to release the hogged descriptor in such a case?
>
> Relying on the bootloader for such trivial (and critical) things may
> not work at all. You don't always have the option to replace it,
> either because you physically can't, or just because you don't have
> any alternative.
>
> I agree that in general this is something that should go in the
> bootloader, but we should have a way to deal with the case where it's
> not done.
>
>> Note that if the multiple GPIO consumer feature we are planning goes
>> through, you should be able to use both hogging *and* a regulator on
>> the same GPIO and achieve what you want. The expectation of multiple
>> consumers is that the board designers know what they are doing, and
>> this case would certainly fit (chip hogs the line and doesn't touch
>> the value after that, letting the regulator control it without any
>> conflict afterwards), although it would of course be better to solve
>> the issue through regular probing...
>
> If such an effort is on-going, then I'm totally fine waiting for it
> and leaving that outside the hogging mechanism. As long as it works,
> I'm happy.

Ok. I just want to wait until the next -rc1 to make sure that the
large GPIO array removal patch (on which the multiple consumers
feature depend) did not break anything important, then I will submit
it.
