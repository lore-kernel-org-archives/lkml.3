Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaBLFvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:51:38 -0500
Received: from mail.efficios.com ([78.47.125.74]:58875 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaBLFvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:51:36 -0500
Date: Wed, 12 Feb 2014 05:51:33 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <269616647.23590.1392184293963.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140211234534.6bc34e57@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: xi92SaVbCeiZEOEHWjNZsCODJIgQlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Ingo Molnar" <mingo@kernel.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, "Ingo Molnar"
> <mingo@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>, "Rusty Russell" <rusty@rustcorp.com.au>, "David Howells"
> <dhowells@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Tuesday, February 11, 2014 11:45:34 PM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> On Tue, 11 Feb 2014 08:27:38 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > Users have reported being unable to trace non-signed modules loaded
> > > within a kernel supporting module signature.
> > 
> > External modules should strive to get out of the 'crap' and
> > 'felony law breaker' categories and we should not make it
> > easier for them to linger in a broken state.
> > 
> > Nacked-by: Ingo Molnar <mingo@kernel.org>
> 
> I'm not sure how great this idea is, but it isn't the same as the
> "crap" and "fenony law breaker" categories. Having a non-signed module
> doesn't mean that it isn't fully GPL compliant, it just means that it
> hasn't been signed. There's several things that can taint the kernel
> when loading a module. Being non GPL compliant is just one of them, and
> that will never be allowed to accept tracepoints.
> 
> Forcing a module that was built for a different kernel version gives us
> another taint, which we don't add tracepoints for, not because it is
> not compliant, but because that could corrupt the kernel as we can
> not guarantee the binary structure layout of those modules would be the
> same as what the kernel was built with. We don't want people
> complaining about tracepoint failures due to forcing an older module
> into a newer kernel with different tracepoint structures.
> 
> But if the kernel expects to have signed modules, and you force a
> module to be loaded that is not signed, then you still get that
> "forced" module taint, which is the same one as loading a module from
> an older kernel into a newer kernel. It's a different problem, and I
> can see having a different taint flag be more informative to kernel
> developers in general. I would welcome that change with or without
> letting tracepoints be set for that module.
> 
> But I have to ask Mathieu, what exactly is the use case here? If you
> have a kernel that expects to only load signed modules, why would you
> want to force non signed ones? That basically breaks the whole purpose
> of signing modules. Once you allow a non signed module to be loaded
> then the kernel can be considered compromised. That is, you just gave
> kernel access to an untrusted source.

The use-case is with a kernel that has this config:

CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set

which is the case for at least Ubuntu kernels (that I know of). It allows
users to specify the kernel boot argument "module.sig_enforce" if they care
about refusing unsigned modules.

The use-case targeted here is loading GPL compliant out-of-tree modules
with those kernels, obviously not using the kernel boot argument
"module.sig_enforce". Tracepoints contained within those modules are
silently skipped due to the TAINT_FORCED_MODULE flag.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
