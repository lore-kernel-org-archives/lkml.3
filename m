Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaJXDzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:55:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46079 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaJXDzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:55:16 -0400
Date: Thu, 23 Oct 2014 23:55:11 -0400 (EDT)
Message-Id: <20141023.235511.1672975903756808524.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        steve.capper@linaro.org, aarcange@redhat.com, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH V2 1/2] mm: Update generic gup implementation to handle
 hugepage directory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414107635.364.91.camel@pasglop>
References: <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
	<20141023.184035.388557314666522484.davem@davemloft.net>
	<1414107635.364.91.camel@pasglop>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 20:55:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 24 Oct 2014 10:40:35 +1100

> Another option would be to make the generic code use something defined
> by the arch to decide whether to use speculative get or
> not. I like the idea of keeping the bulk of that code generic...

Me too.  We could have inlines that do either speculative or
non-speculative gets on the pages in some header file and hide
the ifdefs in there.
