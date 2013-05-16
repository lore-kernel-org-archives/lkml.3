Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3EPXzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:55:31 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57799 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3EPXza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WVx4E0xLpyqwe7LhzFvw4=fOY67Kkiux7Dat8qo7V_Wg@mail.gmail.com>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
	<2099430.Q29j0K3hPy@flatron>
	<201305170030.39266.heiko@sntech.de>
	<1475116.qtX3b3bLWZ@flatron>
	<CAD=FV=WVx4E0xLpyqwe7LhzFvw4=fOY67Kkiux7Dat8qo7V_Wg@mail.gmail.com>
Date: Thu, 16 May 2013 16:55:28 -0700
X-Google-Sender-Auth: HuQaRhyqK0LOdz-eiMgaSHxFmws
Message-ID: <CAD=FV=V5LhsWWufUZ6vQwY3Om7mysjPzu-amQJeb8259OiPFzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, May 16, 2013 at 4:10 PM, Doug Anderson <dianders@chromium.org> wrote:
> If state of these registers isn't lost on those SoCs then running the
> save/restore shouldn't _hurt_ though, right?  If you can run the old
> GPIO code on one of those systems and do a suspend/resume you could
> check...

I think it's been too long of a day for me, too.

I just thought about this and realized that there is no "powerdown"
registers for the GPX banks on exynos5250.  ...and they don't lose
their state at sleep!  ...so maybe a reasonable thing to do would be
to skip save/restore in any case where there are no powerdown
registers?

You can see a printout in my case:

[  412.840000] gpx0 @ f004ac00 (con 0x30000110 => 0x30000110)
[  412.840000] gpx1 @ f004ac20 (con 0x1f10ff10 => 0x1f10ff10)
[  412.840000] gpx2 @ f004ac40 (con 0x1f000f0f => 0x1f000f0f)
[  412.840000] gpx3 @ f004ac60 (con 0x00f00f01 => 0x00f00f01)

-Doug
