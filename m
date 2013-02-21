Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3BUXib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:38:31 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21498 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741Ab3BUXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:38:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnIJAG6vJlF5LJe7/2dsb2JhbABFhWW2HIURgQUXc4IfAQEFOhwjEAgDGAklDwUlAyETiBG/LhWOGiI9B4NAA5Y1kF+DGw
Date: Fri, 22 Feb 2013 10:38:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
Message-ID: <20130221233818.GM26694@dastard>
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 01:50:55PM -0500, Waiman Long wrote:
> It was found that the Oracle database software issues a lot of call
> to the seq_path() kernel function which translates a (dentry, mnt)
> pair to an absolute path. The seq_path() function will eventually
> take the following two locks:

Nobody should be doing reverse dentry-to-name lookups in a quantity
sufficient for it to become a performance limiting factor. What is
the Oracle DB actually using this path for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
