Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaDGL6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:58:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51536 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:58:47 -0400
MIME-Version: 1.0
Date: Mon, 7 Apr 2014 17:28:46 +0530
Message-ID: <CAKohpo=6RGy1vVZ58N6yH-sfUFPs3afZLj88MtuarYCFJ=Y0PQ@mail.gmail.com>
Subject: [Query] tick-oneshot: Why do we need to disable interrupts for
 reading tick_cpu_device.mode
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I found this piece of code in tick-oneshot.c:

+int tick_oneshot_mode_active(void)
+{
+       unsigned long flags;
+       int ret;
+
+       local_irq_save(flags);
+       ret = __get_cpu_var(tick_cpu_device).mode == TICKDEV_MODE_ONESHOT;
+       local_irq_restore(flags);
+
+       return ret;
+}

Why do we need local_irq_save/restore() here for just reading value
of this variable? Can these be dropped? If yes, I would do that as
part of my cleanup series around tick stuff.

--
viresh
