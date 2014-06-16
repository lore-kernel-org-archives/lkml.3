Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaFPXuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:50:52 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50486 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaFPXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:50:51 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 17 Jun 2014 08:51:17 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Yucong <slaoub@gmail.com>, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
Message-ID: <20140616235117.GD18790@bbox>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
 <1402923474.3958.34.camel@debian>
 <20140616164237.5fcba7baaec83d509c9683e0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616164237.5fcba7baaec83d509c9683e0@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:42:37PM -0700, Andrew Morton wrote:
> On Mon, 16 Jun 2014 20:57:54 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > On Mon, 2014-06-09 at 21:27 +0800, Chen Yucong wrote:
> > > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > > original scan targets introduces extra 40 bytes on the stack. This patch
> > > is able to avoid this situation and the call to memcpy(). At the same time,
> > > it does not change the relative design idea.
> > > 
> > > ratio = original_nr_file / original_nr_anon;
> > > 
> > > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> > >  x = nr_file - ratio * nr_anon;
> > > 
> > > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> > >  x = nr_anon - nr_file / ratio;
> > > 
> > Hi Andrew Morton,
> > 
> > I think the patch
> >  
> > [PATCH]
> > mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch
> > 
> > which I committed should be discarded.
> 
> OK, thanks.
> 
> I assume you're referring to
> mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch

True.

-- 
Kind regards,
Minchan Kim
