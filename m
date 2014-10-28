Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaJ1Soz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:44:55 -0400
Received: from rush.cubic.ch ([176.9.78.115]:50430 "EHLO mail2.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaJ1Soy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:44:54 -0400
X-Greylist: delayed 2057 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 14:44:54 EDT
Message-ID: <544FDC1C.9040908@decentral.ch>
Date: Tue, 28 Oct 2014 19:10:36 +0100
From: Tim Tassonis <stuff@decentral.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: overlayfs: "filesystem of lowerdir is not supported" on cdrom
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Just installed 3.18-rc2 and tried to test the overlayfs stuff:

$ mkdir /ovtmp
$ mount -t tmpfs tmpfs /ovtmp/
$ mkdir /ovtmp/work
$ mkdir /ovtmp/upper
$ mkdir /cdrw
$ mount /dev/sr0 /mnt
$ mount |egrep "ovtmp|sr0"

/dev/sr0 on /mnt type iso9660 (ro,relatime)
tmpfs on /ovtmp type tmpfs (rw,relatime)

$ mount -t overlayfs overlayfs \
 -olowerdir=/mnt,upperdir=/ovtmp/upper,workdir=/ovtmp/work /cdrw

mount: wrong fs type, bad option, bad superblock on overlayfs,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

$ dmesg |tail

[ 3266.793218] overlayfs: filesystem of lowerdir is not supported

However, the doc in Documentation/filesystems/overlayfs.txt states:

"The lower filesystem can be any filesystem supported by Linux and does
not need to be writable.  The lower filesystem can even be another
overlayfs.  The upper filesystem will normally be writable and if it
is it must support the creation of trusted.* extended attributes, and
must provide valid d_type in readdir responses, so NFS is not suitable."

So: Is the documentation wrong, the error message in dmesg wrong, or
have missed something completely?


Kind regards
Tim

