Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3HaKHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:07:06 -0400
Received: from smtp1.uu.se ([130.238.7.54]:33960 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3HaKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:07:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21025.49202.207730.949120@pilspetsen.it.uu.se>
Date: Sat, 31 Aug 2013 12:06:42 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
In-Reply-To: <alpine.DEB.2.10.1308301426070.19485@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
	<CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
	<alpine.DEB.2.10.1308301426070.19485@vincent-weaver-1.um.maine.edu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver writes:
 > On Fri, 30 Aug 2013, Stephane Eranian wrote:
 > > >
 > > You mean that the high cost in your first example comes from the fact
 > > that you are averaging over all the iterations and not n-1 (where 1 is
 > > the first). I don't see a flag in mmap() to fault it in immediately. But
 > > why not document, that programs should touch the page once before
 > > starting any timing measurements.
 > 
 > I was just curious why perfctr didn't need to do this, but possibly
 > I'm just missing the mmap page being touched.  Though the code is pretty
 > small and I'm not seeing any such access.

perfctr's ->mmap() actively inserts the counters page into the calling
process' mm, so it's available immediately.  The other model is to wait
for the first page fault on that page before inserting it; apparently
the other performance counter frameworks do that instead.
