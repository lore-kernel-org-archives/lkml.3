Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaARImF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 03:42:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:34206 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaARImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 03:42:01 -0500
Message-ID: <52DA3E41.9050202@huawei.com>
Date: Sat, 18 Jan 2014 16:41:37 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>, Wang Nan <wangnan0@huawei.com>
Subject: Re: [PATCH] mm/kmemleak: add support for re-enable kmemleak at runtime
References: <52D8FA72.8080100@huawei.com> <20140117120436.GC28895@arm.com>
In-Reply-To: <20140117120436.GC28895@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/17 20:04, Catalin Marinas wrote:

> On Fri, Jan 17, 2014 at 09:40:02AM +0000, Jianguo Wu wrote:
>> Now disabling kmemleak is an irreversible operation, but sometimes
>> we may need to re-enable kmemleak at runtime. So add a knob to enable
>> kmemleak at runtime:
>> echo on > /sys/kernel/debug/kmemleak
> 
> It is irreversible for very good reason: once it missed the initial
> memory allocations, there is no way for kmemleak to build the object
> reference graph and you'll get lots of false positives, pretty much
> making it unusable.
> 

Do you mean we didn't trace memory allocations during kmemleak disable period,
and these memory may reference to new allocated objects after re-enable? 

