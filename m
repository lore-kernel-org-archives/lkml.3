Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaHUL5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbaHUL47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:56:59 -0400
Date: Thu, 21 Aug 2014 13:56:38 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 5/6] KVM: trace kvm_ple_window
Message-ID: <20140821115637.GE20546@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-6-git-send-email-rkrcmar@redhat.com>
 <53F5ADE6.30106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5ADE6.30106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 10:29+0200, Paolo Bonzini:
> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> > Tracepoint for dynamic PLE window, fired on every potential change.
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h | 25 +++++++++++++++++++++++++
> >  arch/x86/kvm/vmx.c   |  8 +++++---
> >  arch/x86/kvm/x86.c   |  1 +
> >  3 files changed, 31 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index e850a7d..4b8e6cb 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -848,6 +848,31 @@ TRACE_EVENT(kvm_track_tsc,
> >  		  __print_symbolic(__entry->host_clock, host_clocks))
> >  );
> >  
> > +TRACE_EVENT(kvm_ple_window,
> > +	TP_PROTO(int grow, unsigned int vcpu_id, int new, int old),
> 
> s/int grow/bool grow/ (and similarly in TP_STRUCT__entry).

Ok.
(We are using 'int' for this in other tracepoints, so I guessed there is
 some hate agains bool.)

> > +	TP_ARGS(grow, vcpu_id, new, old),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(                 int,      grow         )
> > +		__field(        unsigned int,   vcpu_id         )
> > +		__field(                 int,       new         )
> > +		__field(                 int,       old         )
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->grow           = grow;
> > +		__entry->vcpu_id        = vcpu_id;
> > +		__entry->new            = new;
> > +		__entry->old            = old;
> > +	),
> > +
> > +	TP_printk("vcpu %u: ple_window %d %s %d",
> > +	          __entry->vcpu_id,
> > +	          __entry->new,
> > +	          __entry->grow ? "<+" : "<-",
> 
> ? "grow" : "shrink"

Can't say I haven't expected comment about that :)
