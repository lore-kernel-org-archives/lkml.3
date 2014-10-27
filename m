Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaJ0JLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:11:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaJ0JLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:11:37 -0400
Message-ID: <544E0C43.3030009@suse.cz>
Date: Mon, 27 Oct 2014 10:11:31 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm, compaction: pass classzone_idx and alloc_flags
 to watermark checking
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-2-git-send-email-vbabka@suse.cz> <20141027064651.GA23379@js1304-P5Q-DELUXE>
In-Reply-To: <20141027064651.GA23379@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 07:46 AM, Joonsoo Kim wrote:
> On Tue, Oct 07, 2014 at 05:33:35PM +0200, Vlastimil Babka wrote:
> 
> Hello,
> 
> compaction_suitable() has one more zone_watermark_ok(). Why is it
> unchanged?

Hi,

it's a check whether there are enough free pages to perform compaction,
which means enough migration targets and temporary copies during
migration. These allocations are not affected by the flags of the
process that makes the high-order allocation.

> Thanks.
> 

