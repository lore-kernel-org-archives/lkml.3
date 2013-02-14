Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3BNCsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:48:04 -0500
Received: from fn.samba.org ([216.83.154.106]:38477 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3BNCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:48:02 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 21:48:02 EST
Message-ID: <1360809636.1727.304.camel@jesse>
Subject: Read support for fat_fallocate()?  (was  [v2] fat: editions to
 support fat_fallocate())
From: Andrew Bartlett <abartlet@samba.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jpm, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Date: Thu, 14 Feb 2013 13:40:36 +1100
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day,

I've been looking into the patch "[v2] fat: editions to support
fat_fallocate()" and I wonder if there is a way we can split this issue
in two, so that we get at least some of the patch into the kernel.

https://lkml.org/lkml/2012/10/13/75
https://patchwork.kernel.org/patch/1589161/

What I'm wanting to discuss (and perhaps implement, with you if
possible) is splitting this patch into writing to existing pre-allocated
files, and creating a new pre-allocation.

If Windows does, as you claim, simply read preallocations as zero, and
writes to them normally and without error, then Linux should do the
same.  Here of course I'm assuming that Windows is not preallocating,
but instead simply trying to recover gracefully and safely from a simple
'file system corruption', where the sectors are allocated but not used. 

The bulk of this patch is implementing this transparent recovery, and it
seem relatively harmless to include this into the kernel.

Then vendors doing TV streaming, or in my case copies of large files
onto Samba-mounted USB FAT devices, can add only the smaller patch to
implement fallocate, at their own risk and fully knowing that it will be
regarded as corrupt on Linux. 

If accepted read support will, over a period of years, trickle down to
other Linux users, broadening the base that can still read these
'corrupt' drives, no matter the cause. 

I hope you agree that this is a practical way forward, and I look
forward to working with you on this.

Thanks,

Andrew Bartlett
-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org


