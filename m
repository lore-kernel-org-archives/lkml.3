Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaHSLbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:31:52 -0400
Received: from 8bytes.org ([81.169.241.247]:43983 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbaHSLbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:31:51 -0400
Date: Tue, 19 Aug 2014 13:31:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] iommu: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140819113147.GC26492@8bytes.org>
References: <20140818122056.GA29961@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818122056.GA29961@ada>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 03:20:56PM +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

Applied, thanks.

