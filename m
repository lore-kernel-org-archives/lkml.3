Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaCVOV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 10:21:59 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52121 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaCVOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 10:21:56 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>
Subject: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
Date: Sat, 22 Mar 2014 15:19:49 +0100
Message-ID: <8891481.xyaW2OauMW@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.12.3 (Linux/3.4.83-gentoo-r1; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140308010614.545650590@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org> <20140308010614.545650590@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original Message from: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit 8a964f44e01ad3bbc208c3e80d931ba91b9ea786 upstream.

Forwarding original message to make sure it isn't lost - this patch breaks 
iwlwifi in >=3.4.83 for at least some people, including me and my Intel(R) 
Centrino(R) Ultimate-N 6300 AGN, REV=0x74.

Reverting the patch so far has been a workaround. Before sending, I also tried 
out 3.4.83 + current stable-queue to make sure the problem persists.


Original Message From: Andres Bertens <abertensu@yahoo.com>
Subject: Linux 3.4.83 update: wireless card (iwlwifi) stop working
Date: Wednesday 12 March 2014, 14:46:14
> Hi,
> 
> I updated today to 3.4.83 kernel and my wireless card stop working (log 
> says: iwlwifi 0000:03:00.0: Unable to initialize device).
> 
> My laptop is a Lenovo Thinkpad X230, with an Intel 6205 AGN card.
> 
> Reverting patch
>      Johannes Berg <johannes.berg@intel.com>
>         iwlwifi: always copy first 16 bytes of commands
> makes it work again.
> 
> Regards,
> Andres Bertens
> 
> Linux mintaka 3.4.83-smp #1 SMP Wed Mar 12 13:10:44 CLST 2014 x86_64 
> x86_64 x86_64 GNU/Linux
> 
> --------------------------------
> iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
> iwlwifi 0000:03:00.0: pci_resource_base = ffffc90006618000
> iwlwifi 0000:03:00.0: HW Revision ID = 0x34
> iwlwifi 0000:03:00.0: irq 42 for MSI/MSI-X
> iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
> iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
> iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, 
> REV=0xB0
> iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
> iwlwifi 0000:03:00.0: Device SKU: 0x1F0
> iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
> iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> iwlwifi 0000:03:00.0: Error sending CALIBRATION_CFG_CMD: time out after 
> 2000ms.
> iwlwifi 0000:03:00.0: Current CMD queue read_ptr 2 write_ptr 3
> iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 7 
> [0x077f0001]
> iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
> iwlwifi 0000:03:00.0: Unable to initialize device.
> 
