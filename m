Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161412AbaJ3W6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:58:20 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42418 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161298AbaJ3W6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
Date: Thu, 30 Oct 2014 15:58:18 -0700
X-Google-Sender-Auth: xQoaaiX5f_Qnv9pUhEwnQvHGIEc
Message-ID: <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Rannaud <e@nanocritical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Agreed. Will apply and add the stable cc.

Ho humm. Thinking about this some more, I'm starting to wonder. Not
about this patch per se (open on a newly created file should indeed
succeed regardless), but about the horrible glibc behavior of screwing
up the third argument.

If you want to do O_TMPFILE + linkat() (or some eventual future
flink()), the mode really matters. So this idiotic glibc behavior of
only forwarding the third argument if O_CREAT is set seems to be a
bug.

Why the hell does glibc think it's a good idea to intersect system
call semantics? It's not a good idea - it's just stupid in the
extreme. And in this case it seems to actively breaks things.

                     Linus
