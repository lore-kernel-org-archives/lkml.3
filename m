Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaKMHSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:18:21 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53037 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaKMHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:18:19 -0500
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <54645B38.10603@lge.com>
Date: Thu, 13 Nov 2014 16:18:16 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>, Joonsoo Kim <js1304@gmail.com>
CC: John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lauraa@codeaurora.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?EUC-KR?B?IsDMsMfIoy/DpcDTv6yxuL/4L1NXIFBs?=
	 =?EUC-KR?B?YXRmb3JtKL+sKUFPVMbAKGd1bmhvLmxlZUBsZ2UuY29tKSI=?= 
	<gunho.lee@lge.com>
Subject: Why does ion_cma_allocate need GFP_HIGHUSER | __GFP_ZERO flags?
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm wondering why dma_alloc_coherent needs GFP_HIGHUSER | __GFP_ZERO flags in ion_cma_allocate().

I think dma_alloc_coherent can go to __dma_alloc if the system has CMA area.
If __GFP_WAIT flag is set, it allocates memory from atomic pool.
So I think calling dma_alloc_coherent with __GFP_WAIT is enough.

And can I get zero-filled-memory from CMA if I set __GFP_ZERO?


-- 
Thanks,
Gioh Kim
