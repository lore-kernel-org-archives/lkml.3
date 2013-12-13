Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3LMBYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:24:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38693 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab3LMBYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:24:44 -0500
Message-ID: <52AA61BF.9080204@ti.com>
Date: Thu, 12 Dec 2013 20:24:15 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 13/23] mm/lib/swiotlb: Use memblock apis for early
 memory allocations
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com> <1386625856-12942-14-git-send-email-santosh.shilimkar@ti.com> <20131212170857.e36d016a95992c932da824b0@linux-foundation.org>
In-Reply-To: <20131212170857.e36d016a95992c932da824b0@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 08:08 PM, Andrew Morton wrote:
> On Mon, 9 Dec 2013 16:50:46 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
>> Switch to memblock interfaces for early memory allocator instead of
>> bootmem allocator. No functional change in beahvior than what it is
>> in current code from bootmem users points of view.
>>
>> Archs already converted to NO_BOOTMEM now directly use memblock
>> interfaces instead of bootmem wrappers build on top of memblock. And the
>> archs which still uses bootmem, these new apis just fallback to exiting
>> bootmem APIs.
> 
> This one makes my x86_64 test box fail to boot.  There's no obvious
> indication why and I don't have netconsole on this machine, sorry.  It
> simply fails to mount the root fs.
> 
> config:
> 
Thanks for config and reporting the issue.
Unfortunately I don't have ability to test x86 machine but will
try to analyze it and find out whats could be going wrong.

Failure around rootfs mount means it could be something to do
with memory free related code from the patch.

Regards,
Santosh
