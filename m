Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaJ0MNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:13:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39873 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJ0MNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:13:08 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-9c-544e36d22470
Message-id: <544E36D1.3090609@samsung.com>
Date: Mon, 27 Oct 2014 13:13:05 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Weijie Yang <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH v2 0/4] Low/high memory CMA reservation fixes
References: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-reply-to: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xq7qXzPxCDM4/kLRY2d3MZjGx6Q6L
	xabH11gtLu+aw2Zxb81/Vos5f6YwW9y+zGux4HgLq8WTE/9ZHDg9Wpp72Dx2zrrL7jG7Yyar
	x6ZPk9g9ut5eYfLYvKTeY92fV0wenzfJBXBEcdmkpOZklqUW6dslcGUsPzKPsWAyd8Wkv8uZ
	GxjfcXQxcnJICJhI9P68xQRhi0lcuLeerYuRi0NIYCmjxJWbJ5ghnE+MEvcWT2IGqeIV0JK4
	/ukDO4jNIqAq8ffEfzYQm03AUKLrbReYLSoQI3F/52o2iHpBiR+T77GA2CICYRJ/tlwCs5kF
	+pgk9h6KAbGFBRwl1u2/zgpiCwlES5xb9RishhNozvMHV5gg6s0kvrw8zAphy0tsXvOWeQKj
	wCwkK2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCo+LqDcekxq0OMAhyM
	Sjy8E4p9Q4RYE8uKK3MPMUpwMCuJ8Dr+BArxpiRWVqUW5ccXleakFh9iZOLglGpg7G7/pfg3
	+bDDS73HXhrOIUqhrAzpho5P/NaH/n+3svWGX9RPb/Yne7xSxdWYFIqar7RM07T0PfBNqr3y
	7MHNjpPVGy/byJ/Nrg+XFX61fwbH5y0unMHPI+p/e/xaX+j2tPXoLcd5oZ/2ZgjzPfjJICPD
	98Iq6uTWNcGeL7utynjc2flWTNqixFKckWioxVxUnAgACzijTmgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-24 12:18, Laurent Pinchart wrote:
> Hello,
>
> This patch set fixes an issue introduced by commits 95b0e655f914 ("ARM: mm:
> don't limit default CMA region only to low memory") and f7426b983a6a ("mm:
> cma: adjust address limit to avoid hitting low/high memory boundary")
> resulting in reserved areas crossing the low/high memory boundary.
>
> Patches 1/4 and 2/4 fix sides issues, with the bulk of the work in patch 3/4.
> Patch 4/4 then fixes a printk issue that got me puzzled wondering why memory
> reported under the lowmem limit was actually highmem.
>
> This series fixes a v3.18-rc1 regression causing Renesas Koelsch boot
> breakages when CMA is enabled.

I've applied the whole series to my fixes-for-v3.18 branch.

> Changes since v1:
>
> - Use the cma count field to detect non-activated reservations
> - Remove the redundant limit adjustment
>
> Laurent Pinchart (4):
>    mm: cma: Don't crash on allocation if CMA area can't be activated
>    mm: cma: Always consider a 0 base address reservation as dynamic
>    mm: cma: Ensure that reservations never cross the low/high mem
>      boundary
>    mm: cma: Use %pa to print physical addresses
>
>   mm/cma.c | 68 +++++++++++++++++++++++++++++++++++++++++-----------------------
>   1 file changed, 44 insertions(+), 24 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

