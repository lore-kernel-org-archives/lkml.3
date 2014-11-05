Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaKEK2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:28:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbaKEK23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:28:29 -0500
Date: Wed, 5 Nov 2014 11:28:14 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rustad <mark.d.rustad@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Message-ID: <20141105102814.GA4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.585025609@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160221.585025609@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:38, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> To allow for the restructiong of the trace_seq code, we need users
> of it to use the helper functions instead of accessing the internals
> of the trace_seq structure itself.
> 
> Cc: Mark Rustad <mark.d.rustad@intel.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr

> ---
>  arch/x86/kvm/mmutrace.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> index 5aaf35641768..ce463a9cc8fb 100644
> --- a/arch/x86/kvm/mmutrace.h
> +++ b/arch/x86/kvm/mmutrace.h
> @@ -22,7 +22,7 @@
>  	__entry->unsync = sp->unsync;
>  
>  #define KVM_MMU_PAGE_PRINTK() ({				        \
> -	const u32 saved_len = p->len;					\
> +	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
>  	static const char *access_str[] = {			        \
>  		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
>  	};							        \
> @@ -41,7 +41,7 @@
>  			 role.nxe ? "" : "!",				\
>  			 __entry->root_count,				\
>  			 __entry->unsync ? "unsync" : "sync", 0);	\
> -	p->buffer + saved_len;						\
> +	saved_ptr;							\
>  		})
>  
>  #define kvm_mmu_trace_pferr_flags       \
> -- 
> 2.1.1
> 
> 
