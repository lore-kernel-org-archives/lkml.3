Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3GASTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:19:47 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:58669 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab3GASTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:19:44 -0400
Date: Mon, 1 Jul 2013 18:19:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH] mm, slab: Drop unnecessary slabp->inuse < cachep->num
 test
In-Reply-To: <51D1AE84.8010404@gmail.com>
Message-ID: <0000013f9b76364e-6d24303e-93bc-425d-9933-710b0587b56b-000000@email.amazonses.com>
References: <51D1AE84.8010404@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, Zhang Yanfei wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>
> In function cache_alloc_refill, we have used BUG_ON to ensure
> that slabp->inuse is less than cachep->num before the while
> test. And in the while body, we do not change the value of
> slabp->inuse and cachep->num, so it is not necessary to test
> if slabp->inuse < cachep->num test for every loop.

The body calls slab_get_obj which changes slabp->inuse!
