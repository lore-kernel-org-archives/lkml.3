Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaIRAdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:33:15 -0400
Received: from www.sr71.net ([198.145.64.142]:37628 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbaIRAdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:33:14 -0400
Message-ID: <541A2848.6030308@sr71.net>
Date: Wed, 17 Sep 2014 17:33:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com, Alex Chiang <achiang@hp.com>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain> <5417F228.9060301@sr71.net> <20140916175851.GC2848@worktop.localdomain> <5418CC6F.2040803@sr71.net> <20140917225726.GH2848@worktop.localdomain>
In-Reply-To: <20140917225726.GH2848@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 03:57 PM, Peter Zijlstra wrote:
>> > Another option would be to:
>> > 1. Add a new "PKG" level and actually _build_ it with phys_proc_id
>> > 2. Make sure to tie the sysfs 'core_siblings' file to PKG
>> > 3. Leave the "MC" level as it is now, but define it as being the lowest-
>> >    common-denominator of core grouping.  In other words, the "MC" group
>> >    will stop at a NUMA node or a socket boundary, whichever it sees
>> >    first.
>> > 4. Chop the "COD_NUMA" level off in sched_init_numa()
> No, we should provide an arch override for sched_domain_topology which
> has the right setup for the detected topology.
> 
> See arm,powerpc and s390, which already have his.

I _think_ the problem here is that all of the existing topologies
describe something below the smallest NUMA node.  With the
cluster-on-die stuff, we've got a node boundary smack in the middle of
the existing topology levels.

So, if we're going to do this with a new sched_domain_topology, we've
got to make sure that we eliminate all of the levels below that first
NUMA node.  I think that means just have a topology with the SMT level
alone in it.

Does that work?


