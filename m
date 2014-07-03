Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbaGCQqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:46:02 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61761 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaGCQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:45:59 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Arruat <michel.arruat@gmail.com>
Subject: PCIe bus enumeration
Date: Thu, 03 Jul 2014 18:45:54 +0200
Message-ID: <280883016.9onmf0miLq@pcbe13110.cern.ch>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(I haven't a deep knowledge of the PCIe specification, maybe I'm just 
missing something)

is there a way to force the PCI subsystem to assign a bus-number to 
every PCIe bridge, even if there is nothing connected?


My aim is to have a bus enumeration constant and independent from what 
I plugged on the system. So, I can associate a physical slot to linux 
device address bb:dd.f. Is it possible?

I can do the mapping with a simple shell script by discovering the 
"new" bus number, but I'm wondering if there is a way to have a 
constant bus enumeration.



My Humble Observation
---------------------
It seems (to me) that for PCI the kernel assigns a bus-number to every 
PCI bridges and sub-bridges even if there is nothing connected:


e.g. from lspci -t

      [...]
      +-1e.0-[04-05]----0c.0-[05]--

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
04:0c.0 PCI bridge: Texas Instruments PCI2050 PCI-to-PCI Bridge (rev 
02)


The behavior on PCIe seems different. When there is nothing plugged on 
a bus, then the kernel doesn't assign any bus-number and it doesn't 
detect any PCI-Bridge at all. So, when I reboot the system with a new 
PCIe card the bus enumeration may change.


I tried to use the following pci kernel parameters:

assign-busses : because I want to force the kernel to re-enumerate the 
busses, hopefully _all_ buses even if they are empty.

pcie_scan_all : not clear the explanation, but it sounds like it tells 
to the kernel to inspect everything.

bfsort : because, maybe, for a bfsort it must assign a number to each 
bridge at the same level before inspect the next one.

noacpi : in order to scan independently from BIOS information


The result is always the same (empty buses are not enumerated). 



Thank you :)

-- 
Federico Vaga
