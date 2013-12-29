Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab3L2FLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 00:11:30 -0500
Received: from mail.wdtv.com ([66.118.69.84]:56795 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3L2FL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 00:11:29 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: Git puzzle
Date: Sun, 29 Dec 2013 00:11:26 -0500
Cc: linux-kernel@vger.kernel.org
References: <201312282141.40725.gheskett@wdtv.com> <20131229043547.GJ19878@titan.lakedaemon.net>
In-Reply-To: <20131229043547.GJ19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312290011.26801.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 December 2013, Jason Cooper wrote:
>Hey Gene,
>
>On Sat, Dec 28, 2013 at 09:41:40PM -0500, Gene Heskett wrote:
>> Hey guys, I need to setup a bisect using git but the man pages aren't
>> giving me what I need to know.  Mainly I have no clue what the URL for
>> the git repos looks like, I've been downloading and building the
>> tarballs from kernel.org all this time.
>
>Looks like you now have your driving problem to learn git. ;-)
>
>> Assuming I start with fresh git pull of 3.8.2 which worked,
>
>Here's where the wheels come off the cart.  You aren't cloning a specific
>revision/tag/version.  'git clone' makes a clone (hence the name) of the
>entire tree's history.  Once you have a clone on your local disk, you
>can then checkout _any_ version you want.  You have *all* of them.  This
>is what 'git bisect' will be doing for you.
>
>> working toward 3.8.3 which doesn't, and I have the disk space chowned
>> to me, what is the exact syntax to pull a clone of 3.8.2, and then do
>> a bisect to 3.8.3 where the microcode update for an AMD phenom doesn't
>> work. Skipping fwd to 3.12.0 it still isn't working.
>
>The version tags you are referring to are from the linux-stable tree, so
>we'll clone that one instead of Linus'.
>
>So, something like this:
>
>$ git clone \
>git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
>~/linux-stable

Looks like its working.

>$ cd ~/linux-stable
>$ git checkout v3.8.3
>$ git bisect start
>$ git bisect bad
>$ git bisect good v3.8.2
>$ ...
>
>And now you iterate through as the manpage suggests, until it narrows it
>down to a single commit.  Once there, report to this list with '[BUG
>BISECTED] ...' in the subject line.
>
>hth,

Yes, I think I can nail it now.  One final clarification, do I use a 
.config geared more to my machine, or am I supposed to do a "make 
allmodconfig?"

I haven't done this in a while and I'm still going thru the xconfig, 
stripping out modules for hardware I don't have, but if I just transfer the 
old ones in, they should work but will be building about 1400 modules 
extra.

I just got the 2nd message about marking the subject line, can do, thanks.

Thanks Jason.

>Jason.


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

BOFH excuse #8:

static buildup
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
