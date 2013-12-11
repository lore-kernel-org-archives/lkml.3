Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3LKTaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:30:14 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:62238 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3LKTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:30:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131209074933.GA2922@jtriplet-mobl1>
References: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
	<20131209074933.GA2922@jtriplet-mobl1>
Date: Wed, 11 Dec 2013 20:30:10 +0100
Message-ID: <CABPqkBTufgMk=iqXM87+psUeLd865QF9tCEVHT6hwT4=TtetfQ@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: char: Add a dynamic clock for the trace clock
From: Stephane Eranian <eranian@google.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Pawel Moll <pawell.moll@arm.com>,
        Olof Johansson <olof@lixom.net>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonny,

Your patch has a couple of problems for me:
 - requires CONFIG_TRACING

You should directly invoke getrawmonotonic()
 and inline the code from trace_clock_getres().

That's how I managed to compile your kernel module on my system.


On Mon, Dec 9, 2013 at 8:49 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Fri, Dec 06, 2013 at 04:34:11PM -0800, Sonny Rao wrote:
>> Based on a suggestion from John Stultz.
>>
>> This adds a dynamic clock device which can be used with clock_gettime
>> to sample the clock source used for time stamping trace events in the
>> kernel.  The only use for this clock source is to associate user space
>> events with kernel events on a given kernel.  It is explicitly not
>> supposed to be used as a generic time source and won't necessarily be
>> consistent between kernels.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
