Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaB1UzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:55:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42400 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaB1UzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:55:06 -0500
Date: Fri, 28 Feb 2014 21:55:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228205500.GC14089@laptop.programming.kicks-ass.net>
References: <20140227173150.4e5ed747@gandalf.local.home>
 <530FC1C6.5040209@zytor.com>
 <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
 <20140227215726.7018c861@gandalf.local.home>
 <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5310B60F.30806@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 08:15:11AM -0800, H. Peter Anvin wrote:
> On 02/28/2014 07:40 AM, Peter Zijlstra wrote:
> > On Fri, Feb 28, 2014 at 07:13:06AM -0800, H. Peter Anvin wrote:
> >> If I'm reading this right we end up going from the page fault
> >> tracepoint to copy_from_user_nmi() without going through NMI, and the
> >> cr2 corruption is obvious.  I guess the assumption that only the NMI
> >> path needed to save cr2 is flawed?
> > 
> > It was never assumed it would only go through NMI, but that it would be
> > NMI safe -- and as it turns out, it is that.
> > 
> > What I did assume was that any other callsites would be safe, seeing how
> > they'd already be running in 'normal' contexts.
> > 
> > I had not considered people putting tracepoints _that_ early in the
> > exception paths.
> > 
> > Note that there's more tracepoints there than the one mentioned.
> > 
> 
> Well, I was talking about the assumption spelled out in the comment
> above copy_from_user_nmi() which pretty much states "cr2 is safe because
> cr2 is saved/restored in the NMI wrappers."

That is because we assumed NMI was the only thing that could interrupt a
fault handler before it would read CR2. Never thinking someone would put
a tracepoint there.
