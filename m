Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3CWRe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:34:58 -0400
Received: from mail.wdtv.com ([66.118.69.84]:46879 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3CWRe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:34:57 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org, ubuntu-users@lists.ubuntu.com
Subject: 3.8.3 build error, compiler segfault
Date: Sat, 23 Mar 2013 13:34:54 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303231334.54169.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Trying to build a working 3.8.3 kernel, on a *buntu 10.04-4 LTS system here

My usual 'makeit' script didn't report any errors at the end, but the end 
trace on screen was obviously incomplete.

Adding a few more echo's to the script, and verifying that every line in it 
was terminated with " && \\r"  I reran it, and see an error that should 
have stopped it right there, but did not:
==========================
  CC      net/ipv6/icmp.o
net/ipv4/icmp.c:1115: internal compiler error: Segmentation fault
Please submit a full bug report,
with preprocessed source if appropriate.
See <file:///usr/share/doc/gcc-4.4/README.Bugs> for instructions.
make[2]: *** [net/ipv4/icmp.o] Error 1
make[1]: *** [net/ipv4] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      drivers/md/bitmap.o
===========================
as can be seen it kept marching, the error never made it to bash.

Much later in the screen trace:
===========================
  LD      net/ipv6/built-in.o
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....
  CC      drivers/of/of_mdio.o
============================

And eventually the screen trace ends with the report from the 'time -p'
from the invocation "time -p ./makeit"

I am using ccache, and cc -v says:
gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) 

My major problem in trying to build a newer kernel that the 2.6.32-122-43-
rtai currently running is that at least 50% of the time I run a make 
xconfig, the resultant .config saved has had the ext4 support, which this / 
partition is, has been removed, so the boot fails with the can't find the 
blkid of this partition error message.

Obviously I have more than one error, so how should I proceed?

The system is completely up to date for a 10.04-4 LTS install as of 2 or 3 
hours ago.

Thank you.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
Our swords shall play the orators for us.
		-- Christopher Marlowe
I was taught to respect my elders, but its getting 
harder and harder to find any...
