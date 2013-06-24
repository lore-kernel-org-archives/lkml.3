Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FXKYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:24:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47647 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3FXKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:24:32 -0400
Date: Mon, 24 Jun 2013 12:24:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130624102426.GS28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 06:42:26PM +0200, Robert Richter wrote:
> The basic concept is to use a pmu as an event container for persistent
> events. The pmu registers events in sysfs and provides format and
> event information for the userland. The persistent event framework
> requires to add events to the pmu dynamically.
> 
> With the information in sysfs userland knows about how to setup the
> perf_event attribute of a persistent event. Since a persistent event
> always has the persistent flag set, a way is needed to express this in
> sysfs. A new syntax is used for this. With 'attr<num>:<mask>' any bit
> in the attribute structure may be set in a similar way as using
> 'config<num>', but <num> is an index that points to the u64 value to
> change within the attribute.
> 
> For persistent events the persistent flag (bit 23 of flag field in
> struct perf_event_attr) needs to be set which is expressed in sysfs
> with "attr5:23". E.g. the mce_record event is described in sysfs as
> follows:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23
> 

Ok so it took me a little to 'get' this PMU 'abuse', but I suppose I can
go along with it ;-)

On the specifics though; it again seems to hard assume persistent events
are for tracepoints only -- either make this very explicit or remove it.
