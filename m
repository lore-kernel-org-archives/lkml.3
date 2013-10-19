Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3JSWj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:39:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:1176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3JSWj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:39:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,531,1378882800"; 
   d="scan'208";a="421714639"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page to reduce memory usage
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
Date: Sat, 19 Oct 2013 15:39:34 -0700
In-Reply-To: <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
	(Andrew Morton's message of "Wed, 16 Oct 2013 13:34:57 -0700")
Message-ID: <8738nwvqah.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> One example is mm/memory-failure.c:memory_failure().  It starts with a
> raw pfn, uses that to get at the `struct page', then starts playing
> around with it.  Will that code still work correctly when some of the
> page's fields have been overlayed with slab-specific contents?

As long as PageSlab() works correctly memory_failure should be happy.

>
> This issue hasn't been well thought through.  Given a random struct
> page, there isn't any protocol to determine what it actually *is*. 
> It's a plain old variant record, but it lacks the agreed-upon tag field
> which tells users which variant is currently in use.

PageSlab() should work for this right?

For the generic case it may not though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
