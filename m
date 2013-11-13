Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3KMVR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:17:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33024 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750874Ab3KMVRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:17:24 -0500
Date: Wed, 13 Nov 2013 16:17:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace/x86: Load ftrace_ops in parameter not the
 variable holding it
Message-ID: <20131113161718.5aaa6aea@gandalf.local.home>
In-Reply-To: <5283E9D9.5070006@linux.intel.com>
References: <20131113152004.459787f9@gandalf.local.home>
	<5283E9D9.5070006@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 13:06:33 -0800
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> On 11/13/2013 12:20 PM, Steven Rostedt wrote:
> > 
> > Function tracing callbacks expect to have the ftrace_ops that registered it
> > passed to them, not the address of the variable that holds the ftrace_ops
> > that registered it.
> > 
> > Use a mov instead of a lea to store the ftrace_ops into the parameter
> > of the function tracing callback.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This looks like an urgent fix, am I correct?
> 

It should go into 3.13 at least. I have code that will depend on this
fix, and it would be nice if it makes it into 3.13.

It's been shear luck that this hasn't caused any issues so far. That's
because the current callbacks that use its ftrace_ops don't get called
directly by assembly. If they did, they would crash due to this bug.

We should probably tag it for stable too. The bug goes back to 3.8.

Fixes: 2f5f6ad9390c1 ("ftrace: Pass ftrace_ops as third parameter to
function trace callback")

Thanks,

-- Steve
