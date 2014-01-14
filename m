Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaANR4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:56:20 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50588 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaANR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com>
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>
	<52D404DE.2020806@ti.com>
	<CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
	<52D55CE5.1060902@ti.com>
	<CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com>
Date: Tue, 14 Jan 2014 11:56:17 -0600
X-Google-Sender-Auth: jOgtJBVcuKPHdn5JqPRctt3Lnrs
Message-ID: <CAGo_u6oKpRFnPAWaqr9NTNAJB+m56jiDgBUgvsiZpaQ-3SF2kw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
From: Nishanth Menon <nm@ti.com>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Tero Kristo <t-kristo@ti.com>, Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:35 AM, Victor Kamensky
<victor.kamensky@linaro.org> wrote:
>
> When BE kernel is built Makefile does take of compiling code in BE
> mode. I.e all proper flags like -mbig-endian and -Wl,--be8 will be set.

Agreed, and I assume you cannot instead switch to LE mode when
entering assembly assuming LE?

The reason I ask this is - most of our development is NOT in BE mode.
we will continue to manipulate and add assembly - AM335x, DRA7/OMAP5
etc.. and obviously not every code change will indulge in ensuring
right markers will be in place.

by ensuring readl_relaxed handles the variations, you have ensured
that I dont need to care about drivers other than to ensure they use
_relaxed variants. in the case of assembly, this does not seem long
term manageable.

>
>> is the idea of BE build meant to deal with having a single BE kernel
>> build work for all platforms (including LE ones)?
>
> Sort of. The idea here to run BE image on OMAP4 chip, with
> kernel that would deals with LE periphery correctly, but ARM
> core run in BE with special kernel that compiled for BE case (i.e
> CONFIG_CPU_BIG_ENDIAN is set).

I still dont get the usecase - other than "hey, we do this coz we can
do it!".. I mean, yep, it sounds great and all.. but 4 years down the
line, is this still going to work? is this going to be interesting
careabout? or we are just maintaining additional code for a passing
fancy or proof-of-concept?

Regards,
Nishanth Menon
