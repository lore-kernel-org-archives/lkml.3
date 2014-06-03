Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbaFCPh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:37:28 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52145 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaFCPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:37:27 -0400
Date: Tue, 3 Jun 2014 17:37:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/4] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20140603153721.GD23860@localhost.localdomain>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-2-git-send-email-fweisbec@gmail.com>
 <20140530133332.GC25555@localhost.localdomain>
 <538936AB.9000005@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538936AB.9000005@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:55:55PM -0500, Suravee Suthikulpanit wrote:
> 
> 
> On 05/30/2014 08:33 AM, Frederic Weisbecker wrote:
> >>diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> >>>index 4b528a9..145b009 100644
> >>>--- a/arch/x86/include/asm/debugreg.h
> >>>+++ b/arch/x86/include/asm/debugreg.h
> >>>@@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
> >>>  static inline void debug_stack_usage_dec(void) { }
> >>>  #endif /* X86_64 */
> >>>
> >>>+#ifdef CONFIG_CPU_SUP_AMD
> >>>+extern void set_dr_addr_mask(unsigned long mask, int dr);
> >>>+#else
> >>>+static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
> >>>+#endif
> >I see this symbol in the code but it's not defined anywhere in a Kconfig file.
> >Maybe you (or I) forgot to include a file in your patches?
> >
> >Thanks.
> 
> If you are referring to the CONFIG_CPU_SUP_AMD, this is in
> arch/x86/Kconfig.cpu

Ah I thought it was created in the patchset. Nevermind.
