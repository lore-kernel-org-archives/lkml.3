Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3IKXBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:01:55 -0400
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:36550 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3IKXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:01:54 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 19:01:54 EDT
Message-ID: <5230F4CD.4080501@cogweb.net>
Date: Thu, 12 Sep 2013 00:55:09 +0200
From: David Liontooth <lionteeth@cogweb.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ching2048@areca.com.tw
Subject: arcmsr fails on wait 'get adapter firmware miscellaneous data' timeout
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To work around a cascading failure of arcmsr 
(https://lkml.org/lkml/2012/6/12/320), I removed the arcmsr kernel module.

On reinsertion, the first of two Areca 1680 cards (0b:00.0) fails to 
initialize:

# dmesg | tail -n 300 | grep -C2 setting
arcmsr 0000:0a:00.0: PCI INT A disabled
arcmsr 0000:0b:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
arcmsr 0000:0b:00.0: setting latency timer to 64
arcmsr21: wait 'get adapter firmware             miscellaneous data' 
timeout
arcmsr 0000:0b:00.0: PCI INT A disabled
arcmsr 0000:0a:00.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
arcmsr 0000:0a:00.0: setting latency timer to 64
Areca RAID Controller22: F/W V1.51 2012-07-04 & Model ARC-1680
scsi22 : Areca SAS Host Adapter RAID Controller( RAID6 capable)

The second card (0a:00.0) succeeds every time. On reboot, both cards 
initialize correctly every time.

# modinfo arcmsr
filename: /lib/modules/3.0.26/kernel/drivers/scsi/arcmsr/arcmsr.ko
version:        Driver Version 1.20.00.15 2010/08/05
license:        Dual BSD/GPL
description:    ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus 
Adapter
author:         Nick Cheng <support@areca.com.tw>
srcversion:     F9D834593FE182DC013DBD0

0a:00.0 RAID bus controller: Areca Technology Corp. ARC-1680 8 port 
PCIe/PCI-X to SAS/SATA II RAID Controller
0b:00.0 RAID bus controller: Areca Technology Corp. ARC-1680 8 port 
PCIe/PCI-X to SAS/SATA II RAID Controller

Not subscribed; please CC:

Cheers,
Dave

