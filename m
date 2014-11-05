Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaKEQ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:57:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaKEQ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:57:41 -0500
Date: Wed, 5 Nov 2014 17:57:26 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 09/12 v3] seq_buf: Move the seq_buf code to lib/
Message-ID: <20141105165726.GK4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.809349817@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160222.809349817@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:46, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The seq_buf functions are rather useful outside of tracing. Instead
> of having it be dependent on CONFIG_TRACING, move the code into lib/
> and allow other users to have access to it even when tracing is not
> configured.
> 
> The seq_buf utility is similar to the seq_file utility, but instead of
> writing sending data back up to userland, it writes it into a buffer
> defined at seq_buf_init(). This allows us to send a descriptor around
> that writes printf() formatted strings into it that can be retrieved
> later.
> 
> It is currently used by the tracing facility for such things like trace
> events to convert its binary saved data in the ring buffer into an
> ASCII human readable context to be displayed in /sys/kernel/debug/trace.
> 
> It can also be used for doing NMI prints safely from NMI context into
> the seq_buf and retrieved later and dumped to printk() safely. Doing
> printk() from an NMI context is dangerous because an NMI can preempt
> a current printk() and deadlock on it.
> 
> Link: http://lkml.kernel.org/p/20140619213952.058255809@goodmis.org
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This patch might needed an update when there are changes in the
previous patches. But it is a simple file move that makes
perfect sense, so:

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
