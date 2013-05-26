Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3EZGQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:16:14 -0400
Received: from moltke.seatribe.se ([178.63.100.209]:51066 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3EZGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:16:13 -0400
X-Greylist: delayed 2818 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 May 2013 02:16:12 EDT
Date: Sun, 26 May 2013 07:29:08 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: linux-kernel@vger.kernel.org
Subject: Weird disk idling
Message-ID: <alpine.DEB.2.02.1305260712220.8957@shack.dolda2000.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.7 (nerv.dolda2000.com [IPv6:2002:54d9:e26d:200::1]); Sun, 26 May 2013 07:29:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

In order to debug I/O performance, I recently wrote a tiny program for 
inspecting /sys/block/$DISK/stat. It works by dumping deltas of the values 
every 100 ms, quite simply (except the queue-length value, for which 
deltas are clearly useless).

Using this, I often see periods during constant I/O loads where there are 
lots of requests in the queue, but the disk is completely idle. They 
usually last somewhere from 0.1 to 2 seconds. Using the aforementioned 
program, they might look, for instance, like this:

1369545418.8       0        0        0        0        2        0       16     4888      134      100    13400
1369545418.9       0        0        0        0        0        0        0        0      134      100    13400
1369545419.0       0        0        0        0        0        0        0        0      135      104    13984
1369545419.1       0        0        0        0        0        0        0        0      135      100    13500
1369545419.2       0        0        0        0        0        0        0        0      135      100    13500
1369545419.3       0        0        0        0        0        0        0        0      135      100    13500
1369545419.4       0        0        0        0        0        0        0        0      135      100    13500
1369545419.5       0        0        0        0        0        0        0        0      135      100    13500
1369545419.6       0        0        0        0        0        0        0        0      135      104    14040
1369545419.7       2        0       64      672       58        0     1185   152512       78      100    11296

I'm sure you all know what the various fields are (except the first, which 
is just a timestamp), so as you can see, there are 135 requests in the 
queue, but no reads or writes happen, in this case, for at least 800 ms.

Is this behavior normal and expected, or is there something wrong here? In 
the latter case, is it my hardware that is failing somehow, or can there 
be some software weirdness that can be tweaked away or bugfixed?

The disk in question is a 640 GB WDC Caviar Green, and it's attached via 
an old Silicon Image 3114 PCI card. Clearly, the hardware is less than 
optimal, but can that explain this behavior? (For the record, the disk 
does at least not report any SMART errors, and there are no errors about 
in the dmesg.)

The kernel version is 3.7.1, and the scheduler is CFQ.

Thanks for reading!

--

Fredrik Tolf
