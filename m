Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3KGNZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:25:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3KGNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:25:08 -0500
Date: Thu, 7 Nov 2013 14:25:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, kbuild-all@01.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        fengguang.wu@intel.com
Subject: Re: [memcg:since-3.12 75/75] fs/proc/meminfo.c:undefined reference
 to `vm_commit_limit'
Message-ID: <20131107132505.GA16393@dhcp22.suse.cz>
References: <527b74a0.xBELNKuc6Ws8XONb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527b74a0.xBELNKuc6Ws8XONb%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-11-13 19:08:16, Wu Fengguang wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.12
> head:   2f11d7af8df66cb4f217b6293ad8189aa101d601
> commit: 2f11d7af8df66cb4f217b6293ad8189aa101d601 [75/75] mm-factor-commit-limit-calculation-fix
> config: make ARCH=blackfin BF526-EZBRD_defconfig
> 
> All error/warnings:
> 
>    mm/built-in.o: In function `__vm_enough_memory':
>    (.text+0x11b4c): undefined reference to `vm_commit_limit'
>    fs/built-in.o: In function `meminfo_proc_show':
> >> fs/proc/meminfo.c:(.text+0x37ef0): undefined reference to `vm_commit_limit'

Andrew, it seems that moving vm_commit_limit out of mman.h is not that
easy because it breaks NOMMU configurations. mm/mmap.o is not part of
the nommu build apparently.

So either we move it back to mman.h or put it somewhere else. I do not
have a good idea where, though.

I have dropped mm-factor-commit-limit-calculation-fix from mm-git tree
for now.
-- 
Michal Hocko
SUSE Labs
