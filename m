Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3HWGxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:53:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51227 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3HWGxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:53:04 -0400
X-AuditID: 9c930197-b7b44ae00000347f-b7-521706cf87e3
Date: Fri, 23 Aug 2013 15:53:15 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] slab: remove cachep in struct slab_rcu
Message-ID: <20130823065315.GG22605@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1377161065-30552-6-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140a72870a6-f7c87696-ecbc-432c-9f41-93f414c0c623-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140a72870a6-f7c87696-ecbc-432c-9f41-93f414c0c623-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:53:00PM +0000, Christoph Lameter wrote:
> On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> 
> > We can get cachep using page in struct slab_rcu, so remove it.
> 
> Ok but this means that we need to touch struct page. Additional cacheline
> in cache footprint.

In following patch, we overload RCU_HEAD to LRU of struct page and
also overload struct slab to struct page. So there is no
additional cacheline footprint at final stage.

Thanks.
