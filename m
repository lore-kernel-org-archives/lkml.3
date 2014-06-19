Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaFSAHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:07:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40548 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbaFSAHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:07:13 -0400
Message-ID: <1403136272.12954.4.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, mhocko@suse.cz,
        riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 08:04:32 +0800
In-Reply-To: <20140618152751.283deda95257cc32ccea8f20@linux-foundation.org>
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
	 <20140618152751.283deda95257cc32ccea8f20@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 15:27 -0700, Andrew Morton wrote:
> On Tue, 17 Jun 2014 12:55:02 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a8ffe4e..2c35e34 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2087,8 +2086,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  	blk_start_plug(&plug);
> >  	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
> >  					nr[LRU_INACTIVE_FILE]) {
> > -		unsigned long nr_anon, nr_file, percentage;
> > -		unsigned long nr_scanned;
> > +		unsigned long nr_anon, nr_file, file_percent, anon_percent;
> > +		unsigned long nr_to_scan, nr_scanned, percentage;
> >  
> >  		for_each_evictable_lru(lru) {
> >  			if (nr[lru]) {
> 
> The increased stack use is a slight concern - we can be very deep here.
> I suspect the "percent" locals are more for convenience/clarity, and
> they could be eliminated (in a separate patch) at some cost of clarity?
> 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a8ffe4e..2c35e34 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2057,8 +2057,7 @@ out:
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control
*sc)
 {
        unsigned long nr[NR_LRU_LISTS];
-       unsigned long targets[NR_LRU_LISTS];
-       unsigned long nr_to_scan;
+       unsigned long file_target, anon_target;

>From the above snippet, we can know that the "percent" locals come from
targets[NR_LRU_LISTS]. So this fix does not increase the stack.

thx!
cyc


