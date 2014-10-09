Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaJIVeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:34:36 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42273 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbaJIVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:34:32 -0400
Date: Thu, 9 Oct 2014 14:34:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: arm64 non-SMP build error in latest upstream kernel
Message-ID: <20141009213427.GA27232@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuration: arm64 defconfig, -SMP

Error:

In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
                 from include/linux/irq_work.h:46,
                 from include/linux/perf_event.h:49,
                 from include/linux/hw_breakpoint.h:4,
                 from arch/arm64/kernel/process.c:43:
./arch/arm64/include/asm/smp.h:24:3: error: #error "<asm/smp.h> included in non-SMP build"
 # error "<asm/smp.h> included in non-SMP build"
   ^
./arch/arm64/include/asm/smp.h:27:0: warning: "raw_smp_processor_id" redefined [enabled by default]
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 ^
In file included from include/linux/sched.h:34:0,
                 from ./arch/arm64/include/asm/compat.h:25,
                 from ./arch/arm64/include/asm/stat.h:23,
                 from include/linux/stat.h:5,
                 from include/linux/compat.h:10,
                 from arch/arm64/kernel/process.c:23:
include/linux/smp.h:129:0: note: this is the location of the previous definition
 #define raw_smp_processor_id()   0

This is just one example; the error is seen multiple times.

Let me know if you need me to bisect.

Guenter
