Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaCKOc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaCKOc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:32:28 -0400
Date: Tue, 11 Mar 2014 15:31:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] perf, tools, test: Add test case for alias and JSON
 parsing
Message-ID: <20140311143149.GA31431@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:38AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a simple test case to perf test that runs perf download and parses
> all the events. This needs adding an all event iterator to pmu.c

[jolsa@krava perf]$ ./perf test -vvv 25
25: Test parsing JSON aliases                              :
--- start ---
invalid or unsupported event: 'energy-gpu'
 Parsed 522 events: ---- end ----
Test parsing JSON aliases: FAILED!

I think the problem is in parse_events_fixup, which assumes
the 'cpu' pmu globaly for all events

jirka
