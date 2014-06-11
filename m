Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaFKFnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:43:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61590 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaFKFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:43:40 -0400
Message-ID: <1402465419.3645.453.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2] vmalloc: use rcu list iterator to reduce
 vmap_area_lock contention
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>
Date: Tue, 10 Jun 2014 22:43:39 -0700
In-Reply-To: <5397CDC3.1050809@hurleysoftware.com>
References: <1402453146-10057-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <5397CDC3.1050809@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 23:32 -0400, Peter Hurley wrote:

> While rcu list traversal over the vmap_area_list is safe, this may
> arrive at different results than the spinlocked version. The rcu list
> traversal version will not be a 'snapshot' of a single, valid instant
> of the entire vmap_area_list, but rather a potential amalgam of
> different list states.
> 
> This is because the vmap_area_list can continue to change during
> list traversal.


As soon as we exit from get_vmalloc_info(), information can be obsolete
anyway, especially if we held a spinlock for the whole list traversal.

So using the spinlock is certainly not protecting anything in this
regard.



