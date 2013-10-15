Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab3JOPih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:38:37 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:39179 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab3JOPid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Xo2UgbP+VA=s908FSusELERh8kvSVyiyMX1H1Ue8uPSg@mail.gmail.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
	<1381818232-12542-1-git-send-email-ch.naveen@samsung.com>
	<CAH9JG2Xo2UgbP+VA=s908FSusELERh8kvSVyiyMX1H1Ue8uPSg@mail.gmail.com>
Date: Tue, 15 Oct 2013 08:38:32 -0700
X-Google-Sender-Auth: z8IxqpNCI-E_nJ0H0HaV9t9DwVU
Message-ID: <CAD=FV=XsZoGUeppkxMq9DnVsp761s6ckStsmUxR4aEL3U7JZ1A@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: s3c2410: dont need CPU_FREQ transitions for
 exynos series
From: Doug Anderson <dianders@chromium.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "broonie@kernel.org" <broonie@kernel.org>, "cpgs ." <cpgs@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 14, 2013 at 11:56 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Tue, Oct 15, 2013 at 3:23 PM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
>> on a fixed 66 MHz peripheral clock, and therefore is completely
>> independent of the cpu frequency.
>> Thus, registering for a CPU freq notifier is very wasteful.
>>
>> This patch modifes the code such that, i2c bus registers to
>> cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.
>>
>> This change should save a bunch of cpufreq transitions calls
>> which does not apply to exynos SoCs.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Changes since v1:
>> Use CONFIG_CPU_FREQ_S3C24XX instead of (CONFIG_CPU_FREQ & !CONFIG_EXYNOS)
>> As commented by Tomasz
>>
>>  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks great to me.  Thank you for the suggestions Tomasz, as always.

Reviewed-by: Doug Anderson <dianders@chromium.org>

We need to come up with a solution for the CPU_FREQ stuff in
s3c2410_wdt too.  We could use a similar solution but since the
CPU_FREQ stuff in s3c2410_wdt is more than just an optimization it
means that it's not good if S3C24XX is included in a multiplatform
kernel.  (For the watchdog it's more than just an optimization since
every frequency transition actually pets the watchdog, making it
useless when you transition several times per second).

-Doug
