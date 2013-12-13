Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3LMPu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:50:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38043 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209Ab3LMPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:50:28 -0500
Date: Fri, 13 Dec 2013 10:50:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20131213105023.67e45640@gandalf.local.home>
In-Reply-To: <20131213154104.GG19177@mudshark.cambridge.arm.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
	<1386691433-6827-7-git-send-email-liuj97@gmail.com>
	<20131213154104.GG19177@mudshark.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 15:41:04 +0000
Will Deacon <will.deacon@arm.com> wrote:

> > +#include <linux/kernel.h>
> > +#include <linux/jump_label.h>
> > +#include <asm/jump_label.h>
> > +#include <asm/insn.h>
> > +
> > +#ifdef HAVE_JUMP_LABEL
> 
> Slightly worrying... this should be CONFIG_HAVE_JUMP_LABEL, right? How did
> you manage to test this code?

In <linux/jump_label.h> we have:

#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)

[...]

# include <asm/jump_label.h>
# define HAVE_JUMP_LABEL
#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */


-- Steve
