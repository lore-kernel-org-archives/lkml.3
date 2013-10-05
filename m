Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3JEG1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:27:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:52727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3JEG1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:27:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1038,1371106800"; 
   d="scan'208";a="303455857"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH 10/26] lustre: Convert ll_get_user_pages() to use
 get_user_pages_fast()
Thread-Topic: [PATCH 10/26] lustre: Convert ll_get_user_pages() to use
 get_user_pages_fast()
Thread-Index: AQHOv3vFlEOI4G32yk6DS75n0qPGCpnluckA
Date: Sat, 5 Oct 2013 06:27:43 +0000
Message-ID: <CE750CA8.75301%andreas.dilger@intel.com>
In-Reply-To: <1380724087-13927-11-git-send-email-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.125.217]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78094AFAA7D9084EB3F62453362B75D3@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/02 8:27 AM, "Jan Kara" <jack@suse.cz> wrote:
>CC: Greg Kroah-Hartman <greg@kroah.com>
>CC: Peng Tao <tao.peng@emc.com>
>CC: Andreas Dilger <andreas.dilger@intel.com>
>CC: hpdd-discuss@lists.01.org
>Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Andreas Dilger <andreas.dilger@intel.com>

>---
> drivers/staging/lustre/lustre/llite/rw26.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/llite/rw26.c
>b/drivers/staging/lustre/lustre/llite/rw26.c
>index 96c29ad2fc8c..7e3e0967993b 100644
>--- a/drivers/staging/lustre/lustre/llite/rw26.c
>+++ b/drivers/staging/lustre/lustre/llite/rw26.c
>@@ -202,11 +202,8 @@ static inline int ll_get_user_pages(int rw, unsigned
>long user_addr,
> 
> 	OBD_ALLOC_LARGE(*pages, *max_pages * sizeof(**pages));
> 	if (*pages) {
>-		down_read(&current->mm->mmap_sem);
>-		result = get_user_pages(current, current->mm, user_addr,
>-					*max_pages, (rw == READ), 0, *pages,
>-					NULL);
>-		up_read(&current->mm->mmap_sem);
>+		result = get_user_pages_fast(user_addr, *max_pages,
>+					     (rw == READ), *pages);
> 		if (unlikely(result <= 0))
> 			OBD_FREE_LARGE(*pages, *max_pages * sizeof(**pages));
> 	}


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


