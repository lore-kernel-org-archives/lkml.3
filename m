Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaA0KFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:05:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57682 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA0KFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:05:05 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-12-52e62f500992
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 7/8] mm/swap: check swapfile blocksize greater than PAGE_SIZE
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000801cf1b47$3fcab170$bf601450$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRu3aHC4G58qRQ9meKjqMWLoq9Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgG6A/rMgg803NSzmrF/DZtF1aiqL
	xcHZS5gsnn7qY7G4vGsOm8W9Nf9ZLZZ9fc9uMeXhJEaLC4fuM1ks2PiI0eLJif8sDtweO2fd
	ZfdYsKnUY9OqTjaPTZ8msXucmPGbxePj01ssHu/3XWXz6NuyitHj8ya5AM4oLpuU1JzMstQi
	fbsErozFa1+xFyxmrXhx7yNTA+Nsli5GTg4JAROJb32LmSFsMYkL99azdTFycQgJLGKUeHH5
	F5Tzh1Fi4ZR3YB1sAtoSd/s3soLYIgIiEmvuLGQEKWIWOMMkcWFXOxtIQljAV2LXi1tgDSwC
	qhJHD01nB7F5BewkOn8/YIawBSV+TL4HVMMB1KwuMWVKLkiYWUBeYvOat8wgYQmg8KO/uhCr
	9CTeXF/HCFEiLrHxyC2WCYwCs5AMmoUwaBaSQbOQdCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERxJz6R2MK5ssDjEKMDBqMTDm3H9aZAQa2JZcWXuIUYJDmYlEd4KnWdBQrwpiZVV
	qUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhh3n/589Io7J9fkbm/L
	58zeMks+XDOcPiltu4nKzoPK90J42WTZZYoqll3bY3A0iOGU+UHdUw8FFxX0cM33ip3+3WOm
	/onJF6/9WOJyZa+plEl/5llmx73uQZ//JO/duWclT75l1Izr/f+i3y8sW+fI3bv4Z4nb2fQb
	Qtar4h+EzYzfsHQvw+PlSizFGYmGWsxFxYkAGlXKHaACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If S_ISREG swapfile's blocksize > PAGE_SIZE, it is not suitable to be
a swapfile, because swap slot is fixed to PAGE_SIZE.

This patch check this situation and return -EINVAL if it happens.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 7247be6..3d9bd12 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -150,6 +150,8 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 	int ret;
 
 	blkbits = inode->i_blkbits;
+	if(blkbits > PAGE_SHIFT)
+		return -EINVAL;
 	blocks_per_page = PAGE_SIZE >> blkbits;
 
 	/*
-- 
1.7.10.4


