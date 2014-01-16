Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaAPVZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:25:09 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56478 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAPVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140116184121.34d1e97c@lilie>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
	<CAPp3RGpWhx4uoTTiSkUe9rZ2iJjMW6O2u=xdWL7BSskse=61qw@mail.gmail.com>
	<20140116164936.1c6c3274@lilie>
	<CAPp3RGpt+qjFYrA928hBjseJNo4v0RKVnb-BjFJzH0uaVGcX+g@mail.gmail.com>
	<20140116184121.34d1e97c@lilie>
Date: Thu, 16 Jan 2014 15:25:04 -0600
Message-ID: <CAPp3RGp2qi0mLnbZv1ZZuKnz+1yqV2gC1LfP3xxhmhosoBNhzg@mail.gmail.com>
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
From: Robin Holt <robinmholt@gmail.com>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jiang Liu <liuj97@gmail.com>,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, Robin Holt <robin.m.holt@gmail.com>,
        yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the definition of the
get_allocated_memblock_reserved_regions_info() function when
CONFIG_ARCH_DISCARD_MEMBLOCK simply returns 0, the compiler will see
that size is defined, the optimizer will see that it is always 0 and
that the if(0) is always false.  The net result will be no code will
be produced and the function will be less cluttered.

On Thu, Jan 16, 2014 at 11:41 AM, Philipp Hachtmann
<phacht@linux.vnet.ibm.com> wrote:
>
>> I would think you would be better off making
>> get_allocated_memblock_reserved_regions_info() and
>> get_allocated_memblock_memory_regions_info be static inline functions
>> when #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK.
> Possible, of course.
> But the size variable has still to be #ifdef'd. And that's what the
> patch is about. It's just an addition to another patch.
>
>
