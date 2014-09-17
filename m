Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaIQMzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:55:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36169 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbaIQMzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:55:37 -0400
Date: Wed, 17 Sep 2014 14:55:26 +0200
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
Message-ID: <20140917125526.GA5463@nazgul.tnic>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <5417F228.9060301@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5417F228.9060301@sr71.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:17:44AM -0700, Dave Hansen wrote:
> >> This also fixes sysfs because CPUs with the same 'physical_package_id'
> >> in /sys/devices/system/cpu/cpu*/topology/ are not listed together
> >> in the same 'core_siblings_list'.  This violates a statement from
> >> Documentation/ABI/testing/sysfs-devices-system-cpu:
> >>
> >> 	core_siblings: internal kernel map of cpu#'s hardware threads
> >> 	within the same physical_package_id.
> >>
> >> 	core_siblings_list: human-readable list of the logical CPU
> >> 	numbers within the same physical_package_id as cpu#.
> > 
> > No that statement is wrong; it assumes physical_package_id is a good
> > identifier for nodes. Clearly this is no longer true.
> 
> I went back and re-read the text around there.  I don't see any mention
> of nodes or NUMA.  It's just talking about the topology within the CPU
> from what I can tell.
> 
> Good thing it's just in "Documentation/ABI/testing/" I guess.
> 
> Either way, are you saying that a core's "physical_package_id" should
> depend on what BIOS options get set, and that different cores in the
> same physical package should have different "physical_package_id"s?

This sounds misleading to me. If I would have to explain how I
understand physical_package_id, I'd say it is the physical piece of
silicon containing the core. Which is consistent with what Peter says
that using it to identify NUMA nodes is wrong.

Btw, I'm trying to get on an AMD MCM box to dump those fields but it is
kinda hard currently. Will report back once I have something...

-- 
Regards/Gruss,
    Boris.
--
