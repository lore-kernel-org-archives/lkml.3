Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaAWKau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:30:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaAWKat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:30:49 -0500
Date: Thu, 23 Jan 2014 10:30:44 +0000
From: Mel Gorman <mgorman@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140123103044.GE4963@suse.de>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140122223325.GA30637@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:33:25AM +0400, Cyrill Gorcunov wrote:
> On Wed, Jan 22, 2014 at 11:19:28PM +0400, Cyrill Gorcunov wrote:
> > > commit. Test case was simple -- try and open the large file described in
> > > the bug. I did not investigate the patch itself as I'm just reporting
> > > the results of the bisection. If I had to guess, I'd say that VMA
> > > merging has been affected.
> > 
> > Thanks a lot for report, Mel! I'm investigating...
> 
> Mel, here is a quick fix for bring merging back (just in case if you
> have a minute to test it and confirm the merging were affected). It
> seems I've lost setting up vma-softdirty bit somewhere and procedure
> which tests vma flags mathcing fails, will continue investigating/testing
> tomorrow.

The test case passes with this patch applied to 3.13 so that appears
to confirm that this is related to VM_SOFTDIRTY preventing merges.
Unfortunately I did not have slabinfo tracking enabled to double check
the number of vm_area_structs in teh system.

-- 
Mel Gorman
SUSE Labs
