Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaFLHaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:30:55 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:35357 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaFLHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <539891D0.8090309@gmail.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-2-git-send-email-tushar.b@samsung.com>
	<539891D0.8090309@gmail.com>
Date: Thu, 12 Jun 2014 13:00:53 +0530
X-Google-Sender-Auth: eqDuLO97j0x2U8P--b5gAm7qROo
Message-ID: <CAC5m3BwYTSBW9WxH+f002aU1mMQH-0_WbGUiPgsabOh8C-YV+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss
 always enabled
From: Tushar Behera <tushar.b@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
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
        Kevin Hilman <khilman@linaro.org>, Doug Anderson <dianders@google.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:58 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Tushar,
>
> On 11.06.2014 07:32, Tushar Behera wrote:
>> When the output clock of AUDSS mux is disabled, we are getting kernel
>> oops while doing a clk_get() on other clocks provided by AUDSS. Though
>> user manual doesn't specify this dependency, we came across this issue
>> while disabling the parent of AUDSS mux clocks.
>
> Could you provide more data about this oops? E.g. kernel log, platforms
> it affects (just peach-pit or also others), test case, extra patches
> applied on top of mainline (if any).
>
> I don't like this solution, because keeping a clock always enabled is
> usually not desirable and this driver is also used on other platforms
> than peach-pit, so this change will affect all of them.
>

I will update later after doing similar tests on other platforms.

> Best regards,
> Tomasz
