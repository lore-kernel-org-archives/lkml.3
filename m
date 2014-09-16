Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaIPQBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:01:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaIPQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:01:40 -0400
Date: Tue, 16 Sep 2014 18:01:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916160134.GB2848@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <20140916013845.390833b9@as>
 <20140916064403.GC14807@gmail.com>
 <20140916020300.5013b8f0@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916020300.5013b8f0@as>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 02:03:00AM -0500, Chuck Ebbert wrote:
> Hmm, looking closer at the diagram, each ring has its own memory controller, so
> it really is NUMA if you break the interconnect between that caches.

How does it do that? Does it split the DIMM slots in two as well, with
half for the one node and the other half for the other? Or will both
'nodes' share the same local memory?

In the first case its full NUMA, in the second case, not so much.
