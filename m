Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaB1Pki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:40:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaB1Pkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:40:37 -0500
Date: Fri, 28 Feb 2014 16:40:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228154026.GH9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
 <20140227173150.4e5ed747@gandalf.local.home>
 <530FC1C6.5040209@zytor.com>
 <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
 <20140227215726.7018c861@gandalf.local.home>
 <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 07:13:06AM -0800, H. Peter Anvin wrote:
> If I'm reading this right we end up going from the page fault
> tracepoint to copy_from_user_nmi() without going through NMI, and the
> cr2 corruption is obvious.  I guess the assumption that only the NMI
> path needed to save cr2 is flawed?

It was never assumed it would only go through NMI, but that it would be
NMI safe -- and as it turns out, it is that.

What I did assume was that any other callsites would be safe, seeing how
they'd already be running in 'normal' contexts.

I had not considered people putting tracepoints _that_ early in the
exception paths.

Note that there's more tracepoints there than the one mentioned.
