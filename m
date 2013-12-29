Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab3L2G1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 01:27:13 -0500
Received: from mail.wdtv.com ([66.118.69.84]:41546 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab3L2G1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 01:27:11 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: Git puzzle
Date: Sun, 29 Dec 2013 01:27:05 -0500
Cc: linux-kernel@vger.kernel.org
References: <201312282141.40725.gheskett@wdtv.com> <201312290011.26801.gheskett@wdtv.com> <20131229052556.GM19878@titan.lakedaemon.net>
In-Reply-To: <20131229052556.GM19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312290127.05858.gheskett@wdtv.com>
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
>
>> I haven't done this in a while and I'm still going thru the xconfig,
>> stripping out modules for hardware I don't have, but if I just transfer
>> the old ones in, they should work but will be building about 1400
>> modules extra.
>
>You may want to try the opposite approach.  x86_64_defconfig, then add
>just what is necessary to boot and reproduce the bug.
>
>hth,
>
>Jason.

Did that, then added some stuff for my hdwe, made sure the Makefile version 
and my makeit script versions matched. Fired off my build/install script, 
But it bailed out at the mkinitramfs stage, couldn't find 
/lib/modules/3.8.2 because it was named "3.8.2+".

So how does this work?  snilmerg? git playing in the sandbox somehow?  I'm 
going to see about some sleep in the meantime as its 1:30 Am here in WV, 
USA now.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

Living in New York City gives people real incentives to want things that
nobody else wants.
		-- Andy Warhol
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
