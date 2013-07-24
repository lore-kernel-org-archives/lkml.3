Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3GXREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:04:20 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41595 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3GXRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:04:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130724145506.GC15095@kroah.com>
References: <20130723220418.532514378@linuxfoundation.org>
	<CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	<20130724145506.GC15095@kroah.com>
Date: Wed, 24 Jul 2013 10:04:17 -0700
X-Google-Sender-Auth: wU-JfJJ4SOd1UdtlKXsA4W_GYuk
Message-ID: <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 7:55 AM, gregkh@linuxfoundation.org >>
"Kroah-Hartman, Greg" <gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 24, 2013 at 01:40:56PM +0000, Shuah Khan wrote:
>> Note: When I did a git reset --hard on 3.10.2-rc2 patch,
>> drivers/acpi/acpi_cmos_rtc.c was left as an untracked file.
>> I had to remove it before git pull succeeded for 3.10.2.
>
> Yes, that's because 3.10.2 added a new file to the tree, so this is to
> be expected.

.. well, depending on how you do it, yes.

So if you just originally apply it as a patch, and don't actually tell
git about the file, then yes, "git reset --hard" will leave the new
file alone, since git doesn't really even know about it - the same way
that "git diff" will not actually show the file at all, for the same
reason.

And then when you apply the patch again, or when you do a "git pull",
things will be unhappy, because you have that old untracked file
still.

When working with that kind of setup, you're generally best off doing
"git clean -dqfx" or similar to remove all files git doesn't know
about. Or just doing it by hand.

The alternative workflow is to tell git to track the new files added
by the patch. So if you use "git apply --index", git will not just
apply the patch, it will also add the result to the index - so you
could commit it with a single "git commit", and you can see the diff -
including new files - with "git diff --cached". And then "git reset
--hard" will also undo the new files.

So you *can* make git track the new files as you apply a patch.
Whether you actually want to is up to you.

                Linus
