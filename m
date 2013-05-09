Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3EIPXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab3EIPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:23:02 -0400
Date: Thu, 09 May 2013 11:22:55 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1368112975-65m57crd-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130509135504.2b6598d3a52fdd367da1cbb4@canb.auug.org.au>
References: <20130509135504.2b6598d3a52fdd367da1cbb4@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the final tree (Linus'
 tree related)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130509135504.2b6598d3a52fdd367da1cbb4@canb.auug.org.au>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:55:04PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (arm defconfig)
> produced this warning:
> 
> ipc/shm.c: In function 'newseg':
> ipc/shm.c:494:18: warning: unused variable 'hs' [-Wunused-variable]
> 
> Introduced by commit af73e4d9506d ("hugetlbfs: fix mmap failure in
> unaligned size request") in Linus' tree.
> 
> Did the "[akpm@linux-foundation.org: fix warning when
> CONFIG_HUGETLB_PAGE=n]" part get dropped?  Or was that something else?

In my original post, 2 auto variables hs were used both in newseg() and
sys_mmap_pgoff(), and Andrew fixed only one in sys_mmap_pgoff().
hs remains in newseg(), so it fires warning in linux-next.
Hours ago Li suggested another fix of af73e4d9506d and it implicitly
fixes this warning.
http://marc.info/?l=linux-kernel&m=136808335431220&w=2

Thanks,
Naoya
