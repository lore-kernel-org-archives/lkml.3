Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3DWBxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:53:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53218 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3DWBxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:53:52 -0400
X-AuditID: 9c93016f-b7c87ae000002520-91-5175e9ae52e2
Date: Tue, 23 Apr 2013 10:53:49 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 6/6] add documentation on proc.txt
Message-ID: <20130423015349.GC2603@blaptop>
References: <1366620306-30940-1-git-send-email-minchan@kernel.org>
 <1366620306-30940-6-git-send-email-minchan@kernel.org>
 <51756286.4020704@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51756286.4020704@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Mon, Apr 22, 2013 at 09:17:10AM -0700, Dave Hansen wrote:
> On 04/22/2013 01:45 AM, Minchan Kim wrote:
> > +The /proc/PID/reclaim is used to reclaim pages in this process.
> > +To reclaim file-backed pages,
> > +    > echo 1 > /proc/PID/reclaim
> > +
> > +To reclaim anonymous pages,
> > +    > echo 2 > /proc/PID/reclaim
> > +
> > +To reclaim both pages,
> > +    > echo 3 > /proc/PID/reclaim
> 
> This seems to be in the same spirit as /proc/sys/vm/drop_caches.  That's
> not a sin in and of itself.  But, why use numbers here?
> 
> Any chance I could talk you in to using some strings, say like:
> 
> 	echo 'anonymous' > /proc/PID/reclaim
> 	echo 'anonymous|file' > /proc/PID/reclaim

I discussed with Namhyung about interface.
His suggestion looks sane to me.

echo 'file' > /proc/PID/reclaim
echo 'anon' > /proc/PID/reclaim
echo 'both' > /proc/PID/reclaim

For range reclaim,

echo $((1<<20)) 8192 > /proc/PID/reclaim.

IOW, we don't need any type for range reclaim because only thing
user takes care is address range which has mapped page regardless
of that it's anon or file.

Does it make sense to you?

-- 
Kind regards,
Minchan Kim
