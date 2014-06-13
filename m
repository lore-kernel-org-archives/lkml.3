Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaFMFXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:23:54 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44675 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaFMFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:23:53 -0400
Message-ID: <1402636875.1232.13.camel@debian>
Subject: Re: [PATCH v2] mm/vmscan.c: wrap five parameters into
 shrink_result for reducing the stack consumption
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgorman@suse.de, hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140612214016.1beda952.akpm@linux-foundation.org>
References: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
	 <20140612214016.1beda952.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 13:21:15 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 21:40 -0700, Andrew Morton wrote:
> On Fri, 13 Jun 2014 12:36:31 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > @@ -1148,7 +1146,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
> >  		.priority = DEF_PRIORITY,
> >  		.may_unmap = 1,
> >  	};
> > -	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
> > +	unsigned long ret;
> > +	struct shrink_result dummy = { };
> 
> You didn't like the idea of making this static?
Sorry! It's my negligence.
If we make dummy static, it can help us save more stack.

without change:  
0xffffffff810aede8 reclaim_clean_pages_from_list []:	184
0xffffffff810aeef8 reclaim_clean_pages_from_list []:	184

with change: struct shrink_result dummy = {};
0xffffffff810aed6c reclaim_clean_pages_from_list []:	152
0xffffffff810aee68 reclaim_clean_pages_from_list []:	152

with change: static struct shrink_result dummy ={};
0xffffffff810aed69 reclaim_clean_pages_from_list []:	120
0xffffffff810aee4d reclaim_clean_pages_from_list []:	120

thx!
cyc

