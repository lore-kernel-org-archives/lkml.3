Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbaJ1HPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:15:10 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48814 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbaJ1HPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:15:07 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 28 Oct 2014 16:16:25 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm, compaction: pass classzone_idx and alloc_flags
 to watermark checking
Message-ID: <20141028071625.GB27813@js1304-P5Q-DELUXE>
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz>
 <1412696019-21761-2-git-send-email-vbabka@suse.cz>
 <20141027064651.GA23379@js1304-P5Q-DELUXE>
 <544E0C43.3030009@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E0C43.3030009@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:11:31AM +0100, Vlastimil Babka wrote:
> On 10/27/2014 07:46 AM, Joonsoo Kim wrote:
> > On Tue, Oct 07, 2014 at 05:33:35PM +0200, Vlastimil Babka wrote:
> > 
> > Hello,
> > 
> > compaction_suitable() has one more zone_watermark_ok(). Why is it
> > unchanged?
> 
> Hi,
> 
> it's a check whether there are enough free pages to perform compaction,
> which means enough migration targets and temporary copies during
> migration. These allocations are not affected by the flags of the
> process that makes the high-order allocation.

Hmm...

To check whether enough free page is there or not needs zone index and
alloc flag. What we need to ignore is just order information, IMO.
If there is not enough free page in that zone, compaction progress
doesn't have any meaning. It will fail due to shortage of free page
after successful compaction.

I guess that __isolate_free_page() is also good candidate to need this
information in order to prevent compaction from isolating too many
freepage in low memory condition.

Thanks.
