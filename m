Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaC2NOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 09:14:39 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35138 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaC2NOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 09:14:38 -0400
Date: Sat, 29 Mar 2014 09:14:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/percpu.c: don't bother to re-walk the pcpu_slot
 list if nobody free space since we last drop pcpu_lock
Message-ID: <20140329131434.GB5553@htj.dyndns.org>
References: <1396011357-21560-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396011357-21560-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:55:57PM +0800, Jianyu Zhan wrote:
> Quoted tj: 
> >Hmmm... I'm not sure whether the added complexity is worthwhile.  It's
> >a fairly cold path.  Can you show how helpful this optimization is?
> 
> The patch is quite less intrusive in the normal path
> and if we fall on the cold path, it means after satifying this allocation 
> the chunk may be moved to lower slot, and the follow-up allocation 
> of same or larger size(though rare) is likely to fail to cold path again. So
> this patch could be based on to do some heuristic later.

The above really doesn't show how helpful it is.  This adds complexity
to optimize what seemingly is a quite cold path, which often is a
pretty bad idea as they tend to trade off readability and long term
maintainability for almost non-existing actual gain.  If you think
this is a worthwhile optimization, please give justifications - use
scenarios, performance numbers and so on.

Thanks.

-- 
tejun
