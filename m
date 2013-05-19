Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3ESFBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 01:01:31 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:57610 "EHLO Ishtar.hs"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752838Ab3ESFBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 01:01:30 -0400
Message-ID: <51985C9E.3020106@tlinx.org>
Date: Sat, 18 May 2013 22:01:18 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: new mount is broken w/regard to devnames in /etc/fstab
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




There are 2 problems -- they are unlikely to be
directly related, but are in so much as they are in the new version
of mount.

1) How is one supposed to get the real root device?
It's not /dev/root -- and on my system /dev/root doesn't even exist.
(though to be fair, it has in the past -- udev musta got sloppy this time,
and did point to the real root device).  But how can I get /proc to display
the real root device instead of some fake name.   

It's insecure the way it is -- as /dev/root could be "anything"...

2) I'd like lvm's naming to be available through mount.  Ideally, lvm's
naming would be available in /proc/mounts...  At least, though
in going from /dev/VG/LV => /dev/mapper/VG-LV, that can be
scripted reliably to get the mount device name. 

But /dev/root?... How to script that, *reliably*...
And why the bogus name?




