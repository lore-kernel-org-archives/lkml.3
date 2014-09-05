Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaIEMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:21:17 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50636 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaIEMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:21:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "Chen, Alvin" <alvin.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: Re: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
Date: Fri, 05 Sep 2014 14:20:57 +0200
Message-ID: <31986364.cn091cmIXU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409918522.30155.89.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com> <4656BEB6164FC34F8171C6538F1A595B2E9829DA@SHSMSX101.ccr.corp.intel.com> <1409918522.30155.89.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DgVyCYawF6mgXVT6bqzC2L2lfx7IZ9TkpnXcC4VcbOC
 /M9/ReIy2d6G8Vg4my50PCrDQXGR0/iaOflHMLOx1AWld5LV2Z
 GRvOHoiyb0Uw2aK1D0as/YMihBNJiMzB0J+8WoLGTZHKtGKVHE
 PVr3EshOqBKfXR6v4NEAN+X4Q8XenxbLb960pe/1dr7FHw0f0w
 0oZAtExeYP4zbYWsF1Y2Qyk0/R0SHRE2+DdVqo27tkx7OoHGUk
 CNYjQgT8uleL8hstmf7+fA/Dclplcx9ag9JeDdkvuk7IWO2QGs
 e70ctJsspC4q2JevCwKk7dWePlkiSGr01pJjboRK3WMsDseuKy
 v1ntoRkI4FHwU27BF5ag=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 12:02:01 Shevchenko, Andriy wrote:
> > irq = irq_of_parse_and_map(node, 0);
> > If (!irq) {
> > pp->irq = -1;
> > return;
> > } else {
> > pp->irq = irq;
> > }
> > Then the code looks strange.
> > 
> > How do you think?
> 
> If I understood correctly you messed up with hwirq vs. virq.
> Otherwise you have mention that you are using virq everywhere (I guess
> you may rename the field in the structure), but in this case the field
> in the platform_data looks a bit strange.

The field in platform_data should be the mapped virtual irq number, it
makes no sense to use the hwirq unless you also add a pointer to the domain
in which that hwirq exists.

Also the output of irq_of_parse_and_map() is a mapped irq, as the name
suggests.

	Arnd
