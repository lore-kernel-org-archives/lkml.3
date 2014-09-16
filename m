Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaIPPUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:20:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35846 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaIPPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:20:03 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <CAD8Lp47M8jHLrQAdYUn6NZn2Ety_02E6HPzPDUX3uGLVqf1riw@mail.gmail.com>
References: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
	<1409216559-22402-5-git-send-email-cw00.choi@samsung.com>
	<CABxcv=ku9fjFfzyXZEnCGpTrWQ0pN+5mLWay90jXBhkFeWb7sg@mail.gmail.com>
	<CAD8Lp47M8jHLrQAdYUn6NZn2Ety_02E6HPzPDUX3uGLVqf1riw@mail.gmail.com>
Date: Tue, 16 Sep 2014 17:20:01 +0200
Message-ID: <CABxcv==CBbaY_GVgmWe5QzJdhMipyx5TpZ4_3oKLzkyiGPOBrw@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] rtc: s3c: Add support for RTC of Exynos3250 SoC
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Daniel Drake <drake@endlessm.com>,
        Douglas Anderson <dianders@chromium.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, rtc-linux@googlegroups.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Tue, Sep 16, 2014 at 5:03 PM, Daniel Drake <drake@endlessm.com> wrote:
> On Tue, Sep 16, 2014 at 7:48 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>>> Clock list for s3c-rtc device:
>>> - rtc : CLK_RTC of CLK_GATE_IP_PERIR is gate clock for RTC.
>>> - rtc_src : XrtcXTI is 32.768.kHz source clock for RTC.
>>
>> Is this RTC source clock needed for all Exynos SoCs?
>
> It is at least needed on Exynos4412, which has the XrtcXTI thing
> exactly as you describe. However the very standard setup there is to
> hook it up to the CP clock output of the MAX76686 PMIC. This CP clock
> is on by default, so you can potentially live without that detail
> being present in the DT.
>

Thanks for confirming for Exynos4412, I just answered my own email
saying that I found to be needed on Exynos5420 as well and as you
said, it was just working because the Maxim clocks were left on by
default.

> However... one small issue with this setup is that when you enable
> CONFIG_COMMON_CLK_MAX77686, the CP clock gets exposed in Linux's
> common clock framework, and Linux then turns it off because it
> believes it is unused. Then the RTC stops ticking.
>

Indeed, this is an issue about relying on default state. We had a
quite long discussion a couple of weeks ago about simplefb relying on
clocks and regulators left enabled by the bootloader but once these
were know to the kernel, the frameworks disable them because were
unused making simplefb to fail.

> So the rtc_src idea would also be good for Exynos4412. Maybe it would
> make sense to drop the needs_src_clk flag, and simply require/enable
> the src clock whenever it is present in the DT.
>

That sounds more sensible to me as well. I wonder what should happen
in this case with DT backward compatibility though. But as you said,
the external clock is required and the kernel will disable this clock
once is know to the CCF since is not used so maybe will be hard to
maintain DT backward compatibility in this case.

> Also, are you sure about the way you are treating this clock, all
> those enable/disable calls? You only seem to enable it when doing some
> particular driver operations e.g. reading the time, leaving it
> disabled at all other times. However I believe on Exynos4412 that if
> you disable this clock then the RTC will not tick.
>
> Daniel

Best regards,
Javier
