Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3HKPyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 11:54:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65318 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3HKPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 11:54:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5207B3C3.9080508@roeck-us.net>
Date: Sun, 11 Aug 2013 08:54:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: SCSI bus failures with qemu-arm in kernel 3.8+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying to boot arm versatile images with qemu results in the following error
if I try to boot with a disk image.

      sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 92
      sym0: SCSI BUS has been reset.
      scsi0 : sym-2.2.3
      [...]
      scsi 0:0:0:0: ABORT operation started
      scsi 0:0:0:0: ABORT operation timed-out.
      [...]

Yocto's 3.8 kernel images work, upstream kernels 3.8 and later fail
(I did not check if/how earlier kernels are affected).

Tracking this down shows that the problem is known and has been fixed with
commit 351d1339 (arm: add dummy swizzle for versatile with qemu) in the
Yocto 3.8 kernel at git://git.yoctoproject.org/linux-yocto-3.8.

Would it be possible to submit this patch for inclusion into affected upstream kernels ?

Thanks,
Guenter
