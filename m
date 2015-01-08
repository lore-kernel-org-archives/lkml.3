Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbbAHPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:05:49 -0500
Received: from fortimail.online.lv ([81.198.164.220]:40206 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbbAHPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:05:48 -0500
Message-ID: <54AE9CC8.2080302@apollo.lv>
Date: Thu, 08 Jan 2015 17:05:44 +0200
From: Raimonds Cicans <ray@apollo.lv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0)
 Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Subject: Re: Questions about IOMMU & PCIe switch
References: <54ACB0D4.3000008@apollo.lv> <54AD21E2.2020100@ladisch.de>
 <54AD3D0B.6060501@apollo.lv> <54AE410B.40101@ladisch.de>
In-Reply-To: <54AE410B.40101@ladisch.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
DomainKey-Status: no signature
DKIM-Status: no signature
X-AXIGEN-DK-Result: No records
X-AXIGEN-DKIM-Result: No records
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.01.2015 10:34, Clemens Ladisch wrote:
> Raimonds Cicans wrote:
>> https://github.com/ljalves/linux_media/issues/66
> If the TBS driver works, why don't you use it?
1) driver is not stable in 24x7 setups

2) driver use old DVBAPI. This cause problems with some
      user space programs.

3) TBS recommends to use card in MSI interrupt mode
      but this mode on IOMMU systems do not work:
      card is able to find transponders and tune to it
      but can not receive any data

4) I use GRSecurity patched kernels but external media
     drivers are incompatible with such kernels.
     I am forced to use driver source code injection in kernel
     from project https://github.com/bas-t/saa716x-intree
     which injects few drivers from https://github.com/ljalves/linux_media
     in kernel source tree.

5) I prefer open source drivers, but TBS drivers are half way open -
     open back-end drivers and closed front-end drivers.

>
> The WARNING from the kernel log indicates a hardware bug in the PCIe
> bridge.  Do you have the same card, and do you also get this warning
> with kernel 3.16?
1) I have same card with same revision number

2) affected computer is Intel based but mine is AMD based

3) I can not test kernel 3.16 because I had IOMMU related regression
     in kernels 3.14-3.17 (AMD-Vi: Completion-Wait loop timed out)
     On other kernels I do not have such warning, but starting from
     kernel 3.17.7 I have IOMMU related messages with my other card
    (TBS 6981):

AMD-Vi: Event logged [IO_PAGE_FAULT device=08:00.0 domain=0x001c 
address=0x0000000001355000 flags=0x0000]

and

WARNING: CPU: 0 PID: 13204 at drivers/iommu/amd_iommu.c:2625 
dma_ops_domain_unmap.part.9+0x4d/0x56()

Because TBS 6981 driver is included in kernel I contacted yesterday 
linux-media mailing list, but not received answer yet.



Raimonds Cicans
