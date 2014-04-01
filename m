Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaDAR1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:27:49 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36875 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaDAR1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140401175947.5b5a3298@alan.etchedpixels.co.uk>
References: <20140331211607.26784.43976.stgit@zurg>
	<20140401175947.5b5a3298@alan.etchedpixels.co.uk>
Date: Tue, 1 Apr 2014 21:27:47 +0400
Message-ID: <CALYGNiONACddsH_6uaG5QyaWRaZ_5ZH0atZJyZVD=DowiKLJcw@mail.gmail.com>
Subject: Re: [PATCH RFC] drivers/char/mem: byte generating devices and
 poisoned mappings
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Yury Gribov <y.gribov@samsung.com>,
        Alexandr Andreev <aandreev@parallels.com>,
        Vassili Karpov <av1474@comtv.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 8:59 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Tue, 01 Apr 2014 01:16:07 +0400
> Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
>> This patch adds 256 virtual character devices: /dev/byte0, ..., /dev/byte255.
>> Each works like /dev/zero but generates memory filled with particular byte.
>
> More kernel code for an ultra-obscure corner case that can be done in
> user space
>
> I don't see the point

True. That was a long-planned joke.
But at the final moment I've found practical usage for it and overall
design became not such funny.

Currently I'm thinking about single-device model proposed by Kirill.

Let's call it /dev/poison. Application can open it, write a poison (up
to a page size) and after that this instance will generate pages
filled with this pattern. I don't see how this can be done in
userspace without major memory/cpu overhead caused by initial memset.

Default poison might be for example 0xff, so it still will be useful for 'dd'.
