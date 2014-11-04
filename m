Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaKDTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:09:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:26312 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751188AbaKDTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:09:57 -0500
Date: Tue, 4 Nov 2014 14:09:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Message-ID: <20141104140954.3a31ebe3@gandalf.local.home>
In-Reply-To: <C664BE5A-1B30-454F-B7B8-DE4D5F5DF4B8@intel.com>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.585025609@goodmis.org>
	<C664BE5A-1B30-454F-B7B8-DE4D5F5DF4B8@intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 17:17:08 +0000
"Rustad, Mark D" <mark.d.rustad@intel.com> wrote:

> On Nov 4, 2014, at 7:52 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > To allow for the restructiong of the trace_seq code, we need users
> > of it to use the helper functions instead of accessing the internals
> > of the trace_seq structure itself.
> > 
> > Cc: Mark Rustad <mark.d.rustad@intel.com>
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> > arch/x86/kvm/mmutrace.h | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> > index 5aaf35641768..ce463a9cc8fb 100644
> > --- a/arch/x86/kvm/mmutrace.h
> > +++ b/arch/x86/kvm/mmutrace.h
> > @@ -22,7 +22,7 @@
> > 	__entry->unsync = sp->unsync;
> > 
> > #define KVM_MMU_PAGE_PRINTK() ({				        \
> > -	const u32 saved_len = p->len;					\
> > +	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
> 
> I think the above should not be a const char *, because the location pointed to is surely being changed. It should either be a char * or a char * const.

Ah right. It should be 'char * const'.

Thanks, I'll update it.

-- Steve

> 
> > 	static const char *access_str[] = {			        \
> > 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
> > 	};							        \
> > @@ -41,7 +41,7 @@
> > 			 role.nxe ? "" : "!",				\
> > 			 __entry->root_count,				\
> > 			 __entry->unsync ? "unsync" : "sync", 0);	\
> > -	p->buffer + saved_len;						\
> > +	saved_ptr;							\
> > 		})
> > 
> > #define kvm_mmu_trace_pferr_flags       \
> > -- 
> > 2.1.1
> 

