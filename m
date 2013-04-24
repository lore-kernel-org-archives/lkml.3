Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3DXTpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:45:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:33370 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3DXTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 21:44:47 +0200
Message-ID: <CAPXgP12_auNLogaK0J8yj7_Nhf=B+Anh9NVNGTM3TqT15OKRFQ@mail.gmail.com>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 8:32 PM, John Stultz <john.stultz@linaro.org> wrote:
> Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
> which enables some minor compile time optimization to avoid
> uncessary code in mostly the suspend/resume path could cause
> problems for userland.
>
> In particular, the dependency for RTC_HCTOSYS on
> !ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
> twice and simplifies suspend/resume, has the side effect
> of causing the /sys/class/rtc/rtcN/hctosys flag to always be
> zero, and this flag is commonly used by udev to setup the
> /dev/rtc symlink to /dev/rtcN, which can cause pain for
> older applications.

An alternative to reverting this could be to set that flag
unconditionally on the rtc that matches the persistent clock the
kernel uses internally?

I mean regardless of the pretty weird config option
CONFIG_RTC_HCTOSYS_DEVICE, which internally just does a strcmp() with
the given device name when the flag is queried. :)

Can't we just have the same interface and your original optimization
on x86, even without CONFIG_RTC_HCTOSYS_DEVICE enabled at all?

Kay
