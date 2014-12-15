Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaLOJSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:18:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28461 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaLOJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:17:55 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-62-548ea74037b1
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <001c01d012b6$a0fbaaa0$e2f2ffe0$@samsung.com>
 <20141215082717.GA83773@jaegeuk-mac02.mot-mobility.com>
In-reply-to: <20141215082717.GA83773@jaegeuk-mac02.mot-mobility.com>
Subject: RE: [f2fs-dev][PATCH] f2fs: merge two uchar variable in struct
 nat_entry to reduce memory cost
Date: Mon, 15 Dec 2014 17:16:36 +0800
Message-id: <002401d01848$010fa9a0$032efce0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFE9v2eO9wn3GIObs17ONh/OTt1GgH8hNF/nZa5M3A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQV3H5X0hBu272Syu7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	6/dvMhac4q44sO8uYwPjK44uRk4OCQETidtfX7BA2GISF+6tZ+ti5OIQEpjOKHFi+z5GCOcH
	o8SD9kVgVWwCKhLLO/4zgdgiAmoSvfumMIEUMQtMZpSY1XcXLCEkUCyxacduRhCbU8BFYk5v
	K3MXIweHsECmxJENYJtZBFQlGpevACvnFbCUmPK7jQXCFpT4MfkemM0soCWxfudxJghbXmLz
	mrfMEJcqSOw4+5oR4gYriYY7y1khasQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEx8Mz6R2MqxosDjEKcDAq8fAy/O8NEWJNLCuuzD3EKMHB
	rCTCGzenL0SINyWxsiq1KD++qDQntfgQozQHi5I4r5J9W4iQQHpiSWp2ampBahFMlomDU6qB
	Ucn+kuAOPp+mpzqH1fZfY4yY/LuSoVts7YLitj3l0d+PHHZaWWH965Yf79k6957vv8yWONzS
	4FhR8IOnroAlxvxzfk1z6O6HvR3p+e3pty/q7BeZdd2bezZPZJLuZc9pH/84mwiKr13Ld/SZ
	q74pb+DV6c+/rutZOXWz8tGpm3okZp5z/qDkosRSnJFoqMVcVJwIADAVySyDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, December 15, 2014 4:27 PM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH] f2fs: merge two uchar variable in struct nat_entry to reduce
> memory cost
> 
> Hi Chao,
> 
> I found a bug in this patch.

Oh, it's my bad. I will fix this as you suggested.
Thank you for helping to find this bug. :)

Regards,
Yu

> 
> In set_node_addr,
> 
>  	down_write(&nm_i->nat_tree_lock);
> 	e = __lookup_nat_cache(nm_i, ni->nid);
> 	if (!e) {
> 		e = grab_nat_entry(nm_i, ni->nid);
> 		e->ni = *ni;
> 		^^^^^^^^^^^^
> 		this line should not copy ni.flag.
> 
> 		f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
> 	} else if (new_blkaddr == NEW_ADDR) {
> 		/*
> 		 * when nid is reallocated,
> 		 * previous nat entry can be remained in nat cache.
> 		 * So, reinitialize it with new information.
> 		 */
> 		e->ni = *ni;
> 		^^^^^^^^^^^^
> 		ditto.
> 
> 		f2fs_bug_on(sbi, ni->blk_addr != NULL_ADDR);
> 	}
> 
> So, please add inline function in node.h like:
> 
> static inline void copy_node_info(dst, src)
> {
> 	dst->nid = src->nid;
> 	dst->ino = src->ino;
> 	dst->blk_addr = src->blk_addr;
> 	dst->version = src->version;
> 	/* should not copy flag here */
> }
> 
> Then let's use this function.
> 
> Thanks,
> 

