Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaBZVmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:42:38 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaBZVmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:42:37 -0500
Date: Wed, 26 Feb 2014 22:42:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140226214236.GO22728@two.firstfloor.org>
References: <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com>
 <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
 <20140226205322.GM22728@two.firstfloor.org>
 <530E5DE7.7060904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E5DE7.7060904@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:34:31PM -0700, David Ahern wrote:
> On 2/26/14, 1:53 PM, Andi Kleen wrote:
> >>Is there some reason not to enable frame pointers?
> >
> >It makes code slower.
> 
> Sure there is some overhead because of the push, mov, pop
> instructions per function. But, take for example the simple program
> below. Compile with and without frame pointers

I'm not criticizing your choice, just saying that
it's often not practical to get FP everywhere
(and I bet you missed some cases too)

<.. micro benchmark snipped...>

The CPU you're using has special hardware to avoid the main 
problems with FP. It can still cause slow downs in other
cases (e.g. one register less). But there are other
CPUs where this special hardware is not available.

You may not care about these cases, but other people do.

> >wrong annotations, out of date or broken dwarf library etc.)
> 
> dwarf is often just not usable:

I agree (altough I haven't seen that error before)


> That is a huge difference. Not to mention the fact the dwarf file is
> useless which means radically lowering sample rate and increasing
> mmap size.

Yep.

It's just fundamentally inefficient for profiling.

-Andi
