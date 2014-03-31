Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaCaMye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:54:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaCaMyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:54:31 -0400
Date: Mon, 31 Mar 2014 14:54:25 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>
Subject: [PATCH] Documentation/serial: Delete obsolete driver documentation
Message-ID: <20140331145425.247f87ff@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These serial drivers were removed in kernel v3.1, so we can drop their
documentation files and references to their magic numbers and
parameters.

There are still references to these old drivers in
Documentation/devices.txt but I'm afraid they can't be removed.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/kernel-parameters.txt  |   13 -
 Documentation/magic-number.txt       |   12 -
 Documentation/serial/00-INDEX        |    8 
 Documentation/serial/digiepca.txt    |   98 --------
 Documentation/serial/riscom8.txt     |   36 ---
 Documentation/serial/specialix.txt   |  383 -----------------------------------
 Documentation/serial/sx.txt          |  294 --------------------------
 Documentation/zh_CN/magic-number.txt |   12 -
 firmware/WHENCE                      |   10 
 9 files changed, 866 deletions(-)

--- linux-3.14-rc8.orig/Documentation/serial/00-INDEX	2014-03-31 13:52:29.448516297 +0200
+++ linux-3.14-rc8/Documentation/serial/00-INDEX	2014-03-31 13:52:30.729545875 +0200
@@ -2,23 +2,15 @@
 	- this file.
 README.cycladesZ
 	- info on Cyclades-Z firmware loading.
-digiepca.txt
-	- info on Digi Intl. {PC,PCI,EISA}Xx and Xem series cards.
 driver
 	- intro to the low level serial driver.
 moxa-smartio
 	- file with info on installing/using Moxa multiport serial driver.
 n_gsm.txt
 	- GSM 0710 tty multiplexer howto.
-riscom8.txt
-	- notes on using the RISCom/8 multi-port serial driver.
 rocket.txt
 	- info on the Comtrol RocketPort multiport serial driver.
 serial-rs485.txt
 	- info about RS485 structures and support in the kernel.
-specialix.txt
-	- info on hardware/driver for specialix IO8+ multiport serial card.
-sx.txt
-	- info on the Specialix SX/SI multiport serial driver.
 tty.txt
 	- guide to the locking policies of the tty layer.
--- linux-3.14-rc8.orig/Documentation/serial/digiepca.txt	2014-03-31 13:52:29.448516297 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,98 +0,0 @@
-NOTE:  This driver is obsolete.  Digi provides a 2.6 driver (dgdm) at
-http://www.digi.com for PCI cards.  They no longer maintain this driver,
-and have no 2.6 driver for ISA cards.
-
-This driver requires a number of user-space tools.  They can be acquired from
-http://www.digi.com, but only works with 2.4 kernels.
-
-
-The Digi Intl. epca driver. 
-----------------------------
-The Digi Intl. epca driver for Linux supports the following boards:
-
-Digi PC/Xem, PC/Xr, PC/Xe, PC/Xi, PC/Xeve 
-Digi EISA/Xem, PCI/Xem, PCI/Xr 
-
-Limitations:
-------------
-Currently the driver only autoprobes for supported PCI boards. 
-
-The Linux MAKEDEV command does not support generating the Digiboard
-Devices.  Users executing digiConfig to setup EISA and PC series cards
-will have their device nodes automatically constructed (cud?? for ~CLOCAL,
-and ttyD?? for CLOCAL).  Users wishing to boot their board from the LILO
-prompt, or those users booting PCI cards may use buildDIGI to construct 
-the necessary nodes. 
-
-Notes:
-------
-This driver may be configured via LILO.  For users who have already configured
-their driver using digiConfig, configuring from LILO will override previous 
-settings.  Multiple boards may be configured by issuing multiple LILO command 
-lines.  For examples see the bottom of this document.
-
-Device names start at 0 and continue up.  Beware of this as previous Digi 
-drivers started device names with 1.
-
-PCI boards are auto-detected and configured by the driver.  PCI boards will
-be allocated device numbers (internally) beginning with the lowest PCI slot
-first.  In other words a PCI card in slot 3 will always have higher device
-nodes than a PCI card in slot 1. 
-
-LILO config examples:
----------------------
-Using LILO's APPEND command, a string of comma separated identifiers or 
-integers can be used to configure supported boards.  The six values in order 
-are:
-
-   Enable/Disable this card or Override,
-   Type of card: PC/Xe (AccelePort) (0), PC/Xeve (1), PC/Xem or PC/Xr (2), 
-                 EISA/Xem (3), PC/64Xe (4), PC/Xi (5), 
-   Enable/Disable alternate pin arrangement,
-   Number of ports on this card,
-   I/O Port where card is configured (in HEX if using string identifiers),
-   Base of memory window (in HEX if using string identifiers), 
-
-NOTE : PCI boards are auto-detected and configured.  Do not attempt to 
-configure PCI boards with the LILO append command.  If you wish to override
-previous configuration data (As set by digiConfig), but you do not wish to
-configure any specific card (Example if there are PCI cards in the system) 
-the following override command will accomplish this:
--> append="digi=2"
-
-Samples:
-   append="digiepca=E,PC/Xe,D,16,200,D0000"
-                  or
-   append="digi=1,0,0,16,512,851968"
-
-Supporting Tools:
------------------
-Supporting tools include digiDload, digiConfig, buildPCI, and ditty.  See
-drivers/char/README.epca for more details.  Note,
-this driver REQUIRES that digiDload be executed prior to it being used. 
-Failure to do this will result in an ENODEV error.
-
-Documentation:
---------------
-Complete documentation for this product may be found in the tool package. 
-
-Sources of information and support:
------------------------------------
-Digi Intl. support site for this product:
-
-->  http://www.digi.com
-
-Acknowledgments:
-----------------
-Much of this work (And even text) was derived from a similar document 
-supporting the original public domain DigiBoard driver Copyright (C)
-1994,1995 Troy De Jongh.  Many thanks to Christoph Lameter 
-(christoph@lameter.com) and Mike McLagan (mike.mclagan@linux.org) who authored 
-and contributed to the original document. 
-
-Changelog:
-----------
-10-29-04:	Update status of driver, remove dead links in document
-		James Nelson <james4765@gmail.com>
-
-2000 (?)	Original Document
--- linux-3.14-rc8.orig/Documentation/serial/riscom8.txt	2014-03-31 13:52:29.448516297 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,36 +0,0 @@
-* NOTE - this is an unmaintained driver.  The original author cannot be located.
-
-SDL Communications is now SBS Technologies, and does not have any
-information on these ancient ISA cards on their website.
-
-James Nelson <james4765@gmail.com> - 12-12-2004
-
-	This is the README for RISCom/8 multi-port serial driver
-	(C) 1994-1996 D.Gorodchanin
-	See file LICENSE for terms and conditions.
-
-NOTE: English is not my native language. 
-      I'm sorry for any mistakes in this text.
-
-Misc. notes for RISCom/8 serial driver, in no particular order :)
-
-1) This driver can support up to 4 boards at time.
-   Use string "riscom8=0xXXX,0xXXX,0xXXX,0xXXX" at LILO prompt, for
-   setting I/O base addresses for boards. If you compile driver
-   as module use modprobe options "iobase=0xXXX iobase1=0xXXX iobase2=..."
-
-2) The driver partially supports famous 'setserial' program, you can use almost
-   any of its options, excluding port & irq settings.
-
-3) There are some misc. defines at the beginning of riscom8.c, please read the 
-   comments and try to change some of them in case of problems.
-
-4) I consider the current state of the driver as BETA.
-
-5) SDL Communications WWW page is http://www.sdlcomm.com.
-
-6) You can use the MAKEDEV program to create RISCom/8 /dev/ttyL* entries.
-
-7) Minor numbers for first board are 0-7, for second 8-15, etc.
-
-22 Apr 1996.
--- linux-3.14-rc8.orig/Documentation/serial/specialix.txt	2014-03-31 13:52:29.448516297 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,383 +0,0 @@
-
-      specialix.txt  -- specialix IO8+ multiport serial driver readme.
-
-
-
-      Copyright (C) 1997  Roger Wolff (R.E.Wolff@BitWizard.nl)
-
-      Specialix pays for the development and support of this driver.
-      Please DO contact io8-linux@specialix.co.uk if you require
-      support.
-
-      This driver was developed in the BitWizard linux device
-      driver service. If you require a linux device driver for your
-      product, please contact devices@BitWizard.nl for a quote.
-
-      This code is firmly based on the riscom/8 serial driver,
-      written by Dmitry Gorodchanin. The specialix IO8+ card
-      programming information was obtained from the CL-CD1865 Data
-      Book, and Specialix document number 6200059: IO8+ Hardware
-      Functional Specification, augmented by document number 6200088:
-      Merak Hardware Functional Specification. (IO8+/PCI is also 
-      called Merak)
-
-
-      This program is free software; you can redistribute it and/or
-      modify it under the terms of the GNU General Public License as
-      published by the Free Software Foundation; either version 2 of
-      the License, or (at your option) any later version.
-
-      This program is distributed in the hope that it will be
-      useful, but WITHOUT ANY WARRANTY; without even the implied
-      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-      PURPOSE.  See the GNU General Public License for more details.
-
-      You should have received a copy of the GNU General Public
-      License along with this program; if not, write to the Free
-      Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
-      USA.
-
-
-Intro
-=====
-
- 
-This file contains some random information, that I like to have online
-instead of in a manual that can get lost. Ever misplace your Linux
-kernel sources?  And the manual of one of the boards in your computer?
-
-
-Addresses and interrupts
-========================
-
-Address dip switch settings:
-The dip switch sets bits 2-9 of the IO address. 
-
-       9 8 7 6 5 4 3 2 
-     +-----------------+
-   0 | X   X X X X X X |
-     |                 |    =   IoBase = 0x100 
-   1 |   X             |
-     +-----------------+          ------ RS232 connectors ---->
-         
-         |    |    |
-       edge connector
-         |    |    |
-         V    V    V
-
-Base address 0x100 caused a conflict in one of my computers once.  I
-haven't the foggiest why. My Specialix card is now at 0x180.  My
-other computer runs just fine with the Specialix card at 0x100....
-The card occupies 4 addresses, but actually only two are really used.
-
-The PCI version doesn't have any dip switches. The BIOS assigns
-an IO address. 
-
-The driver now still autoprobes at 0x100, 0x180, 0x250 and 0x260.  If
-that causes trouble for you, please report that. I'll remove
-autoprobing then.
-
-The driver will tell the card what IRQ to use, so you don't have to
-change any jumpers to change the IRQ. Just use a command line
-argument (irq=xx) to the insmod program to set the interrupt.
-
-The BIOS assigns the IRQ on the PCI version. You have no say in what
-IRQ to use in that case. 
-
-If your specialix cards are not at the default locations, you can use
-the kernel command line argument "specialix=io0,irq0,io1,irq1...".
-Here "io0" is the io address for the first card, and "irq0" is the
-irq line that the first card should use. And so on. 
-
-Examples. 
-
-You use the driver as a module and have three cards at 0x100, 0x250
-and 0x180. And some way or another you want them detected in that
-order. Moreover irq 12 is taken (e.g. by your PS/2 mouse).
-
-  insmod specialix.o iobase=0x100,0x250,0x180 irq=9,11,15
-
-The same three cards, but now in the kernel would require you to
-add 
-
-   specialix=0x100,9,0x250,11,0x180,15
-
-to the command line. This would become 
-
-   append="specialix=0x100,9,0x250,11,0x180,15" 
-
-in your /etc/lilo.conf file if you use lilo. 
-
-The Specialix driver is slightly odd: It allows you to have the second
-or third card detected without having a first card. This has
-advantages and disadvantages. A slot that isn't filled by an ISA card,
-might be filled if a PCI card is detected. Thus if you have an ISA
-card at 0x250 and a PCI card, you would get:
-
-sx0: specialix IO8+ Board at 0x100 not found.
-sx1: specialix IO8+ Board at 0x180 not found.
-sx2: specialix IO8+ board detected at 0x250, IRQ 12, CD1865 Rev. B.
-sx3: specialix IO8+ Board at 0x260 not found.
-sx0: specialix IO8+ board detected at 0xd800, IRQ 9, CD1865 Rev. B.
-
-This would happen if you don't give any probe hints to the driver. 
-If you would specify:
-
-   specialix=0x250,11
-
-you'd get the following messages:
-
-sx0: specialix IO8+ board detected at 0x250, IRQ 11, CD1865 Rev. B.
-sx1: specialix IO8+ board detected at 0xd800, IRQ 9, CD1865 Rev. B.
-
-ISA probing is aborted after the IO address you gave is exhausted, and
-the PCI card is now detected as the second card. The ISA card is now
-also forced to IRQ11....
-
-
-Baud rates
-==========
-
-The rev 1.2 and below boards use a CL-CD1864. These chips can only 
-do 64kbit. The rev 1.3 and newer boards use a CL-CD1865. These chips
-are officially capable of 115k2.
-
-The Specialix card uses a 25MHz crystal (in times two mode, which in
-fact is a divided by two mode). This is not enough to reach the rated
-115k2 on all ports at the same time. With this clock rate you can only
-do 37% of this rate. This means that at 115k2 on all ports you are
-going to lose characters (The chip cannot handle that many incoming
-bits at this clock rate.) (Yes, you read that correctly: there is a
-limit to the number of -=bits=- per second that the chip can handle.)
-
-If you near the "limit" you will first start to see a graceful
-degradation in that the chip cannot keep the transmitter busy at all
-times. However with a central clock this slow, you can also get it to
-miss incoming characters. The driver will print a warning message when
-you are outside the official specs. The messages usually show up in
-the file /var/log/messages .
-
-The specialix card cannot reliably do 115k2. If you use it, you have
-to do "extensive testing" (*) to verify if it actually works.
-
-When "mgetty" communicates with my modem at 115k2 it reports:
-got: +++[0d]ATQ0V1H0[0d][0d][8a]O[cb][0d][8a]
-                            ^^^^ ^^^^    ^^^^ 
-
-The three characters that have the "^^^" under them have suffered a
-bit error in the highest bit. In conclusion: I've tested it, and found
-that it simply DOESN'T work for me. I also suspect that this is also
-caused by the baud rate being just a little bit out of tune. 
-
-I upgraded the crystal to 66Mhz on one of my Specialix cards. Works
-great! Contact me for details. (Voids warranty, requires a steady hand
-and more such restrictions....)
-
-
-(*) Cirrus logic CD1864 databook, page 40.
-
-
-Cables for the Specialix IO8+
-=============================
-
-The pinout of the connectors on the IO8+ is:
-
-     pin    short    direction    long name
-            name
-    Pin 1   DCD      input        Data Carrier Detect
-    Pin 2   RXD      input        Receive
-    Pin 3   DTR/RTS  output       Data Terminal Ready/Ready To Send
-    Pin 4   GND      -            Ground
-    Pin 5   TXD      output       Transmit
-    Pin 6   CTS      input        Clear To Send
-        
-    
-             -- 6  5  4  3  2  1 --
-             |                    |
-             |                    |
-             |                    |
-             |                    |
-             +-----          -----+
-                  |__________|
-                      clip
-    
-    Front view of an RJ12 connector. Cable moves "into" the paper.
-    (the plug is ready to plug into your mouth this way...)
-
-    
-    NULL cable. I don't know who is going to use these except for
-    testing purposes, but I tested the cards with this cable. (It 
-    took quite a while to figure out, so I'm not going to delete
-    it. So there! :-)
-    
-    
-    This end goes               This end needs
-    straight into the           some twists in
-    RJ12 plug.                  the wiring.
-       IO8+ RJ12                   IO8+ RJ12
-        1  DCD       white          -
-        -             -             1 DCD
-        2  RXD       black          5 TXD
-        3  DTR/RTS   red            6 CTS
-        4  GND       green          4 GND
-        5  TXD       yellow         2 RXD
-        6  CTS       blue           3 DTR/RTS
-    
-
-    Same NULL cable, but now sorted on the second column.
- 
-        1  DCD       white          -
-        -             -             1 DCD
-        5  TXD       yellow         2 RXD
-        6  CTS       blue           3 DTR/RTS
-        4  GND       green          4 GND
-        2  RXD       black          5 TXD
-        3  DTR/RTS   red            6 CTS
-    
-    
-    
-    This is a modem cable usable for hardware handshaking:
-        RJ12                        DB25           DB9
-        1   DCD      white          8 DCD          1 DCD
-        2   RXD      black          3 RXD          2 RXD
-        3   DTR/RTS  red            4 RTS          7 RTS
-        4   GND      green          7 GND          5 GND
-        5   TXD      yellow         2 TXD          3 TXD
-        6   CTS      blue           5 CTS          8 CTS
-                            +----   6 DSR          6 DSR
-                            +----  20 DTR          4 DTR
-
-    This is a modem cable usable for software handshaking:
-    It allows you to reset the modem using the DTR ioctls.
-    I (REW) have never tested this, "but xxxxxxxxxxxxx
-    says that it works." If you test this, please
-    tell me and I'll fill in your name on the xxx's.
-
-        RJ12                        DB25           DB9
-        1   DCD      white          8 DCD          1 DCD
-        2   RXD      black          3 RXD          2 RXD
-        3   DTR/RTS  red           20 DTR          4 DTR
-        4   GND      green          7 GND          5 GND
-        5   TXD      yellow         2 TXD          3 TXD
-        6   CTS      blue           5 CTS          8 CTS
-                            +----   6 DSR          6 DSR
-                            +----   4 RTS          7 RTS
-
-   I bought a 6 wire flat cable. It was colored as indicated.
-   Check that yours is the same before you trust me on this.
-   
- 
-Hardware handshaking issues.
-============================
-
-The driver can be told to operate in two different ways. The default
-behaviour is specialix.sx_rtscts = 0 where the pin behaves as DTR when
-hardware handshaking is off. It behaves as the RTS hardware
-handshaking signal when hardware handshaking is selected.
-
-When you use this, you have to use the appropriate cable. The
-cable will either be compatible with hardware handshaking or with
-software handshaking. So switching on the fly is not really an
-option.
-
-I actually prefer to use the "specialix.sx_rtscts=1" option.
-This makes the DTR/RTS pin always an RTS pin, and ioctls to
-change DTR are always ignored. I have a cable that is configured
-for this. 
-
-
-Ports and devices
-=================
-
-Port 0 is the one furthest from the card-edge connector.
-
-Devices:
-
-You should make the devices as follows:
-
-bash
-cd /dev
-for i in  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 \
-         16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
-do
-  echo -n "$i "
-  mknod /dev/ttyW$i c 75 $i
-  mknod /dev/cuw$i c 76 $i
-done
-echo ""
-
-If your system doesn't come with these devices preinstalled, bug your
-linux-vendor about this. They have had ample time to get this
-implemented by now.
-
-You cannot have more than 4 boards in one computer. The card only
-supports 4 different interrupts. If you really want this, contact me
-about this and I'll give you a few tips (requires soldering iron)....
-
-If you have enough PCI slots, you can probably use more than 4 PCI
-versions of the card though.... 
-
-The PCI version of the card cannot adhere to the mechanical part of
-the PCI spec because the 8 serial connectors are simply too large. If
-it doesn't fit in your computer, bring back the card.
-
-
-------------------------------------------------------------------------
-
-
-  Fixed bugs and restrictions:
-       - During initialization, interrupts are blindly turned on.
-            Having a shadow variable would cause an extra memory
-            access on every IO instruction. 
-       - The interrupt (on the card) should be disabled when we
-         don't allocate the Linux end of the interrupt. This allows 
-         a different driver/card to use it while all ports are not in
-         use..... (a la standard serial port)
-       == An extra _off variant of the sx_in and sx_out macros are
-          now available. They don't set the interrupt enable bit.
-          These are used during initialization. Normal operation uses
-          the old variant which enables the interrupt line.
-       - RTS/DTR issue needs to be implemented according to 
-         specialix' spec.
-            I kind of like the "determinism" of the current 
-            implementation. Compile time flag?
-       == Ok. Compile time flag! Default is how Specialix likes it.
-       == Now a config time flag! Gets saved in your config file. Neat!
-       - Can you set the IO address from the lilo command line?
-            If you need this, bug me about it, I'll make it. 
-       == Hah! No bugging needed. Fixed! :-)
-       - Cirrus logic hasn't gotten back to me yet why the CD1865 can
-            and the CD1864 can't do 115k2. I suspect that this is
-            because the CD1864 is not rated for 33MHz operation.
-            Therefore the CD1864 versions of the card can't do 115k2 on 
-            all ports just like the CD1865 versions. The driver does
-            not block 115k2 on CD1864 cards. 
-        == I called the Cirrus Logic representative here in Holland.
-           The CD1864 databook is identical to the CD1865 databook, 
-           except for an extra warning at the end. Similar Bit errors
-           have been observed in testing at 115k2 on both an 1865 and
-           a 1864 chip. I see no reason why I would prohibit 115k2 on
-           1864 chips and not do it on 1865 chips. Actually there is
-           reason to prohibit it on BOTH chips. I print a warning.
-           If you use 115k2, you're on your own. 
-       - A spiky CD may send spurious HUPs. Also in CLOCAL???
-         -- A fix for this turned out to be counter productive. 
-            Different fix? Current behaviour is acceptable?
-         -- Maybe the current implementation is correct. If anybody
-            gets bitten by this, please report, and it will get fixed.
-
-         -- Testing revealed that when in CLOCAL, the problem doesn't
-            occur. As warned for in the CD1865 manual, the chip may
-            send modem intr's on a spike. We could filter those out,
-            but that would be a cludge anyway (You'd still risk getting
-            a spurious HUP when two spikes occur.).....
- 
-
-
-  Bugs & restrictions:
-       - This is a difficult card to autoprobe.
-            You have to WRITE to the address register to even 
-            read-probe a CD186x register. Disable autodetection?
-         -- Specialix: any suggestions?
-
-
--- linux-3.14-rc8.orig/Documentation/serial/sx.txt	2014-03-31 13:52:29.448516297 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,294 +0,0 @@
-
-      sx.txt  -- specialix SX/SI multiport serial driver readme.
-
-
-
-      Copyright (C) 1997  Roger Wolff (R.E.Wolff@BitWizard.nl)
-
-      Specialix pays for the development and support of this driver.
-      Please DO contact support@specialix.co.uk if you require
-      support.
-
-      This driver was developed in the BitWizard linux device
-      driver service. If you require a linux device driver for your
-      product, please contact devices@BitWizard.nl for a quote.
-
-      (History)
-      There used to be an SI driver by Simon Allan. This is a complete 
-      rewrite  from scratch. Just a few lines-of-code have been snatched.
-
-      (Sources)
-      Specialix document number 6210028: SX Host Card and Download Code
-      Software Functional Specification.
-
-      (Copying)
-      This program is free software; you can redistribute it and/or
-      modify it under the terms of the GNU General Public License as
-      published by the Free Software Foundation; either version 2 of
-      the License, or (at your option) any later version.
-
-      This program is distributed in the hope that it will be
-      useful, but WITHOUT ANY WARRANTY; without even the implied
-      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-      PURPOSE.  See the GNU General Public License for more details.
-
-      You should have received a copy of the GNU General Public
-      License along with this program; if not, write to the Free
-      Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
-      USA.
-      
-      (Addendum)
-      I'd appreciate it that if you have fixes, that you send them
-      to me first. 
-
-
-Introduction
-============
-
-This file contains some random information, that I like to have online
-instead of in a manual that can get lost. Ever misplace your Linux
-kernel sources?  And the manual of one of the boards in your computer?
-
-
-Theory of operation
-===================
-
-An important thing to know is that the driver itself doesn't have the
-firmware for the card. This means that you need the separate package
-"sx_firmware". For now you can get the source at
-
-	ftp://ftp.bitwizard.nl/specialix/sx_firmware_<version>.tgz
-
-The firmware load needs a "misc" device, so you'll need to enable the
-"Support for user misc device modules" in your kernel configuration.
-The misc device needs to be called "/dev/specialix_sxctl". It needs
-misc major 10, and minor number 167 (assigned by HPA). The section
-on creating device files below also creates this device. 
-
-After loading the sx.o module into your kernel, the driver will report
-the number of cards detected, but because it doesn't have any
-firmware, it will not be able to determine the number of ports. Only
-when you then run "sx_firmware" will the firmware be downloaded and
-the rest of the driver initialized. At that time the sx_firmware
-program will report the number of ports installed.
-
-In contrast with many other multi port serial cards, some of the data
-structures are only allocated when the card knows the number of ports
-that are connected. This means we won't waste memory for 120 port
-descriptor structures when you only have 8 ports. If you experience
-problems due to this, please report them: I haven't seen any.
-
-
-Interrupts
-==========
-
-A multi port serial card, would generate a horrendous amount of
-interrupts if it would interrupt the CPU for every received
-character. Even more than 10 years ago, the trick not to use
-interrupts but to poll the serial cards was invented.
-
-The SX card allow us to do this two ways. First the card limits its
-own interrupt rate to a rate that won't overwhelm the CPU. Secondly,
-we could forget about the cards interrupt completely and use the
-internal timer for this purpose.
-
-Polling the card can take up to a few percent of your CPU. Using the
-interrupts would be better if you have most of the ports idle. Using
-timer-based polling is better if your card almost always has work to
-do. You save the separate interrupt in that case.
-
-In any case, it doesn't really matter all that much. 
-
-The most common problem with interrupts is that for ISA cards in a PCI
-system the BIOS has to be told to configure that interrupt as "legacy
-ISA". Otherwise the card can pull on the interrupt line all it wants
-but the CPU won't see this.
-
-If you can't get the interrupt to work, remember that polling mode is
-more efficient (provided you actually use the card intensively).
-
-
-Allowed Configurations
-======================
-
-Some configurations are disallowed. Even though at a glance they might
-seem to work, they are known to lockup the bus between the host card
-and the device concentrators. You should respect the drivers decision
-not to support certain configurations. It's there for a reason.
-
-Warning: Seriously technical stuff ahead. Executive summary: Don't use
-SX cards except configured at a 64k boundary. Skip the next paragraph.
-
-The SX cards can theoretically be placed at a 32k boundary. So for
-instance you can put an SX card at 0xc8000-0xd7fff. This is not a
-"recommended configuration". ISA cards have to tell the bus controller
-how they like their timing. Due to timing issues they have to do this
-based on which 64k window the address falls into. This means that the
-32k window below and above the SX card have to use exactly the same
-timing as the SX card. That reportedly works for other SX cards. But
-you're still left with two useless 32k windows that should not be used
-by anybody else.
-
-
-Configuring the driver
-======================
-
-PCI cards are always detected. The driver auto-probes for ISA cards at
-some sensible addresses. Please report if the auto-probe causes trouble
-in your system, or when a card isn't detected.
-
-I'm afraid I haven't implemented "kernel command line parameters" yet.
-This means that if the default doesn't work for you, you shouldn't use
-the compiled-into-the-kernel version of the driver. Use a module
-instead.  If you convince me that you need this, I'll make it for
-you. Deal?
-
-I'm afraid that the module parameters are a bit clumsy. If you have a
-better idea, please tell me.
-
-You can specify several parameters:
-
-	sx_poll: number of jiffies between timer-based polls.
-
-		Set this to "0" to disable timer based polls. 
-                Initialization of cards without a working interrupt
-                will fail.
-
-		Set this to "1" if you want a polling driver. 
-		(on Intel: 100 polls per second). If you don't use
-                fast baud rates, you might consider a value like "5". 
-                (If you don't know how to do the math, use 1).
-
-	sx_slowpoll: Number of jiffies between timer-based polls. 
- 		Set this to "100" to poll once a second. 
-		This should get the card out of a stall if the driver
-                ever misses an interrupt. I've never seen this happen,
-                and if it does, that's a bug. Tell me. 
-
-	sx_maxints: Number of interrupts to request from the card. 
-		The card normally limits interrupts to about 100 per
-		second to offload the host CPU. You can increase this
-		number to reduce latency on the card a little.
-		Note that if you give a very high number you can overload
-		your CPU as well as the CPU on the host card. This setting 
-		is inaccurate and not recommended for SI cards (But it 
-		works). 
-
-	sx_irqmask: The mask of allowable IRQs to use. I suggest you set 
-		this to 0 (disable IRQs all together) and use polling if 
-		the assignment of IRQs becomes problematic. This is defined
-		as the sum of (1 << irq) 's that you want to allow. So 
-		sx_irqmask of 8 (1 << 3) specifies that only irq 3 may
-		be used by the SX driver. If you want to specify to the 
-		driver: "Either irq 11 or 12 is ok for you to use", then
-		specify (1 << 11) | (1 << 12) = 0x1800 . 
-
-	sx_debug: You can enable different sorts of debug traces with this. 
-		At "-1" all debugging traces are active. You'll get several
-		times more debugging output than you'll get characters 
-		transmitted. 
-
-
-Baud rates
-==========
-
-Theoretically new SXDCs should be capable of more than 460k
-baud. However the line drivers usually give up before that.  Also the
-CPU on the card may not be able to handle 8 channels going at full
-blast at that speed. Moreover, the buffers are not large enough to
-allow operation with 100 interrupts per second. You'll have to realize
-that the card has a 256 byte buffer, so you'll have to increase the
-number of interrupts per second if you have more than 256*100 bytes
-per second to transmit.  If you do any performance testing in this
-area, I'd be glad to hear from you...
-
-(Psst Linux users..... I think the Linux driver is more efficient than
-the driver for other OSes. If you can and want to benchmark them
-against each other, be my guest, and report your findings...... :-)
-
-
-Ports and devices
-=================
-
-Port 0 is the top connector on the module closest to the host
-card. Oh, the ports on the SXDCs and TAs are labelled from 1 to 8
-instead of from 0 to 7, as they are numbered by linux. I'm stubborn in
-this: I know for sure that I wouldn't be able to calculate which port
-is which anymore if I would change that....
-
-
-Devices:
-
-You should make the device files as follows:
-
-#!/bin/sh
-# (I recommend that you cut-and-paste this into a file and run that)
-cd /dev
-t=0
-mknod specialix_sxctl c 10 167
-while [ $t -lt 64 ]
-  do 
-  echo -n "$t "
-  mknod ttyX$t c 32 $t
-  mknod cux$t  c 33 $t
-  t=`expr $t + 1`
-done
-echo ""
-rm /etc/psdevtab
-ps > /dev/null
-
-
-This creates 64 devices. If you have more, increase the constant on
-the line with "while". The devices start at 0, as is customary on
-Linux. Specialix seems to like starting the numbering at 1. 
-
-If your system doesn't come with these devices pre-installed, bug your
-linux-vendor about this. They should have these devices
-"pre-installed" before the new millennium. The "ps" stuff at the end
-is to "tell" ps that the new devices exist.
-
-Officially the maximum number of cards per computer is 4. This driver
-however supports as many cards in one machine as you want. You'll run
-out of interrupts after a few, but you can switch to polled operation
-then. At about 256 ports (More than 8 cards), we run out of minor
-device numbers. Sorry. I suggest you buy a second computer.... (Or
-switch to RIO).
-
-------------------------------------------------------------------------
-
-
-  Fixed bugs and restrictions:
-	- Hangup processing.  
-	  -- Done.
-
-	- the write path in generic_serial (lockup / oops). 
-	  -- Done (Ugly: not the way I want it. Copied from serial.c).
-
-        - write buffer isn't flushed at close.
-	  -- Done. I still seem to lose a few chars at close. 
-	     Sorry. I think that this is a firmware issue. (-> Specialix)
-
-	- drain hardware before  changing termios
-	- Change debug on the fly. 
-	- ISA free irq -1. (no firmware loaded).
-	- adding c8000 as a probe address. Added warning. 
-	- Add a RAMtest for the RAM on the card.c
-        - Crash when opening a port "way" of the number of allowed ports. 
-          (for example opening port 60 when there are only 24 ports attached)
-	- Sometimes the use-count strays a bit. After a few hours of
-          testing the use count is sometimes "3". If you are not like
-          me and can remember what you did to get it that way, I'd
-          appreciate an Email. Possibly fixed. Tell me if anyone still
-          sees this.
-	- TAs don't work right if you don't connect all the modem control
-	  signals. SXDCs do. T225 firmware problem -> Specialix. 
-	  (Mostly fixed now, I think. Tell me if you encounter this!)
-
-  Bugs & restrictions:
-
-	- Arbitrary baud rates. Requires firmware update. (-> Specialix)
-
-	- Low latency (mostly firmware, -> Specialix)
-
-
-
--- linux-3.14-rc8.orig/Documentation/kernel-parameters.txt	2014-03-31 13:52:29.448516297 +0200
+++ linux-3.14-rc8/Documentation/kernel-parameters.txt	2014-03-31 13:53:45.558275533 +0200
@@ -790,13 +790,6 @@ bytes respectively. Such letter suffixes
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
-	digi=		[HW,SERIAL]
-			IO parameters + enable/disable command.
-
-	digiepca=	[HW,SERIAL]
-			See drivers/char/README.epca and
-			Documentation/serial/digiepca.txt.
-
 	disable=	[IPV6]
 			See Documentation/networking/ipv6.txt.
 
@@ -2906,9 +2899,6 @@ bytes respectively. Such letter suffixes
 	rhash_entries=	[KNL,NET]
 			Set number of hash buckets for route cache
 
-	riscom8=	[HW,SERIAL]
-			Format: <io_board1>[,<io_board2>[,...<io_boardN>]]
-
 	ro		[KNL] Mount root device read-only on boot
 
 	root=		[KNL] Root filesystem
@@ -3050,9 +3040,6 @@ bytes respectively. Such letter suffixes
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/laptops/sonypi.txt
 
-	specialix=	[HW,SERIAL] Specialix multi-serial port adapter
-			See Documentation/serial/specialix.txt.
-
 	spia_io_base=	[HW,MTD]
 	spia_fio_base=
 	spia_pedr=
--- linux-3.14-rc8.orig/firmware/WHENCE	2014-03-31 13:52:29.448516297 +0200
+++ linux-3.14-rc8/firmware/WHENCE	2014-03-31 13:52:30.733545967 +0200
@@ -273,16 +273,6 @@ Converted from Intel HEX files, used in
 
 --------------------------------------------------------------------------
 
-Driver: ip2 -- Computone IntelliPort Plus serial device
-
-File: intelliport2.bin
-
-Licence: Unknown
-
-Found in hex form in kernel source.
-
---------------------------------------------------------------------------
-
 Driver: CPiA2 -- cameras based on Vision's CPiA2
 
 File: cpia2/stv0672_vp4.bin
--- linux-3.14-rc8.orig/Documentation/magic-number.txt	2014-01-20 03:40:07.000000000 +0100
+++ linux-3.14-rc8/Documentation/magic-number.txt	2014-03-31 14:43:27.191756399 +0200
@@ -63,8 +63,6 @@ Magic Name            Number      Struct
 PG_MAGIC              'P'         pg_{read,write}_hdr include/linux/pg.h
 CMAGIC                0x0111      user              include/linux/a.out.h
 MKISS_DRIVER_MAGIC    0x04bf      mkiss_channel     drivers/net/mkiss.h
-RISCOM8_MAGIC         0x0907      riscom_port       drivers/char/riscom8.h
-SPECIALIX_MAGIC       0x0907      specialix_port    drivers/char/specialix_io8.h
 HDLC_MAGIC            0x239e      n_hdlc            drivers/char/n_hdlc.c
 APM_BIOS_MAGIC        0x4101      apm_user          arch/x86/kernel/apm_32.c
 CYCLADES_MAGIC        0x4359      cyclades_port     include/linux/cyclades.h
@@ -82,7 +80,6 @@ STRIP_MAGIC           0x5303      strip
 X25_ASY_MAGIC         0x5303      x25_asy           drivers/net/x25_asy.h
 SIXPACK_MAGIC         0x5304      sixpack           drivers/net/hamradio/6pack.h
 AX25_MAGIC            0x5316      ax_disp           drivers/net/mkiss.h
-ESP_MAGIC             0x53ee      esp_struct        drivers/char/esp.h
 TTY_MAGIC             0x5401      tty_struct        include/linux/tty.h
 MGSL_MAGIC            0x5401      mgsl_info         drivers/char/synclink.c
 TTY_DRIVER_MAGIC      0x5402      tty_driver        include/linux/tty_driver.h
@@ -94,13 +91,10 @@ USB_BLUETOOTH_MAGIC   0x6d02      usb_bl
 RFCOMM_TTY_MAGIC      0x6d02                        net/bluetooth/rfcomm/tty.c
 USB_SERIAL_PORT_MAGIC 0x7301      usb_serial_port   drivers/usb/serial/usb-serial.h
 CG_MAGIC              0x00090255  ufs_cylinder_group include/linux/ufs_fs.h
-A2232_MAGIC           0x000a2232  gs_port           drivers/char/ser_a2232.h
 RPORT_MAGIC           0x00525001  r_port            drivers/char/rocket_int.h
 LSEMAGIC              0x05091998  lse               drivers/fc4/fc.c
 GDTIOCTL_MAGIC        0x06030f07  gdth_iowr_str     drivers/scsi/gdth_ioctl.h
 RIEBL_MAGIC           0x09051990                    drivers/net/atarilance.c
-RIO_MAGIC             0x12345678  gs_port           drivers/char/rio/rio_linux.c
-SX_MAGIC              0x12345678  gs_port           drivers/char/sx.h
 NBD_REQUEST_MAGIC     0x12560953  nbd_request       include/linux/nbd.h
 RED_MAGIC2            0x170fc2a5  (any)             mm/slab.c
 BAYCOM_MAGIC          0x19730510  baycom_state      drivers/net/baycom_epp.c
@@ -116,7 +110,6 @@ ISDN_ASYNC_MAGIC      0x49344C01  modem_
 CTC_ASYNC_MAGIC       0x49344C01  ctc_tty_info      drivers/s390/net/ctctty.c
 ISDN_NET_MAGIC        0x49344C02  isdn_net_local_s  drivers/isdn/i4l/isdn_net_lib.h
 SAVEKMSG_MAGIC2       0x4B4D5347  savekmsg          arch/*/amiga/config.c
-STLI_BOARDMAGIC       0x4bc6c825  stlibrd           include/linux/istallion.h
 CS_STATE_MAGIC        0x4c4f4749  cs_state          sound/oss/cs46xx.c
 SLAB_C_MAGIC          0x4f17a36d  kmem_cache        mm/slab.c
 COW_MAGIC             0x4f4f4f4d  cow_header_v1     arch/um/drivers/ubd_user.c
@@ -127,10 +120,8 @@ SCC_MAGIC             0x52696368  gs_por
 SAVEKMSG_MAGIC1       0x53415645  savekmsg          arch/*/amiga/config.c
 GDA_MAGIC             0x58464552  gda               arch/mips/include/asm/sn/gda.h
 RED_MAGIC1            0x5a2cf071  (any)             mm/slab.c
-STL_PORTMAGIC         0x5a7182c9  stlport           include/linux/stallion.h
 EEPROM_MAGIC_VALUE    0x5ab478d2  lanai_dev         drivers/atm/lanai.c
 HDLCDRV_MAGIC         0x5ac6e778  hdlcdrv_state     include/linux/hdlcdrv.h
-EPCA_MAGIC            0x5c6df104  channel           include/linux/epca.h
 PCXX_MAGIC            0x5c6df104  channel           drivers/char/pcxx.h
 KV_MAGIC              0x5f4b565f  kernel_vars_s     arch/mips/include/asm/sn/klkernvars.h
 I810_STATE_MAGIC      0x63657373  i810_state        sound/oss/i810_audio.c
@@ -142,17 +133,14 @@ SLOT_MAGIC            0x67267322  slot
 LO_MAGIC              0x68797548  nbd_device        include/linux/nbd.h
 OPROFILE_MAGIC        0x6f70726f  super_block       drivers/oprofile/oprofilefs.h
 M3_STATE_MAGIC        0x734d724d  m3_state          sound/oss/maestro3.c
-STL_PANELMAGIC        0x7ef621a1  stlpanel          include/linux/stallion.h
 VMALLOC_MAGIC         0x87654320  snd_alloc_track   sound/core/memory.c
 KMALLOC_MAGIC         0x87654321  snd_alloc_track   sound/core/memory.c
 PWC_MAGIC             0x89DC10AB  pwc_device        drivers/usb/media/pwc.h
 NBD_REPLY_MAGIC       0x96744668  nbd_reply         include/linux/nbd.h
-STL_BOARDMAGIC        0xa2267f52  stlbrd            include/linux/stallion.h
 ENI155_MAGIC          0xa54b872d  midway_eprom	    drivers/atm/eni.h
 SCI_MAGIC             0xbabeface  gs_port           drivers/char/sh-sci.h
 CODA_MAGIC            0xC0DAC0DA  coda_file_info    fs/coda/coda_fs_i.h
 DPMEM_MAGIC           0xc0ffee11  gdt_pci_sram      drivers/scsi/gdth.h
-STLI_PORTMAGIC        0xe671c7a1  stliport          include/linux/istallion.h
 YAM_MAGIC             0xF10A7654  yam_port          drivers/net/hamradio/yam.c
 CCB_MAGIC             0xf2691ad2  ccb               drivers/scsi/ncr53c8xx.c
 QUEUE_MAGIC_FREE      0xf7e1c9a3  queue_entry       drivers/scsi/arm/queue.c
--- linux-3.14-rc8.orig/Documentation/zh_CN/magic-number.txt	2014-01-20 03:40:07.000000000 +0100
+++ linux-3.14-rc8/Documentation/zh_CN/magic-number.txt	2014-03-31 14:43:37.532996134 +0200
@@ -63,8 +63,6 @@ 魔术名                 地址
 PG_MAGIC              'P'         pg_{read,write}_hdr include/linux/pg.h
 CMAGIC                0x0111      user              include/linux/a.out.h
 MKISS_DRIVER_MAGIC    0x04bf      mkiss_channel     drivers/net/mkiss.h
-RISCOM8_MAGIC         0x0907      riscom_port       drivers/char/riscom8.h
-SPECIALIX_MAGIC       0x0907      specialix_port    drivers/char/specialix_io8.h
 HDLC_MAGIC            0x239e      n_hdlc            drivers/char/n_hdlc.c
 APM_BIOS_MAGIC        0x4101      apm_user          arch/x86/kernel/apm_32.c
 CYCLADES_MAGIC        0x4359      cyclades_port     include/linux/cyclades.h
@@ -82,7 +80,6 @@ STRIP_MAGIC           0x5303      strip
 X25_ASY_MAGIC         0x5303      x25_asy           drivers/net/x25_asy.h
 SIXPACK_MAGIC         0x5304      sixpack           drivers/net/hamradio/6pack.h
 AX25_MAGIC            0x5316      ax_disp           drivers/net/mkiss.h
-ESP_MAGIC             0x53ee      esp_struct        drivers/char/esp.h
 TTY_MAGIC             0x5401      tty_struct        include/linux/tty.h
 MGSL_MAGIC            0x5401      mgsl_info         drivers/char/synclink.c
 TTY_DRIVER_MAGIC      0x5402      tty_driver        include/linux/tty_driver.h
@@ -94,13 +91,10 @@ USB_BLUETOOTH_MAGIC   0x6d02      usb_bl
 RFCOMM_TTY_MAGIC      0x6d02                        net/bluetooth/rfcomm/tty.c
 USB_SERIAL_PORT_MAGIC 0x7301      usb_serial_port   drivers/usb/serial/usb-serial.h
 CG_MAGIC              0x00090255  ufs_cylinder_group include/linux/ufs_fs.h
-A2232_MAGIC           0x000a2232  gs_port           drivers/char/ser_a2232.h
 RPORT_MAGIC           0x00525001  r_port            drivers/char/rocket_int.h
 LSEMAGIC              0x05091998  lse               drivers/fc4/fc.c
 GDTIOCTL_MAGIC        0x06030f07  gdth_iowr_str     drivers/scsi/gdth_ioctl.h
 RIEBL_MAGIC           0x09051990                    drivers/net/atarilance.c
-RIO_MAGIC             0x12345678  gs_port           drivers/char/rio/rio_linux.c
-SX_MAGIC              0x12345678  gs_port           drivers/char/sx.h
 NBD_REQUEST_MAGIC     0x12560953  nbd_request       include/linux/nbd.h
 RED_MAGIC2            0x170fc2a5  (any)             mm/slab.c
 BAYCOM_MAGIC          0x19730510  baycom_state      drivers/net/baycom_epp.c
@@ -116,7 +110,6 @@ ISDN_ASYNC_MAGIC      0x49344C01  modem_
 CTC_ASYNC_MAGIC       0x49344C01  ctc_tty_info      drivers/s390/net/ctctty.c
 ISDN_NET_MAGIC        0x49344C02  isdn_net_local_s  drivers/isdn/i4l/isdn_net_lib.h
 SAVEKMSG_MAGIC2       0x4B4D5347  savekmsg          arch/*/amiga/config.c
-STLI_BOARDMAGIC       0x4bc6c825  stlibrd           include/linux/istallion.h
 CS_STATE_MAGIC        0x4c4f4749  cs_state          sound/oss/cs46xx.c
 SLAB_C_MAGIC          0x4f17a36d  kmem_cache        mm/slab.c
 COW_MAGIC             0x4f4f4f4d  cow_header_v1     arch/um/drivers/ubd_user.c
@@ -127,10 +120,8 @@ SCC_MAGIC             0x52696368  gs_por
 SAVEKMSG_MAGIC1       0x53415645  savekmsg          arch/*/amiga/config.c
 GDA_MAGIC             0x58464552  gda               arch/mips/include/asm/sn/gda.h
 RED_MAGIC1            0x5a2cf071  (any)             mm/slab.c
-STL_PORTMAGIC         0x5a7182c9  stlport           include/linux/stallion.h
 EEPROM_MAGIC_VALUE    0x5ab478d2  lanai_dev         drivers/atm/lanai.c
 HDLCDRV_MAGIC         0x5ac6e778  hdlcdrv_state     include/linux/hdlcdrv.h
-EPCA_MAGIC            0x5c6df104  channel           include/linux/epca.h
 PCXX_MAGIC            0x5c6df104  channel           drivers/char/pcxx.h
 KV_MAGIC              0x5f4b565f  kernel_vars_s     arch/mips/include/asm/sn/klkernvars.h
 I810_STATE_MAGIC      0x63657373  i810_state        sound/oss/i810_audio.c
@@ -142,17 +133,14 @@ SLOT_MAGIC            0x67267322  slot
 LO_MAGIC              0x68797548  nbd_device        include/linux/nbd.h
 OPROFILE_MAGIC        0x6f70726f  super_block       drivers/oprofile/oprofilefs.h
 M3_STATE_MAGIC        0x734d724d  m3_state          sound/oss/maestro3.c
-STL_PANELMAGIC        0x7ef621a1  stlpanel          include/linux/stallion.h
 VMALLOC_MAGIC         0x87654320  snd_alloc_track   sound/core/memory.c
 KMALLOC_MAGIC         0x87654321  snd_alloc_track   sound/core/memory.c
 PWC_MAGIC             0x89DC10AB  pwc_device        drivers/usb/media/pwc.h
 NBD_REPLY_MAGIC       0x96744668  nbd_reply         include/linux/nbd.h
-STL_BOARDMAGIC        0xa2267f52  stlbrd            include/linux/stallion.h
 ENI155_MAGIC          0xa54b872d  midway_eprom	    drivers/atm/eni.h
 SCI_MAGIC             0xbabeface  gs_port           drivers/char/sh-sci.h
 CODA_MAGIC            0xC0DAC0DA  coda_file_info    include/linux/coda_fs_i.h
 DPMEM_MAGIC           0xc0ffee11  gdt_pci_sram      drivers/scsi/gdth.h
-STLI_PORTMAGIC        0xe671c7a1  stliport          include/linux/istallion.h
 YAM_MAGIC             0xF10A7654  yam_port          drivers/net/hamradio/yam.c
 CCB_MAGIC             0xf2691ad2  ccb               drivers/scsi/ncr53c8xx.c
 QUEUE_MAGIC_FREE      0xf7e1c9a3  queue_entry       drivers/scsi/arm/queue.c

-- 
Jean Delvare
SUSE L3 Support
