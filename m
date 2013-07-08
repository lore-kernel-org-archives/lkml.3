Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3GHUfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:35:03 -0400
Received: from www.sr71.net ([198.145.64.142]:44868 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab3GHUfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:35:00 -0400
Message-ID: <51DB2271.1010009@sr71.net>
Date: Mon, 08 Jul 2013 13:34:57 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        dave.hansen@linux.intel.com, "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
References: <20130704223010.GA30625@quad> <51DACE08.5030109@intel.com> <CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com> <51DB1B75.8060303@intel.com> <CABPqkBRdK5WwokEWE3tQZiAyO3pWbS9aUn7HUkQT+XsMYfJUiA@mail.gmail.com>
In-Reply-To: <CABPqkBRdK5WwokEWE3tQZiAyO3pWbS9aUn7HUkQT+XsMYfJUiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 01:20 PM, Stephane Eranian wrote:
> On Mon, Jul 8, 2013 at 10:05 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>> If the interrupts _consistently_ take too long individually they can
>> starve out all the other CPU users.  I saw no way to make them finish
>> faster, so the only recourse is to also drop the rate.
>>
> I think we need to investigate why some interrupts take so much time.
> Could be HW, could be SW. Not talking about old hardware here.
> Once we understand this, then we know maybe adjust the timing on
> our patch.

I spent quite a while looking at it on my hardware.  It's difficult to
profile in NMIs, but I'm fairly satisfied (for me) it is a NUMA issue
which gets worse as I add cores.

I did a quite a bit of ftracing to look for spots inside the handler
which were taking large amounts of time.  There were none.  The
execution time was spread very evenly over the entire nmi handler.  It
didn't appear to be any individual hot cachelines or doing something
silly like sitting in a loop handling lots of PMU events.

