Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3L3TSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 14:18:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:4462 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab3L3TSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 14:18:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="431829819"
Message-ID: <52C1C6F7.8010809@intel.com>
Date: Mon, 30 Dec 2013 11:18:15 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Wang <liwang@ubuntukylin.com>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] Fadvise: Directory level page cache cleaning support
References: <cover.1388409686.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 05:45 AM, Li Wang wrote:
> This patch extends 'fadvise' to support directory level page cache
> cleaning. The call to posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED) 
> with 'fd' referring to a directory will recursively reclaim page cache 
> entries of files inside 'fd'. For secruity concern, those inodes
> which the caller does not own appropriate permissions will not 
> be manipulated.

Why is this necessary to do in the kernel?  Why not leave it to
userspace to walk the filesystem(s)?


