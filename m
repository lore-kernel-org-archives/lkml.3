Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3LCXy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:54:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab3LCXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:54:55 -0500
Date: Tue, 3 Dec 2013 23:54:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/15] mm: numa: Serialise parallel get_user_page against
 THP migration
Message-ID: <20131203235452.GT11295@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
 <1386060721-3794-5-git-send-email-mgorman@suse.de>
 <529E6447.4030304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <529E6447.4030304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:07:51PM -0500, Rik van Riel wrote:
> On 12/03/2013 03:51 AM, Mel Gorman wrote:
> 
> > +
> > +	if (page_count(page) != 2) {
> > +		set_pmd_at(mm, mmun_start, pmd, orig_entry);
> > +		flush_tlb_range(vma, mmun_start, mmun_end);
> 
> The mmun_start and mmun_end variables are introduced in patch 5.
> 

Thanks, fixed now.

-- 
Mel Gorman
SUSE Labs
