Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaFKRUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:20:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:59247 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaFKRUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,459,1400050800"; 
   d="scan'208";a="526945016"
Date: Wed, 11 Jun 2014 10:18:54 -0700
From: Jon Mason <jon.mason@intel.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NTB driver support in haswell platform?
Message-ID: <20140611171854.GA3698@jonmason-lab>
References: <53981B6A.40807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53981B6A.40807@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 05:03:38PM +0800, Yijing Wang wrote:
> Hi Jon,
>    I have a Intel Haswell platform in hand, and our team want to use NTB in this platform.
> I checked the current intel NTB driver in Linux kernel, I found the Haswell NTB pci device id
> is not contained in ntb_pci_tbl[]. I want to know whether current kernel ntb driver can support
> the ntb device in Haswell platform ?

Yes, it does support Haswell and the Device IDs are in there.
PCI_DEVICE_ID_INTEL_NTB_B2B_HSX, PCI_DEVICE_ID_INTEL_NTB_PS_HSX, and
PCI_DEVICE_ID_INTEL_NTB_SS_HSX are the relevant dev ids for Haswell.

> Haswell NTB device id:
> 
> From Haswell EDS 7.4.2
> 
> did
> Bus: 0 Device: 3 Function: 0 Offset: 2
> Bit Attr Default Description
> 15:0 RO-V 2F08h Device_Identification_Number — Device ID values vary from function to function.
> Bits 15:8 are equal to 0x2F. The following list is a breakdown of the function groups.
>   0x2F00 - 0x2F1F : PCI Express and DMI2
>   0x2F20 - 0x2F3F : Integrated I/O Features
>   0x2F40 - 0x2F5F : Performance Monitors
>   0x2F80 - 0x2F9F : Intel QPI
>   0x2FA0 - 0x2FBF : Home Agent/Memory Controller
>   0x2FC0 - 0x2FDF : Power Management
>   0x2FE0 - 0x2FFF : Cbo/Ring
> Default value may vary based on bus, device, and function of this CSR location.
> 
> 
> Current ntb_pci_tbl[] in Linux:
> 
> #define PCI_DEVICE_ID_INTEL_NTB_B2B_JSF		0x3725
> #define PCI_DEVICE_ID_INTEL_NTB_PS_JSF		0x3726
> #define PCI_DEVICE_ID_INTEL_NTB_SS_JSF		0x3727
> #define PCI_DEVICE_ID_INTEL_NTB_B2B_SNB		0x3C0D
> #define PCI_DEVICE_ID_INTEL_NTB_PS_SNB		0x3C0E
> #define PCI_DEVICE_ID_INTEL_NTB_SS_SNB		0x3C0F
> #define PCI_DEVICE_ID_INTEL_NTB_B2B_IVT		0x0E0D
> #define PCI_DEVICE_ID_INTEL_NTB_PS_IVT		0x0E0E
> #define PCI_DEVICE_ID_INTEL_NTB_SS_IVT		0x0E0F
> #define PCI_DEVICE_ID_INTEL_NTB_B2B_HSX		0x2F0D
> #define PCI_DEVICE_ID_INTEL_NTB_PS_HSX		0x2F0E
> #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
> #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
> 
> So we should modify the default device id to 0x2F0D, 0x2F0E or 0x2F0F ?

The device IDs are present above: PCI_DEVICE_ID_INTEL_NTB_B2B_HSX,
PCI_DEVICE_ID_INTEL_NTB_PS_HSX, and PCI_DEVICE_ID_INTEL_NTB_SS_HSX.

> What's the difference between them?

The last 3 letters are the name of the CPU where NTB is found.  HSX is
Haswell Xeon.  The 2-3 letters before that are the configuration type
of the NTB device.  B2B is for "Back-to-back" configurations, aka
"NTB-NTB". 

B2B
[CPU]---[NTB]===[NTB]---[CPU]

PS/SS is for NTB-RP configurations.  PS is "Primary Side" and SS is
"Secondary Side".

[CPU]---[SS|PS]---[CPU]

I have an NTB wiki on my github account
(https://github.com/jonmason/ntb/wiki) describing the configuration,
etc.  Also on the wiki is a link to a doc (not written by me, and
contains references to a driver that was not made public) that has
some graphics that might be useful.  Specifically, pages 10 and 17.
To save time, the URL is
http://download.intel.com/design/intarch/papers/323328.pdf

Let me know if you have any questions or issues, and I'll be happy to
walk you through it.

Thanks,
Jon

> 
> Thanks!
> Yijing.
> 
> 
> 
> 
> -- 
> Thanks!
> Yijing
> 
