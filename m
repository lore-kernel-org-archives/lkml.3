Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaFWOWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:22:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:1649 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaFWOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:22:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="448843096"
Date: Mon, 23 Jun 2014 07:22:40 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf/x86: fix constraints for load latency and
 precise events
Message-ID: <20140623142240.GD8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-3-git-send-email-eranian@google.com>
 <20140623084254.GK19860@laptop.programming.kicks-ass.net>
 <CABPqkBTXvBwwQ1vWkfQRtq7=GxS_KyE94wSOxPaBCffeJ7yc+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTXvBwwQ1vWkfQRtq7=GxS_KyE94wSOxPaBCffeJ7yc+A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know why they did it this way. I think somehow, it is believe that
> ll and st cannot be captured together (and putting both on cnt3 enforces
> that). But when it seems to be working fine. If someone from Intel can
> confirm this is okay/not okay then we can revisit.

Depending on the CPU, if you have multiple load and store threshold events
active at the same time it may capture junk.

So it's better to keep that constraint too, or enforce it with other 
ways (e.g. an extra reg)

> You can say the same with PREC_DIST which up until HSW needs to be
> taken alone, i.e., no other event active. We don't enforce that either, it would
> cause problems with the NMI watchdog.

I believe it's only sandy bridge where it needs to be taken alone.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
