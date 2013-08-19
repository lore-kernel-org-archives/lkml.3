Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3HSOq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:46:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3HSOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:46:25 -0400
Date: Mon, 19 Aug 2013 16:45:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only
 active events
Message-ID: <20130819144557.GH24092@twins.programming.kicks-ass.net>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
 <1376411952-16718-2-git-send-email-jolsa@redhat.com>
 <20130815114040.GR24092@twins.programming.kicks-ass.net>
 <20130815135314.GE19750@two.firstfloor.org>
 <CABPqkBQAnj+tNBpQ+ebjTTe2Ht1__w9HzZnB15QGc+czCaYULg@mail.gmail.com>
 <20130819111616.GA1145@krava.brq.redhat.com>
 <CABPqkBSNv-=3+BCopb8KZC5ZdwKFERS2as4wJ-Yu0_cX-vUY3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSNv-=3+BCopb8KZC5ZdwKFERS2as4wJ-Yu0_cX-vUY3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 04:31:31PM +0200, Stephane Eranian wrote:
> Yeah, I think you can have one NMI pending because it came
> while you were already servicing an NMI interrupt. Though, this
> is very unlikely.

Yeah exceedingly rare. I'm also fairly certain I've had NMIs right after
clearing EN bits. Although I cannot remember if that was on Intel or AMD
hardware, nor on what specific model :/
