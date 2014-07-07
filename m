Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaGGSoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:44:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55931 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaGGSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbUAnSFAJMM4hewTA7+KsvZ5T_X5mmjzoFtJ9wAZYix2w@mail.gmail.com>
References: <1403782279-10116-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACRpkdbUAnSFAJMM4hewTA7+KsvZ5T_X5mmjzoFtJ9wAZYix2w@mail.gmail.com>
Date: Mon, 7 Jul 2014 20:44:41 +0200
Message-ID: <CAFo99gYPkd7n=dtMrzJ_be0VbzqNYhbYgtYRV0TcUNKJ=7yM1w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-msm.c: Cleaning up if unsigned is less
 than zero
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-07 17:40 GMT+02:00 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Jun 26, 2014 at 1:31 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> Remove checking if a unsigned is less than zero
>>
>> This was found using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> (...)
>> -       if (WARN_ON(g->mux_bit < 0))
>> +       if (WARN_ON(g->mux_bit != 0))
>
> Is that correct?
>
> If the variable cannot be < 0 should the check not simply be
> deleted, since this is all it checks for?


Hi Linus!

Yes, it was a bit silly. Do not really know how that happened :-/

I guess I thought it was reasonable. But I should do as I have tried
to do in all other cases, the smallest possible change. And let you
check in code, if so, to capture what is missing.

New patch on the way!


Kind regards
Rickard Strandqvist
