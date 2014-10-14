Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaJNWhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:37:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42039 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaJNWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
Date: Tue, 14 Oct 2014 16:37:51 -0600
Message-ID: <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement arch_trigger_all_cpu_backtrace
From: Daniel Drake <drake@endlessm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks a lot for working on this!

On Wed, Sep 17, 2014 at 10:10 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> Changes *before* v1:
>
> * This patchset is a hugely cut-down successor to "[PATCH v11 00/19]
>   arm: KGDB NMI/FIQ support". Thanks to Thomas Gleixner for suggesting
>   the new structure. For historic details see:
>         https://lkml.org/lkml/2014/9/2/227

What's the right way to extend your work in order to get a NMI-like
watchdog hard lockup detector similar to the one on x86?

I'm testing your patches on Exynos4412 and I guess in their current
state they don't go quite this deep, as the only callers of
trigger_all_cpu_backtrace() are sysrq, hung_task and spinlock debug
code - none of which seem as fail-safe as a trigger like a
pre-programmed watchdog NMI interrupt would be.

Do I need to find a way to get CONFIG_FIQ available on this platform
first? and/or CONFIG_HARDLOCKUP_DETECTOR?

Thanks
Daniel
