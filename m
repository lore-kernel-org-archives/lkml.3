Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaEaTjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:39:37 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41664 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaEaTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <538A1B75.5030107@gmail.com>
References: <538A1B75.5030107@gmail.com>
Date: Sat, 31 May 2014 12:39:34 -0700
X-Google-Sender-Auth: Ncr07O4GS88YpjzbfTOOdfvqYek
Message-ID: <CA+55aFzfrGYCeUgXkeVowfJY+CL6MFPo7LpWSGiZvKhGA_qroQ@mail.gmail.com>
Subject: Re: [PATCH] fs/buffer.c: grow_buffers: fix the uncorrect check
From: Linus Torvalds <torvalds@linux-foundation.org>
To: mnipxh <mnipxh@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, shuox.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 11:12 AM, mnipxh <mnipxh@gmail.com> wrote:
> When pgoff_t index is 32bit, sector_t block is 64bit, need check if block number is too big.
> If block is bigger than (4Gb * PAGE_SIZE), index becomes a wrong value.
> Commit e5657933863f43cc6bb76a54d659303dafaa9e58 wants to do this. But it gives an uncorrect check.
> I think block != index << sizebits is correct. And it can detect such issue above.

I don't understand why you think the current check is incorrect.

It is testing that the calculation hasn't overflowed. It is correct.
It *should* use the same calculation, to (a) make it more obvious that
it's double-checking the earlier calculation in a different type, and
(b) to make it easier for the compiler to optimize it away if sector_t
and pgoff_t are the same size.

So the current code is correct, afaik. Note that "index" is "pgoff_t",
but "block >> sizebits" is "sector_t".

               Linus
