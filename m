Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3LLAYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:24:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:43668 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3LLAYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:24:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="448649115"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Sasha Levin <sasha.levin@oracle.com>
In-Reply-To: <20131211163809.GA26342@redhat.com>
References: <20131206210254.GA7962@redhat.com>
 <52A8877A.10209@suse.cz>
 <20131211163809.GA26342@redhat.com>
Subject: Re: oops in pgtable_trans_huge_withdraw
Content-Transfer-Encoding: 7bit
Message-Id: <20131212002422.98262E0090@blue.fi.intel.com>
Date: Thu, 12 Dec 2013 02:24:22 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Dec 11, 2013 at 04:40:42PM +0100, Vlastimil Babka wrote:
>  > On 12/06/2013 10:02 PM, Dave Jones wrote:
>  > > I've spent a few days enhancing trinity's use of mmap's, trying to make it
>  > > reproduce https://lkml.org/lkml/2013/12/4/499
>  > 
>  > FYI, I managed to reproduce that using trinity today,
>  > trinity was from git at commit e8912cc which is from Dec 09 so I guess 
>  > your enhancements were already there?
> 
> yep, everything I had pending is in HEAD now.
> 
>  > kernel was linux-next-20131209
>  > I was running trinity -c mmap -c munmap -c mremap -c remap_file_pages -c 
>  > mlock -c munlock
>  
> A shorthand for all those -c's is '-G vm'. (Though there might be a couple
> extra syscalls in the list too, madvise, mprotect etc).
> 
>  > Now I'm running with Kirill's patch, will post results later.
>  
> Seemed to fix it for me, I've not reproduced that particular bug since applying it.
> Kirill, is that on its way to Linus soon ?

It's in -mm tree for a week already.

Andrew, could you push it to Linus? More people steps on the bug.

-- 
 Kirill A. Shutemov
