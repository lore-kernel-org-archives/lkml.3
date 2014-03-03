Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaCCXXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:23:21 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:27402 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbaCCXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:23:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao1uAPQNFVN5LJYePGdsb2JhbABagwaDQ4UMs0mFWYEeFwMBAQEBHxkNKIIlAQEFOhwjEAgDGAklDwUlAwcaE4d4zGYXFo5DB4MkgRQBA5g7ilWLGCg
Date: Tue, 4 Mar 2014 10:17:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs] f876e446: +1.2% fileio.requests_per_sec
Message-ID: <20140303231740.GA6851@dastard>
References: <20140303142151.GA7935@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303142151.GA7935@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 10:21:51PM +0800, Fengguang Wu wrote:
> Hi Dave,
> 
> We noticed the below changes on commit f876e44603ad091c840a5fae5b0753bbb421c037
> ("xfs: always do log forces via the workqueue"):
> 
> Basically there are +1.2% increased throughput with +29.5% increased
> context switches.

Yes, the increase in context switches is expected. Every sync IO
causes a log force if it changed inode metadata, and the above
commit, as it describes, moves them to a work queue. Hence there's
more context switches involved in a log force that has to do work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
