Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAXKOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:14:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaAXKOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:14:21 -0500
Date: Fri, 24 Jan 2014 10:14:16 +0000
From: Mel Gorman <mgorman@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        grawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-ID: <20140124101416.GP4963@suse.de>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
 <20140123103606.GU1574@moon>
 <20140123121555.GV1574@moon>
 <20140123125543.GW1574@moon>
 <20140123151445.GX1574@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140123151445.GX1574@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 07:14:45PM +0400, Cyrill Gorcunov wrote:
> On Thu, Jan 23, 2014 at 04:55:43PM +0400, Cyrill Gorcunov wrote:
> > On Thu, Jan 23, 2014 at 04:15:55PM +0400, Cyrill Gorcunov wrote:
> > > > 
> > > > Thanks a lot, Mel! I'm testing the patch as well (manually though :).
> > > > I'll send the final fix today.
> > > 
> > > The patch below should fix the problem. I would really appreaciate
> > > some additional testing.
> > 
> > Forgot to refresh the patch, sorry.
> > ---
> 
> I think setting up dirty bit inside vma_merge() body is a big hammer
> which should not be used, but it's up to caller of vma_merge() to figure
> out if dirty bit should be set or not if merge successed. Thus softdirty
> vma bit should be (and it already is) set at the end of mmap_region and do_brk
> routines. So patch could be simplified (below). Pavel, what do you think?
> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
> 

It passed the gimp launching test. Patch looks sane but I confess I did
not put a whole lot of thought into it because I see that Andrew is
already reviewing it so

Tested-by: Mel Gorman <mgorman@suse.de>

If this is merged then remember that it should be tagged for 3.12-stable
as 3.12.7 and 3.12.8 are affected by this bug.

-- 
Mel Gorman
SUSE Labs
