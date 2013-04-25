Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3DYF1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:27:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48087 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3DYF1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:27:48 -0400
Date: Thu, 25 Apr 2013 01:27:46 -0400 (EDT)
Message-Id: <20130425.012746.827018439951615849.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: active URB submitted multiple times
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1304191115230.4161@fry.nucleusys.com>
References: <20130412.151824.2029469075886743722.davem@davemloft.net>
	<alpine.DEB.2.02.1304151017230.3010@bender.nucleusys.com>
	<alpine.DEB.2.02.1304191115230.4161@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Apr 2013 22:27:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Fri, 19 Apr 2013 11:21:49 +0300 (EEST)

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

Three completely unrelated changes combined into one patch, split this
up properly into three distinct changes, and resubmit them as a series
with a "[PATCH 0/N]" initial posting.
