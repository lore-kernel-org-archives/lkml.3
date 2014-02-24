Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaBXRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:39:11 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38346 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaBXRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:39:09 -0500
Date: Mon, 24 Feb 2014 12:41:14 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402241239450.20170@vincent-weaver-1.um.maine.edu>
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
 <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Vince Weaver wrote:

> I do note that 
> 	perf_callchain_user();
> 
> Does
> 	fp = (void __user *)regs->bp;
> 	
> 	...
> 
> 	bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> 
> 
> And in my particular executable RBP has nothing to do with a frame 
> pointer, but is instead being used as a general purpose register.

and as a reminder, I'm seeing this on an x32 executable, so 
perf_callchain_user32() is probably coming into play.

So maybe it is an x32 issue after all.

Vince
