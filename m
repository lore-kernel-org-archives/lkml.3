Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaAQMFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:05:12 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44056 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751276AbaAQMFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:05:10 -0500
Date: Fri, 17 Jan 2014 12:04:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>, Wang Nan <wangnan0@huawei.com>
Subject: Re: [PATCH] mm/kmemleak: add support for re-enable kmemleak at
 runtime
Message-ID: <20140117120436.GC28895@arm.com>
References: <52D8FA72.8080100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D8FA72.8080100@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:40:02AM +0000, Jianguo Wu wrote:
> Now disabling kmemleak is an irreversible operation, but sometimes
> we may need to re-enable kmemleak at runtime. So add a knob to enable
> kmemleak at runtime:
> echo on > /sys/kernel/debug/kmemleak

It is irreversible for very good reason: once it missed the initial
memory allocations, there is no way for kmemleak to build the object
reference graph and you'll get lots of false positives, pretty much
making it unusable.

-- 
Catalin
