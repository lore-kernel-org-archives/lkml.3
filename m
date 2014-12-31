Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaLaNFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:05:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40877 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaLaNFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:05:16 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ce-54a3f489a498
Message-id: <54A3F488.8060904@samsung.com>
Date: Wed, 31 Dec 2014 14:05:12 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: linux-mm@kvack.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xq7qdXxaHGLTMlre4vGsOm8W9Nf9Z
	LdYeucvuwOyx6dMkdo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKeL9wIWvBR7aK438kGhh7
	WbsYOTkkBEwk3q3bwghhi0lcuLeeDcQWEljKKDHrZnQXIxeQ/YlR4ta+60xdjBwcvAJaEsum
	BoHUsAioSvx+0MACYrMJaEr83XwTrFdUIELiw6qvYDavgKDEj8n3wGr4gHZN3N3LDGKLAO36
	eOYymM0s4Csx+9J7JhBbWMBQYsXvZVA3OEv8XDKFHWQtp4CLxN+uOBCTWUBP4v5FLYhOeYnN
	a94yT2AUnIVk2SyEqllIqhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnbLzsYFx+z
	OsQowMGoxMPbYLM4RIg1say4MvcQowQHs5IIr/tloBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG
	pwXJKRURy9k922SnLdb4kPBKLfWN7LMXXXcrnTatr++Yoty9ekrHzFDvjUclFfvMJZ60bdFb
	v3xRf4Lf9KMNnbf6zc8nm+e92vlzaf6SUJ6P1s8WN9hdt5YRm/fEyyptB38xm252bqZl9uqH
	Iq2Fnn3Xtj2p2PbtXEKf06I1ATts5b+3XLNWYinOSDTUYi4qTgQA8Ng2GzkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 03:48 PM, Andrzej Hajda wrote:

(...)

> As I have tested it on mobile platform (exynos4210-trats) it saves above 2600
> string duplications. Below simple stats about the most frequent duplications:
> Count String
>   880 power
>   874 subsystem
>   130 device
>   126 parameters
>    61 iommu_group
>    40 driver
>    28 bdi
>    28 none
>    25 sclk_mpll
>    23 sclk_usbphy0
>    23 sclk_hdmi24m
>    23 xusbxti
>    22 sclk_vpll
>    22 sclk_epll
>    22 xxti
>    20 sclk_hdmiphy
>    11 aclk100

Minor update, printk buffer was too short during tests so I have not
catched everything. In fact the patchset saves 3260 duplications. Below
stats per kstrdup_const caller:
   2260 __kernfs_new_node+0x28/0xc4
    631 clk_register+0xc8/0x1b8
    318 clk_register+0x34/0x1b8
     51 kmem_cache_create+0x7c/0x1c8

Regards
Andrzej

