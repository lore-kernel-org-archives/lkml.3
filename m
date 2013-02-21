Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3BUWPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:15:53 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59028 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3BUWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:15:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130221215850.GC17833@n2100.arm.linux.org.uk>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-3-git-send-email-khilman@linaro.org>
	<87y5ehmp8d.fsf@linaro.org>
	<CAFTL4hw1=mKtUadL0WDrydtspOehKuW7jhhzr65vXR2P2zdTWw@mail.gmail.com>
	<20130221215850.GC17833@n2100.arm.linux.org.uk>
Date: Thu, 21 Feb 2013 23:15:50 +0100
Message-ID: <CAFTL4hzJ8YXfCaHBaHZ5X8jRJA+zaC0FEaP-=-+5b=SrpXPLiw@mail.gmail.com>
Subject: Re: [RFC/PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Feb 21, 2013 at 10:53:07PM +0100, Frederic Weisbecker wrote:
>> That too should be kcpustat_this_cpu_set(), or kcpustat_this_cpu_add()
>> FWIW. But we probably don't need the overhead of atomic_add() that
>> does a LOCK.
>> atomic_set(var, atomic_read(var) + delta) would be better. All we need
>
> You mean atomic64_set() and atomic64_read().

Right.

> Looking at the generic
> version in lib/atomic64.c, atomic64_add() is cheaper for 32-bit arches
> because it doesn't involve taking the lock twice.

Yeah but that's the generic version. I guess the archs that have
overriden don't take any locks there.
