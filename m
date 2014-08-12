Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHLJhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:37:19 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:60951 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaHLJhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:37:16 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <24270.1407767827@warthog.procyon.org.uk>
References: <24270.1407767827@warthog.procyon.org.uk>
Date: Tue, 12 Aug 2014 11:37:15 +0200
Message-ID: <CAJfpegtoO6wub5+diEhiVfUmj+ZxeT5wi_6EPxFJgqtXuqraog@mail.gmail.com>
Subject: Re: Race in ovl_copy_up()?
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 4:37 PM, David Howells <dhowells@redhat.com> wrote:

> In the for-loop in the middle, if you ascend any levels at all, how are you
> protected from racing with copy-ups taking place on those more rootwards
> dentries?
>
> I can see ovl_copy_up_one() using lock_rename() on the workdir and upperdir,
> but there's no relevant lock on the overlayfs fs.

Locking upperdir should be enough protection.

Lets say we have a race:

A: copy_up(a/b/c/d)
B: copy_up(a/b/e/f)

Both ascend to "b" and try to lock "a".  The one that wins the lock
acquisition will do the copy-up, the other one will just skip it once
it gets the lock.

Thanks,
Miklos
