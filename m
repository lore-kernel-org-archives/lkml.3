Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaFKDXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:23:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53950 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaFKDXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:23:03 -0400
Message-ID: <1402456897.28433.46.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgorman@suse.de, mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 11:21:37 +0800
In-Reply-To: <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
	 <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 16:33 -0700, Andrew Morton wrote:
> >                       break;
> >  
> >               if (nr_file > nr_anon) {
> > -                     unsigned long scan_target =
> targets[LRU_INACTIVE_ANON] +
> >
> -                                             targets[LRU_ACTIVE_ANON]
> + 1;
> > +                     nr_to_scan = nr_file - ratio * nr_anon;
> > +                     percentage = nr[LRU_FILE] * 100 / nr_file;
> 
> here, nr_file and nr_anon are derived from the contents of nr[].  But
> nr[] was modified in the for_each_evictable_lru() loop, so its
> contents
> now may differ from what was in targets[]? 

nr_to_scan is used for recording the number of pages that should be
scanned to keep original *ratio*.

We can assume that the value of (nr_file > nr_anon) is true, nr_to_scan
should be distribute to nr[LRU_ACTIVE_FILE] and nr[LRU_INACTIVE_FILE] in
proportion.

    nr_file = nr[LRU_ACTIVE_FILE] + nr[LRU_INACTIVE_FILE];
    percentage = nr[LRU_FILE] / nr_file;

Note that in comparison with *old* percentage, the "new" percentage has
the different meaning. It is just used to divide nr_so_scan pages
appropriately.

thx!
cyc     

