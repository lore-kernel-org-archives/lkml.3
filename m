Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbaGYCzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:55:44 -0400
Received: from ozlabs.org ([103.22.144.67]:58203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805AbaGYCzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:55:43 -0400
Message-ID: <1406256941.8481.1.camel@concordia>
Subject: Re: [RFC PATCH 2/2] powerpc/perf: Implement get_cpu_str()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 25 Jul 2014 12:55:41 +1000
In-Reply-To: <20140724074749.GC18829@us.ibm.com>
References: <20140724074645.GA18829@us.ibm.com>
	 <20140724074749.GC18829@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 00:47 -0700, Sukadev Bhattiprolu wrote:
> [RFC PATCH 2/2] powerpc/perf: Implement get_cpu_str()
> 
> get_cpu_str() returns a string identifying the CPU type on the system.
> This string is then used to locate a cached JSON file which defines
> the list of PMU events supported by the CPU.
> 
> Eg: if get_cpu_str() returns "power8", the perf tool would refer to the
> PMU events defined in ~/.cache/pmu-events/power8.json.

Hi Suka,

I know we talked internally a while ago about using AT_BASE_PLATFORM, but that
was before I looked closely at Andi's patches last week.

I think we're better off using the PVR directly, it's less magic, it gives us
more flexibility and it's easier to get at.

So get_cpu_str() would just return eg. "004b0201-core".

We would handle the mapping of that name to an event file either in the
download script via the mapfile, or just by using symlinks.

cheers


