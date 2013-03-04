Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3CDLcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:32:15 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52440 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3CDLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:32:14 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Cooks'" <acooks@gmail.com>
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'YingChu'" <xjtuychu@hotmail.com>,
        "'Chu Ying'" <gm.ychu@gmail.com>,
        "'Alex Williamson'" <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, "'David Woodhouse'" <dwmw2@infradead.org>,
        "'open list:INTEL IOMMU \(VT-d\)'" <iommu@lists.linux-foundation.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:PCI SUBSYSTEM'" <linux-pci@vger.kernel.org>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>	<1355914703-28576-1-git-send-email-acooks@gmail.com>	<1362126373-32318-1-git-send-email-acooks@gmail.com>	<CAO9zADxjoP+R9ccz7vMPmcFvdYwNjErSjaWc_RFkW_FY3+SK=w@mail.gmail.com>	<CAJtEV7Zs2BiwJ9jdDeoceh9hiVXvVaSvj=9H+4+vEzhY72AS9g@mail.gmail.com>	<00b701ce16d3$0aabe0f0$2003a2d0$@lucidpixels.com> <CAJtEV7bvPORPoXgQY2OahNVMj+SY5z=xxQ=nueX7=kLVfpyF_A@mail.gmail.com>
In-Reply-To: <CAJtEV7bvPORPoXgQY2OahNVMj+SY5z=xxQ=nueX7=kLVfpyF_A@mail.gmail.com>
Subject: RE: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with Intel IOMMU.
Date: Mon, 4 Mar 2013 06:32:11 -0500
Message-ID: <003101ce18cb$ea51f330$bef5d990$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIIKZSuL60UU+m8wYLyh6ljrQ5QswLzR3IpAdE8RacCHftIbgMK2uKGAlmAGcwB1h24wJewXFrg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, Mar 2, 2013 at 7:18 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
>
> Against a clean 3.7.10 (from ftp.kernel.org)
>
> # patch -p1 <
>
../patch/RFC-Fix-Intel-IOMMU-support-for-Marvell-88SE91xx-SATA-controllers..
> patch
> patching file drivers/iommu/intel-iommu.c
> patching file drivers/pci/quirks.c
> Hunk #1 succeeded at 3230 (offset 3 lines).
> patching file include/linux/pci.h
> # pwd
> /usr/src/linux-3.7.10
>

I've downloaded and patched the 3.7.10 tarball and still get the same
output I got before; different output from yours. I'm not sure the
patch is complete or applying correctly, are you?
Could you please check whether the patch you're applying is the same
as the attached file?

Hi,

Success!

Patch from e-mail:
# md5sum marvell_ghost_funcs.patch 
718bfb5876e3538ec23a516ef28d03f5  marvell_ghost_funcs.patch

Kernel from ftp.kernel.org:
# md5sum linux-3.7.10.tar.bz2
56ec294a922b6112a1ef129668f38a83  linux-3.7.10.tar.bz2

Decompress, patch, re-compile w/IOMMU=on.

# tar jxf linux-3.7.10.tar.bz2 ; ln -s linux-3.7.10 linux   
# cd linux; patch -p1 < ../marvell_ghost_funcs.patch
patching file drivers/iommu/intel-iommu.c
Hunk #1 succeeded at 1672 (offset -2 lines).
Hunk #2 succeeded at 1729 (offset -2 lines).
Hunk #3 succeeded at 3833 (offset -2 lines).
patching file drivers/pci/quirks.c
Hunk #1 succeeded at 3210 (offset -39 lines).
Hunk #2 succeeded at 3240 (offset -39 lines).
Hunk #3 succeeded at 3258 (offset -39 lines).
patching file include/linux/pci.h
Hunk #1 succeeded at 1546 (offset -32 lines).
Hunk #2 succeeded at 1555 (offset -32 lines).
patching file include/linux/pci_ids.h

Reboot, re-test.

# lilo
Added 3.7.7-1
Added 3.7.10-5-ioff
Added 3.7.10-7    (iommu=off w/patch) = OK
Added 3.7.10-8  * (iommu=on w/patch) = OK

dmesg w/patch + iommu
http://home.comcast.net/~jpiszcz/20130304/dmesg-success-patch.txt

Thanks!

Justin.


