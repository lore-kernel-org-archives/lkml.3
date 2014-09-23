Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaIWMD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:03:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53321 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaIWMD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:03:26 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 2/3] power: gpio-charger: add device tree support
Date: Tue, 23 Sep 2014 14:03:17 +0200
Message-ID: <1549304.qklrgkYl3q@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=W6q7wMDWWDkwdC_KF4EHJt2q8afxSGCpPEC+Nk2Jp2Ag@mail.gmail.com>
References: <1411329923-15912-1-git-send-email-heiko@sntech.de> <1411329923-15912-3-git-send-email-heiko@sntech.de> <CAD=FV=W6q7wMDWWDkwdC_KF4EHJt2q8afxSGCpPEC+Nk2Jp2Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. September 2014, 09:48:33 schrieb Doug Anderson:
> > @@ -196,6 +255,7 @@ static struct platform_driver gpio_charger_driver = {
> > 
> >                 .name = "gpio-charger",
> >                 .owner = THIS_MODULE,
> >                 .pm = &gpio_charger_pm_ops,
> > 
> > +               .of_match_table = of_match_ptr(gpio_charger_match),
> 
> Given that you don't have any #ifdefs with "CONFIG_OF", I think
> gpio_charger_match will always exist.  It seems like you should remove
> the of_match_ptr or add some #ifdefs.  I can't quite keep up with what
> the currently suggested best practice is here, though.

I've kept the of_match_ptr in v3. The dt parsing functions (of_read_foo,...) 
define stubs for the !CONFIG_OF case which we use here in this case and 
of_match_ptr is also defined differently for both OF and !OF, so it feels like 
it should be there ;-)


Heiko
