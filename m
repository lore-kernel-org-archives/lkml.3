Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaFXBMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:12:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:33624 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFXBMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:12:54 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53A8D092.4040801@lge.com>
Date: Tue, 24 Jun 2014 10:12:50 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [RFC] CMA page migration failure due to buffers on bh_lru
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I am trying to apply CMA feature for my platform.
My kernel version, 3.10.x, is not allocating memory from CMA area so that I applied
a Joonsoo Kim's patch (https://lkml.org/lkml/2014/5/28/64).
Now my platform can use CMA area effectively.

But I have many failures to allocate memory from CMA area.
I found the same situation to Laura Abbott's patch descrbing, https://lkml.org/lkml/2012/8/31/313,
that releases buffer-heads attached at CPU's LRU list.

If Joonsoo's patch is applied and/or CMA feature is applied more and more,
buffer-heads problem is going to be serious definitely.

Please look into the Laura's patch again.
I think it must be applied with Joonsoo's patch.

