Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3KUMhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:37:34 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:55609 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3KUMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:37:32 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20131121151044.8bbc8cbf38754803915471ef@canb.auug.org.au>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
	<1384952512-21600-5-git-send-email-miklos@szeredi.hu>
	<20131121151044.8bbc8cbf38754803915471ef@canb.auug.org.au>
Date: Thu, 21 Nov 2013 13:37:31 +0100
Message-ID: <CAJfpegsNuTOm5VJV9XLt9qu=wZ_-kRCEsmaWHr4M4sxw=WS9tg@mail.gmail.com>
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 5:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> On Wed, 20 Nov 2013 14:01:45 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Add new renameat2 syscall, which is the same as renameat with an added
>> flags argument.
>>
>> Pass flags to vfs_rename() and to i_op->rename() as well.
>>
>> All filesystems check flags and return -EOPNOTSUPP for unsupported flags.
>
> Can we please consider doing this slightly slower (and avoiding
> conflicts/missed new uses etc) by creating a new i_op callback and only
> implementing this when necessary?
>
> From past experience, I can just about guarantee that the patch as it is
> will cause conflicts (for me in linux-next if noone else) and a new use
> case will turn up before (or during) the next merge window.

I understand, but it makes little sense to have two i_op's with almost
exactly the same functionality, so at some point they are bound to be
merged, resulting in the same pain.

So Linus, how about applying the patches 1-4 at the end of this merge
window?  These are simple with no functional changes.  And then the
meat of the patchset can go into the next merge window without fear of
conflicts.

Thanks,
Miklos
