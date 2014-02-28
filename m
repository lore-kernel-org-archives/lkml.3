Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaB1QQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:16:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaB1QQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:16:21 -0500
Message-ID: <5310B60F.30806@zytor.com>
Date: Fri, 28 Feb 2014 08:15:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com> <20140228154026.GH9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140228154026.GH9987@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 07:40 AM, Peter Zijlstra wrote:
> On Fri, Feb 28, 2014 at 07:13:06AM -0800, H. Peter Anvin wrote:
>> If I'm reading this right we end up going from the page fault
>> tracepoint to copy_from_user_nmi() without going through NMI, and the
>> cr2 corruption is obvious.  I guess the assumption that only the NMI
>> path needed to save cr2 is flawed?
> 
> It was never assumed it would only go through NMI, but that it would be
> NMI safe -- and as it turns out, it is that.
> 
> What I did assume was that any other callsites would be safe, seeing how
> they'd already be running in 'normal' contexts.
> 
> I had not considered people putting tracepoints _that_ early in the
> exception paths.
> 
> Note that there's more tracepoints there than the one mentioned.
> 

Well, I was talking about the assumption spelled out in the comment
above copy_from_user_nmi() which pretty much states "cr2 is safe because
cr2 is saved/restored in the NMI wrappers."

	-hpa
