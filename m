Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbbABRSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:18:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51973 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbbABRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:18:10 -0500
Date: Fri, 2 Jan 2015 09:17:38 -0800
From: Shaohua Li <shli@fb.com>
To: David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20150102171738.GB2381637@devbig257.prn2.facebook.com>
References: <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net>
 <20150102025953.GA1253265@devbig257.prn2.facebook.com>
 <54A6B9D5.5040804@gmail.com>
 <20150102170223.GA2381637@devbig257.prn2.facebook.com>
 <54A6D0B6.7090700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54A6D0B6.7090700@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-02_07:2014-12-31,2015-01-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=50.6482119179177
 compositescore=0.128743225232898 urlsuspect_oldscore=0.128743225232898
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.128743225232898 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501020167
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 10:09:10AM -0700, David Ahern wrote:
> On 1/2/15 10:02 AM, Shaohua Li wrote:
> >On Fri, Jan 02, 2015 at 08:31:33AM -0700, David Ahern wrote:
> >>On 1/1/15 7:59 PM, Shaohua Li wrote:
> >>>I'm wondering how we could use the perf to implament a clock_gettime.
> >>>reading the perf fd or using ioctl is slow so reading the mmap
> >>>ringbuffer is the only option. But as far as I know the ringbuffer has
> >>>data only when an event is generated. Between two events, there is
> >>>nothing we can read from the ringbuffer. Then how can application get
> >>>time info in the interval?
> >>
> >>Are you wanting to read perf_clock from userspace?
> >
> >Yep, in some sort of form. Basically I want to read the time a task
> >runs. Peter suggests we can read the activation time of a perf event.
> >But I don't want to use any system call, as it's slow and likes
> >clock_gettime.
> 
> Since we cannot get the capability committed upstream a number of
> folks are using this method:
> 
>     https://github.com/dsahern/linux/blob/perf-full-monty/README.ahern
> 
> ie., a KLM exports perf_clock and apps can use:
> 
> #define CLOCK_PERF 14
> if (clock_gettime(CLOCK_PERF, &ts) != 0) {
> }
> 
> No vdso acceleration, but works with an unmodified kernel.

no, that's not what I want. as I said, we don't want any syscall (unless
it's vdso based). 

Thanks,
Shaohua
