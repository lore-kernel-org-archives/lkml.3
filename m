Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973Ab3ARILh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:11:37 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39856 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3ARILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:11:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYNAFAC+VB5LBTV/2dsb2JhbABFuBaGHRdzgh4BAQQBOhwjBQsIAw4KCSUPBSUDIRMZh3oFvAIVkSQDlguJToZ8gwk
Date: Fri, 18 Jan 2013 19:11:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
Message-ID: <20130118081133.GQ2498@dastard>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
 <1354058086-27937-10-git-send-email-david@fromorbit.com>
 <50F6FDC8.5020909@parallels.com>
 <20130116225521.GF2498@dastard>
 <50F7475F.90609@parallels.com>
 <20130117042245.GG2498@dastard>
 <50F84118.7030608@parallels.com>
 <20130118001029.GK2498@dastard>
 <50F893D2.7080103@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F893D2.7080103@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:14:10PM -0800, Glauber Costa wrote:
> On 01/17/2013 04:10 PM, Dave Chinner wrote:
> > And then each object uses:
> > 
> > struct lru_item {
> > 	struct list_head global_list;
> > 	struct list_head memcg_list;
> > }
> by objects you mean dentries, inodes, and the such, right?

Yup.

> Would it be acceptable to you?

If it works the way I think it should, then yes.

> We've been of course doing our best to avoid increasing the size of the
> objects, therefore this is something we've never mentioned. However, if
> it would be acceptable from the fs POV, this would undoubtedly make our
> life extremely easier.

I've been trying hard to work out how to avoid increasing the size
of structures as well. But if we can't work out how to implement
something sanely with only a single list head per object to work
from, then increasing the size of objects is something that we need
to consider if it solves all the problems we are trying to solve.

i.e. if adding a second list head makes the code dumb, simple,
obviously correct and hard to break then IMO it's a no-brainer.
But we have to tick all the right boxes first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
