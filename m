Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbaDIL66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:58:58 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57333 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDIL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:58:57 -0400
MIME-Version: 1.0
Date: Wed, 9 Apr 2014 17:28:57 +0530
Message-ID: <CAKohpon3vJzL51V9aOBcXKJC4nr3K-0q77HsxFi+=ACUqNqhcA@mail.gmail.com>
Subject: [Query]: tick-sched: can idle_active be false in tick_nohz_idle_exit()?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

File: kernel/time/tick-sched.c
function: tick_nohz_idle_exit()

We are checking here if idle_active is true or not and then
do some stuff. But is it possible that idle_active be false
here?

The sequence as far as I understood is:
idle-loop:

tick_nohz_idle_enter(), i.e. idle_active = true;
local_irq_disable()

IDLE
.
.

wake up due to IPI ??

local_irq_enable()
    tick_nohz_irq_enter(), i.e. idle_active = false;
    tick_nohz_irq_exit(), i.e. idle_active = true;

tick_nohz_idle_exit()

How can idle_active be false here?

--
viresh
