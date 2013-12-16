Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3LPJma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:42:30 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49853 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3LPJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:42:29 -0500
Message-ID: <52AECABE.60902@huawei.com>
Date: Mon, 16 Dec 2013 17:41:18 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fix huge page reallocated in soft_offline_page
References: <52AEC122.2000609@huawei.com>
In-Reply-To: <52AEC122.2000609@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/16 17:00, Xishi Qiu wrote:

> The huge page may be reallocated in soft_offline_page, because
> MIGRATE_ISOLATE can not keep the page until after setting PG_hwpoison.
> alloc_huge_page()
> 	dequeue_huge_page_vma()
> 		dequeue_huge_page_node()
> If the huge page was reallocated, we need to try offline it again.
> 

Sorry, I made a mistake.
This bug was fixed in
commit c8721bbbdd36382de51cd6b7a56322e0acca2414

Thanks,
Xishi Qiu

