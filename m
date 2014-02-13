Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBMPoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:44:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:54949 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751645AbaBMPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:44:31 -0500
Date: Thu, 13 Feb 2014 10:44:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140213104429.478b56e8@gandalf.local.home>
In-Reply-To: <y0mlhxfnhx8.fsf@fche.csb>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<y0mlhxfnhx8.fsf@fche.csb>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 10:36:35 -0500
fche@redhat.com (Frank Ch. Eigler) wrote:

> 
> rostedt wrote:
> 
> > [...]
> > Oh! You are saying that if the kernel only *supports* signed modules,
> > and you load a module that is not signed, it will taint the kernel?
> 
> Yes: this is the default for several distros.
> 

Rusty, Ingo,

This looks like a bug to me, as it can affect even in-tree kernel
modules. If you have a kernel that supports signed modules, and you
modify a module, recompile it, apply it, since it is no longer signed,
then it sounds like we just tainted it. Worse yet, we just disabled any
tracepoints on that module, which means it is even harder to debug that
module (if that's the reason you recompiled it in the first place).

-- Steve
