Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab3GDDPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:15:04 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:59992 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab3GDDPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:15:02 -0400
Date: Wed, 3 Jul 2013 23:14:40 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: perf/Documentation/ABI -- add some documentation for perf_event
 sysfs usage
In-Reply-To: <alpine.DEB.2.10.1307031527390.12584@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1307032308040.13409@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1307031527390.12584@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Vince Weaver wrote:

> 
> Add some documentation for the perf_event related
>   /sys/bus/event_source/bus/devices/
> files, since in theory it's a stable interface and the only
> current documentation is some lex and yacc files in the
> perf tools directory.

OK, don't I feel silly, these values were already documented in 
   Documentation/ABI/testing/sysfs-bus-event_source-devices-events
rather than ABI/stable

To be fair I missed it because the documentation seemed to come from the 
Power developers and not through perf_event

anyway, that documentation says the values will be hex only, which was 
broken by

commit f9134f36aed59ab55c0ab1a4618dd455f15aef5f
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Jun 17 17:36:52 2013 -0700

    perf/x86/intel: Add mem-loads/stores support for Haswell


which added:
EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");

(note ldlat is not in hex).

This broke the trinity fuzzer (which scans to look for events to use)
as well as some of my personal tools.

Should the ldlat value be fixed to be hex?  Or should we ammend the ABI
document to allow decimal?

Vince
