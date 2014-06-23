Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaFWLj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:39:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:47049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaFWLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:39:55 -0400
Date: Mon, 23 Jun 2014 13:39:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Joe Mario <jmario@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf/x86: fix constraints for load latency and
 precise events
Message-ID: <20140623113953.GE13930@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-3-git-send-email-eranian@google.com>
 <20140623084254.GK19860@laptop.programming.kicks-ass.net>
 <CABPqkBTXvBwwQ1vWkfQRtq7=GxS_KyE94wSOxPaBCffeJ7yc+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTXvBwwQ1vWkfQRtq7=GxS_KyE94wSOxPaBCffeJ7yc+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:00:18AM +0200, Stephane Eranian wrote:
> You can say the same with PREC_DIST which up until HSW needs to be
> taken alone, i.e., no other event active. We don't enforce that either, it would
> cause problems with the NMI watchdog.

Yeah, the SDM states no other PEBS event, so the NMI watchdog would be
fine, but we do indeed not have any means of excluding other PEBS
events, only all other events.
