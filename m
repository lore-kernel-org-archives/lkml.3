Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaCaUol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaCaUok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:44:40 -0400
Date: Mon, 31 Mar 2014 21:43:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes/x86: introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140331194337.GA9257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

x86 can not handle the rip-relative jmp/call instrsuctions, the probed
task can be killed by general protection fault. I'll describe this in
more details when I send the fixes. Now I am sending the preparations
which (I hope) make sense anyway, please review.

My main concern is 3/7. I know absolutely nothing about instruction
decoding, so I can only guess what, for example, OPCODE1() == 0xff or
MODRM_REG() == 2 actually means. Please review.

Ananth, David, please ack/nack the first change, it affects powerpc/arm.

Oleg.

 arch/x86/include/asm/uprobes.h |    7 +-
 arch/x86/kernel/uprobes.c      |  343 ++++++++++++++++++++--------------------
 kernel/events/uprobes.c        |   23 +---
 3 files changed, 176 insertions(+), 197 deletions(-)

