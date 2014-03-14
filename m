Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaCNVMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:12:33 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaCNVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:12:32 -0400
Date: Fri, 14 Mar 2014 22:12:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] perf, tools, test: Add test case for alias and
 JSON parsing
Message-ID: <20140314211230.GA22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-9-git-send-email-andi@firstfloor.org>
 <20140311143149.GA31431@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311143149.GA31431@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the problem is in parse_events_fixup, which assumes
> the 'cpu' pmu globaly for all events

I investigated this now. The problem is that the event is listed,
but cannot be set up. I saw it also with 'data_writes' on another
system. 

That's a generic problem, the test just exposes it. It's a side effect
of the fragile kernel->user interface in perf and likely hard to fix.

The only thing I can do is to ignore failures here and only
print messages.

-Andi
