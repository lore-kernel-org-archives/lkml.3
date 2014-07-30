Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaG3JMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:12:21 -0400
Received: from sym2.noone.org ([178.63.92.236]:33514 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaG3JMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:12:19 -0400
Date: Wed, 30 Jul 2014 11:12:16 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 02/29] nios2: Kernel booting and initialization
Message-ID: <20140730091215.GE10301@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-3-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405413956-2772-3-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 at 10:45:29 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> This patch adds the kernel booting and the initial setup code.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/nios2/include/asm/entry.h | 152 ++++++++++++++++++++++++++++
>  arch/nios2/include/asm/setup.h |  38 +++++++
>  arch/nios2/kernel/head.S       | 175 ++++++++++++++++++++++++++++++++
>  arch/nios2/kernel/setup.c      | 222 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 587 insertions(+)
>  create mode 100644 arch/nios2/include/asm/entry.h
>  create mode 100644 arch/nios2/include/asm/setup.h
>  create mode 100644 arch/nios2/kernel/head.S
>  create mode 100644 arch/nios2/kernel/setup.c
> 
> diff --git a/arch/nios2/include/asm/entry.h b/arch/nios2/include/asm/entry.h
> new file mode 100644
> index 0000000..8b7cddd
> --- /dev/null
> +++ b/arch/nios2/include/asm/entry.h
> @@ -0,0 +1,152 @@

[...]

> +/*
> + * Stack layout in 'ret_from_exception':
> + *
> + * This allows access to the syscall arguments in registers r4-r8
> + *
> + *	 0(sp) - r8
> + *	 4(sp) - r9
> + *	 8(sp) - r10
> + *	 C(sp) - r11
> + *	10(sp) - r12
> + *	14(sp) - r13
> + *	18(sp) - r14
> + *	1C(sp) - r15
> + *	20(sp) - r1
> + *	24(sp) - r2
> + *	28(sp) - r3
> + *	2C(sp) - r4
> + *	30(sp) - r5
> + *	34(sp) - r6
> + *	38(sp) - r7
> + *	3C(sp) - orig_r2
> + *	40(sp) - ra
> + *	44(sp) - fp
> + *	48(sp) - sp
> + *	4C(sp) - gp
> + *	50(sp) - estatus
> + *	54(sp) - status_extension (NOMMU only)
> + *	58(sp) - ea
> + */

status_extension no longer exists and orig_r7 is missing in the list
above. Since this corresponds to the order of struct pt_regs anyhow,
this comment seems rather pointless to me, so you might as well want to
remove it altogether.
