Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3LJUIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:08:24 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:41355 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3LJUIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:08:21 -0500
MIME-Version: 1.0
In-Reply-To: <1386702658-21430-2-git-send-email-will.deacon@arm.com>
References: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
	<1386702658-21430-2-git-send-email-will.deacon@arm.com>
Date: Tue, 10 Dec 2013 12:08:20 -0800
X-Google-Sender-Auth: YD5OVSJVX_uYzqKJJXXorq66A3I
Message-ID: <CA+55aFzVrAQnmt7a_SKqOVyHrY55_uRP1yL4NGAXspeee6ZkRQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] word-at-a-time: provide generic big-endian
 zero_bytemask implementation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Did you try to time this?

Also, I really have #ifdef's in code, and I think we'd be better off
just exposing a function that does this

+#ifdef __BIG_ENDIAN
+       mask = ~(~0ul >> tcount*8);
+#else
        mask = ~(~0ul << tcount*8);
+#endif

thing. I think it would logically go together with zero_bytemask(),
call it something like "bytemask_from_count()" or something. Hmm? It's
basically just the reverse of "count_masked_bytes()", which we also
have an abstraction for.

So the #ifdef really looks out of place for me. We've generated all
these nice abstractions for all the other mask handling, and then you
add that ugly ifdef for this case.

                 Linus
