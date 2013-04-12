Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3DLTS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:18:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3DLTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:18:26 -0400
Date: Fri, 12 Apr 2013 15:18:24 -0400 (EDT)
Message-Id: <20130412.151824.2029469075886743722.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, dcbw@redhat.com
Subject: Re: [PATCH] net: usb: active URB submitted multiple times
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1304112156520.4309@fry>
References: <20130410.232241.1038793023507666278.davem@davemloft.net>
	<alpine.DEB.2.02.1304110956110.4237@fry>
	<alpine.DEB.2.02.1304112156520.4309@fry>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 12:18:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Thu, 11 Apr 2013 22:00:59 +0300 (EEST)

> From: Petko Manolov <petkan@nucleusys.com>
> 
> (For inclusion in 3.10, diff against latest net-next.)
> 
> Pegasus driver used single callback for sync and async control URBs. 
> Special flags were employed to distinguish between both, but due to flawed 
> logic (as Sarah Sharp spotted) it didn't always work.  As a result of this 
> change [get|set]_registers() are now much simpler.  Async write is also 
> leaner and does not use single, statically allocated memory for 
> usb_ctrlrequest, which is another potential race when asynchronously 
> submitting URBs.
> 
> The socket buffer pool for the receive path is now gone.  It's existence 
> didn't make much difference (performance-wise) and the code is better off 
> without the spinlocks protecting it.
> 
> Largely duplicated code in routines reading and writing MII registers is 
> now packed in __mii_op().
> 
> Adding URL for the public pegasus git repository.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

When submitting a new version of a patch, you must list what
changed from the previous version after the "---" delimiter
rather than having people try and guess.

> +T:	git git://petkan@git.code.sf.net/p/pegasus2/git

There is no way that specifying your GIT login in this URL
meant for public use is correct, or is it?
