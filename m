Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaDDRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:16:28 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42715 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaDDRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:16:26 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140404134429.GB26806@quack.suse.cz>
References: <20140403191558.GA8745@thunk.org>
	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
	<20140404035308.GC2525@thunk.org>
	<20140404134429.GB26806@quack.suse.cz>
Date: Fri, 4 Apr 2014 19:16:25 +0200
Message-ID: <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 3:44 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 03-04-14 23:53:08, Ted Tso wrote:
>> On Thu, Apr 03, 2014 at 12:39:42PM -0700, Linus Torvalds wrote:
>> > Btw, since I'm planning on getting to the filesystem pulls later today
>> > (or perhaps tomorrow), I wanted to check: are you ok with the ext4
>> > parts of the cross-rename patches from Miklos?
>> >
>> > They are currently at
>> >
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
>> >
>> > in case you want to refresh your memory.
>>
>> I've pulled in the cross-rename branch to my test branch and run a set
>> of tests, and it passes.  Unfortunately I don't believe Miklos
>> contributed tests for renameat(2) to xfstests, so we don't have any
>> on-point testing of renameat() and cross-rename, but it's at least not
>> triggering any failures on the existing tests.
>   Actually Miklos has contributed xfstests tests. I'm not sure if they were
> merged but I've seen them flying by.

Yes:

http://marc.info/?l=linux-kernel&m=139523745403081&w=2

The following cases are tested:

1) plain rename (flags = 0)
2) cross rename
3) noreplace rename

For each the following are tested:

a) same directory rename
b) cross directory rename

And all combinations of source and dest being:

- negative
- regular file
- symlink
- empty dir
- nonempty dir

After the operation the file type of both source and dest are checked
(or the error value returned).

Thanks,
Miklos
