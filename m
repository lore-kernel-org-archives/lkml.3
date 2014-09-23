Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbaIWP7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:59:47 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36581 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaIWP7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <1549304.qklrgkYl3q@phil>
References: <1411329923-15912-1-git-send-email-heiko@sntech.de>
	<1411329923-15912-3-git-send-email-heiko@sntech.de>
	<CAD=FV=W6q7wMDWWDkwdC_KF4EHJt2q8afxSGCpPEC+Nk2Jp2Ag@mail.gmail.com>
	<1549304.qklrgkYl3q@phil>
Date: Tue, 23 Sep 2014 08:59:43 -0700
X-Google-Sender-Auth: O5Ios21BdVfQQahJspOPkEn_wP0
Message-ID: <CAD=FV=Wc-V6nYTSTPJe4mtyCvGH2CpOhOY37XDFQTP97hXOi_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] power: gpio-charger: add device tree support
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Sep 23, 2014 at 5:03 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 22. September 2014, 09:48:33 schrieb Doug Anderson:
>> > @@ -196,6 +255,7 @@ static struct platform_driver gpio_charger_driver = {
>> >
>> >                 .name = "gpio-charger",
>> >                 .owner = THIS_MODULE,
>> >                 .pm = &gpio_charger_pm_ops,
>> >
>> > +               .of_match_table = of_match_ptr(gpio_charger_match),
>>
>> Given that you don't have any #ifdefs with "CONFIG_OF", I think
>> gpio_charger_match will always exist.  It seems like you should remove
>> the of_match_ptr or add some #ifdefs.  I can't quite keep up with what
>> the currently suggested best practice is here, though.
>
> I've kept the of_match_ptr in v3. The dt parsing functions (of_read_foo,...)
> define stubs for the !CONFIG_OF case which we use here in this case and
> of_match_ptr is also defined differently for both OF and !OF, so it feels like
> it should be there ;-)

...I was thinking you'd get a compile-time warning about
gpio_charger_match not being used.  ...but I can't seem to trigger it
with my compiler settings.  In any case, I'm fairly certain that in
the !CONFIG_OF case (plus non-module case) that "gpio_charger_match"
will be defined but not used in your code.

I was under the impression that of_match_ptr was defined differently
for OF and !OF so that you could use it in the case where the
structure itself (gpio_charger_match) had #ifdefs around it...
