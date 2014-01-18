Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaARKpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 05:45:43 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43938 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaARKpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 05:45:41 -0500
Subject: Re: [PATCH] mm/kmemleak: add support for re-enable kmemleak at runtime
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <52DA3E41.9050202@huawei.com>
Date: Sat, 18 Jan 2014 10:45:38 +0000
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>, Wang Nan <wangnan0@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CE7DF1D3-12AE-4A97-BF05-84FF223C8520@arm.com>
References: <52D8FA72.8080100@huawei.com> <20140117120436.GC28895@arm.com> <52DA3E41.9050202@huawei.com>
To: Jianguo Wu <wujianguo@huawei.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Jan 2014, at 08:41, Jianguo Wu <wujianguo@huawei.com> wrote:
> On 2014/1/17 20:04, Catalin Marinas wrote:
>> On Fri, Jan 17, 2014 at 09:40:02AM +0000, Jianguo Wu wrote:
>>> Now disabling kmemleak is an irreversible operation, but sometimes
>>> we may need to re-enable kmemleak at runtime. So add a knob to enable
>>> kmemleak at runtime:
>>> echo on > /sys/kernel/debug/kmemleak
>> 
>> It is irreversible for very good reason: once it missed the initial
>> memory allocations, there is no way for kmemleak to build the object
>> reference graph and you'll get lots of false positives, pretty much
>> making it unusable.
> 
> Do you mean we didn't trace memory allocations during kmemleak disable period,
> and these memory may reference to new allocated objects after re-enable? 

Yes. Those newly allocated objects would be reported as leaks.

Catalin