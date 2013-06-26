Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3FZE7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:59:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54928 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3FZE7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:59:22 -0400
X-Spam-Score: -100.9
Message-ID: <51CA6D21.3090901@asianux.com>
Date: Wed, 26 Jun 2013 12:25:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: cmetcalf@tilera.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] tile: include: asm: missing "feedback.h" file.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

The compilation failed by "make ARCH=tile tilegx_defconfig", and "make
ARCH=tile CROSS_COMPILE=tile-linux-gnu-" for upstream next-20130625.

The related error:

    CC      kernel/bounds.s
  In file included from include/linux/linkage.h:7:0,
                   from include/linux/kernel.h:6,
                   from include/asm-generic/bug.h:13,
                   from arch/tile/include/generated/asm/bug.h:1,
                   from include/linux/bug.h:4,
                   from include/linux/page-flags.h:9,
                   from kernel/bounds.c:9:
  /root/linux-next/arch/tile/include/asm/linkage.h:18:22: fatal error: feedback.h: No such file or directory

We really need "feedback.h"

  arch/tile/kernel/entry.S: Assembler messages:
  arch/tile/kernel/entry.S:26: Error: Unknown opcode `feedback_enter(current_text_addr)'.
  arch/tile/kernel/entry.S:46: Error: Unknown opcode `feedback_enter(dump_stack)'.
  arch/tile/kernel/entry.S:53: Error: Unknown opcode `feedback_enter(KBacktraceIterator_init_current)'.
  arch/tile/kernel/entry.S:61: Error: Unknown opcode `feedback_enter(smp_nap)'.
  arch/tile/kernel/entry.S:76: Error: Unknown opcode `feedback_enter(_cpu_idle)'.

Welcome any suggestions and completions.


Thanks.
-- 
Chen Gang

Asianux Corporation
