Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3ATWFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:05:18 -0500
Received: from sylphide-consulting.com ([82.225.154.2]:43855 "EHLO
	freehackers.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3ATWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:05:17 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2013 17:05:17 EST
Message-ID: <50FC67B9.7080600@freehackers.org>
Date: Sun, 20 Jan 2013 22:55:05 +0100
From: Thomas Capricelli <orzel@freehackers.org>
Organization: freehackers.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel failing to boot when compressed with bzip2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have had this weird behaviour that seems to be important enough to
report on lkml. I compile my own kernels since ~1994 and never had this
bug before. There are actually two problems :

1st problem
Since around September 2012, i have tried to compile my kernel 3.6.x
with gcc-4.7. It failed this way: just after grub loaded the kernel,
after displaying "Decompressing Linux", the computer rebooted. The exact
same kernel (same .config) compiled with gcc-4.6 would boot perfectly. I
did several tests, it was all very reproducible.
I didn't pay attention and just stick with gcc-4.6 when compiling my
kernel. I thought it would just get fixed with time.

2nd problem
Then the kernel 4.7 was released. I started testing with 4.7.1, did the
usual stuff and obviously, I used gcc-4.6, because of the previous
problem. Guess what, I've had _exactly_ the same behaviour. I double
checked and again i could reproduce it very well:
    kernel 3.6 / gcc 4.6 -> OK
    kernel 3.7 / gcc 4.6 -> reboot after printing "Decompressing Linux"
    kernel 3.6 / gcc 4.7 -> reboot after printing "Decompressing Linux"

It took some time to find out the source of the problem, which will
probably feel obvious to many of you: a long time ago, i had switched
from using CONFIG_KERNEL_GZIP to using CONFIG_KERNEL_BZIP2, probably
just for the fun of testing it. I can't remember when but it was
probably very long ago  (2 years ?).

Testing confirmed : going back to CONFIG_KERNEL_GZIP fixed it all and i
could not only use gcc-4.7 but also kernel 4.7.

So my guess is that there's something badly broken in the bzip2 kernel
decompressing code.. ? There's both a regression between kernel 3.6 and
3.7, and a problem with gcc-4.7.

Here are some more information, just ask if you need some more. I can
even do some testing, but you'll need to cc: me as i'm not anymore on lkml.

* the cpu is "AMD Athlon(tm) II X4 620 Processor" as reported by
/proc/cpuinfo
* CONFIG_DECOMPRESS_BZIP2=y was set on all my tests (not sure it's relevant)
* the last 3.6 kernel tested was 3.6.11
* 4.7 kernels tested were 4.7.1, 4.7.2, and 4.7.3
* the computer will reboot really fast just after the kernel kprinted
"Decompressing Linux", nothing is kprinted after this.

best regards,

-- 
Thomas Capricelli <orzel@freehackers.org>
http://www.freehackers.org/thomas/

