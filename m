Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaCEDbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:31:16 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:34255
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbaCEDbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:31:15 -0500
Date: Tue, 4 Mar 2014 21:31:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
In-Reply-To: <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403042130250.3742@nuc>
References: <20140214201841.826179349@linux.com> <20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andrew Morton wrote:

> >
> > ...
> >
> > --- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > +++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > @@ -618,7 +618,7 @@
> >  };
> >
> >  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> > -#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
> > +#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
>
> arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
> arch/x86/platform/uv/uv_nmi.c:218: error: '_uv_cpu_nmi' undeclared (first use in this function)
> arch/x86/platform/uv/uv_nmi.c:218: error: (Each undeclared identifier is reported only once
> arch/x86/platform/uv/uv_nmi.c:218: error: for each function it appears in.)
>
>
> This?

Nope. I missed an underscore.


> --- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
> +++ a/arch/x86/include/asm/uv/uv_hub.h
> @@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
>  };
>
>  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> -#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> +#define uv_cpu_nmi			(*this_cpu_ptr(&__uv_cpu_nmi))

__this_cpu_read(__uv_cpu_nmi)
