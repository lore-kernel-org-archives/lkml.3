Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3DXSlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:41:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41398 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3DXSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 20:41:10 +0200
Message-ID: <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com>
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

FWIW, in the light of the original change, I've just removed the
/dev/rtc creation from the default udev rules now, so that thing will
be phased out in the future.

Thanks,
Kay
