Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3HKWGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 18:06:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41153 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3HKWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 18:06:02 -0400
Date: Sun, 11 Aug 2013 23:04:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130811220450.GY23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5207B3C3.9080508@roeck-us.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 08:54:43AM -0700, Guenter Roeck wrote:
> Hi,
>
> trying to boot arm versatile images with qemu results in the following error
> if I try to boot with a disk image.
>
>      sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 92
>      sym0: SCSI BUS has been reset.
>      scsi0 : sym-2.2.3
>      [...]
>      scsi 0:0:0:0: ABORT operation started
>      scsi 0:0:0:0: ABORT operation timed-out.
>      [...]
>
> Yocto's 3.8 kernel images work, upstream kernels 3.8 and later fail
> (I did not check if/how earlier kernels are affected).
>
> Tracking this down shows that the problem is known and has been fixed with
> commit 351d1339 (arm: add dummy swizzle for versatile with qemu) in the
> Yocto 3.8 kernel at git://git.yoctoproject.org/linux-yocto-3.8.
>
> Would it be possible to submit this patch for inclusion into affected upstream kernels ?

It could be that it's qemu's PCI routing is wrong - it's not the first
time that qemu has got something wrong.

Unfortunately, the PCI routing is totally undocumented, and as I understand
it, there's very few backplanes out there now that finding out their real
routing is virtually impossible.  I'm loathed to change it unless someone
can point to a definitive source of information on this.
