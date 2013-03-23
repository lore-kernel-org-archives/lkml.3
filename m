Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423289Ab3CWDAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422997Ab3CWDAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:00:49 -0400
Date: Sat, 23 Mar 2013 03:00:44 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: dm-cache fails to write the cache
	device in writethrough mode
Message-ID: <20130323030043.GA30269@agk-dp.fab.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
	Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 01:11:51PM -0700, Darrick J. Wong wrote:
> The new writethrough strategy for dm-cache issues a bio to the origin device,
> remaps the bio to the cache device, and issues the bio to the cache device.
> However, the block layer modifies bi_sector and bi_size, so we need to preserve
> these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> problem where someone writes a block through the cache, but a subsequent reread
> (from the cache) returns old contents.

If this needs doing here, please use dm_bio_record() and dm_bio_restore().
E.g. Look at how dm-raid1.c does something similar.
 
Alasdair

