Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaEVEpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:45:05 -0400
Received: from sam.nabble.com ([216.139.236.26]:52349 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaEVEpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:45:03 -0400
Date: Wed, 21 May 2014 21:45:02 -0700 (PDT)
From: Varka Bhadram <varkab@cdac.in>
To: linux-kernel@vger.kernel.org
Message-ID: <1400733902089-865529.post@n7.nabble.com>
Subject: [OMAP-Serial] omap ttyO2 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I am using the kernel 3.12 from beagleboard. I loaded the overlay to enable
the ttyO2 on BBB.

    echo BB-UART1 > /sys/devices/bone_capemgr.*/slots

It created the ttyO2 device node in /dev.

in dmesg :
[   76.077679] bone-capemgr bone_capemgr.6: part_number 'BB-UART1', version
'N/A'
[   76.077761] bone-capemgr bone_capemgr.6: slot #7: generic override
[   76.077789] bone-capemgr bone_capemgr.6: bone: Using override eeprom data
at slot 7
[   76.077818] bone-capemgr bone_capemgr.6: slot #7: 'Override Board
Name,00A0,Override Manuf,BB-UART1'
[   76.078444] bone-capemgr bone_capemgr.6: slot #7: Requesting part
number/version based 'BB-UART1-00A0.dtbo
[   76.078479] bone-capemgr bone_capemgr.6: slot #7: Requesting firmware
'BB-UART1-00A0.dtbo' for board-name 'Override Board Name', version '00A0'
[   76.086769] bone-capemgr bone_capemgr.6: slot #7: dtbo
'BB-UART1-00A0.dtbo' loaded; converting to live tree
[   76.087041] bone-capemgr bone_capemgr.6: slot #7: #2 overlays
[   76.116716] of_get_named_gpio_flags: can't parse gpios property of node
'/ocp/serial@48024000[0]'
[   76.140196] *omap_uart 48024000.serial:
serial_omap_get_context_loss_count failed : -22*
[   76.140323] omap_uart 48024000.serial: serial_omap_type+2
[   76.140347] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90,
base_baud = 3000000) is a OMAP UART2
[   76.140368] omap_uart 48024000.serial: serial_omap_pm+2
[   76.140394] omap_uart 48024000.serial: serial_omap_set_mctrl+2
[   76.140415] omap_uart 48024000.serial: serial_omap_pm+2
[   76.143291] bone-capemgr bone_capemgr.6: slot #7: Applied #2 overlays.


How can i test the this UART working ?

I write a simple code to open("/dev/ttyO2",O_RDWR), and writes "hello", But
i am not getting the data on TX pin (P9.24) of BBB.

Am i missing any thing ?


Thanks in advance...

Reagrds,
Varka Bhadram. 



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/OMAP-Serial-omap-ttyO2-problem-tp865529.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
