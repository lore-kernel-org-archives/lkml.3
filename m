Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaCXIwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:52:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42135 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaCXIwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:52:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
Date: Mon, 24 Mar 2014 09:52:30 +0100
Message-ID: <CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 6:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Mar 23, 2014 at 9:45 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> It's easier to skip checking the overflow on prepend() of "\0" in the
>> beginning of the whole thing and just let the next operation to fail.
>> That's where the corner case comes from.
>
> Ok, I'll buy the first four commits. Let's wait for Sedat's report on the rest.
>
>                   Linus
>

Hi,

I have tested w/ Al's patch from [1].

AFAICS this changes are now updated in vfs.git#for-linus branch as

commit 9d25fe7e232b ("switch mnt_hash to hlist").

I had a 2nd trouble w/ the old code, installing a Debian package
resulted also in a freeze.
This now works.

The LTP test is still running... and my -5 kernel with Al's fix seems
to hit the 700+ KiB barrier in my logs.

$ LC_ALL=C ls -l /opt/ltp/runltp-log_3.14.0-rc7-[0-9]*-iniza-small.txt
-rw-r--r-- 1 root root  733184 Mar 23 09:51
/opt/ltp/runltp-log_3.14.0-rc7-4-iniza-small.txt
-rw-r--r-- 1 root root  822533 Mar 24 09:51
/opt/ltp/runltp-log_3.14.0-rc7-5-iniza-small.txt
-rw-r--r-- 1 root root 1142248 Mar 23 11:44
/opt/ltp/runltp-log_3.14.0-rc7-66-iniza-small.txt

[ NOTE ]
-66: vanilla Linus-tree
-4: -66 plus old vfs-fixes
-5: -66 plus old vfs-fixes plus Al's fix from [1]

If you like give the usual credits.

Regards,
- Sedat -

P.S.: [Off-topic] With vanilla -66 kernel I have some OOPS in the
oom[1..5] tests of LTP. Whom to adress? mm-folks?

[1] http://marc.info/?l=linux-kernel&m=139559379906251&w=2
