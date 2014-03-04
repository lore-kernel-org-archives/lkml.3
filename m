Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaCDXsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:48:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaCDXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:48:01 -0500
Date: Tue, 4 Mar 2014 15:47:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
Message-Id: <20140304154759.9d64cecc5186dc4eda31080c@linux-foundation.org>
In-Reply-To: <20140304184210.11a0b157@gandalf.local.home>
References: <20140214201841.826179349@linux.com>
	<20140214201907.228035121@linux.com>
	<20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
	<20140304184210.11a0b157@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 18:42:10 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> > --- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
> > +++ a/arch/x86/include/asm/uv/uv_hub.h
> > @@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
> >  };
> >  
> >  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> > -#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> > +#define uv_cpu_nmi			(*this_cpu_ptr(&__uv_cpu_nmi))
> 
> Looks like an extra "_" was added.

yes, there were two mistakes in that line.
