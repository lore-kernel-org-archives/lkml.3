Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3FERjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:39:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38745 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab3FERjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:39:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,808,1363132800"; 
   d="scan'208";a="29454162"
Date: Wed, 5 Jun 2013 18:30:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <marc.zyngier@arm.com>, <will.deacon@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>,
        <olof@lixom.net>, <arnd@arndb.de>, <mingo@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH v5 2/4] kernel: missing include in cputime.c
In-Reply-To: <1369920902-3546-2-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1306051828050.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com> <1369920902-3546-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter,
in cputime.c we calls functions declared in asm/paravirt.h but we
have no include asm/paravirt.h.
Are you OK with this patch that fixes the issue?



On Thu, 30 May 2013, Stefano Stabellini wrote:
> steal_account_process_tick calls paravirt_steal_clock, but paravirt.h is
> currently missing amoung the included header files.
> Add include asm/paravirt.h ifdef CONFIG_PARAVIRT.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: mingo@redhat.com
> CC: peterz@infradead.org
> 
> Changes in v5:
> - add ifdef CONFIG_PARAVIRT.
> ---
>  kernel/sched/cputime.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index cc2dc3ee..317a578 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -5,7 +5,9 @@
>  #include <linux/static_key.h>
>  #include <linux/context_tracking.h>
>  #include "sched.h"
> -
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#endif
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  
> -- 
> 1.7.2.5
> 
