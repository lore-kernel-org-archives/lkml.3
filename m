Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3IYTMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:12:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:55066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3IYTMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,979,1371106800"; 
   d="scan'208";a="383497457"
Date: Wed, 25 Sep 2013 12:12:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
Message-ID: <20130925191216.GE2018@tassilo.jf.intel.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 02:50:26PM +0200, Jiri Olsa wrote:
> hi,
> sending *RFC* for toggling events support.
> 
> Adding perf interface that allows to create toggle events, which can
> enable or disable another event. Whenever the toggle event is triggered
> (has overflow), it toggles another event state and either starts or
> stops it.
> 
> The goal is to be able to create toggling tracepoint events to enable and
> disable HW counters, but the interface is generic enough to be used for
> any kind of event. 

Haven't read the patches, but frequent full event switch in/out seems
very expensive.  If someone puts that switch on a common
function it would likely disturb things quite a bit.

It would be better to keep counting and just do RDPMC on 
the switch points, and then subtract for counting.
For sampling could need a MSR write to enable/disable.
Still somewhat expensive, but nowhere near as bad as a full switch.

Another problem is that it may be very inexact, as
the counting will often happen in the background
and not be very synchronized with the switches.
Not fully sure how big a problem that would be.

-Andi

