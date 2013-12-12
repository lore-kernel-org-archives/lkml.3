Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LLUPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:15:18 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:52507 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LLUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <e24ec9c9-b250-4505-a534-4199202c9580@email.android.com>
References: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
 <e24ec9c9-b250-4505-a534-4199202c9580@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Dec 2013 12:14:53 -0800
Message-ID: <CALCETrWH9QbbHnctpBZiAPVV+CLqV4L9CbB8_T_-T7bJQAEOrg@mail.gmail.com>
Subject: Re: Clock control algorithms (Re: [RFC][PATCH 5/7] x86: Use latch
 data structure for cyc2ns)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 9:34 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> There is a huge difference between something that breaks after 2^32 and 2^64 events.  Very few computers will ever be able to have 2^64 events of any kind in their lifetime, never mind a single boot.

Given that struct seqcount contains an "unsigned" counter, the 32-bit
wraparound thing could be a problem in practice.  I hope there aren't
security vulnerabilities in which userspace overflows a kernel
refcount, seqcount, or other similar structure.

--Andy
