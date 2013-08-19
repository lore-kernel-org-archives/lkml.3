Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3HSJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:16:56 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54958 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3HSJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130815135314.GE19750@two.firstfloor.org>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
	<1376411952-16718-2-git-send-email-jolsa@redhat.com>
	<20130815114040.GR24092@twins.programming.kicks-ass.net>
	<20130815135314.GE19750@two.firstfloor.org>
Date: Mon, 19 Aug 2013 11:16:54 +0200
Message-ID: <CABPqkBQAnj+tNBpQ+ebjTTe2Ht1__w9HzZnB15QGc+czCaYULg@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only
 active events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 3:53 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> I think its a NOP; this is the global ctrl register but
>> intel_pmu_disable_event() writes PERFEVTSELx.EN = 0, so even if you
>> enable it in the global mask, the event should still be disabled.
>
> Yes the hardware ANDs the various enable bits in the different
> registers.
>
Andi is correct. There is a logical AND between GLOBAL_CTRL and
the individual PERFEVTCTL.EN bits. If the EN bit is zero, then the
counter does not count. That also applies to fixed counters.
