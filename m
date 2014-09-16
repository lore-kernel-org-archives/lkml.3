Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaIPQqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:46:33 -0400
Received: from www.sr71.net ([198.145.64.142]:50410 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbaIPQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:46:32 -0400
Message-ID: <54186966.3010901@sr71.net>
Date: Tue, 16 Sep 2014 09:46:30 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, andreas.herrmann3@amd.com,
        hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain> <20140916013845.390833b9@as> <20140916064403.GC14807@gmail.com> <20140916020300.5013b8f0@as> <20140916160134.GB2848@worktop.localdomain>
In-Reply-To: <20140916160134.GB2848@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 09:01 AM, Peter Zijlstra wrote:
> On Tue, Sep 16, 2014 at 02:03:00AM -0500, Chuck Ebbert wrote:
>> Hmm, looking closer at the diagram, each ring has its own memory controller, so
>> it really is NUMA if you break the interconnect between that caches.
> 
> How does it do that? Does it split the DIMM slots in two as well, with
> half for the one node and the other half for the other? Or will both
> 'nodes' share the same local memory?

I the diagrams in here are accurate in describing the rings:

http://www.enterprisetech.com/2014/09/08/intel-ups-performance-ante-haswell-xeon-chips/

The "nodes" each get their own memory controller and exclusive set of DIMMs.
