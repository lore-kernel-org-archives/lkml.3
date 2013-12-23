Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3LWDDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:03:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53012 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3LWDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:03:41 -0500
X-AuditID: 9c930197-b7c4aae000003d84-75-52b7a80b7004
Subject: Re : Re: Re: Re : Re: [PATCH] Squashfs: add asynchronous read support
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
 <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
 <OFA5BC9264.067973F3-ON49257C48.000B85B4-49257C48.000B85B4@lge.com>
In-Reply-To: <OFA5BC9264.067973F3-ON49257C48.000B85B4-49257C48.000B85B4@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
MIME-Version: 1.0
Reply-To: "Chanho Min" <chanho.min@lge.com>
X-Priority: 3 (Normal)
Auto-Submitted: auto-generated
From: "Chanho Min" <chanho.min@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        =?EUC-KR?B?wNPIv8HY?= <hyojun.im@lge.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Message-ID: <OF207E4497.72720BDC-ON49257C4A.0010D055-49257C4A.0010D055@lge.com>
Date: Mon, 23 Dec 2013 12:03:39 +0900
X-MIMETrack: Serialize by Router on LGEKRHQMS17A/LGE/LG Group(Release 8.5.3FP3HF583 | August
 9, 2013) at 2013/12/23 12:03:39
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> read_pages
>   for(page_idx ...) {
>     if (!add_to_page_cache_lru)) { <-- 1)
>       mapping->a_ops->readpage(filp, page)
>         squashfs_readpage
>           for (i ...) {   2)  Here, 31 pages are inserted into page cache
>             grab_cahe_page_nowait <------/
>               add_to_page_cache_lru
>           }
>     }
>     /*
>      * 1) will be failed with EEXIST by 2) so every pages other than first page
>      * in list would be freed
>      */
>     page_cache_release(page)
>   }
>
> If you see ReadAhead works, it is just by luck as I told you.
> Please simulate it with 64K dd.
You right, This luck happened frequently with 128k dd or my test.

> I understand it but your patch doesn't make it.
>
I think my patch can make it if readahead works normally or luckily.

Thanks a lot!
Chanho,

