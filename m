Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab3FSTi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:38:58 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41144 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094Ab3FSTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:38:57 -0400
Date: Wed, 19 Jun 2013 21:38:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v14
Message-ID: <20130619193855.GY6123@two.firstfloor.org>
References: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
 <20130619124822.GC11209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619124822.GC11209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, this series looks good at first sight: you've slightly overdone the 
> checkpatch style changes without checking that the result is actually an 
> improvement - I've fixed those few places.
> 
> I'll give it a bit of testing.

Thanks for testing and merging.

I still have some other patches to enable other features,
on top of this.

I'll repost them in hopefully logical groups. 

If you want them grouped in some particular way or other
requirements please let me know.

https://git.kernel.org/cgit/linux/kernel/git/ak/linux-misc.git/log/?h=hsw/pmu6

FWIW the outstanding patches do:

- Some changes to make CPU event aliases more user friendly:

print aliases in perf list, avoid the need to specify cpu//,
automatically enable PEBS for mem-loads/stores,
Allow aliases to specify "precise"

This is all not Haswell specific, but makes
the TSX changes below a lot more user friendly.

Most of this is actually user mode only, except for the
"precise" alias changes.

- TSX changes: perf stat -T, TSX event aliases, support for 
reporting the abort cause from PEBS, plus the user tools
support for all of this

- Full width counting (generally useful, but also avoids
a TSX checkpoint problem)

- Support TSX filtering in the the LBR, plus a workaround
for the duplicated abort record.

Plus also on top (not in my git tree):

- Zheng's call graph lbr mode patches, to allow user mode -g without
frame pointers or full dwarf. This has a few known problems, but is still
useful enough that it should be available as a option.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
