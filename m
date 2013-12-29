Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838Ab3L2FmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 00:42:04 -0500
Received: from mail.wdtv.com ([66.118.69.84]:38652 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3L2FmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 00:42:03 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: Git puzzle
Date: Sun, 29 Dec 2013 00:42:00 -0500
References: <201312282141.40725.gheskett@wdtv.com> <201312290011.26801.gheskett@wdtv.com> <20131229052556.GM19878@titan.lakedaemon.net>
In-Reply-To: <20131229052556.GM19878@titan.lakedaemon.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312290042.00841.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 December 2013, Jason Cooper wrote:
>Gene,
>
>On Sun, Dec 29, 2013 at 12:11:26AM -0500, Gene Heskett wrote:
>> On Saturday 28 December 2013, Jason Cooper wrote:
>> >On Sat, Dec 28, 2013 at 09:41:40PM -0500, Gene Heskett wrote:
>...
>
>> >> working toward 3.8.3 which doesn't, and I have the disk space
>> >> chowned to me, what is the exact syntax to pull a clone of 3.8.2,
>> >> and then do a bisect to 3.8.3 where the microcode update for an AMD
>> >> phenom doesn't work. Skipping fwd to 3.12.0 it still isn't working.
>> >
>> >The version tags you are referring to are from the linux-stable tree,
>> >so we'll clone that one instead of Linus'.
>> >
>> >So, something like this:
>> >
>> >$ git clone \
>> >git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>> >\ ~/linux-stable
>> 
>> Looks like its working.
>> 
>> >$ cd ~/linux-stable
>> >$ git checkout v3.8.3
>> >$ git bisect start
>> >$ git bisect bad
>> >$ git bisect good v3.8.2
>> >$ ...
>> >
>> >And now you iterate through as the manpage suggests, until it narrows
>> >it down to a single commit.  Once there, report to this list with
>> >'[BUG BISECTED] ...' in the subject line.
>> >
>> >hth,
>> 
>> Yes, I think I can nail it now.  One final clarification, do I use a
>> .config geared more to my machine, or am I supposed to do a "make
>> allmodconfig?"
>
>I would use the smallest config that allows me to boot the system and
>reproduce the bug.  A good starting point is /proc/config.gz from the
>running system.  allmodconfig is just sticking the knife in and
>twisting unnecessarily.

That was my thinking. So I asked. :)

>> I haven't done this in a while and I'm still going thru the xconfig,
>> stripping out modules for hardware I don't have, but if I just transfer
>> the old ones in, they should work but will be building about 1400
>> modules extra.
>
>You may want to try the opposite approach.  x86_64_defconfig, then add
>just what is necessary to boot and reproduce the bug.

Oh-oh, and where in this new tree do I find that?  Or is that a make 
command?

I use a script called makeit, does everything but the grub-update.  
Designed to stop if it encounters an error so the error doesn't scroll off 
screen.

Thanks. 
>
>hth,
>
>Jason.


Cheers, Gene
