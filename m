Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaIBXEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:04:25 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48924 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaIBXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140902171036.GA12406@kria>
References: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
	<1408892163-8073-2-git-send-email-akinobu.mita@gmail.com>
	<20140902171036.GA12406@kria>
Date: Wed, 3 Sep 2014 08:04:20 +0900
Message-ID: <CAC5umygz-bsrWJErmyaLE25cXCpXHpw5uiKeM7-pD+KvKtjmxw@mail.gmail.com>
Subject: Re: kmemleak: Cannot insert [...] into the object search tree
 (overlaps existing) (mm: use memblock_alloc_range())
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-03 2:10 GMT+09:00 Sabrina Dubroca <sd@queasysnail.net>:
> Hello,
>
> 2014-08-24, 23:56:03 +0900, Akinobu Mita wrote:
>> Replace memblock_find_in_range() and memblock_reserve() with
>> memblock_alloc_range().
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: linux-mm@kvack.org
>
> This patch is included in linux-next, and when I boot next-20140901,
> on a 32-bit build, I get this message:
>
>
> kmemleak: Cannot insert 0xf6556000 into the object search tree (overlaps existing)

kmemleak_alloc() in memblock_virt_alloc_internal() should have been removed by
the conversion in this patch.  Otherwise kmemleak() is called twice because
memblock_alloc_range() also calls it.

Andrew, could you drop this patch for now.  I'll send the patch with this fix.

Thanks for the report.
