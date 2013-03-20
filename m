Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3CTSnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:43:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3CTSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:43:44 -0400
Date: Wed, 20 Mar 2013 14:43:41 -0400 (EDT)
Message-Id: <20130320.144341.680730923044605208.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: x86@kernel.org, akpm@linux-foundation.org, ben@decadent.org.uk,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] sparse-vmemmap: specify vmemmap population range
 in bytes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363802612-32127-3-git-send-email-hannes@cmpxchg.org>
References: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
	<1363802612-32127-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Mar 2013 11:43:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 20 Mar 2013 14:03:29 -0400

> The sparse code, when asking the architecture to populate the vmemmap,
> specifies the section range as a starting page and a number of pages.
> 
> This is an awkward interface, because none of the arch-specific code
> actually thinks of the range in terms of 'struct page' units and
> always translates it to bytes first.
> 
> In addition, later patches mix huge page and regular page backing for
> the vmemmap.  For this, they need to call vmemmap_populate_basepages()
> on sub-section ranges with PAGE_SIZE and PMD_SIZE in mind.  But these
> are not necessarily multiples of the 'struct page' size and so this
> unit is too coarse.
> 
> Just translate the section range into bytes once in the generic sparse
> code, then pass byte ranges down the stack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Boot tested on sparc64:

Acked-by: David S. Miller <davem@davemloft.net>
