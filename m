Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3HGJno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:43:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50868 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab3HGJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:43:42 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fef6d000002d62-9a-520216ccf2d6
Content-transfer-encoding: 8BIT
Message-id: <1375868596.22638.35.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix a deadlock in fsync
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jim Xu <jinuxstyle@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Wed, 07 Aug 2013 18:43:16 +0900
In-reply-to: <7C98DE50-F64F-4FE8-8804-964DDD25561A@gmail.com>
References: <1375704124-22274-1-git-send-email-jinuxstyle@gmail.com>
 <1375793175.22638.18.camel@kjgkr>
 <7C98DE50-F64F-4FE8-8804-964DDD25561A@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zA90zYkxBBve/W1rsfHKa2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2Pdz9yCHtaKUwva
	2RsYO1m6GDk5JARMJP6emMgMYYtJXLi3nq2LkYtDSGAZo8TGt7vhir7d7mGESCxilNj9ZScr
	SIJXQFDix+R7QEUcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlFiZls3E0S9rsTMpoVgQ4UFjCRW
	bvnCBtLLJqAtsXm/AUhYSEBR4u3+u6wgYREg+/bSAJAxzAK3GSXevDoItpZFQFVi0+tPjCA2
	p4CtxK7OL0wQu2YzSqz+8IAdJMEvICpxeOF2qM+UJHa3d7KDFEkIHGOXmHX4HzvEJAGJb5MP
	gT0gISArsekAVL2kxMEVN1gmMErMQvLmLIQ3ZyF5cwEj8ypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MkHibuIPx/gHrQ4zJQBsnMkuJJucD4zWvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwN++f+2/R2vXLO3bhHM7cu37ZePPUkXzjrL1+W
	199CYmxPXv6zuT/+rKWgwNfIrWneO3YrXM1McWVsOLOc7Tt/SNexSq8Vane/XtvlU3Xij5/W
	gdI/XWXlywRaGhL6vt6pneySsk362wdj99jgG+6HnN6qfeBd0qiRnXDitdmvhTcSM/cr3nJS
	YinOSDTUYi4qTgQA/A+Q/80CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd0zYkxBBv3tZhY7n5xmtri0yN1i
	z96TLBaXd81hc2Dx2DnrLrvH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xY9zO3oIe14tSCdvYGxk6WLkZODgkBE4lvt3sYIWwxiQv31rN1MXJxCAks
	YpTY/WUnK0iCV0BQ4sfke0ANHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pRYmZbNxNEva7EzKaF
	YAuEBYwkVm75wgbSyyagLbF5vwFIWEhAUeLt/rusIGERIPv20gCQMcwCtxkl3rw6CLaWRUBV
	YtPrT2C3cQrYSuzq/MIEsWs2o8TqDw/YQRL8AqIShxduZ4Z4QElid3sn+wRGoVlIzp6FcPYs
	JGcvYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREczc+kdjCubLA4xCjAwajEw1shxhgk
	xJpYVlyZe4hRgoNZSYR3AitTkBBvSmJlVWpRfnxRaU5q8SHGZKDLJzJLiSbnAxNNXkm8obGJ
	mZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw2t7O5FLdvNM9Q8ToSkmx
	3x8rjetta/sMJ833EP3U4dy+8Ob3xk/pHlxB5geSp3c8ZIh2mLD31Tqde9pMn5e7Ze1/tKLM
	vLetXM1wRvnKtMrdJ9Z7c3P03H335+h721dlPfE6BgKKN/1WHr6cOrlD2IfHwGh9CDuzg8+D
	61fDfvysqRP1ZlqhxFKckWioxVxUnAgAmjOnQyoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

2013-08-07 (수), 12:23 +0800, Jim Xu:
> Hi Kim,
> 
> The patch sounds good to me.
> 
> BTW, as in the deadlock situation I noticed, I did not find any thread was doing checkpoint at that moment. The bdi writeback thread and the fsync user thread was not. Neither was the background f2fs_gc thread because there had enough free segments. Meanwhile, another user thread was blocked in the f2fs_sync_file->sync_node_pages, which, I think, is not a factor contributing to the deadlock.

I indicated one possible scenario.
As you described, many fsync calls can also consume all the fs_lock too.
Thanks,

-- 
Jaegeuk Kim
Samsung

