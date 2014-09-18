Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaIRHch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:32:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44662 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbaIRHce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:32:34 -0400
Date: Thu, 18 Sep 2014 09:32:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, hpa@linux.intel.com, ak@linux.intel.com,
        Alex Chiang <achiang@hp.com>, Borislav Petkov <bp@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140918073224.GC24842@nazgul.tnic>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <5417F228.9060301@sr71.net>
 <20140917125526.GA5463@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140917125526.GA5463@nazgul.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:55:26PM +0200, Borislav Petkov wrote:
> This sounds misleading to me. If I would have to explain how I
> understand physical_package_id, I'd say it is the physical piece of
> silicon containing the core. Which is consistent with what Peter says
> that using it to identify NUMA nodes is wrong.
> 
> Btw, I'm trying to get on an AMD MCM box to dump those fields but it is
> kinda hard currently. Will report back once I have something...

Ok, so Brice sent me some AMD MCM data from a 4-socket box.
physical_package_id there really denotes the physical package, i.e.
silicon, i.e. physical socket which contains a core.

So on a 4-socket, 16 cores on each machine, you have:

	   physical_package_id
cpu0-15 :  0
cpu16-31:  1
cpu32-47:  2
cpu48-63:  3

which all looks nicely regular and clean.

core_siblings mirrors exactly that too, so you don't see the internal
nodes from that either, i.e:

cpu0/topology/core_siblings_list:0-15
...
cpu16/topology/core_siblings_list:16-31
...
cpu32/topology/core_siblings_list:32-47
...
cpu50/topology/core_siblings_list:48-63

-- 
Regards/Gruss,
    Boris.
--
