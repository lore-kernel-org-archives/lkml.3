Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3FFTrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:47:45 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:58333 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015Ab3FFTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:47:43 -0400
X-Greylist: delayed 1771 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 15:47:43 EDT
Message-ID: <51B0E071.70909@newflow.co.uk>
Date: Thu, 06 Jun 2013 20:18:09 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: General question regarding multiple partitions on a single NOR device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of our products, we have 2 64Mbit NOR devices:- one to hold the
kernel, filesystem, etc, and the other to store "user" data.

The gotcha is that the "user" data is stored using our own wear
levelling code, with read / write / erase operations being carried out
on the raw flash device.

We are now designing a new CPU board with a single 1Gbit Spansion NOR
part on it, rather than the 2 separate devices.

I am planning to allocate 512Mbit to the "system" partitions (eg
bootloader, kernel, filesystem) and have the other 512Mbit as the "data"
partition.

Currently our wear levelling code uses mmap() to gain direct access to
the flash chip, which is not an issue, since all filesystem updates etc
are all carried out on the completely separate chip (via jffs2).

What I would like to know is, when the "system" and "user" partitions
reside on the *same" flash device, if I read/write directly to the
"user" partition, how do I maintain the jffs2 integrity on other
"system" partitions that may be doing their own read/write/erase
operations ?

If I can't read/write directly, can the same be achieved using the mtd
character device using something like:-

fd = open("/dev/mtd4", ..);
seek(fd, 1234);
write(fd, buff, ...);
...etc...

If I need to "manually" erase a sector on our custom data partition, how
can that be handled without disrupting any jffs2 flash access on the
other "system" partitions ?

Do the mtd ioctl() functions handle all the flash locking for me ?

Or is this a bit hole I'm digging for myself ?

Thanks for any help anyone can offer.

Regards
Mark J.
