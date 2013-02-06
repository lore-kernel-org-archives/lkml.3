Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3BFSRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:17:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52766 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3BFSRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:17:44 -0500
Message-ID: <1360174662.4045.34.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Date: Wed, 06 Feb 2013 18:17:42 +0000
In-Reply-To: <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Feb 2013 18:17:42.0803 (UTC) FILETIME=[41552E30:01CE0496]
X-MC-Unique: 113020618174300201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 22:13 +0000, Stephane Eranian wrote:
> The app requesting the timestamp may not necessarily have an active
> perf session. And by that I mean, it may not be self-monitoring. But it
> could be monitored by an external tool such as perf, without necessary
> knowing it.

Fair enough - I guess eg. JIT engine could generate a timestamped
information about generated symbols which could be then merged with a
stream recorded by the perf tool by yet another tool.

> The timestamp is global or at least per-cpu. It is not tied to a particular
> active event.

I know that the implementation does it now, but is it actually specified
as such? I could imagine a situation where perf_clock() returns time
elapsed since the "current" sys_perf_event_open()... (not that I'd like
it ;-)

Paweł


