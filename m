Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaGFQSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:18:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:58866 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaGFQSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,612,1400050800"; 
   d="scan'208";a="539403637"
From: Andi Kleen <andi@firstfloor.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53B667F9.90306@bull.net>
Date: Sun, 06 Jul 2014 09:18:12 -0700
In-Reply-To: <53B667F9.90306@bull.net> (Sebastien Buisson's message of "Fri, 4
	Jul 2014 10:38:17 +0200")
Message-ID: <87y4w6sbp7.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Buisson <sebastien.buisson@bull.net> writes:

> Allow increasing the buffer-head per-CPU LRU size to allow efficient
> filesystem operations that access many blocks for each transaction.
> For example, creating a file in a large ext4 directory with quota
> enabled will accesses multiple buffer heads and will overflow the LRU
> at the default 8-block LRU size:

I don't think that should be a user visible config. Most users wouldn't
know how to set it. And Linux already has far too many obscure
config options.

Either make it set implicitely by the file system config.
Or just increase it unconditionally? 

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
