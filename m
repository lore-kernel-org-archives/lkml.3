Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaFXW7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:59:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56919 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFXW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5m3Bwj1HEWSQd7rx6Zn5vbUPKFqeT_X0PL3mAxRw0FNkK=QQ@mail.gmail.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-2-git-send-email-tushar.b@samsung.com>
	<7ha99jjspt.fsf@paris.lan>
	<CAC5m3Bwj1HEWSQd7rx6Zn5vbUPKFqeT_X0PL3mAxRw0FNkK=QQ@mail.gmail.com>
Date: Tue, 24 Jun 2014 15:59:17 -0700
Message-ID: <CAD=FV=VP4-+B6oV8Skb3rxxPRbOWmzu=6PJbWbxCU=86ZvRuYQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss
 always enabled
From: Doug Anderson <dianders@google.com>
To: Tushar Behera <tushar.b@samsung.com>
Cc: Kevin Hilman <khilman@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        ML Devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ML Arch-Arm <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar,

On Thu, Jun 12, 2014 at 12:40 AM, Tushar Behera <tushar.b@samsung.com> wrote:
> On Wed, Jun 11, 2014 at 10:20 PM, Kevin Hilman <khilman@linaro.org> wrote:
>> Tushar Behera <tushar.b@samsung.com> writes:
>>
>>> When the output clock of AUDSS mux is disabled, we are getting kernel
>>> oops while doing a clk_get() on other clocks provided by AUDSS.
>>>
>>> Though user manual doesn't specify this dependency, we came across
>>> this issue while disabling the parent of AUDSS mux clocks.
>>>
>>> Keeping the parents of AUDSS mux always enabled fixes this issue.
>>
>> While this patch works (and fixes the boot problem for me), it seems
>> like it's papering over the real problem.
>>
>
> Thanks for testing.
>
>> Seems like the right fix is actually modelling the clocks properly so
>> that enabling a child clock ensures that the parent is also enabled.
>>
>
> Patch 2/3 was to ensure we have proper clock tree defined for
> Exynos5420. While testing with audio disabled, that patch alone fixed
> the issue. But when audio was enabled (and hence I2S0 was trying to
> access the clocks), we got some kernel oops during late booting, hence
> I came up this solution.
>
> The solution might be a little half-baked because of the urgency to
> push the fix, but will try to dig more into the issue on Monday when I
> resume office.

Which Monday were you referring to?  ;)

...but in all seriousness do you have an official status update on
this patch?  It seems as if it's not needed and all you need is
<https://patchwork.kernel.org/patch/4333581/>, but it would be nice to
get an official confirmation.

Thanks!

-Doug
