Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbaCEPfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:35:20 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:47493 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754794AbaCEPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:35:16 -0500
Date: Wed, 5 Mar 2014 09:35:13 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
In-Reply-To: <20140304200023.7b991909.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403050934020.7155@nuc>
References: <20140214201841.826179349@linux.com> <20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org> <alpine.DEB.2.10.1403042130250.3742@nuc> <20140304200023.7b991909.akpm@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andrew Morton wrote:

> On Tue, 4 Mar 2014 21:31:12 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:
>
> --- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
> +++ a/arch/x86/include/asm/uv/uv_hub.h
> @@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
>  };
>
>  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> -#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> +#define uv_cpu_nmi			__this_cpu_read(__uv_cpu_nmi)
>  #define uv_hub_nmi			(uv_cpu_nmi.hub)
>  #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
>  #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
>
> arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
> arch/x86/platform/uv/uv_nmi.c:218: error: lvalue required as increment operand

Uhh.. Lets drop this patch for now. This would mean more work is required.
Will submit a more extensive patch.


