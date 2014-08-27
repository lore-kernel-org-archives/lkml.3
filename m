Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936AbaH0VTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:19:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34884 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaH0VTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:19:22 -0400
MIME-Version: 1.0
X-Originating-IP: [172.19.1.201]
In-Reply-To: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
Date: Wed, 27 Aug 2014 14:19:21 -0700
Message-ID: <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
From: Olof Johansson <olof@lixom.net>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 2:03 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
>
> 0d651e4e "clocksource: arch_timer: use virtual counters"
>
> and completes the implementation of memory mapped access for physical
> timers, so if a system is trying to use physical timers, it will
> function properly.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>

This should have a:

Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")

tag too, and possibly cc stable?


-Olof
