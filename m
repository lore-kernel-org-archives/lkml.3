Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaD1VwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:52:17 -0400
Received: from sea.nor-consult.com ([173.160.193.117]:45870 "EHLO
	mail.nor-consult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbaD1VwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:52:15 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 17:52:15 EDT
From: "Michael Evans" <michael.evans@nor-consult.com>
To: <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 14:30:03 -0700
Organization: Nor Consult, LLC
Message-ID: <023501cf6329$047a8120$0d6f8360$@nor-consult.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac9jKIkatPI0SvzxSRaI3MOs2z7A1Q==
Content-Language: en-us
X-SA-Exim-Connect-IP: 10.2.4.24
X-SA-Exim-Mail-From: michael.evans@nor-consult.com
Subject: umount -f Device or resource busy; already tried: mount, lsof, fuser, exportfs, ps axf, dmsetup table, losetup -a
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Version: 4.2.1 (built Sun, 16 May 2010 01:51:57 +0000)
X-SA-Exim-Scanned: Yes (on mail.nor-consult.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am posting with hope to improve the reliability and usability of
unmounting 'busy' filesystems (for which umount -f doesn't work and no
remedy is known).

There are no apparent resource holders but the device is still 'busy'. (
http://serverfault.com/questions/591406/umount-device-or-resource-busy-alrea
dy-tried-mount-lsof-fuser-exportfs-ps ), including:

* mount | grep /tmp/
* lsof | grep /tmp/
* fuser -m /tmp/...
* exportfs -rv | grep /tmp/
* Restarting the daemon which runs the creation scripts anyway...
* ps axf | grep /tmp/
* dmsetup table
* losetup -a
* fuser -vm /tmp/tmp.random-chars/ (yields two lines)
##                        USER PID    ACCESS COMMAND
## /tmp/tmp.random-chars: root kernel mount  /tmp/tmp.random-chars

Is there /any other/ test which might reveal what is keeping the device busy
(so I can end their existence)?
Is there anything more forceful than 'umount -f' to really just sync what's
possible to a specific device and invalidate all remaining file handles,
buffers, etc?

Failure is always be an option.  However in this case failing to allow
failure would require an entire VM host reboot during the next maintenance
window.


Thank you in advance for your time and ideas.  Please either reply to my
work email address <michael.evans@nor-consult.com> or at the above
serverfault link; optionally CC the list for the archives.  I'll also update
the main post on the serverfault page with any additional tests and
highlight any that yield useful information for future search engine users.

PS: Even if your reply is after our next maintenance window, I'll continue
updating the serverfault post with test for future users (more quickly if
directly emailed as well).

