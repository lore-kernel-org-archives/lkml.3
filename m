Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3EGXRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:17:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36102 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EGXRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:17:31 -0400
Message-ID: <51898B87.9020005@mit.edu>
Date: Tue, 07 May 2013 16:17:27 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The type of bitops
References: <51884263.4020608@zytor.com> <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
In-Reply-To: <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 05:51 PM, Linus Torvalds wrote:
> The only place where the actual size of the data matters is in the
> underlying bitop bitmap itse;f, and that has always been defined to be
> an array of "unsigned long", and we long logn since made sure people
> aren't confused about that. But the index? It's just a number, there's
> no structure associated with it. Somebody might use an "unsigned char"
> as the index into a bitmap, and the operations fundamentally wouldn't
> care - casting the bit index it to an "int" (or a "long") doesn't
> change the operation.

The one and only time I tried to use this, I thought this was odd.  Long
has a different size on 32 vs 64 bit architectures, and bit ops seem
like they'd want to be the same size everywhere so you can allocate the
appropriate number of bits.  (Also, if you only want 32 bits, you have
to do some evil cheating, and I don't trust casting int* to long* on
big-endian architectures.)

Would offering a u32* option make sense?

--Andy
