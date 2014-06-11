Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaFKJD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:03:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25950 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaFKJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:03:56 -0400
Message-ID: <53981B6A.40807@huawei.com>
Date: Wed, 11 Jun 2014 17:03:38 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jon Mason <jon.mason@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: NTB driver support in haswell platform?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,
   I have a Intel Haswell platform in hand, and our team want to use NTB in this platform.
I checked the current intel NTB driver in Linux kernel, I found the Haswell NTB pci device id
is not contained in ntb_pci_tbl[]. I want to know whether current kernel ntb driver can support
the ntb device in Haswell platform ?

Haswell NTB device id:

>From Haswell EDS 7.4.2

did
Bus: 0 Device: 3 Function: 0 Offset: 2
Bit Attr Default Description
15:0 RO-V 2F08h Device_Identification_Number — Device ID values vary from function to function.
Bits 15:8 are equal to 0x2F. The following list is a breakdown of the function groups.
  0x2F00 - 0x2F1F : PCI Express and DMI2
  0x2F20 - 0x2F3F : Integrated I/O Features
  0x2F40 - 0x2F5F : Performance Monitors
  0x2F80 - 0x2F9F : Intel QPI
  0x2FA0 - 0x2FBF : Home Agent/Memory Controller
  0x2FC0 - 0x2FDF : Power Management
  0x2FE0 - 0x2FFF : Cbo/Ring
Default value may vary based on bus, device, and function of this CSR location.


Current ntb_pci_tbl[] in Linux:

#define PCI_DEVICE_ID_INTEL_NTB_B2B_JSF		0x3725
#define PCI_DEVICE_ID_INTEL_NTB_PS_JSF		0x3726
#define PCI_DEVICE_ID_INTEL_NTB_SS_JSF		0x3727
#define PCI_DEVICE_ID_INTEL_NTB_B2B_SNB		0x3C0D
#define PCI_DEVICE_ID_INTEL_NTB_PS_SNB		0x3C0E
#define PCI_DEVICE_ID_INTEL_NTB_SS_SNB		0x3C0F
#define PCI_DEVICE_ID_INTEL_NTB_B2B_IVT		0x0E0D
#define PCI_DEVICE_ID_INTEL_NTB_PS_IVT		0x0E0E
#define PCI_DEVICE_ID_INTEL_NTB_SS_IVT		0x0E0F
#define PCI_DEVICE_ID_INTEL_NTB_B2B_HSX		0x2F0D
#define PCI_DEVICE_ID_INTEL_NTB_PS_HSX		0x2F0E
#define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
#define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E

So we should modify the default device id to 0x2F0D, 0x2F0E or 0x2F0F ?
What's the difference between them?

Thanks!
Yijing.




-- 
Thanks!
Yijing

