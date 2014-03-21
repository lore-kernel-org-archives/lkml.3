Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaCUT2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:28:32 -0400
Received: from nm17-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.147]:39483 "EHLO
	nm17-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbaCUT21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:28:27 -0400
X-Yahoo-Newman-Id: 445563.10429.bm@smtp115.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xUEFdzwVM1n_81hsPMSbDw7pqhFniwXIiqtKNYtwit3JpnG
 Zc_k7LnuLJg02FvgneRYt.3BgN4XUVwYQAw7cbrTyVwK3bgT1Y1NCZrRCXZm
 HXsKVaVnYPW_.8CpI3WYzT0fykfPqQU.oNaoZBErwEef7cLIahR9Dd77_Laf
 2plKc9eectjsSOfd4syL27BdEwveDWy5FKLW9SAdPP8HS.m.qWCRgOQI3kXr
 Q_6xY7vLlqgwMXZByODQfJURFN2byVGpWyQ8ZApZBSn.G4NugU0RIQTJ4zjF
 xeLI.lOLOwx.79GRHAh1pBHJJs45maDvJtoeGWGTQXtbRI7nBCNBEAKq3cli
 NhB5LzBiYAA9d1cj3xqJXlwdzxZOP39cqpaBuYelf_witBsv04xqaGxBj3g1
 sxt9OYSc_1HrBxWkCrYdMNfbnluSNHfmLj676qNKnjO3M3Bu0VyCyVHv5ywP
 xVRHtLHb9KC1_Y6GLVcTTXmkU7.t6w6a2UQPL_olTGfD33IqVpPLavRU6dNI
 XygDuIsK8z79H8q9w2SeSYUxdbnb6A92jml1rxoJJWEtEnEEMvzc-
X-Yahoo-SMTP: VtHv4LaswBDDSIzEGx1ONYC1iGcdTw--
X-Rocket-Received: from [10.210.221.5] (abertensu@200.104.16.16 with plain [98.139.211.125])
        by smtp115.mail.ne1.yahoo.com with SMTP; 21 Mar 2014 12:28:26 -0700 PDT
Message-ID: <532C92D4.6070200@yahoo.com>
Date: Fri, 21 Mar 2014 16:28:20 -0300
From: Andres Bertens <abertensu@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, johannes.berg@intel.com, wujianguo@huawei.com
Subject: 3.4.84-stable review: iwlwifi module fails with an Intel 6205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Same as reported with 3.4.83 release, 3.4.84-rc1 also makes my wifi 
network card stop working:
    iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
    iwlwifi 0000:03:00.0: Unable to initialize device.

My laptop is a Lenovo Thinkpad X230 with an Intel Corporation Centrino 
Advanced-N 6205 [Taylor Peak] (rev 34). Another user also reported same 
problem with an Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74

As a workaround, reverting patch from release 3.4.83:
     Johannes Berg <johannes.berg@intel.com>
        iwlwifi: always copy first 16 bytes of commands
makes it work again.


Saludos,
Andres Bertens


PS
If of any interest, here are related logs.

Linux mintaka 3.4.84-rc1 #1 SMP Fri Mar 21 15:38:25 CLST 2014 x86_64 
x86_64 x86_64 GNU/Linux

Device not working (without reverting patch)
============================================
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc90006658000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 42 for MSI/MSI-X
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, 
REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: Error sending CALIBRATION_CFG_CMD: time out after 
2000ms.
iwlwifi 0000:03:00.0: Current CMD queue read_ptr 2 write_ptr 3
iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 7 
[0x077f0001]
iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
iwlwifi 0000:03:00.0: Unable to initialize device.


Device working (patch reverted)
================================
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc90006610000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, 
REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
