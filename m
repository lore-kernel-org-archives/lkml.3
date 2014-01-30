Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaA3WQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:16:13 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:38951 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaA3WQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
 <8761p1m98f.fsf@xmission.com> <CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Thu, 30 Jan 2014 23:15:31 +0100
Message-ID: <CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-30 Linus Torvalds <torvalds@linux-foundation.org>:
> On Thu, Jan 30, 2014 at 1:48 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> These files have been read-only since this code was merged in 2002.
>> Over a decade of not being used seems like a strong indication that no
>> one cares about the write path.
>
> I think this is a pretty strong argument. Counter-arguments, anybody?
>
>                      Linus

Hi!

In afs documentation is written that you need to write to these files. See:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/afs.txt#n82
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/afs.txt#n159

Without cells file, you cannot specify other cell servers and you can
use only one rootcell which was specified in kernel cmdline. So for
mounting other server, you need to reboot kernel (if you compiled afs
driver statically) and without cells file there is no other option to
mount more afs servers... (or at least it is not written in that
documentation). So I think without write access it is hard or maybe
impossible to use afs driver.

But maybe, afs maintainers or other afs developers should write more
info about it (or update documentation if is old).

-- 
Pali Rohár
pali.rohar@gmail.com
