Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaAXVjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:39:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:21718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbaAXVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:39:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,715,1384329600"; 
   d="scan'208";a="464360913"
From: Andi Kleen <andi@firstfloor.org>
To: T Makphaibulchoke <tmac@hp.com>
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
References: <1377186876-57291-1-git-send-email-tmac@hp.com>
	<1390588288-66930-1-git-send-email-tmac@hp.com>
Date: Fri, 24 Jan 2014 13:38:58 -0800
In-Reply-To: <1390588288-66930-1-git-send-email-tmac@hp.com>
	(T. Makphaibulchoke's message of "Fri, 24 Jan 2014 11:31:25 -0700")
Message-ID: <87fvodcb65.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

T Makphaibulchoke <tmac@hp.com> writes:

> The patch consists of three parts.
>
> The first part changes the implementation of both the block and hash chains of
> an mb_cache from list_head to hlist_bl_head and also introduces new members,
> including a spinlock to mb_cache_entry, as required by the second part.

spinlock per entry is usually overkill for larger hash tables.

Can you use a second smaller lock table that just has locks and is 
indexed by a subset of the hash key. Most likely a very small 
table is good enough.

Also I would be good to have some data on the additional memory consumption.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
