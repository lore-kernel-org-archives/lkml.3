Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3JJClj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:41:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53534 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3JJCli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131010004732.GJ13318@ZenIV.linux.org.uk>
References: <20131010004732.GJ13318@ZenIV.linux.org.uk>
Date: Wed, 9 Oct 2013 19:41:36 -0700
X-Google-Sender-Auth: pJmu7zpNj_Uk3fx7-1DOq8Cqm40
Message-ID: <CA+55aFzLXz1XkbjvNzuF8cOwioLJjoc2QR7C3qy_eSyqM1GG2Q@mail.gmail.com>
Subject: Re: [RFC] do we want pipefs et.al. in /proc/filesystems?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 5:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         These days there's no reason to register the filesystem types
> that can only be used for internal mounts - ia64 pfmfs, anon_inodes,
> bdev, pipefs and sockfs, in the current tree.  The only user-visible
> effect of dropping those register_filesystem() would be shorter
> /proc/filesystems - that bunch wouldn't be mentioned there anymore.
> Does anything care about that?  FWIW, the diff eliminating those
> would be as below (net/socket.c init leaks on early failures;
> I'd left that as-is - it's a separate story).

I like the patch, but I do worry that some user space thing uses this
to check whether the particular filesystem module is loaded.

Those kinds of things can't use /proc/modules (because it might be
built-in), but /proc/filesystems has traditionally contained
everything.

That said, these particular filesystems I really don't think people
would ever possibly check for, so I think it's fine.

              Linus
