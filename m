Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaL2KDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:03:44 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47126 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaL2KDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:03:40 -0500
Date: Mon, 29 Dec 2014 11:03:24 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com (supporter:S390),
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>,
        Scott Wood <scottwood@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Daniel Walter <dwalter@google.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list),
        linux-s390@vger.kernel.org (open list:S390)
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
Message-ID: <20141229110324.50f1339b@mschwide>
In-Reply-To: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122910-0041-0000-0000-000002A3B14E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2014 12:17:43 -0500
Pranith Kumar <bobby.prani@gmail.com> wrote:

> @@ -65,10 +65,13 @@
>  #include <asm/kexec.h>
>  #include <asm/mmu_context.h>
>  #include <asm/code-patching.h>
> -#include <asm/kvm_ppc.h>
>  #include <asm/hugetlb.h>
>  #include <asm/epapr_hcalls.h>
> 
> +#if IS_ENABLED(CONFIG_KVM)
> +#include <asm/kvm_ppc.h>
> +#endif
> +
>  #ifdef DEBUG
>  #define DBG(fmt...) udbg_printf(fmt)
>  #else

I always cringe when I see an include protected by an #ifdef.
Is this really necessary? All that is done in asm-offsets.c is
to calculate offsets, the code where the two offsets in question
are used (entry64.S) does have the #ifdef for CONFIG_KVM.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

