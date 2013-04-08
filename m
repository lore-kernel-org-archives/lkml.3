Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637Ab3DHTGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:06:02 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37145 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741Ab3DHTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:06:00 -0400
Message-ID: <51631510.6080401@linaro.org>
Date: Mon, 08 Apr 2013 12:05:52 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <51586315.7080006@gmail.com> <5159D221.70304@linaro.org>  <1364889256.16858.1.camel@laptop> <515B0502.8070408@linaro.org>  <1365009558.26858.19.camel@hornet> <515C66FE.7030501@linaro.org>  <1365010502.26858.32.camel@hornet> <515C6C01.9070905@linaro.org>  <1365092963.26858.107.camel@hornet> <1365185813.25942.12.camel@hornet>  <20130406110507.GC7572@netboy> <1365443897.24306.12.camel@hornet>
In-Reply-To: <1365443897.24306.12.camel@hornet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 10:58 AM, Pawel Moll wrote:
> Now, before I spend time doing all this, a question to John, Peter,
> Stephane and the rest of the public - would a solution providing such
> userspace interface:
>
> 	fd = sys_perf_open()
> 	timestamp = clock_gettime((FD_TO_CLOCKID(fd), &ts)
>
> be acceptable to all?

So thinking this through further, I'm worried we may _not_ be able to 
eventually enable this to be a vdso as I had earlier hoped. Mostly 
because I'm not sure how the fd -> file -> clock lookup could be done in 
userland (any ideas?).

So this makes this approach mostly equivalent long term to the ioctl 
method, from a performance perspective. And makes the dynamic posix 
clockid somewhat less of a middle-ground compromise between the ioctl 
and generic constant clockid approach.

So while I'm not opposed to the sort of extention proposed above, I want 
to make sure introducing the new approach is worth the effort when 
compared with just adding an ioctl.

thanks
-john


