Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaLRTYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:24:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLRTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:24:17 -0500
Date: Thu, 18 Dec 2014 14:23:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: mingo@redhat.com, peterz@infradead.org, jgross@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, luto@amacapital.net,
        david.vrabel@citrix.com, JBeulich@suse.com, hpa@zytor.com,
        masami.hiramatsu.pt@hitachi.com, xen-devel@lists.xenproject.org,
        tglx@linutronix.de, Borislav Petkov <bp@suse.de>, bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
Message-ID: <20141218192313.GA19507@laptop.dumpdata.com>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
 <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> index 0000000..b5a3e98
> --- /dev/null
> +++ b/drivers/xen/preempt.c
> @@ -0,0 +1,17 @@
> +/*
> + * Preemptible hypercalls
> + *
> + * Copyright (C) 2014 Citrix Systems R&D ltd.
> + *
> + * This source code is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + */
> +
> +#include <xen/xen-ops.h>
> +
> +#ifndef CONFIG_PREEMPT
> +DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
> +EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
> +#endif

Please also add this in the patch:


diff --git a/drivers/xen/preempt.c b/drivers/xen/preempt.c
index b5a3e98..5d773dc 100644
--- a/drivers/xen/preempt.c
+++ b/drivers/xen/preempt.c
@@ -13,5 +13,5 @@
 
 #ifndef CONFIG_PREEMPT
 DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
 #endif
