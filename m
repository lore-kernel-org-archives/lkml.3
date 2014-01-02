Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaABSfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:35:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:23806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaABSfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:35:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,592,1384329600"; 
   d="scan'208";a="433109512"
Message-ID: <52C5B158.10109@intel.com>
Date: Thu, 02 Jan 2014 10:35:04 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Wang <liwang@ubuntukylin.com>, Andreas Dilger <adilger@dilger.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] Fadvise: Directory level page cache cleaning support
References: <cover.1388409686.git.liwang@ubuntukylin.com> <52C1C6F7.8010809@intel.com> <FFE7C704-791E-4B73-9251-EFB9135AB254@dilger.ca> <52C1E6B1.4010402@intel.com> <52C55F12.4050406@ubuntukylin.com>
In-Reply-To: <52C55F12.4050406@ubuntukylin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 04:44 AM, Li Wang wrote:
> Do we really need clean dcache/icache at the current stage?
> That will introduce more code work, so far, iput() will put
> those unreferenced inodes into superblock lru list. To free
> the inodes inside a specific directory, it seems we do not
> have a handy API to use, and need
> modify iput() to recognize our situation, and collect those
> inodes into our list rather than superblock lru list. Maybe
> we stay at current stage now, since it is simple and could
> gain the major benefits, leave the dcache/icache cleaning
> to do in the future?

<sigh> top posting....

I read your response as "that's the right thing to do, but it's too much
work".  Fair enough.  But if we're going to take the lazy hack approach
here, maybe we should do this through some other interface than a
syscall where we're stuck with the behavior.


