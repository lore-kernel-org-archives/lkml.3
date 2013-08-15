Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3HONxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:53:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42923 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3HONxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:53:16 -0400
Date: Thu, 15 Aug 2013 15:53:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only
 active events
Message-ID: <20130815135314.GE19750@two.firstfloor.org>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
 <1376411952-16718-2-git-send-email-jolsa@redhat.com>
 <20130815114040.GR24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815114040.GR24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think its a NOP; this is the global ctrl register but
> intel_pmu_disable_event() writes PERFEVTSELx.EN = 0, so even if you
> enable it in the global mask, the event should still be disabled.

Yes the hardware ANDs the various enable bits in the different
registers.

-andi
