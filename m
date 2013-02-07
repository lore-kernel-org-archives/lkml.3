Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3BGQcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:32:54 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:40427 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:32:52 -0500
Date: Thu, 7 Feb 2013 08:32:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 37/77] i2c: convert to idr_alloc()
Message-ID: <20130207163247.GL2875@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207152831.GA14797@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 07, 2013 at 03:28:31PM +0000, Mark Brown wrote:
> On Wed, Feb 06, 2013 at 11:40:09AM -0800, Tejun Heo wrote:
> > Convert to the much saner new idr interface.
> > 
> > Only compile tested.
> 
> This broke I2C for me in -next today, I saw a spinlock bad magic error
> calling pm_runtime_enable().  

Hmmm... weird, can't see where the difference in behavior would come
from.  The only material difference would be if id < 0 && id != -1 in
i2c_add_numbered_adapter(), which now would trigger WARN_ON_ONCE()
inside idr_alloc() instead of silently returning -EINVAL.

Can you please elaborate the failure?  I can't see how the idr
conversion would lead to spinlock bad magic error.  Does reverting
this patch make the problem go away?

Thanks.

--
tejun
