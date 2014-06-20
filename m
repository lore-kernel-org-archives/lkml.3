Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaFTVsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:48:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44966 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaFTVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:48:05 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, standby24x7@gmail.com,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c\@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
Date: Fri, 20 Jun 2014 14:48:01 -0700
In-Reply-To: <CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	(Doug Anderson's message of "Thu, 19 Jun 2014 15:43:48 -0700")
Message-ID: <7hwqcbs166.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Doug Anderson <dianders@chromium.org> writes:

> On Thu, Jun 19, 2014 at 11:43 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> Doug Anderson <dianders@chromium.org> writes:
>>
>>> The original code for the exynos i2c controller registered for the
>>> "noirq" variants.  However during review feedback it was moved to
>>> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
>>> longer actually "noirq" (despite functions named
>>> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>>>
>>> i2c controllers that might have wakeup sources on them seem to need to
>>> resume at noirq time so that the individual drivers can actually read
>>> the i2c bus to handle their wakeup.
>>
>> I suspect usage of the noirq variants pre-dates the existence of the
>> late/early callbacks in the PM core, but based on the description above,
>> I suspect what you actually want is the late/early callbacks.
>
> I think it actually really needs noirq.  ;)

Yes, it appears it does.   Objection withdrawn.

I just wanted to be sure because since the introduction of late/early,
the need for noirq should be pretty rare, but there certainly are needs.

<tangent> 
In this case though, the need for it has more to do with the
lack of a way for us to describe non parent-child device dependencies
than whether or not IRQs are enabled or not.
</tangent>

Kevin
