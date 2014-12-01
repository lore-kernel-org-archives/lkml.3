Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaLAQ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:28:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42622 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaLAQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:28:33 -0500
Date: Mon, 1 Dec 2014 16:28:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 10/12] kmemleak: disable kasan instrumentation for
 kmemleak
Message-ID: <20141201162810.GA13676@localhost>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-11-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417104057-20335-11-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 04:00:54PM +0000, Andrey Ryabinin wrote:
> kmalloc internally round up allocation size, and kmemleak
> uses rounded up size as object's size. This makes kasan
> to complain while kmemleak scans memory or calculates of object's
> checksum. The simplest solution here is to disable kasan.

This would indeed be the simplest since by the time kmemleak callbacks
get called (from slub) we lose the original size information (especially
for kmem_cache_alloc).

> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  mm/kmemleak.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
