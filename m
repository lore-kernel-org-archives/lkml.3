Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaCYMG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:06:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25104 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaCYMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:06:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,728,1389744000"; 
   d="scan'208";a="113298811"
Date: Tue, 25 Mar 2014 12:06:09 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        <linux@arm.linux.org.uk>, <olof@lixom.net>, <arnd@arndb.de>,
        <catalin.marinas@arm.com>, <mingo@redhat.com>,
        <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v9 2/5] kernel: missing include in cputime.c
In-Reply-To: <1389292336-9292-2-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1403251204240.8273@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com> <1389292336-9292-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,
is this patch OK for you?

On Thu, 9 Jan 2014, Stefano Stabellini wrote:
> steal_account_process_tick calls paravirt_steal_clock, but paravirt.h is
> currently missing among the included header files.
> Add include asm/paravirt.h.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: mingo@redhat.com
> CC: peterz@infradead.org
> ---
>  kernel/sched/cputime.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 9994791..951833e 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -5,6 +5,9 @@
>  #include <linux/static_key.h>
>  #include <linux/context_tracking.h>
>  #include "sched.h"
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#endif
>  
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> -- 
> 1.7.10.4
> 
