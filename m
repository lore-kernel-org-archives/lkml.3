Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbaAOG62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:58:28 -0500
Received: from www.sr71.net ([198.145.64.142]:57495 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaAOG60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:58:26 -0500
Message-ID: <52D63192.3080306@sr71.net>
Date: Tue, 14 Jan 2014 22:58:26 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently instead
 of page->lru
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180044.1E401C47@viggo.jf.intel.com> <alpine.DEB.2.02.1401141829530.32645@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401141829530.32645@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 06:31 PM, David Rientjes wrote:
> Did you try with a CONFIG_BLOCK config?
> 
> block/blk-mq.c: In function ‘blk_mq_free_rq_map’:
> block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
> block/blk-mq.c:1094:10: warning: initialization from incompatible pointer type [enabled by default]
> block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
> block/blk-mq.c:1095:22: error: ‘struct page’ has no member named ‘list’
> block/blk-mq.c: In function ‘blk_mq_init_rq_map’:
> block/blk-mq.c:1159:22: error: ‘struct page’ has no member named ‘list’

As I mentioned in the introduction, these are against linux-next.
There's a patch in there at the moment which fixed this.
