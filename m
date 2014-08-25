Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaHYADQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 20:03:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55323 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaHYADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 20:03:15 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFzW676RhCgu8Wp2SMcnKT2q82_DB9Aof74fwZPuXNtjZw@mail.gmail.com>
References: <20140824184035.GA13254@localhost>
	<CA+55aFzW676RhCgu8Wp2SMcnKT2q82_DB9Aof74fwZPuXNtjZw@mail.gmail.com>
Date: Sun, 24 Aug 2014 17:03:14 -0700
Message-ID: <CAOesGMg+CMMgHm=arDM_JuL0SMknPTKzoa-FMuf_UOGZyDx+6g@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.17-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kukjin Kim <kgene.kim@gmail.com>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 24, 2014 at 11:40 AM, Olof Johansson <olof@lixom.net> wrote:
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes
>
> Grr. Yes and no.
>
> You didn't really mean for me to pull that branch, you meant for me to
> pull your tag "fixes-for-linus".

Yes, of course -- and I missed that.

> Where did this fail? Do you still run an old broken git version that
> guesses at what the pull target is, and makes sh*t up? Please update
> if so.
>
> And if not, how did the tag contents get added to the pull request
> despite the pull request not mentioning the tag?

TL;DR: My fault, I'll double-check this in the future.

Long version:

100% operator error due to the tools changing. I'm still used to
looking for the warning that it doesn't find/use the remote tag as a
safety for these mistakes.

I'm still used to the older version that figured out tag name on its
own, so I did my usual:

 * run request-pull to double-check what's in the branch
 * create the tag
 * push the tag
 * rerun request-pull with the tag, redirect to file
...and then finally send the email with the file contents.

What I forgot to do was change the command line between the first and
the second run -- the first one referenced the branch, the second
should have referenced the tag but I just reused the same command from
history.

The old version of git that auto-guessed branch/tag name used to warn
if it used a tag to create the pull request, but didn't find the tag
in the remote repo. I suppose it'd be useful if the current version
warned if the third argument wasn't referring to the same tag as well,
it would definitely have saved me here.


-Olof
