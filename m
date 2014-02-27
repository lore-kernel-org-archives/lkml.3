Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaB0BCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:02:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62848 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaB0BCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:02:42 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86: Inline the CLOCK_MONOTONIC vdso code
Date: Wed, 26 Feb 2014 17:02:14 -0800
Message-Id: <b246b5b365bc6f4fa91b381f7af56f3696ad3bb0.1393462777.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1393462777.git.luto@amacapital.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393462777.git.luto@amacapital.net>
In-Reply-To: <cover.1393462777.git.luto@amacapital.net>
References: <cover.1393462777.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves a nanosecond or so on my box.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vclock_gettime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 260a422..9234c83 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -263,7 +263,7 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	return mode;
 }
 
-notrace static int do_monotonic(struct timespec *ts)
+notrace static int __always_inline do_monotonic(struct timespec *ts)
 {
 	unsigned long seq;
 	u64 ns;
-- 
1.8.5.3

