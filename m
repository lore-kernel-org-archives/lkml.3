Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaCAJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 04:16:58 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44256 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaCAJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 04:16:55 -0500
Date: Sat, 1 Mar 2014 10:16:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140301091650.GD5885@gmail.com>
References: <20140227215726.7018c861@gandalf.local.home>
 <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
 <20140228112946.1f194397@gandalf.local.home>
 <20140228205638.GD14089@laptop.programming.kicks-ass.net>
 <20140228160638.3b045dbc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228160638.3b045dbc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Also, this function is called a _LOT_ under certain workloads, I 
> > don't know how cheap a CR2 read is, but it had better be really 
> > cheap.
> 
> That's a HPA question.

We read CR2 in the page fault hot path, so it's on the top of CPU 
architects' minds and it's reasonably optimized. A couple of cycles 
IIRC, but would be nice to hear actual numbers.

Thanks,

	Ingo
