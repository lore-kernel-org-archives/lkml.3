Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbaDIQs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:48:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbaDIQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:48:54 -0400
Date: Wed, 9 Apr 2014 18:48:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140409164852.GA22728@two.firstfloor.org>
References: <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com>
 <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
 <CALCETrUA_JSDepFnKYsrDD5CQX65k4z_XeSxc4RxmhB2RahBZA@mail.gmail.com>
 <20140409114857.GT11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409114857.GT11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 01:48:57PM +0200, Peter Zijlstra wrote:
> On Wed, Feb 26, 2014 at 12:26:43PM -0800, Andy Lutomirski wrote:
> > Speed.  FPO saves one register (a big deal on x86_32; not so important
> > on x86_64) but also saves a few cycles on function entry and exit,
> > which is a bigger deal for small functions.
> 
> So I though that LTO was supposed to get rid of a lot of the small
> function and inline them.

It does it when it can (no indirect), thinks it's profitable and won't
increase code size too much. 

> 
> I've also heard that in practise this is very 'hard', and thus we're
> still stuck with a gazillion small functions (mostly C++ people suffer
> from this).

They need devirtualization, which we cannot do currently in the kernel.

> 
> Can anybody give a concise explanation on why LTO doesn't rid us of
> these small functions or point to a web resource that describes the
> problem?

It depends on the code of course.
On one of my LTO builds I have ~10% less functions in System.map.

Actual results will vary of course on the config.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
