Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3J2GmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:42:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3J2GmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:42:04 -0400
Message-ID: <526F58B5.7020503@jp.fujitsu.com>
Date: Tue, 29 Oct 2013 02:41:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: minchan@kernel.org, zhang.mingjun@linaro.org
CC: m.szyprowski@samsung.com, akpm@linux-foundation.org, mgorman@suse.de,
        haojian.zhuang@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, troy.zhangmingjun@linaro.org
Subject: Re: [PATCH] mm: cma: free cma page to buddy instead of being cpu
 hot page
References: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org> <20131029045430.GE17038@bbox>
In-Reply-To: <20131029045430.GE17038@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The concern is likely/unlikely usage is proper in this code peice.
> If we don't use memory isolation, the code path is used for only
> MIGRATE_RESERVE which is very rare allocation in normal workload.
> 
> Even, in memory isolation environement, I'm not sure how many
> CMA/HOTPLUG is used compared to normal alloc/free.
> So, I think below is more proper?
> 
> if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
>         if (is_migrate_isolate(migratetype) || is_migrate_cma(migratetype))
> 
> I know it's an another topic but I'd like to disucss it in this time because
> we will forget such trivial thing later, again.

I completely agree with this.


