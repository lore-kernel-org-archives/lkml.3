Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaKYXlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:41:39 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34856 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKYXli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:41:38 -0500
MIME-Version: 1.0
Date: Tue, 25 Nov 2014 23:41:38 +0000
Message-ID: <CACM4qewg=ZW5CkFJjYObL9LgqNiOUYzd1DmHnA5wnGXdin7wKQ@mail.gmail.com>
Subject: NO_HZ_FULL still getting jitter ~ every 33 ms
From: Konstantin Dmitriev <kon.dmitriev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recompiled the 3.16.7 kernel with the NO_HZ_FULL option enabled
and /proc/interrupts shows roughly 1 tick every 3 seconds on an
isolated core and a process affined to a core

I still see jitter though. Obtaining TSC values in a tight loop
reports 5-20 usecs latencies  approximately 30 times per second

Unfortunately ftrace does not show anything unusual - I can see
apic_timer_interrupt fires every 2.5 seconds followed by the
reschedule in approx 0.5 seconds but nothing in between

perf also does not show anything of interest apart from an unusually
high LLC miss rate

If it is of any help the jitter seems to be evenly spread over 1 sec interval

Please suggest what else to look for

Regards
Konstantin
