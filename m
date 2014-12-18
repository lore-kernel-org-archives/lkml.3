Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaLRHmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:42:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62236 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaLRHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:42:30 -0500
X-AuditID: cbfee61a-f79c06d000004e71-8a-549285638fc4
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@gmail.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000001d0184a$3f09d580$bd1d8080$@samsung.com>
 <CAN863PvqCJJ-m3NimjX7FKeY941rjSgmzupfPEMHm_qXgRBwfQ@mail.gmail.com>
In-reply-to: <CAN863PvqCJJ-m3NimjX7FKeY941rjSgmzupfPEMHm_qXgRBwfQ@mail.gmail.com>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: merge two uchar variable in struct
 node_info to reduce memory cost
Date: Thu, 18 Dec 2014 14:29:51 +0800
Message-id: <004c01d01a96$2b5b3a80$8211af80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ7FeG3g7CT/z3dfOL3gNj25I6qgwLy10zlmyciDYA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jQd2U1kkhBjsvMlmc6elms7i2r5HJ
	4sn6WcwWlxa5W+zZe5LF4vKuOWwObB47Z91l99i0qpPNY/eCz0wefVtWMXp83iQXwBrFZZOS
	mpNZllqkb5fAlbH65wK2gv08FT+n7WBtYLzP2cXIySEhYCJxYeJyRghbTOLCvfVsILaQwHRG
	iWU/I7sYuYDsH4wSl7//YgFJsAmoSCzv+M8EYosIaEjMavgMFmcW2M4osehEEkRzA6PEtedq
	XYwcHJwCwRKf3jCDhIUFciWWrZoAVs4ioCpx5NhWsL28ApYSG268gbIFJX5MvscC0sosoC4x
	ZUouxHR5ic1r3jJDnKkgsePsa0aIC6wk2iZ/ZIOoEZfYeOQWywRGoVlIJs1CmDQLyaRZSDoW
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOjWdSOxhXNlgcYhTgYFTi4ZXQmxQixJpY
	VlyZe4hRgoNZSYQ3OgcoxJuSWFmVWpQfX1Sak1p8iFGag0VJnFfJvi1ESCA9sSQ1OzW1ILUI
	JsvEwSnVwMh8bf/Jhzt23JFdN3ftB63vHe8XSapsaJesWD83+kDU3ny/mTOunK7+rD01M7Xj
	AFeoxcnLB6w6uNytzLq2HjV/3LDg5L1DWwxYeecKlwofXnumvTivcX0Ai9mOnpdbwyQnWscd
	mVWx8HlNp15ewc3TFSt5dk7uOWc6J4t91gfjfJ3D8wptKq4osRRnJBpqMRcVJwIASYGmbYkC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@gmail.com]
> Sent: Wednesday, December 17, 2014 11:09 PM
> To: Chao Yu
> Cc: Jaegeuk Kim; Changman Lee; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH v2] f2fs: merge two uchar variable in struct node_info to reduce
> memory cost
> 
> Hi Yu,
> 
> This patch is effective only in 32 bit machine. In case of 64 bit
> machine, nat_entry will be aligned in 8 bytes due to pointer variable
> (i.e. struct list_head). So it can't get any benefit to reduce memory
> usage. In the case of node_info, however, it will be gain in terms of
> memory usage.
> Hence, I think it's not correct for commit log to describe this patch.
> 

Thanks for your review! :)

AFFIK, in 64 bit machine, size of struct nat_entry is 40 bytes before this patch
apply, the reason is that our compiler will fill 3 bytes pads after flag as
nid's offset should align to type size of nid, and then fill 7 byte pads after
version as size of structure should align to 64 bits when the struct size is bigger
than 64 bits.
layout of struct nat_entry:
|-----8 bytes-----|
|list.next        |
|list.prev        |
|flag    |nid     |
|ino     |blk_addr|
|version          |
After we apply this patch, size of struct nat_entry will be reduced to 32 bytes.
Please correct me if I'm wrong.

Anyway, I agreed that commit log should be uptodate.

Thanks,
Yu

> Thanks,
> 
> Reviewed-by: Changman Lee <cm224.lee@samsung.com>
> 

