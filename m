Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaHUOVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:21:34 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:39868 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018AbaHUOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:21:33 -0400
Date: Thu, 21 Aug 2014 09:21:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slab: use percpu allocator for cpu cache
In-Reply-To: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408210918050.32524@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> So, this patch try to use percpu allocator in SLAB. This simplify
> initialization step in SLAB so that we could maintain SLAB code more
> easily.

I thought about this a couple of times but the amount of memory used for
the per cpu arrays can be huge. In contrast to slub which needs just a
few pointers, slab requires one pointer per object that can be in the
local cache. CC Tj.

Lets say we have 300 caches and we allow 1000 objects to be cached per
cpu. That is 300k pointers per cpu. 1.2M on 32 bit. 2.4M per cpu on
64bit.

