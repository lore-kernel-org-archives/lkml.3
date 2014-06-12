Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaFLAIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:08:06 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47649 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaFLAID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140611234607.775273584@linutronix.de>
References: <20140611234024.103571777@linutronix.de>
	<20140611234607.775273584@linutronix.de>
Date: Wed, 11 Jun 2014 17:08:01 -0700
Message-ID: <CALAqxLUtmY3JeHeq_RXz-Sc_jjyJQv=VRUr6bXtAge1+6bEXDA@mail.gmail.com>
Subject: Re: [patch 13/13] tomoyo: Use sensible time interface
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 4:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> There is no point in calling gettimeofday if only the seconds part of
> the timespec is used. Use get_seconds() instead. It's not only the
> proper interface it's also faster.

My only caution here is you only get tick-granular time here. So if
the second rolled over after the last tick, you'd get the previous
second when you call get_seconds(). This can cause some surprising
effects if the get_seconds() return value is mixed with clocksource
granular gettimeofday() calls.

thanks
-john
