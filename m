Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3HWVV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:21:28 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55864 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3HWVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:21:27 -0400
Date: Sat, 24 Aug 2013 00:20:21 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Leon Ma <xindong.ma@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ccross@android.com
Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
Message-ID: <20130823212021.GA2248@swordfish.minsk.epam.com>
References: <1377049265.22148.7.camel@leonma-sh>
 <20130823164810.GA25863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823164810.GA25863@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/23/13 09:48), Greg KH wrote:
> Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
> User-Agent: Mutt/1.5.21 (2010-09-15)
> 
> On Wed, Aug 21, 2013 at 09:41:05AM +0800, Leon Ma wrote:
> > From: Leon Ma <xindong.ma@intel.com>
> > Date: Mon, 19 Aug 2013 14:22:38 +0800
> > Subject: [PATCH] LMK: Optimize lowmem_shrink.
> 
> Why is all of this in the patch body?
> 
> And what does "LMK:" stand for?
>
> > By comparing with selected_oom_score_adj instead of min_score_adj,
> > we may do less calculation.
> 
> What does this change?  Does it fix a problem?

Hello,

linux-next since

	c95dd63d4cc3647643ff502d70c4c1b52947c770
	Author: Dave Chinner <dchinner@redhat.com>
	Date:   Fri Aug 16 09:39:54 2013 +1000

	drivers: convert shrinkers to new count/scan API

does not contain lowmem_shrink(), but lowmem_scan() instead. plus at lest
one more patch on top of it (e2bfaf75e763396b7baa7c1effa4053d7f19e6d3):

[..]
-static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)

+static long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
[..]

wouldn't it be better to have the patch against -next in this case (in
case it fixes anything)?

thanks,
	-ss

> thanks,
> 
> greg k-h
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
