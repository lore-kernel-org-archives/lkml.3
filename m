Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab3APIo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:44:59 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64947 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3APIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:44:57 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-4d-50f668885924
Date: Wed, 16 Jan 2013 17:45:00 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: correct bootstrap() for kmem_cache,
 kmem_cache_node
Message-ID: <20130116084459.GB13446@lge.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1358234402-2615-2-git-send-email-iamjoonsoo.kim@lge.com>
 <0000013c3eda78d8-da8c775c-d7c0-4a88-bacf-0b5160b5c668-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013c3eda78d8-da8c775c-d7c0-4a88-bacf-0b5160b5c668-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:36:10PM +0000, Christoph Lameter wrote:
> On Tue, 15 Jan 2013, Joonsoo Kim wrote:
> 
> > These didn't make any error previously, because we normally don't free
> > objects which comes from kmem_cache's first slab and kmem_cache_node's.
> 
> And these slabs are on the partial list because the objects are typically
> relatively small compared to page size. Do you have a system with a very
> large kmem_cache size?

These slabs are not on the partial list, but on the cpu_slab of boot cpu.
Reason for this is described in changelog.
Because these slabs are not on partial list, we need to
check kmem_cache_cpu's cpu slab. This patch implement it.

> > Problem will be solved if we consider a cpu slab in bootstrap().
> > This patch implement it.
> 
> At boot time only one processor is up so you do not need the loop over all
> processors.

Okay! I will fix and submit v2, soon.
