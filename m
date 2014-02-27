Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaB0XaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:30:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6150 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751881AbaB0XaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:30:11 -0500
Date: Thu, 27 Feb 2014 18:30:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140227183008.6be081b7@gandalf.local.home>
In-Reply-To: <530FC1C6.5040209@zytor.com>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
	<530B841F.5050803@zytor.com>
	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
	<530B90A5.3090302@zytor.com>
	<20140224141329.1cd3bb52@gandalf.local.home>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 14:52:54 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/27/2014 02:31 PM, Steven Rostedt wrote:
> > 
> > Yeah, something is getting mesed up.
> > 
> 
> What it *looks* like to me is that we try to nest the cr2 save/restore,
> which doesn't nest because it is a percpu variable.
> 
> ... except in the x86-64 case, we *ALSO* save/restore cr2 inside
> entry_64.S, which makes the stuff in do_nmi completely redundant and
> there for no good reason.

Peter, look at the code. That percpu cr2 is in a #ifdef CONFIG_X86_32
section. That is, it isn't even executed. That's i386 code. The only
place the cr2 is saved for x86_64 is in entry_64.S.

-- Steve

> 
> I would actually suggest we do the equivalent on i386 as well.
> 
> Vince, could you try this patch as an experiment?
> 
> 

