Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbaDIKdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:33:03 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46593 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDIKdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:33:01 -0400
MIME-Version: 1.0
Date: Wed, 9 Apr 2014 16:03:00 +0530
Message-ID: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
Subject: [Query]: tick-sched: why don't we stop tick when we are running idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

File: kernel/time/tick-sched.c
Function: tick_nohz_full_stop_tick()

We are doing this:

if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
        return;

Which means: if a FULL_NO_HZ cpu is running idle task currently,
don't stop its tick..

I couldn't understand why. Can you please help here?

--
viresh
