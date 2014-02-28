Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaB1Uvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:51:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:45856 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752130AbaB1Uvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:51:36 -0500
Date: Fri, 28 Feb 2014 15:51:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86: Rename copy_from_user_nmi() to
 copy_from_user_trace()
Message-ID: <20140228155130.26adcef3@gandalf.local.home>
In-Reply-To: <20140228204621.GA14089@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
	<20140228154026.GH9987@twins.programming.kicks-ass.net>
	<5310B60F.30806@zytor.com>
	<20140228112946.1f194397@gandalf.local.home>
	<20140228143316.211d4034@gandalf.local.home>
	<20140228204621.GA14089@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 21:46:21 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Feb 28, 2014 at 02:33:16PM -0500, Steven Rostedt wrote:
> > [ H. Peter, Here's the rename patch. I did not include your update. You
> > can add that first and then massage this patch on top. But this isn't
> > critical for mainline or stable, where as I believe your patch is. ]
> > 
> > The tracing utilities sometimes need to read from userspace (stack tracing),
> > and to do this it has as special copy_from_user function called
> > copy_from_user_nmi(). Well, as tracers can call this from outside of
> > nmi context, the "_nmi" part is a misnomer and "_trace" is a better
> > name.
> 
> NAK, spin_lock_irq() is very much an IRQ safe lock. Similarly
> copy_from_user_nmi() is an NMI safe copy from user.
> 
> Furthermore, there's exactly 0 trace users, so the proposed name is
> actively worse.

Heh, I consider perf and oprofile special tracers ;-)

-- Steve
