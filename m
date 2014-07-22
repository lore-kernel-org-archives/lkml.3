Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbaGVVt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:49:26 -0400
Received: from grace.univie.ac.at ([131.130.3.115]:52445 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaGVVtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:49:25 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 17:49:25 EDT
Message-ID: <53CEDA35.40301@univie.ac.at>
Date: Tue, 22 Jul 2014 23:40:05 +0200
From: "Klaus A. Kreil" <klaus.kreil@univie.ac.at>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: unable to mount using overlayfs.v22 on kernel 3.15.5
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Univie-Virus-Scan: scanned by ClamAV on justin.univie.ac.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,
I have just found out about this mailing list which obviously also takes 
care of overlayfs.

I have been a happy user of overlayfs for quiet some time using it to 
propagate a shared r/o LVM ext4 lowerdir rootfs with a small r/w ext4 
upperdir for a number of XEN domU guests. I started with overlayfs on 
kernel version 3.11.7 (all on gentoo-hardened). Recently I have switched 
from 3.13.10 (using overlayfs.v21) to 3.15.5 with overlayfs.v22.

overlayfs.v22 seems to have changed insofar as there's a new parameter 
workdir=/dir with dir required to be an empty directory on the same 
filesystem as upperdir. So I have changed my initramfs to include that 
parameter and have also created my /dir directory (named /.work, owned 
by root:root and 0755 mode) on all my individual upperdir filesystems 
for all of my XEN domUs.

Now when I start the new kernel 3.15.5 with the modified init script 
from the newly created initramfs, I am ending up in a rescue shell. Both 
the upper and lower filesystem are (as expected) mounted appropriately 
to /mnt/root_ro and /mnt/root_rw amd /mnt/root exists. Howeverm, trying 
to combine those two filesystems on /mnt/root (as before and regardless 
of whether used with or without the workdir= parameter) fails with an 
error message as follows:

# mount -t overlayfs overlayfs -o 
lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/.work /mnt/root
mount: mounting overlayfs on /mnt/root failed: Invalid argument

The error message stays the same regardless of where on the command line 
the overlayfs "device" parameter appears. I can't see what's wrong with 
the command line given that - with the exception of the workdir=/.work 
part - the command has not changed from 3.13.10 (overlayfs.v21), 
therefore currently leaving me at loss.

I would very much appreciate any help and support in tracking down this 
unexpected issue.

Regards Atom2
