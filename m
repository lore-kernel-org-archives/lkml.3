Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaBTM3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:29:46 -0500
Received: from mout.gmx.net ([212.227.17.21]:64016 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbaBTM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:29:44 -0500
MIME-Version: 1.0
Message-ID: <trinity-4cc330c5-5df6-41ca-99e3-ea6a43c4ed56-1392899382625@3capp-gmx-bs46>
From: "Dieter Mummenschanz" <dmummenschanz@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: intel_pstate: Haswell i7-4600M refuses to enter lower Package
 States
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Feb 2014 13:29:42 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:RftUNZ8AjkqexjmWwq0r2gBjL7Ig9/bWVeNU/9n7F/z
 C5svxod1rRtcXEeeVFUAFpPp+H+0iyW6/xivk+9crHe5WF8wiL
 SCVZfcdL1gC4fA1mOnDr3JE5gFdaqc8U/vJ0nWPRc1gTIYTSxv
 2RCCmQjsuHuV25+bVKEV2QAxwH/d2GjijW8Gya5UMJL7gjOG5H
 gKSAe6JLWBs4xfoquLs4bGmTi5P8o3ZQr4GEbSF0x553Urt5Sj
 FuGOn0uaH+9ADm1HSkF2A4zspzejX8vEIPLC/BD6cXuU2bNlIV Ili06M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my Lenovo T440p Laptop the Haswell i7-4600M CPU refuses to enter lower PC states resulting in 14-15 Watts continuous power drain even if the system is idle and every tunalbes in powertop 2.5 are enabled. The issue is reproducable with Kernel versions 3.13 up to 3.14-rc3.

Did anyone else experience a similar issue?

Powertop summary below. 

Kernel config: http://pastebin.com/vnGfhqLT
dmesg: http://pastebin.com/3h1eEgWv

***PowerTOP Report***
**System Information**

PowerTOP Version;v2.5
Kernel Version;Linux version 3.14.0-rc3 (root@knigge) (gcc version 4.8.2 (Gentoo 4.8.2 p1.0, pie-0.5.8) ) #6 SMP Tue Feb 18 08:49:05 CET 2014
System Name;LENOVO 20ANCTO1WW ThinkPad T440p
CPU Information;2x  Intel(R) Core(TM) i7-4600M CPU @ 2.90GHz
OS Information;Gentoo/Linux

**Power Consumption Summary**
-nan wakeups/second, -nan GPU ops/second, -nan VFS ops/sec, -nan GFX wakes/sec and -0.0% CPU use

Usage;Events/s;Category;Description
100.0%;;Device;alsa:hwC0D0
100.0%;;Device;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller
100.0%;;Device;USB device: Lenovo ThinkPad Dock    (LENOVO                 )
  0.0%;;Device;USB device: usb-device-8087-8008
  0.0%;;Device;USB device: usb-device-8087-8000
  0.0%;;Device;USB device: Lenovo ThinkPad Dock    (LENOVO                 )
  0.0%;;Device;USB device: EHCI Host Controller
  0.0%;;Device;USB device: EHCI Host Controller
  0.0%;;Device;USB device: xHCI Host Controller
  0.0%;;Device;USB device: USB2.0 Hub
  0.0%;;Device;USB device: Lenovo ThinkPad Dock (Lenovo)

**Processor Idle state report**

Package 0;;Core 0;;CPU 0
;;;;;;C0 active;  0.5%;
;;;;;;POLL;  0.0%;   0.8 ms
;;;;;;C1E-HSW;  0.2%;   0.1 ms
C2 (pc2); 96.4%;;;;;;;
C3 (pc3);  0.1%;;C3 (cc3);  0.4%;;C3-HSW;  0.5%;   0.6 ms
C6 (pc6);  0.0%;;C6 (cc6);  0.1%;;C6-HSW;  0.1%;   0.6 ms
C7 (pc7);  0.0%;;C7 (cc7); 97.1%;;C7s-HSW; 97.3%;  39.3 ms
;;Core 1;;CPU 1
;;;;;C0 active;  0.5%;
;;;;;POLL;  0.0%;   0.0 ms
;;;;;C1E-HSW;  0.1%;   0.1 ms
;;;;;;;
;;C3 (cc3);  0.2%;;C3-HSW;  0.2%;   0.5 ms
;;C6 (cc6);  0.1%;;C6-HSW;  0.1%;   0.5 ms
;;C7 (cc7); 97.4%;;C7s-HSW; 97.5%;  41.3 ms
;;GPU 27216288;
;;;;
;;Powered On;  0.4%;
;;RC6; 99.6%;
;;RC6p;  0.0%;
;;RC6pp;  0.0%;
;;;;
;;;;

**Processor Frequency Report**

Package 0;;Core 0;;CPU 0
;;;;;;Actual;   801 MHz
Idle;   0.0% ;;Idle;   0.0% ;;Idle;   0.0% 
;;Core 1;;CPU 1
;;;;;Actual;   799 MHz
;;Idle;   0.0% ;;Idle;   0.0% 

**Overview of Software Power Consumers**

Usage;Wakeups/s;GPU ops/s;Disk IO/s;GFX Wakeups/s;Category;Description

**Device Power Report**

Usage;Device name
 -0.0%;DRAM
100.0%;alsa:hwC0D0
 -0.0%;CPU core
100.0%;Display backlight
 95.7%;Display backlight
100.0%;USB device: Lenovo ThinkPad Dock    (LENOVO                 )
100.0%;PCI Device: Intel Corporation Wireless 7260
 -0.0%;CPU misc
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family 6-port SATA Controller 1 [AHCI mode]
100.0%;PCI Device: Intel Corporation QM87 Express LPC Controller
100.0%;USB device: xHCI Host Controller
100.0%;USB device: USB-PS/2 Optical Mouse (Logitech)
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #2
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #1
100.0%;Radio device: iwlwifi
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller
100.0%;PCI Device: Intel Corporation Ethernet Connection I217-LM
100.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI
100.0%;USB device: Logitech Illuminated Keyboard (Logitech)
100.0%;PCI Device: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor HD Audio Controller
100.0%;PCI Device: Intel Corporation 4th Gen Core Processor Integrated Graphics Controller
  0.0 pkts/s;Network interface: enp0s25 (e1000e)
  0.0%;USB device: USB2.0 Hub
  0.0%;USB device: Lenovo ThinkPad Dock (Lenovo)
  0.0%;USB device: usb-device-8087-8000
  0.0%;USB device: xHCI Host Controller
  0.0%;USB device: EHCI Host Controller
  0.0%;USB device: EHCI Host Controller
  0.0%;USB device: Lenovo ThinkPad Dock    (LENOVO                 )
  0.0%;USB device: usb-device-8087-8008
  0.0 rpm;Laptop fan
  0.0%;Thinkpad light
  0.0 pkts/s;Network interface: wlp3s0 (iwlwifi)
  0.0%;PCI Device: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor DRAM Controller
  0.0%;PCI Device: Realtek Semiconductor Co., Ltd. RTS5227 PCI Express Card Reader
  0.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller #1
  0.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #2
  0.0%;PCI Device: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #1

**Process device activity**

Process;Device
wpa_supplicant;/dev/rfkill
acpid;/dev/input/event0
;/dev/input/event1
;/dev/input/event11
;/dev/input/event12
;/dev/input/event13
;/dev/input/event14
;/dev/input/event15
;/dev/input/event2
;/dev/input/event3
;/dev/input/event4
;/dev/input/event7
;/dev/input/event8
;/dev/input/event9
X;/dev/dri/card0
;/dev/input/event1
;/dev/input/event2
;/dev/input/event3
;/dev/input/event4
;/dev/input/event5
;/dev/input/event6
;/dev/input/event7
;/dev/input/event8
;/dev/input/event9
;/dev/vga_arbiter

**Software Settings in need of Tuning**

Description;Script
Autosuspend for USB device USB-PS/2 Optical Mouse [Logitech];"echo 'auto' > '/sys/bus/usb/devices/3-9.1/power/control';"
Autosuspend for USB device Logitech Illuminated Keyboard [Logitech];"echo 'auto' > '/sys/bus/usb/devices/3-9.2/power/control';"

**Optimal Tuned Software Settings**

Description
VM writeback timeout
Enable SATA link power Managmenet for host0
Enable SATA link power Managmenet for host1
Enable SATA link power Managmenet for host2
Enable SATA link power Managmenet for host3
Enable SATA link power Managmenet for host4
Enable SATA link power Managmenet for host5
Enable Audio codec power management
Autosuspend for USB device EHCI Host Controller [usb2]
Autosuspend for unknown USB device 1-1 (8087:8008)
Autosuspend for unknown USB device 2-1 (8087:8000)
Autosuspend for USB device Lenovo ThinkPad Dock    [LENOVO                 ]
Autosuspend for USB device EHCI Host Controller [usb1]
Autosuspend for USB device xHCI Host Controller [usb3]
Autosuspend for USB device xHCI Host Controller [usb4]
Autosuspend for USB device USB2.0 Hub [3-9.3]
Autosuspend for USB device Lenovo ThinkPad Dock [Lenovo]
Autosuspend for USB device Lenovo ThinkPad Dock    [LENOVO                 ]
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #1
Runtime PM for PCI Device Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor DRAM Controller
Runtime PM for PCI Device Intel Corporation 4th Gen Core Processor Integrated Graphics Controller
Runtime PM for PCI Device Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor HD Audio Controller
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller #1
Runtime PM for PCI Device Intel Corporation Ethernet Connection I217-LM
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #2
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #1
Runtime PM for PCI Device Intel Corporation QM87 Express LPC Controller
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family 6-port SATA Controller 1 [AHCI mode]
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller
Runtime PM for PCI Device Realtek Semiconductor Co., Ltd. RTS5227 PCI Express Card Reader
Runtime PM for PCI Device Intel Corporation Wireless 7260
Runtime PM for PCI Device Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #2
Wake-on-lan status for device wlp3s0
Wake-on-lan status for device enp0s25
Using 'ondemand' cpufreq governor
