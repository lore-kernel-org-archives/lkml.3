Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaBMPlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:41:36 -0500
Received: from mail.efficios.com ([78.47.125.74]:37375 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaBMPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:41:34 -0500
Date: Thu, 13 Feb 2014 15:41:30 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140213102817.4bfd5eac@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home> <1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com> <20140213102817.4bfd5eac@gandalf.local.home>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: A/Iy03Jehg5p4/0GKNhoLFAH6Z75mg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Ingo Molnar" <mingo@kernel.org>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas
> Gleixner" <tglx@linutronix.de>, "Rusty Russell" <rusty@rustcorp.com.au>, "David Howells" <dhowells@redhat.com>,
> "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Thursday, February 13, 2014 10:28:17 AM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> On Thu, 13 Feb 2014 15:10:14 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > ----- Original Message -----
> > > From: "Steven Rostedt" <rostedt@goodmis.org>
> > > To: "Ingo Molnar" <mingo@kernel.org>
> > > Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
> > > linux-kernel@vger.kernel.org, "Ingo Molnar"
> > > <mingo@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>, "Rusty
> > > Russell" <rusty@rustcorp.com.au>, "David Howells"
> > > <dhowells@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > > Sent: Tuesday, February 11, 2014 11:45:34 PM
> > > Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
> > > TAINT_UNSIGNED_MODULE
> > > 
> > > 
> > [...]
> > > But if the kernel expects to have signed modules, and you force a
> > > module to be loaded that is not signed, then you still get that
> > > "forced" module taint, which is the same one as loading a module from
> > > an older kernel into a newer kernel. It's a different problem, and I
> > > can see having a different taint flag be more informative to kernel
> > > developers in general. I would welcome that change with or without
> > > letting tracepoints be set for that module.
> > 
> > There is one important inaccuracy in your explanation above: a
> > kernel supporting signed modules, but not enforcing "sig_force",
> > can load unsigned modules with a simple modprobe or insmod, without
> > any "--force" argument. Therefore, tainting the module as
> > "TAINT_FORCED_MODULE" is misleading.
> > 
> 
> Oh! You are saying that if the kernel only *supports* signed modules,
> and you load a module that is not signed, it will taint the kernel?

Yes, exactly, presuming that by "supporting" you mean CONFIG_MODULE_SIG=y.
Loading an unsigned module then taints the kernel, and taints the module
with TAINT_FORCED_MODULE even though "modprobe --force" was never used.

Thanks,

Mathieu

> 
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
