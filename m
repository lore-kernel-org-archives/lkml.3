Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaB1VGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:06:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54922 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752129AbaB1VGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:06:40 -0500
Date: Fri, 28 Feb 2014 16:06:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228160638.3b045dbc@gandalf.local.home>
In-Reply-To: <20140228205638.GD14089@laptop.programming.kicks-ass.net>
References: <530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
	<20140228154026.GH9987@twins.programming.kicks-ass.net>
	<5310B60F.30806@zytor.com>
	<20140228112946.1f194397@gandalf.local.home>
	<20140228205638.GD14089@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 21:56:38 +0100
Peter Zijlstra <peterz@infradead.org> wrote:


> Like already said; _trace is an absolutely abysmal name. Also you
> _really_ don't want an unconditional CR2 write in there, that's just
> stupidly expensive.

But a read isn't. Which is why we only do a write if the copy caused a
page fault (which is already expensive).

The proposed patch will have:

	if (cr2 != read_cr2())
		write_cr2(cr2);

> 
> Also, this function is called a _LOT_ under certain workloads, I don't
> know how cheap a CR2 read is, but it had better be really cheap.

That's a HPA question.

-- Steve
