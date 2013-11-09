Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3KIBJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 20:09:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20274 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757850Ab3KIBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 20:09:18 -0500
Date: Fri, 8 Nov 2013 20:09:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131108200905.3bdb15d9@gandalf.local.home>
In-Reply-To: <20131108223657.GF14606@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
	<20131108200244.GB14606@localhost.localdomain>
	<alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
	<20131108204839.GD14606@localhost.localdomain>
	<alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
	<20131108223657.GF14606@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013 23:36:58 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:


> [  237.623178] ---[ end trace 40cda30d05d0ffa6 ]---
> [  237.627769] perf samples too long (3397569 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> [  237.637124] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 444.233 msecs
> 
> 444 msecs is huge.

I don't think that's the issue you are looking for. Peter told me
there's a timer race with overflows or something (I don't remember the
details, Peter can clarify it), that causes the second timestamp to be
bogus compared to the first, and this makes the code think that the NMI
handler was running much longer that it actually was.

-- Steve

> 
> [  247.186562] perf samples too long (3371028 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
> [  257.180241] perf samples too long (3344694 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
> [  267.173920] perf samples too long (3318566 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
> [  277.167598] perf samples too long (3292642 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
> [  287.161277] perf samples too long (3266920 > 62500), lowering kernel.perf_event_max_sample_rate to 2000
> [  297.154956] perf samples too long (3241400 > 125000), lowering kernel.perf_event_max_sample_rate to 1000

