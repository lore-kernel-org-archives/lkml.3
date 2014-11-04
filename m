Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaKDQ1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaKDQ1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:27:35 -0500
Message-ID: <5458FE64.3090309@redhat.com>
Date: Tue, 04 Nov 2014 17:27:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mark Rustad <mark.d.rustad@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
References: <20141104155237.228431433@goodmis.org> <20141104160221.585025609@goodmis.org>
In-Reply-To: <20141104160221.585025609@goodmis.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 16:52, Steven Rostedt wrote:
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
> -- 2.1.1
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
