Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3IGL4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 07:56:46 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46587 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3IGL4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 07:56:44 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>, devicetree@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Matt Sealey <neko@bakuhatsu.net>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 5/5] clk: dt: binding for basic gate clock
Date: Sat, 07 Sep 2013 13:56:39 +0200
Message-ID: <3912118.JkfesUOyv3@flatron>
User-Agent: KMail/4.11.1 (Linux/3.10.10-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <20130904175909.GB31541@atomide.com>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <CAD6h2NSr0cM_SWqniC30pYm0mCeziBOzVg-46-814qPMxUwDCQ@mail.gmail.com> <20130904175909.GB31541@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wednesday 04 of September 2013 10:59:09 Tony Lindgren wrote:
> * Haojian Zhuang <haojian.zhuang@linaro.org> [130903 20:11]:
> > We can see that it'll try to find static mapping. What's the static
> > mapping? If we define iotable in machine driver, we have the static
> > mapping, just like debug_ll. If we parse everything from DTS file,
> > it'll always get a new virtual address from vm area. So it always
> > create a new page mapping even for one register.
> 
> I may not follow you here.. But it seems that you've missing something
> with the static mapping: It's found based on the physical address. So
> if you create static mappings for your SoC with iotable_init(), those
> mappings will be available everywhere including drivers when you do
> ioremap().

The thing is that today we are moving in favour of fully dynamic mapping, 
based on data from device tree, with as little as possible (or even no) 
static mapping based on hardcoded values.

So, back to the original problem, we end up doing multiple dynamic 
mappings of the same physical page, because there is no refcounting in 
ioremap and, if it doesn't find a static mapping containing the region 
we're interested in, it simply creates a new mapping.

Best regards,
Tomasz

