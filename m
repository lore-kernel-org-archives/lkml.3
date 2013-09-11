Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3IKOjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:39:25 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:49774 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab3IKOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:39:24 -0400
Date: Wed, 11 Sep 2013 14:39:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] slab: overloading the RCU head over the LRU for
 RCU free
In-Reply-To: <1377161065-30552-8-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <000001410d765d3a-0f3f8df2-dccb-455a-a929-f1fd018700d2-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-8-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> With build-time size checking, we can overload the RCU head over the LRU
> of struct page to free pages of a slab in rcu context. This really help to
> implement to overload the struct slab over the struct page and this
> eventually reduce memory usage and cache footprint of the SLAB.

Looks fine to me. Can you add the rcu_head to the struct page union? This
kind of overload is used frequently elsewhere as well. Then cleanup other
cases of such uses (such as in SLUB).

Acked-by: Christoph Lameter <cl@linux.com>

