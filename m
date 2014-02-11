Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaBKHTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:19:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40812 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBKHTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:19:18 -0500
Message-ID: <52F9CE72.30303@huawei.com>
Date: Tue, 11 Feb 2014 15:17:06 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Vegard Nossum" <vegardno@ifi.uio.no>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        <wangnan0@huawei.com>, the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH] mm: add a new command-line kmemcheck value
References: <52C2811C.4090907@huawei.com> <CAOMGZ=GOR_i9ixvHeHwfDN1wwwSQzFNFGa4qLZMhWWNzx0p8mw@mail.gmail.com> <52C4C216.3070607@huawei.com> <CAOMGZ=HhWoRYMQtqQu73X21eZJAO7fETxOnW=9ZWMkwr9dCPFA@mail.gmail.com> <52DF1D59.8090803@huawei.com>
In-Reply-To: <52DF1D59.8090803@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/22 9:22, Xishi Qiu wrote:

> 
> Hi Vegard,
> 
> In some scenes, user want to check memory dynamicly, this "dynamically" 
> means we can turn on/off the feature at boottime, not runtime. Without 
> this patch, if user want to use this feature, he should change config 
> and build the kernel, then reboot. This is impossilbe if user has no 
> kernel code or he don't know how to build the kernel.
> 
> boottime: kmemcheck=0/1/2/3 (command-line)
> runtime: kmemcheck=0/1/2 (/proc/sys/kernel/kmemcheck)
> 
> The main different between kmemcheck=0 and 3 is the used memory. Kmemcheck 
> will use about twice as much memory as normal.
> 
> Thanks,
> Xishi Qiu
> 
> --

Hi Vegard,

What do you think of this feature? 

Add a command-line "kmemcheck=3", then the kernel runs as the same as CONFIG_KMEMCHECK=off
even CONFIG_KMEMCHECK is turn on. "kmemcheck=0/1/2" is the same as originally. 
In another word, "kmemcheck=3" is the same as:
1) turn off CONFIG_KMEMCHECK
2) rebuild the kernel
3) reboot
The different between kmemcheck=0 and 3 is the used memory and nr_cpus.
Also kmemcheck=0 can used in runtime, and kmemcheck=3 is only used in boot.

I think this feature can help users to debug the kernel quickly, It is no 
need to open CONFIG_KMEMCHECK and rebuild it. Especially sometimes users don't
have the kernel source code or the code is different from www.kernel.org.
e.g. some private features were added to the kernel source code, and usually 
users can not have the source code. 

Thanks,
Xishi Qiu

