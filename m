Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab3GLSHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:07:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56006 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab3GLSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:07:33 -0400
Message-ID: <51E045E0.8020702@gmail.com>
Date: Fri, 12 Jul 2013 12:07:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com> <51E038ED.7050600@gmail.com> <20130712171808.GD1537@redhat.com> <51E03F76.3090607@gmail.com> <20130712175028.GA11036@redhat.com>
In-Reply-To: <20130712175028.GA11036@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/13 11:50 AM, Dave Jones wrote:

> Given you can run trinity long enough that you hit this however, makes me
> think you won't be able to triger the bug I'm talking about.
> Perhaps virtualised perf counters are somehow immune to this problem, because
> on bare-metal, it literally takes seconds.

I can generate the message it just does not lock up:

...
[  131.837129] perf samples too long (35849 > 35714), lowering 
kernel.perf_event_max_sample_rate to 4000
...
[  237.271170] INFO: NMI handler (perf_event_nmi_handler) took too long 
to run: 57900.001 msecs


And Dave Hansen: I think nmi.c has the same do_div problem as 
kernel/events/core.c that Stephane fixed. Your patch has:

         whole_msecs = do_div(delta, (1000 * 1000));
         decimal_msecs = do_div(delta, 1000) % 1000;

David
