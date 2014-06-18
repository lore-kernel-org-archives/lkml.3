Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbaFRJMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:12:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45580 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbaFRJLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:11:41 -0400
Message-ID: <1403082532.9368.4.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
From: Chen Yucong <slaoub@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, mgorman@suse.de,
        hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 17:08:52 +0800
In-Reply-To: <53A15544.2010505@redhat.com>
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
	 <53A15544.2010505@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 11:00 +0200, Jerome Marchand wrote:
> >               if (!nr_file || !nr_anon)
> >                       break;
> >  
> > -             if (nr_file > nr_anon) {
> > -                     unsigned long scan_target =
> targets[LRU_INACTIVE_ANON] +
> >
> -                                             targets[LRU_ACTIVE_ANON]
> + 1;
> > +             file_percent = nr_file * 100 / file_target;
> > +             anon_percent = nr_anon * 100 / anon_target;
> 
> Here it could happen.
> 
> 
The snippet 
	...
               if (!nr_file || !nr_anon)
                      break;
        ...
 can help us to filter the situation which you have described. It comes
from Mel's patch that is called:

mm: vmscan: use proportional scanning during direct reclaim and full
scan at DEF_PRIORITY

thx!
cyc

