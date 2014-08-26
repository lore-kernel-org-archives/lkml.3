Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaHZNys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:54:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:18068 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758172AbaHZNyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:54:47 -0400
Date: Tue, 26 Aug 2014 09:54:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Davis <jim.epost@gmail.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH] KVM: Only export kvm_ple_window for x86_64
Message-ID: <20140826095444.5f2b2423@gandalf.local.home>
In-Reply-To: <53FC6A15.5090209@redhat.com>
References: <20140825191035.59673878@gandalf.local.home>
	<53FC6A15.5090209@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 13:05:57 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 26/08/2014 01:10, Steven Rostedt ha scritto:
> > Commit 7b46268d2954 "KVM: trace kvm_ple_window grow/shrink"
> > Added the tracepoint kvm_ple_window under a #ifdef CONFIG_X86_64 but
> > left the export for that tracepoint unprotected, which would cause it
> > to fail to compile when X86_32 is set.
> > 
> > Link: http://lkml.kernel.org/p/20140825172204.769ab4e6@gandalf.local.home
> > 
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > tested-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> The current KVM branch should have fixed this already---it leaves the
> tracepoint outside CONFIG_X86_64, which was the right thing to do in the
> first place.
> 

Fair enough. I was wondering why this was unique to x86_64.

-- Steve
