Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaH1PuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:50:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47632 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaH1PuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140827135348.9c9ccefebccc74083f7ba922@linux-foundation.org>
References: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
	<20140827135348.9c9ccefebccc74083f7ba922@linux-foundation.org>
Date: Fri, 29 Aug 2014 00:50:14 +0900
Message-ID: <CAC5umygnUybkmut9NogAxRD14kQp-NAq5=m14QRVng8pYEAhHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: use memblock_alloc_range() or memblock_alloc_base()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-28 5:53 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 24 Aug 2014 23:56:02 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> Replace memblock_find_in_range() and memblock_reserve() with
>> memblock_alloc_range() or memblock_alloc_base().
>
> Please spend a little more time preparing the changelogs?

OK, I'll be careful next time.

> Why are we making this change?  Because memblock_alloc_range() is
> equivalent to memblock_find_in_range()+memblock_reserve() and it's just
> a cleanup?  Or is there some deeper functional reason?

This is just a cleanup and I thought there are no functional change.
But I've just realized that the conversion to memblock_alloc_base() in
this patch changes the behaviour in the error case.
Because memblock_alloc_base calls panic if it can't allocate.

So please drop this patch from -mm tree for now.

> Does memblock_find_in_range() need to exist?  Can we convert all
> callers to memblock_alloc_range()?

There are two callsites where we can't simply convert with
memblock_alloc_range (arch/s390/kernel/setup.c, arch/x86/mm/init.c).
