Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaFMORM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:17:12 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35340 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaFMORL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:17:11 -0400
Date: Fri, 13 Jun 2014 10:17:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, mhocko@suse.cz,
        riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] mm/vmscan.c: wrap five parameters into
 writeback_stats for reducing the stack consumption
Message-ID: <20140613141700.GO2878@cmpxchg.org>
References: <1402639088-4845-1-git-send-email-slaoub@gmail.com>
 <1402667259.6072.20.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402667259.6072.20.camel@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:47:39PM +0800, Chen Yucong wrote:
> Hi all,
> 
> On Fri, 2014-06-13 at 13:58 +0800, Chen Yucong wrote:
> > shrink_page_list() has too many arguments that have already reached ten.
> > Some of those arguments and temporary variables introduces extra 80 bytes
> > on the stack. This patch wraps five parameters into writeback_stats and removes
> > some temporary variables, thus making the relative functions to consume fewer
> > stack space.
> > 
> I this message, I have renamed shrink_result to writeback_stats
> according to Johannes Weiner's reply. Think carefully, this change is
> too hasty. Although it now just contains statistics on the writeback
> states of the scanned pages, it may also be used for gathering other
> information at some point in the future. So I think shrink_result is a
> little bit better!

Then we can always rename it "at some point in the future", the name
is not set in stone.  At this time, it only contains writeback stats,
and I think it should be named accordingly.
