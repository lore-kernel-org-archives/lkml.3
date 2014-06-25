Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaFYXVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:21:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35469 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaFYXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:21:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Doug Anderson <dianders@google.com>
Cc: Tushar Behera <tushar.b@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kukjin Kim <kgene.kim@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Tushar Behera <trblinux@gmail.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-3-git-send-email-tushar.b@samsung.com>
	<CAD=FV=W5yh58fYTwRZxmZt=BORcZMSRV0oRe12yA74Q5h2S4YQ@mail.gmail.com>
Date: Wed, 25 Jun 2014 16:21:39 -0700
In-Reply-To: <CAD=FV=W5yh58fYTwRZxmZt=BORcZMSRV0oRe12yA74Q5h2S4YQ@mail.gmail.com>
	(Doug Anderson's message of "Tue, 24 Jun 2014 16:00:38 -0700")
Message-ID: <7hpphwlgn0.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@google.com> writes:

> Tushar,
>
> On Tue, Jun 10, 2014 at 10:32 PM, Tushar Behera <tushar.b@samsung.com> wrote:
>> Currently CLK_FOUT_EPLL was set as one of the parents of AUDSS mux.
>> As per the user manual, it should be CLK_MAU_EPLL.
>>
>> The problem surfaced when the bootloader in Peach-pit board set
>> the EPLL clock as the parent of AUDSS mux. While booting the kernel,
>> we used to get a system hang during late boot if CLK_MAU_EPLL was
>> disabled.
>>
>> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reported-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  arch/arm/boot/dts/exynos5420.dtsi |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I've tested this myself now as well.
>
> Tested-by: Doug Anderson <dianders@chromium.org>

For me, this patch alone (on top of -next) doesn't solve the boot hang.
I still need clk_ignore_unused for a successful boot.

So, this patch might be correct, but it doesn't prevent a boot hang
using a chain-loaded nv_uboot on peach-pi.  There's still another clock
being disabled that causes a hang.

Kevin
