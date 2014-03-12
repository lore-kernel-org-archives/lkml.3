Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaCLUmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:42:15 -0400
Received: from mout.gmx.net ([212.227.17.20]:63110 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaCLUmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:42:14 -0400
Message-ID: <5320C69F.5050608@gmx.de>
Date: Wed, 12 Mar 2014 21:42:07 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-audit@redhat.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: scary syslog message (from audit ?)
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:kt+qpR1b8mFJoDnPO1EJm6os74pyhghixfuiE/cnZXy+m0N/Bj7
 5fLW1dqkDHERNSoAB9zr0JyqxGZGbBtKKAdsF46LYJrJ1SatIBDs0sTKCZNZ/slJ2BQ0SdV
 vyGUmNxr9bBqC8cPeO8j1OjrBJbX5dEBMHtL2qKej87pu/UGB7YWI55B7vtgovO8kQPTmcE
 oDmXI0DFq4HN1ncC2gDzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Today I observed this in /var/log/messages with kernel 3.13.6 at a 32 bit Gentoo Linux :


Mar 12 21:20:01 n22 crond[26813]: pam_unix(crond:session): session opened for user root by (uid=0)
Mar 12 21:20:01 n22 kernel: type=1006 audit(1394655601.295:160): pid=26813 uid=0 old auid=4294967295 new auid=0 old ses=4294967295 new ses=159 res=1
Mar 12 21:20:01 n22 CROND[26816]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 12 21:20:01 n22 CROND[26813]: pam_unix(crond:session): session closed for user root
Mar 12 21:29:01 n22 CROND[25166]: pam_unix(crond:session): session closed for user root
Mar 12 21:30:01 n22 crond[30053]: pam_unix(crond:session): session opened for user root by (uid=0)
Mar 12 21:30:01 n22 CROND[30055]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 12 21:30:01 n22 kernel: audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=64
Mar 12 21:30:01 n22 kernel: type=1006 audit(1394656201.313:161): pid=30053 uid=0 old auid=4294967295 new auid=0 old ses=4294967295 new ses=161 res=1
Mar 12 21:30:01 n22 kernel: audit: printk limit exceeded
Mar 12 21:30:01 n22 kernel: new ses=149 res=1
1
1
 @ 40000 KHz), (N/A, 2000 mBm)
<6>cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
<6>cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
<6>cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
00 mBm)
<6>cfg80211: Calling CRDA for country: DE
ulatory domain
<6>PM: freeze of devices complete after 342.951 msecs
<6>PM: late freeze of devices complete after 0.286 msecs
<6>PM: noirq freeze of devices complete after 1.715 msecs
<6>ACPI: Preparing to enter system sleep state S4
<6>PM: Saving platform NVS memory
<4>Disabling non-boot CPUs ...
<6>kvm: disabling virtualization on CPU1
<6>smpboot: CPU 1 is now offline
<6>kvm: disabling virtualization on CPU2
<6>smpboot: CPU 2 is now offline
<6>kvm: disabling virtualization on CPU3
<6>smpboot: CPU 3 is now offline
<6>PM: Creating hibernation image:
<6>PM: Need to copy 152202 pages
<6>PM: Restoring platform NVS memory
<6>Enabling non-boot CPUs ...
<6>x86: Booting SMP configuration:
<6>smpboot: Booting Node 0 Processor 1 APIC 0x1
<6>Initializing CPU#1
<6>Disabled fast string operations
<6>kvm: enabling virtualization on CPU1
<6>CPU1 is up
<6>smpboot: Booting Node 0 Processor 2 APIC 0x2
<6>Initializing CPU#2
<6>Disabled fast string operations
<6>kvm: enabling virtualization on CPU2
<6>CPU2 is up
<6>smpboot: Booting Node 0 Processor 3 APIC 0x3
<6>Initializing CPU#3
<6>Disabled fast string operations
<6>kvm: enabling virtualization on CPU3
<6>CPU3 is up
<6>ACPI: Waking up from system sleep state S4
<6>thinkpad_acpi: EC reports that Thermal Table has changed
<6>PM: noirq restore of devices complete after 23.354 msecs
<6>PM: early restore of devices complete after 0.211 msecs
<4>usb usb1: root hub lost power or was reset
<7>e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<4>usb usb2: root hub lost power or was reset
<7>snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
<7>ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<7>ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[drm] Wrong MCH_SSKPD value: 0x16040307
<6>[drm] This can cause pipe underruns and display issues.
<6>[drm] Please upgrade your BIOS to fix this.
<6>ata5: SATA link down (SStatus 0 SControl 300)
<6>ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>ata4: SATA link down (SStatus 0 SControl 300)
<6>ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<7>ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out

<6>ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<7>ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<6>usb 1-1: reset high-speed USB device number 2 using ehci-pci
<7>ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<7>ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<6>ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>ata1.00: configured for UDMA/100
<7>ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>ata2.00: configured for UDMA/33
<5>sd 0:0:0:0: [sda] Starting disk
<6>usb 2-1: reset high-speed USB device number 2 using ehci-pci
<6>usb 1-1.1: reset high-speed USB device number 3 using ehci-pci
<6>usb 1-1.6: reset high-speed USB device number 5 using ehci-pci
<6>usb 1-1.4: reset full-speed USB device number 4 using ehci-pci
<6>usb 2-1.2: reset high-speed USB device number 3 using ehci-pci
<6>usb 2-1.5: reset full-speed USB device number 4 using ehci-pci
<6>usb 2-1.2.1: reset low-speed USB device number 5 using ehci-pci
<6>[drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp on
<6>usb 2-1.2.3: reset low-speed USB device number 7 using ehci-pci
<6>iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
<6>iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
<6>usb 2-1.2.2: reset full-speed USB device number 6 using ehci-pci
<6>usblp0: removed
<6>PM: restore of devices complete after 2649.424 msecs
<6>usblp 2-1.2.2:1.0: usblp0: USB Bidirectional printer dev 6 if 0 alt 0 proto 2 vid 0x043D pid 0x0078
<4>Restarting tasks ... done.
<6>video LNXVIDEO:00: Restoring backlight state
<6>wlp3s0: authenticate with 08:96:d7:05:f9:2a
<6>wlp3s0: send auth to 08:96:d7:05:f9:2a (try 1/3)
<6>wlp3s0: authenticated
<6>wlp3s0: associate with 08:96:d7:05:f9:2a (try 1/3)
<6>wlp3s0: RX AssocResp from 08:96:d7:05:f9:2a (capab=0x431 status=0 aid=1)
<6>wlp3s0: associated
:
Mar 12 21:30:01 n22 crond[30054]: pam_unix(crond:session): session opened for user root by (uid=0)
Mar 12 21:30:01 n22 CROND[30060]: (root) CMD (/usr/lib/sa/sa1 60 15 )
Mar 12 21:30:01 n22 CROND[30053]: pam_unix(crond:session): session closed for user root
Mar 12 21:37:04 n22 su[32414]: Successful su for root by root
Mar 12 21:37:04 n22 su[32414]: + /dev/pts/9 root:root
Mar 12 21:37:04 n22 su[32414]: pam_unix(su:session): session opened for user root by tfoerste(uid=0)


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMgxp8ACgkQxOrN3gB26U5bkAD/Y3QuDUvzyFSNH15MzbRaAeMZ
+jBeoy2MlW3olxEcp68A/1pG4NeNhNm0vzSNL1BRaLQnUSTrPgnTaHziqqJOrXwh
=8UJV
-----END PGP SIGNATURE-----
