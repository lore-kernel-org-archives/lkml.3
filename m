Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaE1RFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:05:53 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61082 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaE1RFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:05:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140528165144.GK29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
	<1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
	<20140528081053.GP11096@twins.programming.kicks-ass.net>
	<20140528145831.GH29957@tassilo.jf.intel.com>
	<CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
	<20140528165144.GK29957@tassilo.jf.intel.com>
Date: Wed, 28 May 2014 19:05:51 +0200
Message-ID: <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 6:51 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> The only part I don't quite follow here is this:
>>                       if (__test_and_set_bit(bit, (unsigned long *)&status))
>>                                 continue;
>>
>> Which seems to indicate the code is making sure each counter is
>> processed only once. But it can only be processed once, if you have
>> only one record. And if you have multiple, you want to be able to
>> handle the same counter multiple times, at least once perf PEBS
>> record. So I am a bit confused about this test.
>
> Each PEBS record is only for a single counter overflow. So it
> always should only be a single perf event.
>
So, you're telling me this is a sanity check. That p->status can
only have one bit set. Somehow that's not how I recall it working.

The point is that a single PEBS record is enough for multiple
events when the overflows occur simultaneously because they
all get the same machine state which is correct.  A single entry
also saves space in the buffer.
