Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3ITRQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:16:50 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:46842 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3ITRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:16:49 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130920162329.GC18721@radagast>
References: <1379693332-10585-1-git-send-email-nm@ti.com>
	<CAOesGMj6G7LeYUJsGpZHxKOjiNrk+1U55QFqcQyTb6_Co+n4zQ@mail.gmail.com>
	<20130920162329.GC18721@radagast>
Date: Fri, 20 Sep 2013 10:16:48 -0700
Message-ID: <CAOesGMiru=RUHS4XKLL=DC+hxtAJqtcjgd5hPbaccnAfEZ3y0g@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: OMAP3630: Add generic machine descriptor
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 9:23 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Sep 20, 2013 at 09:19:02AM -0700, Olof Johansson wrote:
>> On Fri, Sep 20, 2013 at 9:08 AM, Nishanth Menon <nm@ti.com> wrote:
>> > An alternative approach may be to (for all SoCs):
>> > 1. define every SoC entry - ti,omap3430 ti,omap3630...
>> > 2. have a generic omap3_init which uses "if (of_machine_is_compatible("ti,omap3630"))"
>> > to invoke the appropriate omap3xxx_init_early.
>>
>> Yes, this would be better, but you can do add a DT_MACHINE as in this
>> patch but have ti,omap3630 as the dt_compat table. Then there's no
>> need to add runtime checks.
>
> I was going to reply that adding of_machine_is_compatible("ti,omap3630")
> would help in some situations, but guess it's already tainted ;-)

Oh, if it's just a few checks, then by all means go down that route. I
didn't look at the code to see how much it would be.

But if a new DT_MACHINE is added, then it should definitely be based
on ti,omap3630 instead of listing all the boards.


-Olof
