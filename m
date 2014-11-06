Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaKFVJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:09:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:36509 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbaKFVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:09:21 -0500
Date: Thu, 6 Nov 2014 16:09:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 04/12 v3] tracing: Convert seq_buf_path() to be
 like seq_path()
Message-ID: <20141106160917.3330816d@gandalf.local.home>
In-Reply-To: <20141106141820.GC2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.048795666@goodmis.org>
	<20141105144553.GE4570@pathway.suse.cz>
	<20141105151053.744b77f2@gandalf.local.home>
	<20141106141820.GC2001@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014 15:18:22 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> I see. Well, we still need to fix trace_seq_path() or its callers.
> For example, seq_print_user_ip() checks trace_seq_path() return value
> and expects 0 on failure.

Crap, thanks for pointing that out. Luckily, there's only one user, and
it's not used much. It's the user backtrace and that only prints if a
file is found, and this would only cause the offset not to be printed.

-- Steve
