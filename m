Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaBZUN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:13:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:4586 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753424AbaBZUNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:13:25 -0500
Date: Wed, 26 Feb 2014 15:13:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140226151322.5632c6d3@gandalf.local.home>
In-Reply-To: <8738j64m9n.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
	<20140224105454.3e1981ba@gandalf.local.home>
	<193756443.29489.1393260936319.JavaMail.zimbra@efficios.com>
	<20140224123926.0a44f32e@gandalf.local.home>
	<8738j64m9n.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 13:23:56 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:


> > The one that I replied to. I can't pull the module patch unless I get
> > an ack from Rusty.
> 
> Ah, I applied it in my tree.  Happy for you to take it though; here's
> the variant with an Acked-by from me instead of Signed-off-by if you
> want it:
> 
> ===
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Subject: Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> Users have reported being unable to trace non-signed modules loaded
> within a kernel supporting module signature.
> 
> This is caused by tracepoint.c:tracepoint_module_coming() refusing to
> take into account tracepoints sitting within force-loaded modules
> (TAINT_FORCED_MODULE). The reason for this check, in the first place, is
> that a force-loaded module may have a struct module incompatible with
> the layout expected by the kernel, and can thus cause a kernel crash
> upon forced load of that module on a kernel with CONFIG_TRACEPOINTS=y.
> 
> Tracepoints, however, specifically accept TAINT_OOT_MODULE and
> TAINT_CRAP, since those modules do not lead to the "very likely system
> crash" issue cited above for force-loaded modules.
> 
> With kernels having CONFIG_MODULE_SIG=y (signed modules), a non-signed
> module is tainted re-using the TAINT_FORCED_MODULE taint flag.
> Unfortunately, this means that Tracepoints treat that module as a
> force-loaded module, and thus silently refuse to consider any tracepoint
> within this module.
> 
> Since an unsigned module does not fit within the "very likely system
> crash" category of tainting, add a new TAINT_UNSIGNED_MODULE taint flag
> to specifically address this taint behavior, and accept those modules
> within Tracepoints. This flag is assigned to the letter 'N', since all
> the more obvious ones (e.g. 'S') were already taken.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Nacked-by: Ingo Molnar <mingo@kernel.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: David Howells <dhowells@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

There's another version of this as Mathieu pointed out. You can take
it. I hate to be the committer of a patch with Ingo's Nack ;-)

-- Steve
