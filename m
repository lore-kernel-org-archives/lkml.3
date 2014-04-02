Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206AbaDBT6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:58:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36365 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:58:36 -0400
Subject: Re: [PATCH 0/7] uprobes/x86: introduce uprobe_xol_ops and
 arch_uprobe->ops
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140331194337.GA9257@redhat.com>
References: <20140331194337.GA9257@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Apr 2014 12:58:31 -0700
Message-ID: <1396468711.4659.63.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040219-7164-0000-0000-000000C02A57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 21:43 +0200, Oleg Nesterov wrote:
> Hello.
> 
> x86 can not handle the rip-relative jmp/call instrsuctions, the probed
> task can be killed by general protection fault. I'll describe this in
> more details when I send the fixes. Now I am sending the preparations
> which (I hope) make sense anyway, please review.
> 
> My main concern is 3/7. I know absolutely nothing about instruction
> decoding, so I can only guess what, for example, OPCODE1() == 0xff or
> MODRM_REG() == 2 actually means. Please review.
> 
> Ananth, David, please ack/nack the first change, it affects powerpc/arm.
> 
> Oleg.
> 
>  arch/x86/include/asm/uprobes.h |    7 +-
>  arch/x86/kernel/uprobes.c      |  343 ++++++++++++++++++++--------------------
>  kernel/events/uprobes.c        |   23 +---
>  3 files changed, 176 insertions(+), 197 deletions(-)
> 

I've reviewed all 7 patches.  Aside from a couple of nits (noted
elsewhere) that Oleg inherited, it looks good so far.

Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

