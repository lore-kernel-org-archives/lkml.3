Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab3DAPQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:16:21 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:60077 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab3DAPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
Date: Mon, 1 Apr 2013 08:16:17 -0700
X-Google-Sender-Auth: KjmD7zJM19zYUQirr3bnOlZqd1M
Message-ID: <CA+55aFzqYkX27E8R7Bu8pvn3xO+hKrgMEC7ec5gDz4kr1JbVtQ@mail.gmail.com>
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Salman Qazi <sqazi@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, yan@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 4:58 AM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
>
> To prevent use-after-free we need to hold device inode in loop_set_fd()
> and put it later in loop_clr_fd().

Is there something that guarantees that there's only one loop_set_fd()
and one paired loop_clr_fd()?

IOW, what protects us from somebody doing loop_clr_fd() on a device
that hasn't been set up yet, or doing multiple loop_set_fd calls?

I suspect the "lo->lo_state" is part of the answer, but it's very much
not obvious, and I'd want this to be explicitly explained.

              Linus
