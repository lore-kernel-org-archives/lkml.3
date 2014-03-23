Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaCWQga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:36:30 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:51603 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaCWQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140323071601.GH18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
Date: Sun, 23 Mar 2014 09:36:28 -0700
X-Google-Sender-Auth: GhgvjY6HiCaPzoYE-7xbmtO82gI
Message-ID: <CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 12:16 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Several fixes; first 4 commits are obvious fixes (a couple
> of fdget_pos()-related ones from Eric Biggers, prepend_name() fix, missing
> checks for false negatives from __lookup_mnt() in fs/namei.c)

I'm not seeing the obvious fix in the prepend_name() thing, and I
think it's horrible to *update* the name-len to negative like it now
does.

Why is anybody calling it with a negative buffer length in the first
place? *That* is the bug. Making the buflen become negative just makes
the bug worse, imnsho.

So I'm not pulling this, since the obvious fixes don't all look
obvious to me, and Sedat reports there are problems with it.

                Linus
