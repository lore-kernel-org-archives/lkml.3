Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaF3V7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:59:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaF3V7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:59:42 -0400
Date: Mon, 30 Jun 2014 22:59:38 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: replace init_page_accessed by __SetPageReferenced
Message-ID: <20140630215938.GR10819@suse.de>
References: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
 <alpine.LSU.2.11.1406301408310.1096@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406301408310.1096@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 02:09:49PM -0700, Hugh Dickins wrote:
> Do we really need an exported alias for __SetPageReferenced()?
> Its callers better know what they're doing, in which case the page
> would not be already marked referenced.  Kill init_page_accessed(),
> just __SetPageReferenced() inline.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Ok, fair enough. The context it was written in was that callers should not
need to know the internals of what mark_page_accessed does. Initially I
thought there might be filesystem users that really should not know the
internals but that is not necessary obviously. I still feel that
init_page_accessed shows the intent more clearly and you're certainly
right that the checking PageReferenced is redundant. I don't object to
the patch but I don't think it's obviously better either other than it
avoids the temptation of anyone using __SetPageReferenced incorrectly.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
