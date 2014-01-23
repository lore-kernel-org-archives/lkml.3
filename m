Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaAWKgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:36:18 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:64906 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaAWKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:36:11 -0500
Date: Thu, 23 Jan 2014 14:36:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140123103606.GU1574@moon>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123095541.GD4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:55:41AM +0000, Mel Gorman wrote:
> On Thu, Jan 23, 2014 at 02:33:25AM +0400, Cyrill Gorcunov wrote:
> > On Wed, Jan 22, 2014 at 11:19:28PM +0400, Cyrill Gorcunov wrote:
> > > > commit. Test case was simple -- try and open the large file described in
> > > > the bug. I did not investigate the patch itself as I'm just reporting
> > > > the results of the bisection. If I had to guess, I'd say that VMA
> > > > merging has been affected.
> > > 
> > > Thanks a lot for report, Mel! I'm investigating...
> > 
> > Mel, here is a quick fix for bring merging back (just in case if you
> > have a minute to test it and confirm the merging were affected). It
> > seems I've lost setting up vma-softdirty bit somewhere and procedure
> > which tests vma flags mathcing fails, will continue investigating/testing
> > tomorrow.
> 
> The test case passes with this patch applied to 3.13 so that appears
> to confirm that this is related to VM_SOFTDIRTY preventing merges.
> Unfortunately I did not have slabinfo tracking enabled to double check
> the number of vm_area_structs in teh system.

Thanks a lot, Mel! I'm testing the patch as well (manually though :).
I'll send the final fix today.
