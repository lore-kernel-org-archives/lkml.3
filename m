Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaLQKTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:19:22 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:46066 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaLQKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:19:20 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141217101508.GI22149@ZenIV.linux.org.uk>
References: <20141217100202.GA19050@tucsk>
	<20141217101508.GI22149@ZenIV.linux.org.uk>
Date: Wed, 17 Dec 2014 11:19:19 +0100
Message-ID: <CAJfpegtmMhkFtKQyynxZ=Lo8BhbJVnnhrqHdYmycAie1gAj2WA@mail.gmail.com>
Subject: Re: [GIT PULL] fuse update for 3.19
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:15 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Dec 17, 2014 at 11:02:02AM +0100, Miklos Szeredi wrote:
>> Hi Linus,
>>
>> Please pull from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
>>
>> First part makes sure we don't hold up umount with pending async requests.  In
>> addition to being a cleanup, this is a small behavioral change (for the better)
>> and unlikely to break anything.  Second part prepares for a cleanup of the fuse
>> device I/O code by adding a helper for simple request submission, with some
>> savings in line numbers already realized.
>
> Umm...  Make that igrab(file->f_path.dentry->d_inode) igrab(file_inode(file)),
> please.  OTOH, that can wait for after merge - it's a trivial followup and
> I can take it via vfs.git...

Yeah, I spotted that and added a separate patch (the last one in that pull).

Thanks,
Miklos
