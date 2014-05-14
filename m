Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaENOzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:55:44 -0400
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:39703 "EHLO
	bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762AbaENOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:55:44 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 10:55:43 EDT
Date: Wed, 14 May 2014 16:46:32 +0200
From: Rogier Wolff <R.E.Wolff@bitwizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Buffer cache not working. 
Message-ID: <20140514144632.GB7404@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard B.V.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Guys, 

I have a file-server that has plenty of memory to cache most of the
things that I use. But after I've upgraded the machine it seems to
expire things from the cache even when there is zero memory pressure.

The case that irritates me most is my mailbox. Ok, I should clean it
out, but also my linux-kernel mailbox has 20k messages (= 1 month).

When I open such a mailbox in mutt, it takes 2 minutes for it to read
all the messages. If I quit and restart, it takes less than a second. 
I've resorted to a workaround: every 30 seconds: head Mailbox/cur/* . 
That worked. 

Oh, before a recent upgrade all this worked as I expected: Once a day,
after the backup had run, scanning the mailbox takes a while and then
the rest of the day things are quick. 

Then I gathered: Other people must have the same problem. It is
probably a "tuning" setting which works for desktop machines, but not
for my server. So I've googled a few "tuning your Linux system" pages
and all I could think of that might relate to my problem is
"swappiness".

I've decreased the value from 100 (in a few steps) to 5 now, and this
seems to help somewhat. But still after a few minutes, the buffer
cache drops my maildir, and starting mutt takes a long time again.

All this with the machine reporting 11Gb or more of RAM "Free"
(empty). 

With the default swappiness, I've tested that in a minute already some
of the maildir gets ejected from the cache, while when accessing all
files every 30 seconds seems to keep them cached. 

Kernel: from Ubuntu 14.04, 3.13.0-19-generic
32-bit userspace
16Gb RAM installed. 
Disks: 3x 3T in RAID5

ganglia shows the server memory graph as follows: 
http://prive.bitwizard.nl/server_mem.png

All other computers have a "nice" filled graph there.

So, is there a bug in my kernel or am I missing an important tuning
parameter?


	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
The plan was simple, like my brother-in-law Phil. But unlike
Phil, this plan just might work.
