Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3COQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:08:58 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:59959 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3COQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:08:56 -0400
MIME-Version: 1.0
Date: Sat, 16 Mar 2013 00:08:54 +0800
Message-ID: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
Subject: udelay function delays the wrong time interval in multiprocessor
 system, if ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer is used.
From: chpoph <chpoph@gmail.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, will.deacon@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer is
used for udelay, then __loop_delay and __loop_const_udelay is used to
delay a specific time interval.  but in delay-loop.S, loops_per_jiffy
(not per cpu data) is used to calculate the number of loops. in SMP
system, udelay delays the wrong time interval if two cpus running at
different frequency.


In arch/arm/lib/delay.c arm_delay_ops is set to arm_delay_ops.
/*
 * Default to the loop-based delay implementation.
 */
struct arm_delay_ops arm_delay_ops = {
        .delay          = __loop_delay,
        .const_udelay   = __loop_const_udelay,
        .udelay         = __loop_udelay,
};
