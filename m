Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaFLQsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:48:10 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaFLQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:48:07 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e1-5399d9c30e43
Message-id: <5399D9B4.5030901@samsung.com>
Date: Thu, 12 Jun 2014 18:47:48 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Drake <drake@endlessm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Handle non-secure L2C initialization on Exynos4
References: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
 <20140612162014.GA3705@n2100.arm.linux.org.uk>
In-reply-to: <20140612162014.GA3705@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xy7qHb84MNriwwcDi0fzHzBb90zpY
	LXoXXGWz2N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWty/zWrzuW8NssWrXH0aL/Ve8HHg8
	Wpp72Dy+fZ3E4nG5r5fJY9H3LI+ds+6ye9y5tofNY/OSeo++LasYPe5ef8nkcfzGdiaPz5vk
	ArijuGxSUnMyy1KL9O0SuDL+dxxkK/jJXzFn8T/mBsabPF2MnBwSAiYSTyaeZoGwxSQu3FvP
	1sXIxSEksJRRounhBRYI5zOjxMOuFmaQKl4BLYmWNSsYQWwWAVWJhUvmsIPYbAJqEp8bHrGB
	2PxANWuargM1c3CICkRIPL4gBNEqKPFj8j2wZSICURIfZn4Gm88s8I5J4svkXrCEsICHxNfv
	R1ghFjczSuxc/RZsMaeAtcTbXb/AbGYBHYn9rdPYIGx5ic1r3jJPYBSchWTJLCRls5CULWBk
	XsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREmdfdjAuPmZ1iFGAg1GJh1fj9YxgIdbEsuLK
	3EOMEhzMSiK8j87ODBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAGLzqUI/6tznxJ9rXPz17/4/F
	5hdNslzL2zZ+OpfF+qo7Vf6s/7vkdcdMPY2PvwlIW/zCJF1o8Yf/cxer3JGzdLy7/6i3w41G
	VqYi/pL7J/5+njr14tpJ63bI9Z3ofr45qEth+2WD1yzXn/qst9m55TFbRphPy+XySY3ei02c
	fgfHWoXfWaVbc0aJpTgj0VCLuag4EQBTg17lkQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 12.06.2014 18:20, Russell King - ARM Linux wrote:
> On Thu, Jun 12, 2014 at 02:38:49PM +0100, Daniel Drake wrote:
>> From 2e67231f10ed0b05c2bacfdd05774fe21315d6da Mon Sep 17 00:00:00 2001
>> From: Gu1 <gu1@aeroxteam.fr>
>> Date: Mon, 21 Jan 2013 04:13:56 +0100
>> Subject: [PATCH] ARM: EXYNOS: Add secure firmware support for l2x0 init
>>
>> Conflicts:
>> 	arch/arm/mm/cache-l2x0.c
> 
> For this patch... it's a big NAK because it's taking us right back down
> the route of a totally fucked up cache-l2x0.c driver.

This is just an old, internal patch that was not going to be upstreamed.
I just posted another series yesterday[1], hopefully doing it the right
way. Looking forward for review comments.

[1] http://thread.gmane.org/gmane.linux.kernel/1722989

> 
> Why can't you people write stuff properly?  There's already another set
> of patches on this mailing list which want to pass the virtual base
> address of the l2x0 controller to l2c_write_sec() so that various
> registers can be read back, because the platform's secure API can
> only update several registers at the same time.

Probably the series you mention is [1]? :)

> 
> This is the same pattern that is revealed in this patch.  So, what
> this means is that the l2c_write_sec API is wrong.  We need to come
> up with a *replacement* API which allows the platforms to do this
> kind of setup in a *clean* way, and stop creating rotten hacks like
> this which just makes long term maintanence a nightmare.
> 
> So... please start doing stuff properly.  If you don't, you're going
> to be getting more flames from me, especially if you start doing this
> kind of hackery on code that I've been cleaning up to get rid of such
> crap.
> 

Yes, I fully agree. Fortunately that was not supposed to hit upstream.

You've done a lot of great work to refactor this driver (thanks!), which
made it possible to support Exynos secure firmware in a sane way and
this is how it should be done.

Best regards,
Tomasz
