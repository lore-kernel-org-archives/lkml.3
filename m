Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3GIDv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:51:56 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48721 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GIDvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <1373173169.1943.1.camel@joe-AO722>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
	<1373173169.1943.1.camel@joe-AO722>
Date: Mon, 8 Jul 2013 20:51:53 -0700
Message-ID: <CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 6, 2013 at 9:59 PM, Joe Perches <joe@perches.com> wrote:
>
> Not correct.
>
>>       while (start < end) {
>> -             size_t mid = start + (end - start) / 2;
>> +             size_t mid = (start + end) / 2;
>
>         size_t start = 0x80000000;
>         size_t end   = 0x80000001;

Good point, they aren't equivalent in all cases.

For the overflow to happen though, we need an array with at least
N/2+1 entries, where N is the address space size. The array wouldn't
fit in addressable memory if the element size is greater than 1, so
this can only really happen when the element size is 1. Even then, it
would require the kernel range to be greater than half of all
addressable memory, and allow an allocation taking that much memory. I
don't know all architectures where linux runs, but I don't think such
configuration is likely to exist.
