Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbaDBUyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:54:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58173 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030354AbaDBUyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:54:39 -0400
Date: Wed, 2 Apr 2014 16:54:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jamieliu@google.com, suleiman@google.com
Subject: Re: [PATCH v2 0/3] Per-cgroup swap file support
Message-ID: <20140402205433.GW14688@cmpxchg.org>
References: <1396470849-26154-1-git-send-email-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:34:06PM -0700, Yu Zhao wrote:
> This series of patches adds support to configure a cgroup to swap to a
> particular file by using control file memory.swapfile.
> 
> Originally, cgroups share system-wide swap space and limiting cgroup swapping
> is not possible. This patchset solves the problem by adding mechanism that
> isolates cgroup swap spaces (i.e. per-cgroup swap file) so users can safely
> enable swap for particular cgroups without worrying about one cgroup uses up
> all swap space.

Isn't that what the swap controller is for?

config MEMCG_SWAP
	bool "Memory Resource Controller Swap Extension"
	depends on MEMCG && SWAP
	help
	  Add swap management feature to memory resource controller. When you
	  enable this, you can limit mem+swap usage per cgroup. In other words,
	  when you disable this, memory resource controller has no cares to
	  usage of swap...a process can exhaust all of the swap. This extension
	  is useful when you want to avoid exhaustion swap but this itself
	  adds more overheads and consumes memory for remembering information.
	  Especially if you use 32bit system or small memory system, please
	  be careful about enabling this. When memory resource controller
	  is disabled by boot option, this will be automatically disabled and
	  there will be no overhead from this. Even when you set this config=y,
	  if boot option "swapaccount=0" is set, swap will not be accounted.
	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
	  size is 4096bytes, 512k per 1Gbytes of swap.
