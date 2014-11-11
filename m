Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKKR6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:58:35 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41822 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaKKR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:58:29 -0500
Message-ID: <54624E40.30802@googlemail.com>
Date: Tue, 11 Nov 2014 18:58:24 +0100
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regression: suspend to ram completely broken since at least 3.13-rc5,
 works with 3.12.
Content-Type: multipart/mixed;
 boundary="------------000806090107080401040107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000806090107080401040107
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello,

with kernel 3.12.X with X tested up to .23 suspend to ram works
flawlessly. My machine suspends quickly and wakes up reliably, giving me
uptimes measured in weeks.

Every kernel I tried between 3.13.0-rc5 and 3.16.7 on the other hand
shows this behaviour:

IF suspend works it takes ages. Video blanks quickly, harddisks are
turned off, then it is stuck for a long time (more minute than tens of
seconds), and at some point suspends.

Afterwards there is a 50% chance it will wake up. In that case: nothing
in dmesg.
If it does not wake up on pressing any button, I have to press power
button for a nice cold boot.

Even if it does suspend and resume successfully, it will NOT suspend the
next time. Never.

The much more likely failure mode looks like this:
It will blank video and turn of harddisks and then nothing happens. usb
dead, ps2 keyboard dead, no harddisk activity, fans are spinning,
mainboard is powered - and nothing happens. I can turn off or hit reset
button.

Of course, after a reboot nothing will show up in the logs.

So this is a severe regression. Box worked, it stopped working.

dmesg from 3.14.23 which does not work:

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.23 (root@energy) (gcc version 4.8.3
(Gentoo 4.8.3 p1.1, pie-0.5.9) ) #2 SMP Sun Nov 9 19:18:34 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.14.23
root=/dev/sda2 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ba667fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba668000-0x00000000ba943fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ba944000-0x00000000ba953fff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ba954000-0x00000000bb756fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb757000-0x00000000bc9c9fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000bc9ca000-0x00000000bca37fff]
type 20
[    0.000000] BIOS-e820: [mem 0x00000000bca38000-0x00000000bca38fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bca39000-0x00000000bcc3efff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bcc3f000-0x00000000bd082fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd083000-0x00000000bd7f3fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd7f4000-0x00000000bd7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000043fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.10 by American Megatrends
[    0.000000] efi:  ACPI=0xba94c000  ACPI 2.0=0xba94c000  SMBIOS=0xf04c0
[    0.000000] efi: mem00: type=3, attr=0xf,
range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf,
range=[0x0000000000008000-0x000000000005f000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf,
range=[0x000000000005f000-0x0000000000060000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf,
range=[0x0000000000060000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf,
range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf,
range=[0x0000000001000000-0x0000000002292000) (18MB)
[    0.000000] efi: mem06: type=7, attr=0xf,
range=[0x0000000002292000-0x000000007e53d000) (1986MB)
[    0.000000] efi: mem07: type=2, attr=0xf,
range=[0x000000007e53d000-0x00000000a9b64000) (694MB)
[    0.000000] efi: mem08: type=7, attr=0xf,
range=[0x00000000a9b64000-0x00000000a9b6a000) (0MB)
[    0.000000] efi: mem09: type=1, attr=0xf,
range=[0x00000000a9b6a000-0x00000000a9b87000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf,
range=[0x00000000a9b87000-0x00000000ad3d0000) (56MB)
[    0.000000] efi: mem11: type=4, attr=0xf,
range=[0x00000000ad3d0000-0x00000000ad48f000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf,
range=[0x00000000ad48f000-0x00000000ad497000) (0MB)
[    0.000000] efi: mem13: type=4, attr=0xf,
range=[0x00000000ad497000-0x00000000ad4ba000) (0MB)
[    0.000000] efi: mem14: type=7, attr=0xf,
range=[0x00000000ad4ba000-0x00000000ad4c3000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf,
range=[0x00000000ad4c3000-0x00000000ad4e9000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf,
range=[0x00000000ad4e9000-0x00000000ad4f5000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf,
range=[0x00000000ad4f5000-0x00000000ad52c000) (0MB)
[    0.000000] efi: mem18: type=7, attr=0xf,
range=[0x00000000ad52c000-0x00000000ad540000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf,
range=[0x00000000ad540000-0x00000000ad561000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf,
range=[0x00000000ad561000-0x00000000ad571000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf,
range=[0x00000000ad571000-0x00000000ad59c000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf,
range=[0x00000000ad59c000-0x00000000ad5b0000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf,
range=[0x00000000ad5b0000-0x00000000ad5d8000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf,
range=[0x00000000ad5d8000-0x00000000ad609000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf,
range=[0x00000000ad609000-0x00000000ad695000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf,
range=[0x00000000ad695000-0x00000000ad69d000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf,
range=[0x00000000ad69d000-0x00000000ad6c0000) (0MB)
[    0.000000] efi: mem28: type=7, attr=0xf,
range=[0x00000000ad6c0000-0x00000000ad6c9000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf,
range=[0x00000000ad6c9000-0x00000000ad6ee000) (0MB)
[    0.000000] efi: mem30: type=7, attr=0xf,
range=[0x00000000ad6ee000-0x00000000ad6fa000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf,
range=[0x00000000ad6fa000-0x00000000ad731000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf,
range=[0x00000000ad731000-0x00000000ad745000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf,
range=[0x00000000ad745000-0x00000000ad769000) (0MB)
[    0.000000] efi: mem34: type=7, attr=0xf,
range=[0x00000000ad769000-0x00000000ad779000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf,
range=[0x00000000ad779000-0x00000000ad79f000) (0MB)
[    0.000000] efi: mem36: type=7, attr=0xf,
range=[0x00000000ad79f000-0x00000000ad7b3000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf,
range=[0x00000000ad7b3000-0x00000000ad7ea000) (0MB)
[    0.000000] efi: mem38: type=7, attr=0xf,
range=[0x00000000ad7ea000-0x00000000ad7ff000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf,
range=[0x00000000ad7ff000-0x00000000ad858000) (0MB)
[    0.000000] efi: mem40: type=7, attr=0xf,
range=[0x00000000ad858000-0x00000000ad862000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf,
range=[0x00000000ad862000-0x00000000ad89c000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf,
range=[0x00000000ad89c000-0x00000000ad8a4000) (0MB)
[    0.000000] efi: mem43: type=4, attr=0xf,
range=[0x00000000ad8a4000-0x00000000ad8c6000) (0MB)
[    0.000000] efi: mem44: type=7, attr=0xf,
range=[0x00000000ad8c6000-0x00000000ad8cf000) (0MB)
[    0.000000] efi: mem45: type=4, attr=0xf,
range=[0x00000000ad8cf000-0x00000000ad8f5000) (0MB)
[    0.000000] efi: mem46: type=7, attr=0xf,
range=[0x00000000ad8f5000-0x00000000ad901000) (0MB)
[    0.000000] efi: mem47: type=4, attr=0xf,
range=[0x00000000ad901000-0x00000000ad96d000) (0MB)
[    0.000000] efi: mem48: type=7, attr=0xf,
range=[0x00000000ad96d000-0x00000000ad97d000) (0MB)
[    0.000000] efi: mem49: type=4, attr=0xf,
range=[0x00000000ad97d000-0x00000000ad9a7000) (0MB)
[    0.000000] efi: mem50: type=7, attr=0xf,
range=[0x00000000ad9a7000-0x00000000ad9ab000) (0MB)
[    0.000000] efi: mem51: type=4, attr=0xf,
range=[0x00000000ad9ab000-0x00000000ad9e4000) (0MB)
[    0.000000] efi: mem52: type=7, attr=0xf,
range=[0x00000000ad9e4000-0x00000000ad9ed000) (0MB)
[    0.000000] efi: mem53: type=4, attr=0xf,
range=[0x00000000ad9ed000-0x00000000ada5f000) (0MB)
[    0.000000] efi: mem54: type=7, attr=0xf,
range=[0x00000000ada5f000-0x00000000ada6a000) (0MB)
[    0.000000] efi: mem55: type=4, attr=0xf,
range=[0x00000000ada6a000-0x00000000adaa3000) (0MB)
[    0.000000] efi: mem56: type=7, attr=0xf,
range=[0x00000000adaa3000-0x00000000adaab000) (0MB)
[    0.000000] efi: mem57: type=4, attr=0xf,
range=[0x00000000adaab000-0x00000000adc5e000) (1MB)
[    0.000000] efi: mem58: type=7, attr=0xf,
range=[0x00000000adc5e000-0x00000000adc5f000) (0MB)
[    0.000000] efi: mem59: type=4, attr=0xf,
range=[0x00000000adc5f000-0x00000000ade7d000) (2MB)
[    0.000000] efi: mem60: type=7, attr=0xf,
range=[0x00000000ade7d000-0x00000000ade82000) (0MB)
[    0.000000] efi: mem61: type=4, attr=0xf,
range=[0x00000000ade82000-0x00000000ae0bc000) (2MB)
[    0.000000] efi: mem62: type=7, attr=0xf,
range=[0x00000000ae0bc000-0x00000000ae0be000) (0MB)
[    0.000000] efi: mem63: type=4, attr=0xf,
range=[0x00000000ae0be000-0x00000000ae133000) (0MB)
[    0.000000] efi: mem64: type=7, attr=0xf,
range=[0x00000000ae133000-0x00000000ae134000) (0MB)
[    0.000000] efi: mem65: type=4, attr=0xf,
range=[0x00000000ae134000-0x00000000ae1c3000) (0MB)
[    0.000000] efi: mem66: type=7, attr=0xf,
range=[0x00000000ae1c3000-0x00000000ae1c4000) (0MB)
[    0.000000] efi: mem67: type=4, attr=0xf,
range=[0x00000000ae1c4000-0x00000000ae1f4000) (0MB)
[    0.000000] efi: mem68: type=7, attr=0xf,
range=[0x00000000ae1f4000-0x00000000ae1f5000) (0MB)
[    0.000000] efi: mem69: type=4, attr=0xf,
range=[0x00000000ae1f5000-0x00000000ae269000) (0MB)
[    0.000000] efi: mem70: type=7, attr=0xf,
range=[0x00000000ae269000-0x00000000ae26d000) (0MB)
[    0.000000] efi: mem71: type=4, attr=0xf,
range=[0x00000000ae26d000-0x00000000ae2cf000) (0MB)
[    0.000000] efi: mem72: type=7, attr=0xf,
range=[0x00000000ae2cf000-0x00000000ae2d1000) (0MB)
[    0.000000] efi: mem73: type=4, attr=0xf,
range=[0x00000000ae2d1000-0x00000000ae36a000) (0MB)
[    0.000000] efi: mem74: type=7, attr=0xf,
range=[0x00000000ae36a000-0x00000000ae36d000) (0MB)
[    0.000000] efi: mem75: type=4, attr=0xf,
range=[0x00000000ae36d000-0x00000000ae41b000) (0MB)
[    0.000000] efi: mem76: type=7, attr=0xf,
range=[0x00000000ae41b000-0x00000000ae41c000) (0MB)
[    0.000000] efi: mem77: type=4, attr=0xf,
range=[0x00000000ae41c000-0x00000000ae41f000) (0MB)
[    0.000000] efi: mem78: type=7, attr=0xf,
range=[0x00000000ae41f000-0x00000000ae422000) (0MB)
[    0.000000] efi: mem79: type=4, attr=0xf,
range=[0x00000000ae422000-0x00000000ae51c000) (0MB)
[    0.000000] efi: mem80: type=7, attr=0xf,
range=[0x00000000ae51c000-0x00000000ae523000) (0MB)
[    0.000000] efi: mem81: type=4, attr=0xf,
range=[0x00000000ae523000-0x00000000ae9c8000) (4MB)
[    0.000000] efi: mem82: type=7, attr=0xf,
range=[0x00000000ae9c8000-0x00000000ae9cb000) (0MB)
[    0.000000] efi: mem83: type=4, attr=0xf,
range=[0x00000000ae9cb000-0x00000000aea27000) (0MB)
[    0.000000] efi: mem84: type=7, attr=0xf,
range=[0x00000000aea27000-0x00000000aea2d000) (0MB)
[    0.000000] efi: mem85: type=4, attr=0xf,
range=[0x00000000aea2d000-0x00000000aea7e000) (0MB)
[    0.000000] efi: mem86: type=7, attr=0xf,
range=[0x00000000aea7e000-0x00000000aea7f000) (0MB)
[    0.000000] efi: mem87: type=4, attr=0xf,
range=[0x00000000aea7f000-0x00000000b9a28000) (175MB)
[    0.000000] efi: mem88: type=7, attr=0xf,
range=[0x00000000b9a28000-0x00000000b9f9d000) (5MB)
[    0.000000] efi: mem89: type=2, attr=0xf,
range=[0x00000000b9f9d000-0x00000000b9fa8000) (0MB)
[    0.000000] efi: mem90: type=3, attr=0xf,
range=[0x00000000b9fa8000-0x00000000ba668000) (6MB)
[    0.000000] efi: mem91: type=0, attr=0xf,
range=[0x00000000ba668000-0x00000000ba6fa000) (0MB)
[    0.000000] efi: mem92: type=0, attr=0xf,
range=[0x00000000ba6fa000-0x00000000ba944000) (2MB)
[    0.000000] efi: mem93: type=9, attr=0xf,
range=[0x00000000ba944000-0x00000000ba94c000) (0MB)
[    0.000000] efi: mem94: type=9, attr=0xf,
range=[0x00000000ba94c000-0x00000000ba954000) (0MB)
[    0.000000] efi: mem95: type=10, attr=0xf,
range=[0x00000000ba954000-0x00000000bae29000) (4MB)
[    0.000000] efi: mem96: type=10, attr=0xf,
range=[0x00000000bae29000-0x00000000bb757000) (9MB)
[    0.000000] efi: mem97: type=6, attr=0x800000000000000f,
range=[0x00000000bb757000-0x00000000bc278000) (11MB)
[    0.000000] efi: mem98: type=6, attr=0x800000000000000f,
range=[0x00000000bc278000-0x00000000bc9ca000) (7MB)
[    0.000000] efi: mem99: type=5, attr=0x800000000000000f,
range=[0x00000000bc9ca000-0x00000000bc9e0000) (0MB)
[    0.000000] efi: mem100: type=5, attr=0x800000000000000f,
range=[0x00000000bc9e0000-0x00000000bca38000) (0MB)
[    0.000000] efi: mem101: type=4, attr=0xf,
range=[0x00000000bca38000-0x00000000bca39000) (0MB)
[    0.000000] efi: mem102: type=10, attr=0xf,
range=[0x00000000bca39000-0x00000000bcc3f000) (2MB)
[    0.000000] efi: mem103: type=4, attr=0xf,
range=[0x00000000bcc3f000-0x00000000bcd8f000) (1MB)
[    0.000000] efi: mem104: type=3, attr=0xf,
range=[0x00000000bcd8f000-0x00000000bd02f000) (2MB)
[    0.000000] efi: mem105: type=4, attr=0xf,
range=[0x00000000bd02f000-0x00000000bd031000) (0MB)
[    0.000000] efi: mem106: type=3, attr=0xf,
range=[0x00000000bd031000-0x00000000bd035000) (0MB)
[    0.000000] efi: mem107: type=4, attr=0xf,
range=[0x00000000bd035000-0x00000000bd039000) (0MB)
[    0.000000] efi: mem108: type=3, attr=0xf,
range=[0x00000000bd039000-0x00000000bd03b000) (0MB)
[    0.000000] efi: mem109: type=4, attr=0xf,
range=[0x00000000bd03b000-0x00000000bd03f000) (0MB)
[    0.000000] efi: mem110: type=3, attr=0xf,
range=[0x00000000bd03f000-0x00000000bd041000) (0MB)
[    0.000000] efi: mem111: type=4, attr=0xf,
range=[0x00000000bd041000-0x00000000bd066000) (0MB)
[    0.000000] efi: mem112: type=3, attr=0xf,
range=[0x00000000bd066000-0x00000000bd083000) (0MB)
[    0.000000] efi: mem113: type=6, attr=0x800000000000000f,
range=[0x00000000bd083000-0x00000000bd7f4000) (7MB)
[    0.000000] efi: mem114: type=4, attr=0xf,
range=[0x00000000bd7f4000-0x00000000bd800000) (0MB)
[    0.000000] efi: mem115: type=7, attr=0xf,
range=[0x0000000100001000-0x0000000440000000) (13311MB)
[    0.000000] efi: mem116: type=11, attr=0x8000000000000001,
range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem117: type=11, attr=0x8000000000000001,
range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem118: type=11, attr=0x8000000000000001,
range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem119: type=11, attr=0x8000000000000001,
range=[0x00000000fec20000-0x00000000fec21000) (0MB)
[    0.000000] efi: mem120: type=11, attr=0x8000000000000001,
range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem121: type=11, attr=0x8000000000000001,
range=[0x00000000fed61000-0x00000000fed71000) (0MB)
[    0.000000] efi: mem122: type=11, attr=0x8000000000000001,
range=[0x00000000fed80000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem123: type=11, attr=0x8000000000000001,
range=[0x00000000fef00000-0x0000000100000000) (17MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./M5A99X
EVO R2.0, BIOS 2501 04/03/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000BD800000 mask FFFFFF800000 uncachable
[    0.000000]   3 base 0000BE000000 mask FFFFFE000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000440000000 aka 17408M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3032MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3040MB, range: 32MB, type UC
[    0.000000] total RAM covered: 3032M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 64M         num_reg: 4     
lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3032MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3040MB, range: 32MB, type UC
[    0.000000] e820: update [mem 0xbd800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbd800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e51000, 0x01e51fff] PGTABLE
[    0.000000] BRK [0x01e52000, 0x01e52fff] PGTABLE
[    0.000000] BRK [0x01e53000, 0x01e53fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xba667fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xba5fffff] page 2M
[    0.000000]  [mem 0xba600000-0xba667fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbca38000-0xbca38fff]
[    0.000000]  [mem 0xbca38000-0xbca38fff] page 4k
[    0.000000] BRK [0x01e54000, 0x01e54fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbcc3f000-0xbd082fff]
[    0.000000]  [mem 0xbcc3f000-0xbcdfffff] page 4k
[    0.000000]  [mem 0xbce00000-0xbcffffff] page 2M
[    0.000000]  [mem 0xbd000000-0xbd082fff] page 4k
[    0.000000] BRK [0x01e55000, 0x01e55fff] PGTABLE
[    0.000000] BRK [0x01e56000, 0x01e56fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbd7f4000-0xbd7fffff]
[    0.000000]  [mem 0xbd7f4000-0xbd7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100001000-0x3ffffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13fffffff] page 2M
[    0.000000]  [mem 0x140000000-0x3ffffffff] page 1G
[    0.000000] ACPI: RSDP 00000000ba94c000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000ba94c078 000064 (v01 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000ba9531f0 00010C (v05 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field
Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1
(20131218/tbfadt-634)
[    0.000000] ACPI: DSDT 00000000ba94c170 007079 (v02 ALASKA    A M I
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bb751f80 000040
[    0.000000] ACPI: APIC 00000000ba953300 00007E (v03 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 00000000ba953380 000044 (v01 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000ba9533c8 00003C (v01 ALASKA    A M I
01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000ba953408 000038 (v01 ALASKA    A M I
01072009 AMI  00000005)
[    0.000000] ACPI: IVRS 00000000ba953d90 0000D8 (v01  AMD     RD890S
00202031 AMD  00000000)
[    0.000000] ACPI: BGRT 00000000ba953498 000038 (v00 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000ba9534d0 0008BC (v01 AMD    POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD ->
[ffff88042f600000-ffff88043f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xba667fff]
[    0.000000]   node   0: [mem 0xbca38000-0xbca38fff]
[    0.000000]   node   0: [mem 0xbcc3f000-0xbd082fff]
[    0.000000]   node   0: [mem 0xbd7f4000-0xbd7fffff]
[    0.000000]   node   0: [mem 0x100001000-0x43fffffff]
[    0.000000] On node 0 totalpages: 4172375
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 26 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11883 pages used for memmap
[    0.000000]   DMA32 zone: 760505 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3407871 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 5, version 33, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 6, version 33, address 0xfec20000, GSI
24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] e820: [mem 0xbd800000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88043fc00000 s79296
r8192 d23104 u524288
[    0.000000] pcpu-alloc: s79296 r8192 d23104 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 4107154
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.14.23
root=/dev/sda2 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.000000] Memory: 16108368K/16689500K available (6169K kernel code,
559K rwdata, 2948K rodata, 852K init, 928K bss, 581132K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3467.771 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using
timer frequency.. 6938.52 BogoMIPS (lpj=11559236)
[    0.000023] pid_max: default: 32768 minimum: 301
[    0.000029] ACPI: Core revision 20131218
[    0.001578] ACPI: All ACPI Tables successfully acquired
[    0.210207] Security Framework initialized
[    0.210219] Mount-cache hash table entries: 32768 (order: 6, 262144
bytes)
[    0.210222] Mountpoint-cache hash table entries: 32768 (order: 6,
262144 bytes)
[    0.210488] Initializing cgroup subsys blkio
[    0.210507] tseg: 00bd800000
[    0.210509] CPU: Physical Processor ID: 0
[    0.210511] CPU: Processor Core ID: 0
[    0.210512] mce: CPU supports 6 MCE banks
[    0.210517] LVT offset 0 assigned for vector 0xf9
[    0.210520] process: using AMD E400 aware idle routine
[    0.210523] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 6
[    0.210591] Freeing SMP alternatives memory: 24K (ffffffff81d62000 -
ffffffff81d68000)
[    0.291799] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.324773] smpboot: CPU0: AMD Phenom(tm) II X4 955 Processor (fam:
10, model: 04, stepping: 02)
[    0.429701] Performance Events: AMD PMU driver.
[    0.429705] ... version:                0
[    0.429707] ... bit width:              48
[    0.429708] ... generic registers:      4
[    0.429709] ... value mask:             0000ffffffffffff
[    0.429711] ... max period:             00007fffffffffff
[    0.429712] ... fixed-purpose events:   0
[    0.429713] ... event mask:             000000000000000f
[    0.429877] MCE: In-kernel MCE decoding enabled.
[    0.429944] x86: Booting SMP configuration:
[    0.429946] .... node  #0, CPUs:      #1
[    0.443071] process: System has AMD C1E enabled
[    0.443086] process: Switch to broadcast mode on CPU1
[    0.443106]  #2
[    0.456231] process: Switch to broadcast mode on CPU2
[    0.456257]  #3
[    0.469366] x86: Booted up 1 node, 4 CPUs
[    0.469370] smpboot: Total of 4 processors activated (27753.09 BogoMIPS)
[    0.469378] process: Switch to broadcast mode on CPU3
[    0.473310] process: Switch to broadcast mode on CPU0
[    0.473460] devtmpfs: initialized
[    0.473600] PM: Registering ACPI NVS region [mem
0xba954000-0xbb756fff] (14692352 bytes)
[    0.473721] PM: Registering ACPI NVS region [mem
0xbca39000-0xbcc3efff] (2121728 bytes)
[    0.473843] kworker/u8:0 (26) used greatest stack depth: 6088 bytes left
[    0.473957] xor: measuring software checksum speed
[    0.506377]    prefetch64-sse: 14073.600 MB/sec
[    0.539677]    generic_sse: 13354.800 MB/sec
[    0.539679] xor: using function: prefetch64-sse (14073.600 MB/sec)
[    0.539684] atomic64 test passed for x86-64 platform with CX8 and
with SSE
[    0.539698] RTC time: 16:42:39, date: 11/11/14
[    0.539732] NET: Registered protocol family 16
[    0.540053] cpuidle: using governor ladder
[    0.540055] cpuidle: using governor menu
[    0.540061] node 0 link 0: io port [b000, ffff]
[    0.540063] TOM: 00000000c0000000 aka 3072M
[    0.540065] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.540067] node 0 link 0: mmio [c0000000, fef0ffff] ==> [c0000000,
dfffffff] and [f0000000, fef0ffff]
[    0.540071] TOM2: 0000000440000000 aka 17408M
[    0.540073] bus: [bus 00-1f] on node 0 link 0
[    0.540074] bus: 00 [io  0x0000-0xffff]
[    0.540075] bus: 00 [mem 0xc0000000-0xdfffffff]
[    0.540076] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.540077] bus: 00 [mem 0x440000000-0xfcffffffff]
[    0.540113] ACPI: bus type PCI registered
[    0.540189] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.540192] PCI: not using MMCONFIG
[    0.540194] PCI: Using configuration type 1 for base access
[    0.540195] PCI: Using configuration type 1 for extended access
[    0.544904] bio: create slab <bio-0> at 0
[    0.599624] raid6: sse2x1    4312 MB/s
[    0.656230] raid6: sse2x2    7048 MB/s
[    0.712842] raid6: sse2x4    8066 MB/s
[    0.712844] raid6: using algorithm sse2x4 (8066 MB/s)
[    0.712846] raid6: using intx1 recovery algorithm
[    0.712920] ACPI: Added _OSI(Module Device)
[    0.712922] ACPI: Added _OSI(Processor Device)
[    0.712923] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.712925] ACPI: Added _OSI(Processor Aggregator Device)
[    0.713969] ACPI: Executed 2 blocks of module-level executable AML code
[    0.726538] ACPI: Interpreter enabled
[    0.726545] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20131218/hwxface-580)
[    0.726550] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20131218/hwxface-580)
[    0.726558] ACPI: (supports S0 S3 S5)
[    0.726560] ACPI: Using IOAPIC for interrupt routing
[    0.726654] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.726679] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in
ACPI motherboard resources
[    0.726962] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.727036] ACPI: No dock devices found.
[    0.902312] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.902319] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.902323] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.902517] PCI host bridge to bus 0000:00
[    0.902520] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.902522] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.902524] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.902526] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.902528] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.902531] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.902533] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff]
[    0.902535] pci_bus 0000:00: root bus resource [mem
0xc0000000-0xffffffff]
[    0.902546] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.902667] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    0.902768] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.902802] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.902834] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.902880] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.902912] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.902942] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.902987] pci 0000:00:05.0: [1002:5a19] type 01 class 0x060400
[    0.903019] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.903050] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.903095] pci 0000:00:06.0: [1002:5a1a] type 01 class 0x060400
[    0.903127] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.903157] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.903203] pci 0000:00:07.0: [1002:5a1b] type 01 class 0x060400
[    0.903235] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.903265] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.903323] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.903337] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    0.903345] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    0.903352] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    0.903359] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    0.903366] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    0.903374] pci 0000:00:11.0: reg 0x24: [mem 0xfea0b000-0xfea0b3ff]
[    0.903473] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.903483] pci 0000:00:12.0: reg 0x10: [mem 0xfea0a000-0xfea0afff]
[    0.903551] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.903600] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.903614] pci 0000:00:12.2: reg 0x10: [mem 0xfea09000-0xfea090ff]
[    0.903677] pci 0000:00:12.2: supports D1 D2
[    0.903678] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.903710] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.903759] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.903769] pci 0000:00:13.0: reg 0x10: [mem 0xfea08000-0xfea08fff]
[    0.903835] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.903885] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.903900] pci 0000:00:13.2: reg 0x10: [mem 0xfea07000-0xfea070ff]
[    0.903962] pci 0000:00:13.2: supports D1 D2
[    0.903963] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.904024] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.904073] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.904187] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.904203] pci 0000:00:14.2: reg 0x10: [mem 0xfea00000-0xfea03fff 64bit]
[    0.904253] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.904282] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.904328] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.904441] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.904490] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.904537] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.904548] pci 0000:00:14.5: reg 0x10: [mem 0xfea06000-0xfea06fff]
[    0.904615] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.904664] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.904721] pci 0000:00:15.0: supports D1 D2
[    0.904753] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.904800] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.904810] pci 0000:00:16.0: reg 0x10: [mem 0xfea05000-0xfea05fff]
[    0.904876] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.904929] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.904943] pci 0000:00:16.2: reg 0x10: [mem 0xfea04000-0xfea040ff]
[    0.905005] pci 0000:00:16.2: supports D1 D2
[    0.905006] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.905037] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.905085] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.905157] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.905225] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.905293] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.905362] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.905492] pci 0000:01:00.0: [1002:68b8] type 00 class 0x030000
[    0.905503] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.905512] pci 0000:01:00.0: reg 0x18: [mem 0xfe920000-0xfe93ffff 64bit]
[    0.905518] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.905529] pci 0000:01:00.0: reg 0x30: [mem 0xfe900000-0xfe91ffff pref]
[    0.905559] pci 0000:01:00.0: supports D1 D2
[    0.905617] pci 0000:01:00.1: [1002:aa58] type 00 class 0x040300
[    0.905627] pci 0000:01:00.1: reg 0x10: [mem 0xfe940000-0xfe943fff 64bit]
[    0.905673] pci 0000:01:00.1: supports D1 D2
[    0.909414] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.909418] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.909421] pci 0000:00:02.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.909423] pci 0000:00:02.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.909487] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.909499] pci 0000:02:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.909518] pci 0000:02:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff
64bit pref]
[    0.909530] pci 0000:02:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff
64bit pref]
[    0.909590] pci 0000:02:00.0: supports D1 D2
[    0.909591] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.916073] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.916077] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.916081] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.916144] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.916161] pci 0000:03:00.0: reg 0x10: [mem 0xfe800000-0xfe807fff 64bit]
[    0.916250] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.922732] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.922737] pci 0000:00:05.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.922800] pci 0000:04:00.0: [1b21:0612] type 00 class 0x010601
[    0.922810] pci 0000:04:00.0: reg 0x10: [io  0xc050-0xc057]
[    0.922817] pci 0000:04:00.0: reg 0x14: [io  0xc040-0xc043]
[    0.922825] pci 0000:04:00.0: reg 0x18: [io  0xc030-0xc037]
[    0.922832] pci 0000:04:00.0: reg 0x1c: [io  0xc020-0xc023]
[    0.922839] pci 0000:04:00.0: reg 0x20: [io  0xc000-0xc01f]
[    0.922847] pci 0000:04:00.0: reg 0x24: [mem 0xfe700000-0xfe7001ff]
[    0.929392] pci 0000:00:06.0: PCI bridge to [bus 04]
[    0.929396] pci 0000:00:06.0:   bridge window [io  0xc000-0xcfff]
[    0.929398] pci 0000:00:06.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.929465] pci 0000:05:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.929481] pci 0000:05:00.0: reg 0x10: [mem 0xfe600000-0xfe607fff 64bit]
[    0.929570] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.936052] pci 0000:00:07.0: PCI bridge to [bus 05]
[    0.936057] pci 0000:00:07.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.936112] pci 0000:06:05.0: [1102:0008] type 00 class 0x040100
[    0.936127] pci 0000:06:05.0: reg 0x10: [io  0xb000-0xb03f]
[    0.936190] pci 0000:06:05.0: supports D1 D2
[    0.936262] pci 0000:00:14.4: PCI bridge to [bus 06] (subtractive decode)
[    0.936266] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.936271] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af]
(subtractive decode)
[    0.936272] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7]
(subtractive decode)
[    0.936273] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df]
(subtractive decode)
[    0.936275] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.936276] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.936277] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
[    0.936279] pci 0000:00:14.4:   bridge window [mem
0xc0000000-0xffffffff] (subtractive decode)
[    0.936358] pci 0000:07:00.0: [14f1:8852] type 00 class 0x040000
[    0.936380] pci 0000:07:00.0: reg 0x10: [mem 0xfe400000-0xfe5fffff 64bit]
[    0.936514] pci 0000:07:00.0: supports D1 D2
[    0.936516] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot
[    0.936582] pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device. 
You can enable it with 'pcie_aspm=force'
[    0.936592] pci 0000:00:15.0: PCI bridge to [bus 07]
[    0.936598] pci 0000:00:15.0:   bridge window [mem 0xfe400000-0xfe5fffff]
[    0.936628] pci_bus 0000:00: on NUMA node 0
[    0.936750] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.936794] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.936838] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.936881] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 10 11 14 15) *0
[    0.936915] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.936966] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.936993] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.937020] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.937109] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.937125] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    0.937315] SCSI subsystem initialized
[    0.937383] libata version 3.00 loaded.
[    0.937387] ACPI: bus type USB registered
[    0.937443] usbcore: registered new interface driver usbfs
[    0.937469] usbcore: registered new interface driver hub
[    0.937508] usbcore: registered new device driver usb
[    0.937743] PCI: Using ACPI for IRQ routing
[    0.944276] PCI: pci_cache_line_size set to 64 bytes
[    0.944334] e820: reserve RAM buffer [mem 0xba668000-0xbbffffff]
[    0.944336] e820: reserve RAM buffer [mem 0xbca39000-0xbfffffff]
[    0.944337] e820: reserve RAM buffer [mem 0xbd083000-0xbfffffff]
[    0.944338] e820: reserve RAM buffer [mem 0xbd800000-0xbfffffff]
[    0.944517] NetLabel: Initializing
[    0.944519] NetLabel:  domain hash size = 128
[    0.944521] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.944530] NetLabel:  unlabeled traffic allowed by default
[    0.944544] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.944547] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.946594] Switched to clocksource hpet
[    0.948258] pnp: PnP ACPI init
[    0.948268] ACPI: bus type PNP registered
[    0.948363] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.948366] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.948559] system 00:01: [io  0x040b] has been reserved
[    0.948562] system 00:01: [io  0x04d6] has been reserved
[    0.948564] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.948566] system 00:01: [io  0x0c14] has been reserved
[    0.948568] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.948570] system 00:01: [io  0x0c52] has been reserved
[    0.948572] system 00:01: [io  0x0c6c] has been reserved
[    0.948575] system 00:01: [io  0x0c6f] has been reserved
[    0.948577] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.948579] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.948582] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.948584] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.948586] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.948588] system 00:01: [io  0x0800-0x089f] could not be reserved
[    0.948590] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.948592] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.948594] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.948597] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.948599] system 00:01: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.948602] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.948604] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.948606] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.948609] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.948611] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.948613] system 00:01: [mem 0xff800000-0xffffffff] has been reserved
[    0.948616] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.948727] system 00:02: [io  0x0290-0x02af] has been reserved
[    0.948730] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.948739] pnp 00:03: [dma 4]
[    0.948775] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.948823] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.948862] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.948923] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.948926] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.948969] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.949018] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.949075] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b
(active)
[    0.949178] pnp 00:0a: [dma 0 disabled]
[    0.949236] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.949380] system 00:0b: [mem 0xfeb20000-0xfeb23fff] could not be
reserved
[    0.949383] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.949515] system 00:0c: [mem 0xfec20000-0xfec200ff] could not be
reserved
[    0.949518] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.949658] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.949662] pnp: PnP ACPI: found 14 devices
[    0.949664] ACPI: bus type PNP unregistered
[    0.959027] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.959031] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.959035] pci 0000:00:02.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.959038] pci 0000:00:02.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.959042] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.959045] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.959049] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.959053] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.959056] pci 0000:00:05.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.959060] pci 0000:00:06.0: PCI bridge to [bus 04]
[    0.959063] pci 0000:00:06.0:   bridge window [io  0xc000-0xcfff]
[    0.959066] pci 0000:00:06.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.959070] pci 0000:00:07.0: PCI bridge to [bus 05]
[    0.959073] pci 0000:00:07.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.959077] pci 0000:00:14.4: PCI bridge to [bus 06]
[    0.959080] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.959090] pci 0000:00:15.0: PCI bridge to [bus 07]
[    0.959094] pci 0000:00:15.0:   bridge window [mem 0xfe400000-0xfe5fffff]
[    0.959100] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.959102] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.959103] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.959104] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.959106] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.959107] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.959108] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.959110] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.959111] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.959112] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.959114] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.959115] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd00fffff
64bit pref]
[    0.959116] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.959118] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.959119] pci_bus 0000:04: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.959121] pci_bus 0000:05: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.959122] pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
[    0.959123] pci_bus 0000:06: resource 4 [io  0x0000-0x03af]
[    0.959124] pci_bus 0000:06: resource 5 [io  0x03e0-0x0cf7]
[    0.959126] pci_bus 0000:06: resource 6 [io  0x03b0-0x03df]
[    0.959127] pci_bus 0000:06: resource 7 [io  0x0d00-0xffff]
[    0.959128] pci_bus 0000:06: resource 8 [mem 0x000a0000-0x000bffff]
[    0.959129] pci_bus 0000:06: resource 9 [mem 0x000c0000-0x000dffff]
[    0.959131] pci_bus 0000:06: resource 10 [mem 0xc0000000-0xffffffff]
[    0.959132] pci_bus 0000:07: resource 1 [mem 0xfe400000-0xfe5fffff]
[    0.959156] NET: Registered protocol family 2
[    0.959291] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.959559] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.959834] TCP: Hash tables configured (established 131072 bind 65536)
[    0.959880] TCP: reno registered
[    0.959885] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.959985] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.960100] NET: Registered protocol family 1
[    1.229883] pci 0000:01:00.0: Boot video device
[    1.230068] PCI: CLS 64 bytes, default 64
[    1.230444] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    1.230446] AMD-Vi: Interrupt remapping enabled
[    1.230457] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    1.238699] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.314780] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.314783] software IO TLB [mem 0xa93d0000-0xad3d0000] (64MB) mapped
at [ffff8800a93d0000-ffff8800ad3cffff]
[    1.314935] LVT offset 1 assigned for vector 0x400
[    1.314940] IBS: LVT offset 1 assigned
[    1.314961] perf: AMD IBS detected (0x0000001f)
[    1.315565] Scanning for low memory corruption every 60 seconds
[    1.316274] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.316713] bounce pool size: 64 pages
[    1.316718] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.320553] msgmni has been set to 31877
[    1.321152] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    1.321155] io scheduler noop registered (default)
[    1.321157] io scheduler deadline registered
[    1.321212] io scheduler cfq registered
[    1.321907] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.321912] ACPI: Power Button [PWRB]
[    1.321975] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.321978] ACPI: Power Button [PWRF]
[    1.322097] ACPI: processor limited to max C-state 1
[    1.322626] GHES: HEST is not enabled!
[    1.322938] Non-volatile memory driver v1.3
[    1.322941] Linux agpgart interface v0.103
[    1.323331] [drm] Initialized drm 1.1.0 20060810
[    1.323373] [drm] radeon kernel modesetting enabled.
[    1.323617] [drm] initializing kernel modesetting (JUNIPER
0x1002:0x68B8 0x1682:0x2991).
[    1.323624] [drm] register mmio base: 0xFE920000
[    1.323625] [drm] register mmio size: 131072
[    1.323669] ATOM BIOS: JUNIPER
[    1.323725] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[    1.323729] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 -
0x000000007FFFFFFF
[    1.323731] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.323733] [drm] RAM width 128bits DDR
[    1.323780] [TTM] Zone  kernel: Available graphics memory: 8160680 kiB
[    1.323781] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.323783] [TTM] Initializing pool allocator
[    1.323789] [TTM] Initializing DMA pool allocator
[    1.323807] [drm] radeon: 1024M of VRAM memory ready
[    1.323809] [drm] radeon: 1024M of GTT memory ready.
[    1.323816] [drm] Loading JUNIPER Microcode
[    1.323821] [drm] Internal thermal controller with fan control
[    1.340073] [drm] radeon: dpm initialized
[    1.340087] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    1.341491] [drm] enabling PCIE gen 2 link speeds, disable with
radeon.pcie_gen2=0
[    1.354523] [drm] PCIE GART of 1024M enabled (table at
0x000000000025D000).
[    1.354608] radeon 0000:01:00.0: WB enabled
[    1.354611] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr
0x0000000040000c00 and cpu addr 0xffff88042c634c00
[    1.354614] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr
0x0000000040000c0c and cpu addr 0xffff88042c634c0c
[    1.355375] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr
0x000000000005c418 and cpu addr 0xffffc9001019c418
[    1.355378] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.355380] [drm] Driver supports precise vblank timestamp query.
[    1.355403] radeon 0000:01:00.0: irq 73 for MSI/MSI-X
[    1.355411] radeon 0000:01:00.0: radeon: using MSI.
[    1.355430] [drm] radeon: irq initialized.
[    1.371934] [drm] ring test on 0 succeeded in 1 usecs
[    1.371942] [drm] ring test on 3 succeeded in 1 usecs
[    1.578884] [drm] ring test on 5 succeeded in 1 usecs
[    1.578888] [drm] UVD initialized successfully.
[    1.579242] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.579266] [drm] ib test on ring 3 succeeded in 0 usecs
[    1.750620] [drm] ib test on ring 5 succeeded
[    1.751757] [drm] Radeon Display Connectors
[    1.751759] [drm] Connector 0:
[    1.751761] [drm]   DP-1
[    1.751762] [drm]   HPD4
[    1.751764] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[    1.751765] [drm]   Encoders:
[    1.751767] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.751768] [drm] Connector 1:
[    1.751769] [drm]   HDMI-A-1
[    1.751770] [drm]   HPD5
[    1.751772] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    1.751773] [drm]   Encoders:
[    1.751774] [drm]     DFP2: INTERNAL_UNIPHY2
[    1.751776] [drm] Connector 2:
[    1.751777] [drm]   DVI-I-1
[    1.751778] [drm]   HPD1
[    1.751779] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
0x646c 0x646c
[    1.751781] [drm]   Encoders:
[    1.751782] [drm]     DFP3: INTERNAL_UNIPHY1
[    1.751784] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    1.751785] [drm] Connector 3:
[    1.751786] [drm]   DVI-I-2
[    1.751787] [drm]   HPD6
[    1.751788] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[    1.751790] [drm]   Encoders:
[    1.751792] [drm]     DFP4: INTERNAL_UNIPHY
[    1.751793] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.853279] [drm] fb mappable at 0xC045E000
[    1.853281] [drm] vram apper at 0xC0000000
[    1.853282] [drm] size 9216000
[    1.853283] [drm] fb depth is 24
[    1.853284] [drm]    pitch is 7680
[    1.853400] fbcon: radeondrmfb (fb0) is primary device
[    1.883109] Console: switching to colour frame buffer device 240x75
[    1.889261] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    1.889293] radeon 0000:01:00.0: registered panic notifier
[    1.893442] [drm] Initialized radeon 2.37.0 20080528 for 0000:01:00.0
on minor 0
[    1.893831] ahci 0000:00:11.0: version 3.0
[    1.893983] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 5 ports 6 Gbps
0x1f impl SATA mode
[    1.894025] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo
pmp pio slum part
[    1.895178] scsi0 : ahci
[    1.895358] scsi1 : ahci
[    1.895523] scsi2 : ahci
[    1.895703] scsi3 : ahci
[    1.895899] scsi4 : ahci
[    1.896010] ata1: SATA max UDMA/133 abar m1024@0xfea0b000 port
0xfea0b100 irq 19
[    1.896048] ata2: SATA max UDMA/133 abar m1024@0xfea0b000 port
0xfea0b180 irq 19
[    1.896085] ata3: SATA max UDMA/133 abar m1024@0xfea0b000 port
0xfea0b200 irq 19
[    1.896122] ata4: SATA max UDMA/133 abar m1024@0xfea0b000 port
0xfea0b280 irq 19
[    1.896159] ata5: SATA max UDMA/133 abar m1024@0xfea0b000 port
0xfea0b300 irq 19
[    1.896294] ahci 0000:04:00.0: irq 74 for MSI/MSI-X
[    1.896311] ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
[    1.896371] ahci 0000:04:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps
0x3 impl SATA mode
[    1.896411] ahci 0000:04:00.0: flags: 64bit ncq sntf stag led clo pmp
pio slum part ccc sxs
[    1.896994] scsi5 : ahci
[    1.897188] scsi6 : ahci
[    1.897314] ata6: SATA max UDMA/133 abar m512@0xfe700000 port
0xfe700100 irq 74
[    1.897352] ata7: SATA max UDMA/133 abar m512@0xfe700000 port
0xfe700180 irq 74
[    1.897699] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.897735] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[    1.897941] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.898142] mousedev: PS/2 mouse device common for all mice
[    1.898415] rtc_cmos 00:04: RTC can wake from S4
[    1.898553] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.898597] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    1.898666] md: raid1 personality registered for level 1
[    1.898773] md: raid6 personality registered for level 6
[    1.898798] md: raid5 personality registered for level 5
[    1.898820] md: raid4 personality registered for level 4
[    1.898844] EFI Variables Facility v0.08 2004-May-17
[    1.908628] pstore: Registered efi as persistent store backend
[    1.908732] hidraw: raw HID events driver (C) Jiri Kosina
[    1.908886] usbcore: registered new interface driver usbhid
[    1.908909] usbhid: USB HID core driver
[    1.909072] Netfilter messages via NETLINK v0.30.
[    1.909106] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.909251] ctnetlink v0.93: registering with nfnetlink.
[    1.909536] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.909591] TCP: cubic registered
[    1.909606] Initializing XFRM netlink socket
[    1.909876] NET: Registered protocol family 10
[    1.910063] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.910335] sit: IPv6 over IPv4 tunneling driver
[    1.910582] NET: Registered protocol family 17
[    1.911142] registered taskstats version 1
[    1.912860]   Magic number: 6:239:742
[    1.914157] ata_device dev5.0: hash matches
[    1.915482]  dev5.0: hash matches
[    1.916910] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.922056] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    2.215531] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.215536] ata6: SATA link down (SStatus 0 SControl 300)
[    2.224554] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.229101] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.230876] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.232599] ata4.00: ATA-8: Hitachi HDS5C3020ALA632, ML6OAA10, max
UDMA/133
[    2.234353] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.236125] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.237980] ata5.00: supports DRM functions and may not be fully
accessible
[    2.240145] ata3.00: ATA-8: Hitachi HDS5C3020ALA632, ML6OAA10, max
UDMA/133
[    2.241329] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.242527] ata1.00: ATA-7: SAMSUNG MMCRE64G5MXP-0VB, VBM1901Q, max
UDMA/100
[    2.244005] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.245223] ata5.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.245230] ata5.00: ATA-9: Samsung SSD 840 EVO 250GB, EXT0BB6Q, max
UDMA/133
[    2.246491] ata5.00: 488397168 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    2.248004] ata2.00: ATA-8: Hitachi HDS5C3020ALA632, ML6OAA10, max
UDMA/133
[    2.249880] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.251799] ata4.00: configured for UDMA/133
[    2.253119] ata5.00: supports DRM functions and may not be fully
accessible
[    2.254478] ata5.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.254480] ata5.00: configured for UDMA/133
[    2.256069] ata3.00: configured for UDMA/133
[    2.257345] ata1.00: configured for UDMA/100
[    2.259064] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MMCRE64G
VBM1 PQ: 0 ANSI: 5
[    2.260350] ata2.00: configured for UDMA/133
[    2.260619] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks:
(64.0 GB/59.6 GiB)
[    2.260721] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.260737] sd 0:0:0:0: [sda] Write Protect is off
[    2.260738] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.260769] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.262777]  sda: sda1 sda2
[    2.263382] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.271853] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDS5C302
ML6O PQ: 0 ANSI: 5
[    2.273936] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    2.274114] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.284627] sd 1:0:0:0: [sdb] Write Protect is off
[    2.284683] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS5C302
ML6O PQ: 0 ANSI: 5
[    2.285045] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    2.285193] sd 2:0:0:0: [sdc] Write Protect is off
[    2.285194] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.285203] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.285259] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.285690] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDS5C302
ML6O PQ: 0 ANSI: 5
[    2.286186] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    2.286340] sd 3:0:0:0: [sdd] Write Protect is off
[    2.286344] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.286422] sd 3:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.286428] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    2.286815] scsi 4:0:0:0: Direct-Access     ATA      Samsung SSD 840 
EXT0 PQ: 0 ANSI: 5
[    2.287331] sd 4:0:0:0: [sde] 488397168 512-byte logical blocks: (250
GB/232 GiB)
[    2.287549] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    2.287555] sd 4:0:0:0: [sde] Write Protect is off
[    2.287559] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.287677] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.325843] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.325861] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.328757] tsc: Refined TSC clocksource calibration: 3467.756 MHz
[    2.349477]  sdd: sdd1 sdd9
[    2.355648]  sdc: sdc1 sdc9
[    2.355970] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.360761] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.389639]  sdb: sdb1 sdb9
[    2.395865] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.538859]  sde: sde1
[    2.545008] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.641768] ata7: SATA link down (SStatus 0 SControl 300)
[    2.647423] md: Waiting for all devices to be available before autodetect
[    2.653040] md: If you don't use raid, use raid=noautodetect
[    2.660254] md: Autodetecting RAID arrays.
[    2.662859] md: Scanned 0 and added 0 devices.
[    2.665440] md: autorun ...
[    2.668002] md: ... autorun DONE.
[    2.671109] EXT2-fs (sda2): error: couldn't mount because of
unsupported optional features (244)
[    2.679064] EXT4-fs (sda2): INFO: recovery required on readonly
filesystem
[    2.681291] EXT4-fs (sda2): write access will be enabled during recovery
[    2.710993] EXT4-fs (sda2): recovery complete
[    2.718284] EXT4-fs (sda2): mounted filesystem with ordered data
mode. Opts: (null)
[    2.720498] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    2.727043] devtmpfs: mounted
[    2.730693] Freeing unused kernel memory: 852K (ffffffff81c8d000 -
ffffffff81d62000)
[    2.732917] Write protecting the kernel read-only data: 12288k
[    2.739216] Freeing unused kernel memory: 2012K (ffff880001609000 -
ffff880001800000)
[    2.742844] Freeing unused kernel memory: 1148K (ffff880001ae1000 -
ffff880001c00000)
[    2.922887] setfont (938) used greatest stack depth: 5416 bytes left
[    2.958306] init-early.sh (937) used greatest stack depth: 4904 bytes
left
[    3.311028] random: nonblocking pool is initialized
[    3.331209] Switched to clocksource tsc
[    3.490020] systemd-udevd[1119]: starting version 216
[    3.627844] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.628735] ehci-pci: EHCI PCI platform driver
[    3.628846] QUIRK: Enable AMD PLL fix
[    3.628873] ehci-pci 0000:00:12.2: EHCI Host Controller
[    3.628952] ehci-pci 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    3.628961] ehci-pci 0000:00:12.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.628973] ehci-pci 0000:00:12.2: debug port 1
[    3.629014] ehci-pci 0000:00:12.2: irq 17, io mem 0xfea09000
[    3.633810] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.637280] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.637406] hub 1-0:1.0: USB hub found
[    3.637412] hub 1-0:1.0: 5 ports detected
[    3.637509] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    3.637546] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
bus number 2
[    3.638225] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.638235] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    3.638448] r8169 0000:02:00.0: irq 75 for MSI/MSI-X
[    3.638601] r8169 0000:02:00.0 eth0: RTL8168f/8111f at
0xffffc9000007e000, 60:a4:4c:61:17:68, XID 08000800 IRQ 75
[    3.638603] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    3.655334] Linux video capture interface: v2.00
[    3.674660] snd_emu10k1 0000:06:05.0: enabling device (0000 -> 0001)
[    3.680938] Audigy2 value: Special config.
[    3.695282] cx23885 driver version 0.0.3 loaded
[    3.695394] cx23885 0000:07:00.0: enabling device (0000 -> 0002)
[    3.695546] cx23885[0]: Your board isn't known (yet) to the driver.
cx23885[0]: Try to pick one of the existing card configs via
cx23885[0]: card=<n> insmod option.  Updating to the latest
cx23885[0]: version might help as well.
[    3.695554] cx23885[0]: Here is a list of valid choices for the
card=<n> insmod option:
[    3.695558] cx23885[0]:    card=0 -> UNKNOWN/GENERIC
[    3.695561] cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
[    3.695564] cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
[    3.695567] cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
[    3.695570] cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
[    3.695574] cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
[    3.695577] cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
[    3.695580] cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
[    3.695583] cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
[    3.695586] cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
[    3.695589] cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
[    3.695593] cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
[    3.695596] cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
[    3.695599] cx23885[0]:    card=13 -> Compro VideoMate E650F
[    3.695602] cx23885[0]:    card=14 -> TurboSight TBS 6920
[    3.695605] cx23885[0]:    card=15 -> TeVii S470
[    3.695608] cx23885[0]:    card=16 -> DVBWorld DVB-S2 2005
[    3.695611] cx23885[0]:    card=17 -> NetUP Dual DVB-S2 CI
[    3.695614] cx23885[0]:    card=18 -> Hauppauge WinTV-HVR1270
[    3.695617] cx23885[0]:    card=19 -> Hauppauge WinTV-HVR1275
[    3.695621] cx23885[0]:    card=20 -> Hauppauge WinTV-HVR1255
[    3.695624] cx23885[0]:    card=21 -> Hauppauge WinTV-HVR1210
[    3.695627] cx23885[0]:    card=22 -> Mygica X8506 DMB-TH
[    3.695630] cx23885[0]:    card=23 -> Magic-Pro ProHDTV Extreme 2
[    3.695633] cx23885[0]:    card=24 -> Hauppauge WinTV-HVR1850
[    3.695636] cx23885[0]:    card=25 -> Compro VideoMate E800
[    3.695639] cx23885[0]:    card=26 -> Hauppauge WinTV-HVR1290
[    3.695642] cx23885[0]:    card=27 -> Mygica X8558 PRO DMB-TH
[    3.695645] cx23885[0]:    card=28 -> LEADTEK WinFast PxTV1200
[    3.695648] cx23885[0]:    card=29 -> GoTView X5 3D Hybrid
[    3.695652] cx23885[0]:    card=30 -> NetUP Dual DVB-T/C-CI RF
[    3.695655] cx23885[0]:    card=31 -> Leadtek Winfast PxDVR3200 H XC4000
[    3.695658] cx23885[0]:    card=32 -> MPX-885
[    3.695661] cx23885[0]:    card=33 -> Mygica X8502/X8507 ISDB-T
[    3.695664] cx23885[0]:    card=34 -> TerraTec Cinergy T PCIe Dual
[    3.695667] cx23885[0]:    card=35 -> TeVii S471
[    3.695670] cx23885[0]:    card=36 -> Hauppauge WinTV-HVR1255
[    3.695673] cx23885[0]:    card=37 -> Prof Revolution DVB-S2 8000
[    3.695676] cx23885[0]:    card=38 -> Hauppauge WinTV-HVR4400
[    3.695680] cx23885[0]:    card=39 -> AVerTV Hybrid Express Slim HC81R
[    3.695683] cx23885[0]:    card=40 -> TurboSight TBS 6981
[    3.695686] cx23885[0]:    card=41 -> TurboSight TBS 6980
[    3.695689] cx23885[0]:    card=42 -> Leadtek Winfast PxPVR2200
[    3.695721] CORE cx23885[0]: subsystem: 4254:0952, board:
UNKNOWN/GENERIC [card=0,autodetected]
[    3.697807] xhci_hcd 0000:03:00.0: irq 76 for MSI/MSI-X
[    3.697867] xhci_hcd 0000:03:00.0: irq 77 for MSI/MSI-X
[    3.697928] xhci_hcd 0000:03:00.0: irq 78 for MSI/MSI-X
[    3.697992] xhci_hcd 0000:03:00.0: irq 79 for MSI/MSI-X
[    3.698054] xhci_hcd 0000:03:00.0: irq 80 for MSI/MSI-X
[    3.698639] hub 2-0:1.0: USB hub found
[    3.698730] hub 2-0:1.0: 2 ports detected
[    3.698949] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    3.698960] ehci-pci 0000:00:13.2: EHCI Host Controller
[    3.699014] ehci-pci 0000:00:13.2: new USB bus registered, assigned
bus number 4
[    3.699018] ehci-pci 0000:00:13.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.699028] ehci-pci 0000:00:13.2: debug port 1
[    3.699058] ehci-pci 0000:00:13.2: irq 21, io mem 0xfea07000
[    3.699076] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
bus number 3
[    3.699189] hub 3-0:1.0: USB hub found
[    3.699195] hub 3-0:1.0: 2 ports detected
[    3.707224] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.707359] hub 4-0:1.0: USB hub found
[    3.707365] hub 4-0:1.0: 5 ports detected
[    3.707483] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    3.707595] xhci_hcd 0000:05:00.0: new USB bus registered, assigned
bus number 5
[    3.766999] xhci_hcd 0000:05:00.0: irq 81 for MSI/MSI-X
[    3.767024] xhci_hcd 0000:05:00.0: irq 82 for MSI/MSI-X
[    3.767044] xhci_hcd 0000:05:00.0: irq 83 for MSI/MSI-X
[    3.767064] xhci_hcd 0000:05:00.0: irq 84 for MSI/MSI-X
[    3.767083] xhci_hcd 0000:05:00.0: irq 85 for MSI/MSI-X
[    3.767545] hub 5-0:1.0: USB hub found
[    3.767564] hub 5-0:1.0: 2 ports detected
[    3.767766] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    3.767775] ehci-pci 0000:00:16.2: EHCI Host Controller
[    3.767849] ehci-pci 0000:00:16.2: new USB bus registered, assigned
bus number 7
[    3.767858] ehci-pci 0000:00:16.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.767875] ehci-pci 0000:00:16.2: debug port 1
[    3.767936] ehci-pci 0000:00:16.2: irq 23, io mem 0xfea04000
[    3.767985] xhci_hcd 0000:05:00.0: new USB bus registered, assigned
bus number 6
[    3.768278] hub 6-0:1.0: USB hub found
[    3.768294] hub 6-0:1.0: 2 ports detected
[    3.777149] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    3.777301] hub 7-0:1.0: USB hub found
[    3.777424] EDAC MC: Ver: 3.0.0
[    3.777542] hub 7-0:1.0: 4 ports detected
[    3.777686] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
revision 0
[    3.777726] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller
at 0xb20
[    3.778602] AMD64 EDAC driver v3.4.0
[    3.778622] EDAC amd64: DRAM ECC enabled.
[    3.778629] EDAC amd64: F10h detected (node 0).
[    3.778645] EDAC MC: DCT0 chip selects:
[    3.778646] EDAC amd64: MC: 0:     0MB 1:     0MB
[    3.778648] EDAC amd64: MC: 2:  4096MB 3:  4096MB
[    3.778649] EDAC amd64: MC: 4:     0MB 5:     0MB
[    3.778650] EDAC amd64: MC: 6:     0MB 7:     0MB
[    3.778651] EDAC MC: DCT1 chip selects:
[    3.778652] EDAC amd64: MC: 0:     0MB 1:     0MB
[    3.778653] EDAC amd64: MC: 2:  4096MB 3:  4096MB
[    3.778654] EDAC amd64: MC: 4:     0MB 5:     0MB
[    3.778655] EDAC amd64: MC: 6:     0MB 7:     0MB
[    3.778656] EDAC amd64: using x4 syndromes.
[    3.778657] EDAC amd64: MCT channel count: 2
[    3.778674] EDAC amd64: CS2: Unbuffered DDR3 RAM
[    3.778675] EDAC amd64: CS3: Unbuffered DDR3 RAM
[    3.778686] ohci-pci: OHCI PCI platform driver
[    3.778797] EDAC MC0: Giving out device to module amd64_edac
controller F10h: DEV 0000:00:18.2 (INTERRUPT)
[    3.778838] EDAC PCI0: Giving out device to module amd64_edac
controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[    3.778908] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    3.779099] ohci-pci 0000:00:12.0: new USB bus registered, assigned
bus number 8
[    3.779131] ohci-pci 0000:00:12.0: irq 18, io mem 0xfea0a000
[    3.790371] microcode: CPU0: patch_level=0x010000c6
[    3.792744] microcode: CPU0: new patch_level=0x010000db
[    3.792754] microcode: CPU1: patch_level=0x010000c6
[    3.792759] microcode: CPU1: new patch_level=0x010000db
[    3.792766] microcode: CPU2: patch_level=0x010000c6
[    3.792772] microcode: CPU2: new patch_level=0x010000db
[    3.792779] microcode: CPU3: patch_level=0x010000c6
[    3.792783] microcode: CPU3: new patch_level=0x010000db
[    3.792823] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.802690] kvm: Nested Virtualization enabled
[    3.802701] kvm: Nested Paging enabled
[    3.825098] cx23885_dev_checkrevision() Hardware revision = 0xa5
[    3.825105] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 20,
latency: 0, mmio: 0xfe400000
[    3.838405] hub 8-0:1.0: USB hub found
[    3.838417] hub 8-0:1.0: 5 ports detected
[    3.838661] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    3.838805] ohci-pci 0000:00:13.0: new USB bus registered, assigned
bus number 9
[    3.838848] ohci-pci 0000:00:13.0: irq 20, io mem 0xfea08000
[    3.873268] alsactl (1180) used greatest stack depth: 4872 bytes left
[    3.894878] hub 9-0:1.0: USB hub found
[    3.894887] hub 9-0:1.0: 5 ports detected
[    3.895120] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    3.895176] ohci-pci 0000:00:14.5: new USB bus registered, assigned
bus number 10
[    3.895196] ohci-pci 0000:00:14.5: irq 18, io mem 0xfea06000
[    3.951502] hub 10-0:1.0: USB hub found
[    3.951522] hub 10-0:1.0: 2 ports detected
[    3.951888] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    3.951992] ohci-pci 0000:00:16.0: new USB bus registered, assigned
bus number 11
[    3.952051] ohci-pci 0000:00:16.0: irq 22, io mem 0xfea05000
[    4.008061] hub 11-0:1.0: USB hub found
[    4.008070] hub 11-0:1.0: 4 ports detected
[    4.023700] usb 1-4: new high-speed USB device number 3 using ehci-pci
[    4.110661] SPL: Loaded module v0.6.3-r0-gentoo
[    4.111977] znvpair: module license 'CDDL' taints kernel.
[    4.111981] znvpair: module license 'CDDL' taints kernel.
[    4.111988] Disabling lock debugging due to kernel taint
[    4.148126] ZFS: Loaded module v0.6.3-r0-gentoo, ZFS pool version
5000, ZFS filesystem version 5
[    4.148333] modprobe (1258) used greatest stack depth: 4832 bytes left
[    4.149233] hub 1-4:1.0: USB hub found
[    4.149590] hub 1-4:1.0: 4 ports detected
[    4.949508] usb 9-4: new full-speed USB device number 2 using ohci-pci
[    5.119446] input: Razer Razer Naga 2014 as
/devices/pci0000:00/0000:00:13.0/usb9/9-4/9-4:1.0/0003:1532:0040.0001/input/input3
[    5.119754] hid-generic 0003:1532:0040.0001: input,hidraw0: USB HID
v1.11 Mouse [Razer Razer Naga 2014] on usb-0000:00:13.0-4/input0
[    5.128763] input: Razer Razer Naga 2014 as
/devices/pci0000:00/0000:00:13.0/usb9/9-4/9-4:1.1/0003:1532:0040.0002/input/input4
[    5.128960] hid-generic 0003:1532:0040.0002: input,hidraw1: USB HID
v1.11 Keyboard [Razer Razer Naga 2014] on usb-0000:00:13.0-4/input1
[    5.134504] input: Razer Razer Naga 2014 as
/devices/pci0000:00/0000:00:13.0/usb9/9-4/9-4:1.2/0003:1532:0040.0003/input/input5
[    5.134634] hid-generic 0003:1532:0040.0003: input,hidraw2: USB HID
v1.11 Keyboard [Razer Razer Naga 2014] on usb-0000:00:13.0-4/input2
[    5.262408] usb 8-3: new low-speed USB device number 2 using ohci-pci
[    5.336582] SPL: using hostid 0x00000000
[    5.442581] hid-generic 0003:0665:5161.0004: hiddev0,hidraw3: USB HID
v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:12.0-3/input0
[    5.445058] zpool (1298) used greatest stack depth: 3128 bytes left
[    5.692084] usb 8-5: new low-speed USB device number 3 using ohci-pci
[    5.856716] input: HID 04f3:0103 as
/devices/pci0000:00/0000:00:12.0/usb8/8-5/8-5:1.0/0003:04F3:0103.0005/input/input6
[    5.856940] hid-generic 0003:04F3:0103.0005: input,hidraw4: USB HID
v1.10 Keyboard [HID 04f3:0103] on usb-0000:00:12.0-5/input0
[    5.865194] input: HID 04f3:0103 as
/devices/pci0000:00/0000:00:12.0/usb8/8-5/8-5:1.1/0003:04F3:0103.0006/input/input7
[    5.865383] hid-generic 0003:04F3:0103.0006: input,hidraw5: USB HID
v1.10 Device [HID 04f3:0103] on usb-0000:00:12.0-5/input1
[    8.226093] EXT4-fs (sda2): re-mounted. Opts: (null)
[    8.406257] FAT-fs (sda1): Volume was not properly unmounted. Some
data may be corrupt. Please run fsck.
[    8.423420] EXT4-fs (sde1): mounted filesystem with ordered data
mode. Opts: discard
[   11.645546] r8169 0000:02:00.0 eth0: link down
[   11.645579] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.650934] r8169 0000:02:00.0 eth0: link down
[   13.829171] r8169 0000:02:00.0 eth0: link up
[   13.829189] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.418880] it87: Found IT8721F chip at 0x290, revision 1
[   19.432135] it87 it87.656: Sensor type 2 is deprecated, please use 4
instead
[   19.432207] it87 it87.656: Sensor type 2 is deprecated, please use 4
instead
[   20.886774] input: Razer Razer Naga 2014 as
/devices/pci0000:00/0000:00:13.0/usb9/9-4/9-4:1.0/0003:1532:0040.0007/input/input8
[   20.887158] hid-generic 0003:1532:0040.0007: input,hidraw0: USB HID
v1.11 Mouse [Razer Razer Naga 2014] on usb-0000:00:13.0-4/input0
[   21.109574] input: Razer Razer Naga 2014 as
/devices/pci0000:00/0000:00:13.0/usb9/9-4/9-4:1.0/0003:1532:0040.0008/input/input9
[   21.109885] hid-generic 0003:1532:0040.0008: input,hidraw0: USB HID
v1.11 Mouse [Razer Razer Naga 2014] on usb-0000:00:13.0-4/input0
[  472.166673] nf_conntrack: automatic helper assignment is deprecated
and it will be removed soon. Use the iptables CT target to attach
helpers instead.

lspci -v
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (external gfx0 port B) (rev 02)
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (external gfx0 port B)
        Flags: fast devsel
        Capabilities: [f0] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [c4] HyperTransport: Slave or Primary Interface
        Capabilities: [40] HyperTransport: Retry Mode
        Capabilities: [54] HyperTransport: UnitID Clumping
        Capabilities: [9c] HyperTransport: #1a
        Capabilities: [70] MSI: Enable- Count=1/4 Maskable- 64bit-

00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O Memory
Management Unit (IOMMU)
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O
Memory Management Unit (IOMMU)
        Flags: fast devsel, IRQ 72
        Capabilities: [40] Secure device <?>
        Capabilities: [54] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [64] HyperTransport: MSI Mapping Enable+ Fixed+

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (PCI express gpp port B) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fe900000-fe9fffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot+), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [190] Access Control Services
        Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot+), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [190] Access Control Services
        Kernel driver in use: pcieport

00:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (PCI express gpp port E) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: fe800000-fe8fffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot+), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [190] Access Control Services
        Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (PCI express gpp port F) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe700000-fe7fffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot+), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [190] Access Control Services
        Kernel driver in use: pcieport

00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to
PCI bridge (PCI express gpp port G) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        Memory behind bridge: fe600000-fe6fffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot+), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [190] Access Control Services
        Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01 [AHCI
1.0])
        Subsystem: ASUSTeK Computer Inc. Device 84dd
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
        I/O ports at f040 [size=8]
        I/O ports at f030 [size=4]
        I/O ports at f020 [size=8]
        I/O ports at f010 [size=4]
        I/O ports at f000 [size=16]
        Memory at fea0b000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] SATA HBA v1.0
        Capabilities: [a4] PCI Advanced Features
        Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
        Memory at fea0a000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
        Memory at fea09000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 20
        Memory at fea08000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 21
        Memory at fea07000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 42)
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller
        Flags: 66MHz, medium devsel
        Kernel driver in use: piix4_smbus
        Kernel modules: i2c_piix4

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
        Subsystem: ASUSTeK Computer Inc. Device 84fb
        Flags: slow devsel, IRQ 10
        Memory at fea00000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Kernel modules: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller
        Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to
PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
        Flags: bus master, VGA palette snoop, 66MHz, medium devsel,
latency 64
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=64
        I/O behind bridge: 0000b000-0000bfff

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
        Memory at fea06000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        Memory behind bridge: fe400000-fe5fffff
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Root Port (Slot-), MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc.
[AMD/ATI] Device 0000
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Kernel driver in use: pcieport

00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 22
        Memory at fea05000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 23
        Memory at fea04000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor HyperTransport Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor DRAM Controller
        Flags: fast devsel
        Kernel driver in use: amd64_edac
        Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Miscellaneous Control
        Flags: fast devsel
        Capabilities: [f0] Secure device <?>
        Kernel driver in use: k10temp
        Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Link Control
        Flags: fast devsel

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Juniper XT [Radeon HD 5770] (prog-if 00 [VGA controller])
        Subsystem: XFX Pine Group Inc. Device 2991
        Flags: bus master, fast devsel, latency 0, IRQ 73
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at fe920000 (64-bit, non-prefetchable) [size=128K]
        I/O ports at e000 [size=256]
        Expansion ROM at fe900000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [150] Advanced Error Reporting
        Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Juniper
HDMI Audio [Radeon HD 5700 Series]
        Subsystem: XFX Pine Group Inc. Device aa58
        Flags: fast devsel, IRQ 15
        Memory at fe940000 (64-bit, non-prefetchable) [disabled] [size=16K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
        Capabilities: [150] Advanced Error Reporting
        Kernel modules: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 09)
        Subsystem: ASUSTeK Computer Inc. P8 series motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 75
        I/O ports at d000 [size=256]
        Memory at d0004000 (64-bit, prefetchable) [size=4K]
        Memory at d0000000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 52-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169

03:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])
        Subsystem: ASUSTeK Computer Inc. P8B WS Motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 46
        Memory at fe800000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
        Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
        Capabilities: [78] Power Management version 3
        Capabilities: [80] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Virtual Channel
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_hcd

04:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA
Controller (rev 01) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 84b7
        Flags: bus master, fast devsel, latency 0, IRQ 74
        I/O ports at c050 [size=8]
        I/O ports at c040 [size=4]
        I/O ports at c030 [size=8]
        I/O ports at c020 [size=4]
        I/O ports at c000 [size=32]
        Memory at fe700000 (32-bit, non-prefetchable) [size=512]
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [78] Power Management version 3
        Capabilities: [80] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Virtual Channel
        Kernel driver in use: ahci

05:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])
        Subsystem: ASUSTeK Computer Inc. P8B WS Motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 50
        Memory at fe600000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
        Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
        Capabilities: [78] Power Management version 3
        Capabilities: [80] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Virtual Channel
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_hcd

06:05.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
        Subsystem: Creative Labs Device 1001
        Flags: bus master, medium devsel, latency 32, IRQ 20
        I/O ports at b000 [size=64]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: snd_emu10k1
        Kernel modules: snd_emu10k1

07:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)
        Subsystem: Device 4254:0952
        Flags: bus master, fast devsel, latency 0, IRQ 20
        Memory at fe400000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint, MSI 00
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [200] Virtual Channel
        Kernel driver in use: cx23885
        Kernel modules: cx23885

Attached is dmesg from 3.12.23 with one successful suspend/resume cycle.

Will do git-bisect in the next couple of evenings, a starting point to
keep the reset-button usage down would be nice.

Please cc me on replies, since I am not subscribed,

Glück Auf,

Volker Hemmann

--------------000806090107080401040107
Content-Type: text/plain; charset=ISO-8859-15;
 name="dmesg_3.12.23"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg_3.12.23"

WyAgICAwLjAwMDAwMF0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1ClsgICAgMC4w
MDAwMDBdIExpbnV4IHZlcnNpb24gMy4xMi4yMyAocm9vdEBlbmVyZ3kpIChnY2MgdmVyc2lv
biA0LjcuMyAoR2VudG9vIDQuNy4zLXIxIHAxLjMsIHBpZS0wLjUuNSkgKSAjMSBTTVAgU2F0
IEp1biAyOCAxMjo0MDozMCBDRVNUIDIwMTQKWyAgICAwLjAwMDAwMF0gQ29tbWFuZCBsaW5l
OiBCT09UX0lNQUdFPS9ib290L3ZtbGludXotMy4xMi4yMyByb290PS9kZXYvc2RhMiBybwpb
ICAgIDAuMDAwMDAwXSBLRVJORUwgc3VwcG9ydGVkIGNwdXM6ClsgICAgMC4wMDAwMDBdICAg
QU1EIEF1dGhlbnRpY0FNRApbICAgIDAuMDAwMDAwXSBlODIwOiBCSU9TLXByb3ZpZGVkIHBo
eXNpY2FsIFJBTSBtYXA6ClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAw
MDAwMDAwMDAwMDAtMHgwMDAwMDAwMDAwMDlmZmZmXSB1c2FibGUKWyAgICAwLjAwMDAwMF0g
QklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwMDEwMDAwMC0weDAwMDAwMDAwYmE2NjdmZmZd
IHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGJhNjY4
MDAwLTB4MDAwMDAwMDBiYTk0M2ZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1l
ODIwOiBbbWVtIDB4MDAwMDAwMDBiYTk0NDAwMC0weDAwMDAwMDAwYmE5NTNmZmZdIEFDUEkg
ZGF0YQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGJhOTU0MDAw
LTB4MDAwMDAwMDBiYjc1NmZmZl0gQUNQSSBOVlMKWyAgICAwLjAwMDAwMF0gQklPUy1lODIw
OiBbbWVtIDB4MDAwMDAwMDBiYjc1NzAwMC0weDAwMDAwMDAwYmM5YzlmZmZdIHJlc2VydmVk
ClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwYmM5Y2EwMDAtMHgw
MDAwMDAwMGJjYTM3ZmZmXSB0eXBlIDIwClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21l
bSAweDAwMDAwMDAwYmNhMzgwMDAtMHgwMDAwMDAwMGJjYTM4ZmZmXSB1c2FibGUKWyAgICAw
LjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBiY2EzOTAwMC0weDAwMDAwMDAw
YmNjM2VmZmZdIEFDUEkgTlZTClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAw
MDAwMDAwYmNjM2YwMDAtMHgwMDAwMDAwMGJkMDgyZmZmXSB1c2FibGUKWyAgICAwLjAwMDAw
MF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBiZDA4MzAwMC0weDAwMDAwMDAwYmQ3ZjNm
ZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAw
YmQ3ZjQwMDAtMHgwMDAwMDAwMGJkN2ZmZmZmXSB1c2FibGUKWyAgICAwLjAwMDAwMF0gQklP
Uy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmODAwMDAwMC0weDAwMDAwMDAwZmJmZmZmZmZdIHJl
c2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZmVjMDAw
MDAtMHgwMDAwMDAwMGZlYzAwZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4
MjA6IFttZW0gMHgwMDAwMDAwMGZlYzEwMDAwLTB4MDAwMDAwMDBmZWMxMGZmZl0gcmVzZXJ2
ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmZWMyMDAwMC0w
eDAwMDAwMDAwZmVjMjBmZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDog
W21lbSAweDAwMDAwMDAwZmVkMDAwMDAtMHgwMDAwMDAwMGZlZDAwZmZmXSByZXNlcnZlZApb
ICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGZlZDYxMDAwLTB4MDAw
MDAwMDBmZWQ3MGZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVt
IDB4MDAwMDAwMDBmZWQ4MDAwMC0weDAwMDAwMDAwZmVkOGZmZmZdIHJlc2VydmVkClsgICAg
MC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZmVmMDAwMDAtMHgwMDAwMDAw
MGZmZmZmZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgw
MDAwMDAwMTAwMDAxMDAwLTB4MDAwMDAwMDQzZmZmZmZmZl0gdXNhYmxlClsgICAgMC4wMDAw
MDBdIE5YIChFeGVjdXRlIERpc2FibGUpIHByb3RlY3Rpb246IGFjdGl2ZQpbICAgIDAuMDAw
MDAwXSBlZmk6IEVGSSB2Mi4xMCBieSBBbWVyaWNhbiBNZWdhdHJlbmRzClsgICAgMC4wMDAw
MDBdIGVmaTogIEFDUEk9MHhiYTk0YzAwMCAgQUNQSSAyLjA9MHhiYTk0YzAwMCAgU01CSU9T
PTB4ZjA0YzAgClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMDA6IHR5cGU9MywgYXR0cj0weGYs
IHJhbmdlPVsweDAwMDAwMDAwMDAwMDAwMDAtMHgwMDAwMDAwMDAwMDA4MDAwKSAoME1CKQpb
ICAgIDAuMDAwMDAwXSBlZmk6IG1lbTAxOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMDAwMDA4MDAwLTB4MDAwMDAwMDAwMDA1ZjAwMCkgKDBNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW0wMjogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDAwMDA1
ZjAwMC0weDAwMDAwMDAwMDAwNjAwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVt
MDM6IHR5cGU9MywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwMDAwNjAwMDAtMHgwMDAw
MDAwMDAwMGEwMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTA0OiB0eXBlPTcs
IGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMDAwMTAwMDAwLTB4MDAwMDAwMDAwMTAwMDAw
MCkgKDE1TUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMDU6IHR5cGU9MiwgYXR0cj0weGYs
IHJhbmdlPVsweDAwMDAwMDAwMDEwMDAwMDAtMHgwMDAwMDAwMDAyMDg5MDAwKSAoMTZNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW0wNjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4
MDAwMDAwMDAwMjA4OTAwMC0weDAwMDAwMDAwN2U1NTEwMDApICgxOTg4TUIpClsgICAgMC4w
MDAwMDBdIGVmaTogbWVtMDc6IHR5cGU9MiwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAw
N2U1NTEwMDAtMHgwMDAwMDAwMGE5YjY0MDAwKSAoNjk0TUIpClsgICAgMC4wMDAwMDBdIGVm
aTogbWVtMDg6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYTliNjQwMDAt
MHgwMDAwMDAwMGE5YjZhMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTA5OiB0
eXBlPTEsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGE5YjZhMDAwLTB4MDAwMDAwMDBh
OWI4NzAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMDogdHlwZT03LCBhdHRy
PTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhOWI4NzAwMC0weDAwMDAwMDAwYWQxOTgwMDApICg1
NE1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTExOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5n
ZT1bMHgwMDAwMDAwMGFkMTk4MDAwLTB4MDAwMDAwMDBhZDYwZDAwMCkgKDRNQikKWyAgICAw
LjAwMDAwMF0gZWZpOiBtZW0xMjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAw
MDBhZDYwZDAwMC0weDAwMDAwMDAwYWQ2MTUwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVm
aTogbWVtMTM6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ2MTUwMDAt
MHgwMDAwMDAwMGFkNjM2MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE0OiB0
eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkNjM2MDAwLTB4MDAwMDAwMDBh
ZDYzZjAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xNTogdHlwZT00LCBhdHRy
PTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDYzZjAwMC0weDAwMDAwMDAwYWQ2NjQwMDApICgw
TUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTY6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdl
PVsweDAwMDAwMDAwYWQ2NjQwMDAtMHgwMDAwMDAwMGFkNjcwMDAwKSAoME1CKQpbICAgIDAu
MDAwMDAwXSBlZmk6IG1lbTE3OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAw
MGFkNjcwMDAwLTB4MDAwMDAwMDBhZDZhODAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZp
OiBtZW0xODogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDZhODAwMC0w
eDAwMDAwMDAwYWQ2YmMwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTk6IHR5
cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ2YmMwMDAtMHgwMDAwMDAwMGFk
NmUwMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTIwOiB0eXBlPTcsIGF0dHI9
MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkNmUwMDAwLTB4MDAwMDAwMDBhZDZmMDAwMCkgKDBN
QikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0yMTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9
WzB4MDAwMDAwMDBhZDZmMDAwMC0weDAwMDAwMDAwYWQ3MTcwMDApICgwTUIpClsgICAgMC4w
MDAwMDBdIGVmaTogbWVtMjI6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAw
YWQ3MTcwMDAtMHgwMDAwMDAwMGFkNzJiMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6
IG1lbTIzOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkNzJiMDAwLTB4
MDAwMDAwMDBhZDc1NDAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0yNDogdHlw
ZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDc1NDAwMC0weDAwMDAwMDAwYWQ3
Y2QwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMjU6IHR5cGU9NCwgYXR0cj0w
eGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ3Y2QwMDAtMHgwMDAwMDAwMGFkODExMDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTI2OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1b
MHgwMDAwMDAwMGFkODExMDAwLTB4MDAwMDAwMDBhZDgxOTAwMCkgKDBNQikKWyAgICAwLjAw
MDAwMF0gZWZpOiBtZW0yNzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBh
ZDgxOTAwMC0weDAwMDAwMDAwYWQ4M2QwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTog
bWVtMjg6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ4M2QwMDAtMHgw
MDAwMDAwMGFkODQ2MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTI5OiB0eXBl
PTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkODQ2MDAwLTB4MDAwMDAwMDBhZDg2
YTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0zMDogdHlwZT03LCBhdHRyPTB4
ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDg2YTAwMC0weDAwMDAwMDAwYWQ4NzYwMDApICgwTUIp
ClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMzE6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsw
eDAwMDAwMDAwYWQ4NzYwMDAtMHgwMDAwMDAwMGFkOGFlMDAwKSAoME1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTMyOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFk
OGFlMDAwLTB4MDAwMDAwMDBhZDhjMjAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBt
ZW0zMzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDhjMjAwMC0weDAw
MDAwMDAwYWQ4ZTQwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMzQ6IHR5cGU9
NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ4ZTQwMDAtMHgwMDAwMDAwMGFkOGY0
MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTM1OiB0eXBlPTQsIGF0dHI9MHhm
LCByYW5nZT1bMHgwMDAwMDAwMGFkOGY0MDAwLTB4MDAwMDAwMDBhZDkxYzAwMCkgKDBNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW0zNjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4
MDAwMDAwMDBhZDkxYzAwMC0weDAwMDAwMDAwYWQ5MzAwMDApICgwTUIpClsgICAgMC4wMDAw
MDBdIGVmaTogbWVtMzc6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWQ5
MzAwMDAtMHgwMDAwMDAwMGFkOTY1MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1l
bTM4OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkOTY1MDAwLTB4MDAw
MDAwMDBhZDk3YTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0zOTogdHlwZT00
LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZDk3YTAwMC0weDAwMDAwMDAwYWQ5ZDMw
MDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNDA6IHR5cGU9NywgYXR0cj0weGYs
IHJhbmdlPVsweDAwMDAwMDAwYWQ5ZDMwMDAtMHgwMDAwMDAwMGFkOWYyMDAwKSAoME1CKQpb
ICAgIDAuMDAwMDAwXSBlZmk6IG1lbTQxOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMGFkOWYyMDAwLTB4MDAwMDAwMDBhZGExNzAwMCkgKDBNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW00MjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGEx
NzAwMC0weDAwMDAwMDAwYWRhMWYwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVt
NDM6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRhMWYwMDAtMHgwMDAw
MDAwMGFkYTQzMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTQ0OiB0eXBlPTcs
IGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkYTQzMDAwLTB4MDAwMDAwMDBhZGE0YzAw
MCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW00NTogdHlwZT00LCBhdHRyPTB4Ziwg
cmFuZ2U9WzB4MDAwMDAwMDBhZGE0YzAwMC0weDAwMDAwMDAwYWRhNzEwMDApICgwTUIpClsg
ICAgMC4wMDAwMDBdIGVmaTogbWVtNDY6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAw
MDAwMDAwYWRhNzEwMDAtMHgwMDAwMDAwMGFkYTdkMDAwKSAoME1CKQpbICAgIDAuMDAwMDAw
XSBlZmk6IG1lbTQ3OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkYTdk
MDAwLTB4MDAwMDAwMDBhZGFiNDAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW00
ODogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGFiNDAwMC0weDAwMDAw
MDAwYWRhYzgwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNDk6IHR5cGU9NCwg
YXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRhYzgwMDAtMHgwMDAwMDAwMGFkYWViMDAw
KSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTUwOiB0eXBlPTcsIGF0dHI9MHhmLCBy
YW5nZT1bMHgwMDAwMDAwMGFkYWViMDAwLTB4MDAwMDAwMDBhZGFmYjAwMCkgKDBNQikKWyAg
ICAwLjAwMDAwMF0gZWZpOiBtZW01MTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAw
MDAwMDBhZGFmYjAwMC0weDAwMDAwMDAwYWRiMjMwMDApICgwTUIpClsgICAgMC4wMDAwMDBd
IGVmaTogbWVtNTI6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRiMjMw
MDAtMHgwMDAwMDAwMGFkYjM3MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTUz
OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkYjM3MDAwLTB4MDAwMDAw
MDBhZGI2MDAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW01NDogdHlwZT03LCBh
dHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGI2MDAwMC0weDAwMDAwMDAwYWRiNzUwMDAp
ICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNTU6IHR5cGU9NCwgYXR0cj0weGYsIHJh
bmdlPVsweDAwMDAwMDAwYWRiNzUwMDAtMHgwMDAwMDAwMGFkYmRhMDAwKSAoME1CKQpbICAg
IDAuMDAwMDAwXSBlZmk6IG1lbTU2OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAw
MDAwMGFkYmRhMDAwLTB4MDAwMDAwMDBhZGJmOTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0g
ZWZpOiBtZW01NzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGJmOTAw
MC0weDAwMDAwMDAwYWRjMWYwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNTg6
IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRjMWYwMDAtMHgwMDAwMDAw
MGFkYzI3MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTU5OiB0eXBlPTQsIGF0
dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkYzI3MDAwLTB4MDAwMDAwMDBhZGM0YTAwMCkg
KDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW02MDogdHlwZT03LCBhdHRyPTB4ZiwgcmFu
Z2U9WzB4MDAwMDAwMDBhZGM0YTAwMC0weDAwMDAwMDAwYWRjNTMwMDApICgwTUIpClsgICAg
MC4wMDAwMDBdIGVmaTogbWVtNjE6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAw
MDAwYWRjNTMwMDAtMHgwMDAwMDAwMGFkYzc5MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBl
Zmk6IG1lbTYyOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkYzc5MDAw
LTB4MDAwMDAwMDBhZGM4NTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW02Mzog
dHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGM4NTAwMC0weDAwMDAwMDAw
YWRjYmIwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNjQ6IHR5cGU9NywgYXR0
cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRjYmIwMDAtMHgwMDAwMDAwMGFkY2NmMDAwKSAo
ME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTY1OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5n
ZT1bMHgwMDAwMDAwMGFkY2NmMDAwLTB4MDAwMDAwMDBhZGNmMjAwMCkgKDBNQikKWyAgICAw
LjAwMDAwMF0gZWZpOiBtZW02NjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAw
MDBhZGNmMjAwMC0weDAwMDAwMDAwYWRkMDIwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVm
aTogbWVtNjc6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRkMDIwMDAt
MHgwMDAwMDAwMGFkZDI5MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTY4OiB0
eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkZDI5MDAwLTB4MDAwMDAwMDBh
ZGQzZDAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW02OTogdHlwZT00LCBhdHRy
PTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGQzZDAwMC0weDAwMDAwMDAwYWRkNzIwMDApICgw
TUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNzA6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdl
PVsweDAwMDAwMDAwYWRkNzIwMDAtMHgwMDAwMDAwMGFkZDg3MDAwKSAoME1CKQpbICAgIDAu
MDAwMDAwXSBlZmk6IG1lbTcxOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAw
MGFkZDg3MDAwLTB4MDAwMDAwMDBhZGRkYTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZp
OiBtZW03MjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGRkYTAwMC0w
eDAwMDAwMDAwYWRkZjkwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNzM6IHR5
cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRkZjkwMDAtMHgwMDAwMDAwMGFk
ZTI4MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTc0OiB0eXBlPTcsIGF0dHI9
MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkZTI4MDAwLTB4MDAwMDAwMDBhZGUzMDAwMCkgKDBN
QikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW03NTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9
WzB4MDAwMDAwMDBhZGUzMDAwMC0weDAwMDAwMDAwYWRlNTIwMDApICgwTUIpClsgICAgMC4w
MDAwMDBdIGVmaTogbWVtNzY6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAw
YWRlNTIwMDAtMHgwMDAwMDAwMGFkZTViMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6
IG1lbTc3OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkZTViMDAwLTB4
MDAwMDAwMDBhZGU4MTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW03ODogdHlw
ZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGU4MTAwMC0weDAwMDAwMDAwYWRl
OGQwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtNzk6IHR5cGU9NCwgYXR0cj0w
eGYsIHJhbmdlPVsweDAwMDAwMDAwYWRlOGQwMDAtMHgwMDAwMDAwMGFkZWM1MDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTgwOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1b
MHgwMDAwMDAwMGFkZWM1MDAwLTB4MDAwMDAwMDBhZGVkOTAwMCkgKDBNQikKWyAgICAwLjAw
MDAwMF0gZWZpOiBtZW04MTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBh
ZGVkOTAwMC0weDAwMDAwMDAwYWRlZmIwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTog
bWVtODI6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWRlZmIwMDAtMHgw
MDAwMDAwMGFkZjBiMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTgzOiB0eXBl
PTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFkZjBiMDAwLTB4MDAwMDAwMDBhZGYz
NTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW04NDogdHlwZT03LCBhdHRyPTB4
ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGYzNTAwMC0weDAwMDAwMDAwYWRmNDkwMDApICgwTUIp
ClsgICAgMC4wMDAwMDBdIGVmaTogbWVtODU6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsw
eDAwMDAwMDAwYWRmNDkwMDAtMHgwMDAwMDAwMGFkZmZjMDAwKSAoME1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTg2OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFk
ZmZjMDAwLTB4MDAwMDAwMDBhZGZmZDAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBt
ZW04NzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZGZmZDAwMC0weDAw
MDAwMDAwYWUyYjEwMDApICgyTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtODg6IHR5cGU9
NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWUyYjEwMDAtMHgwMDAwMDAwMGFlMmQw
MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTg5OiB0eXBlPTQsIGF0dHI9MHhm
LCByYW5nZT1bMHgwMDAwMDAwMGFlMmQwMDAwLTB4MDAwMDAwMDBhZTJmYjAwMCkgKDBNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW05MDogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4
MDAwMDAwMDBhZTJmYjAwMC0weDAwMDAwMDAwYWUzMDQwMDApICgwTUIpClsgICAgMC4wMDAw
MDBdIGVmaTogbWVtOTE6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWUz
MDQwMDAtMHgwMDAwMDAwMGFlMzNlMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1l
bTkyOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlMzNlMDAwLTB4MDAw
MDAwMDBhZTM0ODAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW05MzogdHlwZT00
LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTM0ODAwMC0weDAwMDAwMDAwYWUzNzAw
MDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtOTQ6IHR5cGU9NywgYXR0cj0weGYs
IHJhbmdlPVsweDAwMDAwMDAwYWUzNzAwMDAtMHgwMDAwMDAwMGFlMzdkMDAwKSAoME1CKQpb
ICAgIDAuMDAwMDAwXSBlZmk6IG1lbTk1OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMGFlMzdkMDAwLTB4MDAwMDAwMDBhZTNhZDAwMCkgKDBNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW05NjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTNh
ZDAwMC0weDAwMDAwMDAwYWUzYzEwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVt
OTc6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWUzYzEwMDAtMHgwMDAw
MDAwMGFlM2U0MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTk4OiB0eXBlPTcs
IGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlM2U0MDAwLTB4MDAwMDAwMDBhZTNmNDAw
MCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW05OTogdHlwZT00LCBhdHRyPTB4Ziwg
cmFuZ2U9WzB4MDAwMDAwMDBhZTNmNDAwMC0weDAwMDAwMDAwYWU0MWYwMDApICgwTUIpClsg
ICAgMC4wMDAwMDBdIGVmaTogbWVtMTAwOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMGFlNDFmMDAwLTB4MDAwMDAwMDBhZTQyODAwMCkgKDBNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW0xMDE6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU0
MjgwMDAtMHgwMDAwMDAwMGFlNDRiMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1l
bTEwMjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTQ0YjAwMC0weDAw
MDAwMDAwYWU0NGQwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTAzOiB0eXBl
PTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlNDRkMDAwLTB4MDAwMDAwMDBhZTRi
OTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMDQ6IHR5cGU9NywgYXR0cj0w
eGYsIHJhbmdlPVsweDAwMDAwMDAwYWU0YjkwMDAtMHgwMDAwMDAwMGFlNGJhMDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEwNTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9
WzB4MDAwMDAwMDBhZTRiYTAwMC0weDAwMDAwMDAwYWU0ZTcwMDApICgwTUIpClsgICAgMC4w
MDAwMDBdIGVmaTogbWVtMTA2OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAw
MGFlNGU3MDAwLTB4MDAwMDAwMDBhZTRlYTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZp
OiBtZW0xMDc6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU0ZWEwMDAt
MHgwMDAwMDAwMGFlNTI5MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEwODog
dHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTUyOTAwMC0weDAwMDAwMDAw
YWU1MmQwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTA5OiB0eXBlPTQsIGF0
dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlNTJkMDAwLTB4MDAwMDAwMDBhZTU0ODAwMCkg
KDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMTA6IHR5cGU9NywgYXR0cj0weGYsIHJh
bmdlPVsweDAwMDAwMDAwYWU1NDgwMDAtMHgwMDAwMDAwMGFlNTRhMDAwKSAoME1CKQpbICAg
IDAuMDAwMDAwXSBlZmk6IG1lbTExMTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAw
MDAwMDBhZTU0YTAwMC0weDAwMDAwMDAwYWU2NzQwMDApICgxTUIpClsgICAgMC4wMDAwMDBd
IGVmaTogbWVtMTEyOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlNjc0
MDAwLTB4MDAwMDAwMDBhZTY3NzAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0x
MTM6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU2NzcwMDAtMHgwMDAw
MDAwMGFlODFjMDAwKSAoMU1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTExNDogdHlwZT03
LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTgxYzAwMC0weDAwMDAwMDAwYWU4MjEw
MDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTE1OiB0eXBlPTQsIGF0dHI9MHhm
LCByYW5nZT1bMHgwMDAwMDAwMGFlODIxMDAwLTB4MDAwMDAwMDBhZTg0NzAwMCkgKDBNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMTY6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsw
eDAwMDAwMDAwYWU4NDcwMDAtMHgwMDAwMDAwMGFlODQ5MDAwKSAoME1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTExNzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBh
ZTg0OTAwMC0weDAwMDAwMDAwYWU4NjEwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTog
bWVtMTE4OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlODYxMDAwLTB4
MDAwMDAwMDBhZTg2MjAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMTk6IHR5
cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU4NjIwMDAtMHgwMDAwMDAwMGFl
ODY1MDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEyMDogdHlwZT03LCBhdHRy
PTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTg2NTAwMC0weDAwMDAwMDAwYWU4NjgwMDApICgw
TUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTIxOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5n
ZT1bMHgwMDAwMDAwMGFlODY4MDAwLTB4MDAwMDAwMDBhZTg5OTAwMCkgKDBNQikKWyAgICAw
LjAwMDAwMF0gZWZpOiBtZW0xMjI6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAw
MDAwYWU4OTkwMDAtMHgwMDAwMDAwMGFlODliMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBl
Zmk6IG1lbTEyMzogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTg5YjAw
MC0weDAwMDAwMDAwYWU4OWQwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTI0
OiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlODlkMDAwLTB4MDAwMDAw
MDBhZThhMTAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMjU6IHR5cGU9NCwg
YXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU4YTEwMDAtMHgwMDAwMDAwMGFlOGUxMDAw
KSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEyNjogdHlwZT03LCBhdHRyPTB4Ziwg
cmFuZ2U9WzB4MDAwMDAwMDBhZThlMTAwMC0weDAwMDAwMDAwYWU4ZTYwMDApICgwTUIpClsg
ICAgMC4wMDAwMDBdIGVmaTogbWVtMTI3OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMGFlOGU2MDAwLTB4MDAwMDAwMDBhZTljODAwMCkgKDBNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW0xMjg6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWU5
YzgwMDAtMHgwMDAwMDAwMGFlOWNiMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1l
bTEyOTogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZTljYjAwMC0weDAw
MDAwMDAwYWVhN2EwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTMwOiB0eXBl
PTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGFlYTdhMDAwLTB4MDAwMDAwMDBhZWE3
YzAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMzE6IHR5cGU9NCwgYXR0cj0w
eGYsIHJhbmdlPVsweDAwMDAwMDAwYWVhN2MwMDAtMHgwMDAwMDAwMGFlYWE2MDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEzMjogdHlwZT03LCBhdHRyPTB4ZiwgcmFuZ2U9
WzB4MDAwMDAwMDBhZWFhNjAwMC0weDAwMDAwMDAwYWVhYTcwMDApICgwTUIpClsgICAgMC4w
MDAwMDBdIGVmaTogbWVtMTMzOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAw
MGFlYWE3MDAwLTB4MDAwMDAwMDBhZWFkMjAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZp
OiBtZW0xMzQ6IHR5cGU9NywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYWVhZDIwMDAt
MHgwMDAwMDAwMGFlYWQzMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEzNTog
dHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBhZWFkMzAwMC0weDAwMDAwMDAw
YjlhMjgwMDApICgxNzVNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xMzY6IHR5cGU9Nywg
YXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYjlhMjgwMDAtMHgwMDAwMDAwMGI5ZjljMDAw
KSAoNU1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTEzNzogdHlwZT0yLCBhdHRyPTB4Ziwg
cmFuZ2U9WzB4MDAwMDAwMDBiOWY5YzAwMC0weDAwMDAwMDAwYjlmYTgwMDApICgwTUIpClsg
ICAgMC4wMDAwMDBdIGVmaTogbWVtMTM4OiB0eXBlPTMsIGF0dHI9MHhmLCByYW5nZT1bMHgw
MDAwMDAwMGI5ZmE4MDAwLTB4MDAwMDAwMDBiYTY2ODAwMCkgKDZNQikKWyAgICAwLjAwMDAw
MF0gZWZpOiBtZW0xMzk6IHR5cGU9MCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYmE2
NjgwMDAtMHgwMDAwMDAwMGJhNmZhMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1l
bTE0MDogdHlwZT0wLCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBiYTZmYTAwMC0weDAw
MDAwMDAwYmE5NDQwMDApICgyTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTQxOiB0eXBl
PTksIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGJhOTQ0MDAwLTB4MDAwMDAwMDBiYTk0
YzAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xNDI6IHR5cGU9OSwgYXR0cj0w
eGYsIHJhbmdlPVsweDAwMDAwMDAwYmE5NGMwMDAtMHgwMDAwMDAwMGJhOTU0MDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE0MzogdHlwZT0xMCwgYXR0cj0weGYsIHJhbmdl
PVsweDAwMDAwMDAwYmE5NTQwMDAtMHgwMDAwMDAwMGJhZTI5MDAwKSAoNE1CKQpbICAgIDAu
MDAwMDAwXSBlZmk6IG1lbTE0NDogdHlwZT0xMCwgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAw
MDAwYmFlMjkwMDAtMHgwMDAwMDAwMGJiNzU3MDAwKSAoOU1CKQpbICAgIDAuMDAwMDAwXSBl
Zmk6IG1lbTE0NTogdHlwZT02LCBhdHRyPTB4ODAwMDAwMDAwMDAwMDAwZiwgcmFuZ2U9WzB4
MDAwMDAwMDBiYjc1NzAwMC0weDAwMDAwMDAwYmMyNzgwMDApICgxMU1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTE0NjogdHlwZT02LCBhdHRyPTB4ODAwMDAwMDAwMDAwMDAwZiwgcmFu
Z2U9WzB4MDAwMDAwMDBiYzI3ODAwMC0weDAwMDAwMDAwYmM5Y2EwMDApICg3TUIpClsgICAg
MC4wMDAwMDBdIGVmaTogbWVtMTQ3OiB0eXBlPTUsIGF0dHI9MHg4MDAwMDAwMDAwMDAwMDBm
LCByYW5nZT1bMHgwMDAwMDAwMGJjOWNhMDAwLTB4MDAwMDAwMDBiYzllMDAwMCkgKDBNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xNDg6IHR5cGU9NSwgYXR0cj0weDgwMDAwMDAwMDAw
MDAwMGYsIHJhbmdlPVsweDAwMDAwMDAwYmM5ZTAwMDAtMHgwMDAwMDAwMGJjYTM4MDAwKSAo
ME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE0OTogdHlwZT00LCBhdHRyPTB4ZiwgcmFu
Z2U9WzB4MDAwMDAwMDBiY2EzODAwMC0weDAwMDAwMDAwYmNhMzkwMDApICgwTUIpClsgICAg
MC4wMDAwMDBdIGVmaTogbWVtMTUwOiB0eXBlPTEwLCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAw
MDAwMDBiY2EzOTAwMC0weDAwMDAwMDAwYmNjM2YwMDApICgyTUIpClsgICAgMC4wMDAwMDBd
IGVmaTogbWVtMTUxOiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGJjYzNm
MDAwLTB4MDAwMDAwMDBiY2Q4ZjAwMCkgKDFNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0x
NTI6IHR5cGU9MywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYmNkOGYwMDAtMHgwMDAw
MDAwMGJkMDJmMDAwKSAoMk1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE1MzogdHlwZT00
LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBiZDAyZjAwMC0weDAwMDAwMDAwYmQwMzEw
MDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTU0OiB0eXBlPTMsIGF0dHI9MHhm
LCByYW5nZT1bMHgwMDAwMDAwMGJkMDMxMDAwLTB4MDAwMDAwMDBiZDAzNTAwMCkgKDBNQikK
WyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xNTU6IHR5cGU9NCwgYXR0cj0weGYsIHJhbmdlPVsw
eDAwMDAwMDAwYmQwMzUwMDAtMHgwMDAwMDAwMGJkMDM5MDAwKSAoME1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTE1NjogdHlwZT0zLCBhdHRyPTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBi
ZDAzOTAwMC0weDAwMDAwMDAwYmQwM2IwMDApICgwTUIpClsgICAgMC4wMDAwMDBdIGVmaTog
bWVtMTU3OiB0eXBlPTQsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMGJkMDNiMDAwLTB4
MDAwMDAwMDBiZDAzZjAwMCkgKDBNQikKWyAgICAwLjAwMDAwMF0gZWZpOiBtZW0xNTg6IHR5
cGU9MywgYXR0cj0weGYsIHJhbmdlPVsweDAwMDAwMDAwYmQwM2YwMDAtMHgwMDAwMDAwMGJk
MDQxMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE1OTogdHlwZT00LCBhdHRy
PTB4ZiwgcmFuZ2U9WzB4MDAwMDAwMDBiZDA0MTAwMC0weDAwMDAwMDAwYmQwNjYwMDApICgw
TUIpClsgICAgMC4wMDAwMDBdIGVmaTogbWVtMTYwOiB0eXBlPTMsIGF0dHI9MHhmLCByYW5n
ZT1bMHgwMDAwMDAwMGJkMDY2MDAwLTB4MDAwMDAwMDBiZDA4MzAwMCkgKDBNQikKWyAgICAw
LjAwMDAwMF0gZWZpOiBtZW0xNjE6IHR5cGU9NiwgYXR0cj0weDgwMDAwMDAwMDAwMDAwMGYs
IHJhbmdlPVsweDAwMDAwMDAwYmQwODMwMDAtMHgwMDAwMDAwMGJkN2Y0MDAwKSAoN01CKQpb
ICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE2MjogdHlwZT00LCBhdHRyPTB4ZiwgcmFuZ2U9WzB4
MDAwMDAwMDBiZDdmNDAwMC0weDAwMDAwMDAwYmQ4MDAwMDApICgwTUIpClsgICAgMC4wMDAw
MDBdIGVmaTogbWVtMTYzOiB0eXBlPTcsIGF0dHI9MHhmLCByYW5nZT1bMHgwMDAwMDAwMTAw
MDAxMDAwLTB4MDAwMDAwMDQ0MDAwMDAwMCkgKDEzMzExTUIpClsgICAgMC4wMDAwMDBdIGVm
aTogbWVtMTY0OiB0eXBlPTExLCBhdHRyPTB4ODAwMDAwMDAwMDAwMDAwMSwgcmFuZ2U9WzB4
MDAwMDAwMDBmODAwMDAwMC0weDAwMDAwMDAwZmMwMDAwMDApICg2NE1CKQpbICAgIDAuMDAw
MDAwXSBlZmk6IG1lbTE2NTogdHlwZT0xMSwgYXR0cj0weDgwMDAwMDAwMDAwMDAwMDEsIHJh
bmdlPVsweDAwMDAwMDAwZmVjMDAwMDAtMHgwMDAwMDAwMGZlYzAxMDAwKSAoME1CKQpbICAg
IDAuMDAwMDAwXSBlZmk6IG1lbTE2NjogdHlwZT0xMSwgYXR0cj0weDgwMDAwMDAwMDAwMDAw
MDEsIHJhbmdlPVsweDAwMDAwMDAwZmVjMTAwMDAtMHgwMDAwMDAwMGZlYzExMDAwKSAoME1C
KQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE2NzogdHlwZT0xMSwgYXR0cj0weDgwMDAwMDAw
MDAwMDAwMDEsIHJhbmdlPVsweDAwMDAwMDAwZmVjMjAwMDAtMHgwMDAwMDAwMGZlYzIxMDAw
KSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE2ODogdHlwZT0xMSwgYXR0cj0weDgw
MDAwMDAwMDAwMDAwMDEsIHJhbmdlPVsweDAwMDAwMDAwZmVkMDAwMDAtMHgwMDAwMDAwMGZl
ZDAxMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE2OTogdHlwZT0xMSwgYXR0
cj0weDgwMDAwMDAwMDAwMDAwMDEsIHJhbmdlPVsweDAwMDAwMDAwZmVkNjEwMDAtMHgwMDAw
MDAwMGZlZDcxMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE3MDogdHlwZT0x
MSwgYXR0cj0weDgwMDAwMDAwMDAwMDAwMDEsIHJhbmdlPVsweDAwMDAwMDAwZmVkODAwMDAt
MHgwMDAwMDAwMGZlZDkwMDAwKSAoME1CKQpbICAgIDAuMDAwMDAwXSBlZmk6IG1lbTE3MTog
dHlwZT0xMSwgYXR0cj0weDgwMDAwMDAwMDAwMDAwMDEsIHJhbmdlPVsweDAwMDAwMDAwZmVm
MDAwMDAtMHgwMDAwMDAwMTAwMDAwMDAwKSAoMTdNQikKWyAgICAwLjAwMDAwMF0gU01CSU9T
IDIuNyBwcmVzZW50LgpbICAgIDAuMDAwMDAwXSBETUk6IFRvIGJlIGZpbGxlZCBieSBPLkUu
TS4gVG8gYmUgZmlsbGVkIGJ5IE8uRS5NLi9NNUE5OVggRVZPIFIyLjAsIEJJT1MgMjUwMSAw
NC8wMy8yMDE0ClsgICAgMC4wMDAwMDBdIGU4MjA6IHVwZGF0ZSBbbWVtIDB4MDAwMDAwMDAt
MHgwMDAwMGZmZl0gdXNhYmxlID09PiByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBlODIwOiBy
ZW1vdmUgW21lbSAweDAwMGEwMDAwLTB4MDAwZmZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAw
XSBlODIwOiBsYXN0X3BmbiA9IDB4NDQwMDAwIG1heF9hcmNoX3BmbiA9IDB4NDAwMDAwMDAw
ClsgICAgMC4wMDAwMDBdIE1UUlIgZGVmYXVsdCB0eXBlOiB1bmNhY2hhYmxlClsgICAgMC4w
MDAwMDBdIE1UUlIgZml4ZWQgcmFuZ2VzIGVuYWJsZWQ6ClsgICAgMC4wMDAwMDBdICAgMDAw
MDAtOUZGRkYgd3JpdGUtYmFjawpbICAgIDAuMDAwMDAwXSAgIEEwMDAwLUJGRkZGIHdyaXRl
LXRocm91Z2gKWyAgICAwLjAwMDAwMF0gICBDMDAwMC1DRkZGRiB3cml0ZS1wcm90ZWN0Clsg
ICAgMC4wMDAwMDBdICAgRDAwMDAtREZGRkYgdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSAg
IEUwMDAwLUZGRkZGIHdyaXRlLXByb3RlY3QKWyAgICAwLjAwMDAwMF0gTVRSUiB2YXJpYWJs
ZSByYW5nZXMgZW5hYmxlZDoKWyAgICAwLjAwMDAwMF0gICAwIGJhc2UgMDAwMDAwMDAwMDAw
IG1hc2sgRkZGRjgwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMDAwMF0gICAxIGJhc2Ug
MDAwMDgwMDAwMDAwIG1hc2sgRkZGRkMwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMDAw
MF0gICAyIGJhc2UgMDAwMEJEODAwMDAwIG1hc2sgRkZGRkZGODAwMDAwIHVuY2FjaGFibGUK
WyAgICAwLjAwMDAwMF0gICAzIGJhc2UgMDAwMEJFMDAwMDAwIG1hc2sgRkZGRkZFMDAwMDAw
IHVuY2FjaGFibGUKWyAgICAwLjAwMDAwMF0gICA0IGRpc2FibGVkClsgICAgMC4wMDAwMDBd
ICAgNSBkaXNhYmxlZApbICAgIDAuMDAwMDAwXSAgIDYgZGlzYWJsZWQKWyAgICAwLjAwMDAw
MF0gICA3IGRpc2FibGVkClsgICAgMC4wMDAwMDBdIFRPTTI6IDAwMDAwMDA0NDAwMDAwMDAg
YWthIDE3NDA4TQpbICAgIDAuMDAwMDAwXSB4ODYgUEFUIGVuYWJsZWQ6IGNwdSAwLCBvbGQg
MHg3MDQwNjAwMDcwNDA2LCBuZXcgMHg3MDEwNjAwMDcwMTA2ClsgICAgMC4wMDAwMDBdIG9y
aWdpbmFsIHZhcmlhYmxlIE1UUlJzClsgICAgMC4wMDAwMDBdIHJlZyAwLCBiYXNlOiAwR0Is
IHJhbmdlOiAyR0IsIHR5cGUgV0IKWyAgICAwLjAwMDAwMF0gcmVnIDEsIGJhc2U6IDJHQiwg
cmFuZ2U6IDFHQiwgdHlwZSBXQgpbICAgIDAuMDAwMDAwXSByZWcgMiwgYmFzZTogMzAzMk1C
LCByYW5nZTogOE1CLCB0eXBlIFVDClsgICAgMC4wMDAwMDBdIHJlZyAzLCBiYXNlOiAzMDQw
TUIsIHJhbmdlOiAzMk1CLCB0eXBlIFVDClsgICAgMC4wMDAwMDBdIHRvdGFsIFJBTSBjb3Zl
cmVkOiAzMDMyTQpbICAgIDAuMDAwMDAwXSBGb3VuZCBvcHRpbWFsIHNldHRpbmcgZm9yIG10
cnIgY2xlYW4gdXAKWyAgICAwLjAwMDAwMF0gIGdyYW5fc2l6ZTogNjRLIAljaHVua19zaXpl
OiA2NE0gCW51bV9yZWc6IDQgIAlsb3NlIGNvdmVyIFJBTTogMEcKWyAgICAwLjAwMDAwMF0g
TmV3IHZhcmlhYmxlIE1UUlJzClsgICAgMC4wMDAwMDBdIHJlZyAwLCBiYXNlOiAwR0IsIHJh
bmdlOiAyR0IsIHR5cGUgV0IKWyAgICAwLjAwMDAwMF0gcmVnIDEsIGJhc2U6IDJHQiwgcmFu
Z2U6IDFHQiwgdHlwZSBXQgpbICAgIDAuMDAwMDAwXSByZWcgMiwgYmFzZTogMzAzMk1CLCBy
YW5nZTogOE1CLCB0eXBlIFVDClsgICAgMC4wMDAwMDBdIHJlZyAzLCBiYXNlOiAzMDQwTUIs
IHJhbmdlOiAzMk1CLCB0eXBlIFVDClsgICAgMC4wMDAwMDBdIGU4MjA6IHVwZGF0ZSBbbWVt
IDB4YmQ4MDAwMDAtMHhmZmZmZmZmZl0gdXNhYmxlID09PiByZXNlcnZlZApbICAgIDAuMDAw
MDAwXSBlODIwOiBsYXN0X3BmbiA9IDB4YmQ4MDAgbWF4X2FyY2hfcGZuID0gMHg0MDAwMDAw
MDAKWyAgICAwLjAwMDAwMF0gU2Nhbm5pbmcgMSBhcmVhcyBmb3IgbG93IG1lbW9yeSBjb3Jy
dXB0aW9uClsgICAgMC4wMDAwMDBdIEJhc2UgbWVtb3J5IHRyYW1wb2xpbmUgYXQgW2ZmZmY4
ODAwMDAwOTgwMDBdIDk4MDAwIHNpemUgMjQ1NzYKWyAgICAwLjAwMDAwMF0gVXNpbmcgR0Ig
cGFnZXMgZm9yIGRpcmVjdCBtYXBwaW5nClsgICAgMC4wMDAwMDBdIGluaXRfbWVtb3J5X21h
cHBpbmc6IFttZW0gMHgwMDAwMDAwMC0weDAwMGZmZmZmXQpbICAgIDAuMDAwMDAwXSAgW21l
bSAweDAwMDAwMDAwLTB4MDAwZmZmZmZdIHBhZ2UgNGsKWyAgICAwLjAwMDAwMF0gQlJLIFsw
eDAxYzQ5MDAwLCAweDAxYzQ5ZmZmXSBQR1RBQkxFClsgICAgMC4wMDAwMDBdIEJSSyBbMHgw
MWM0YTAwMCwgMHgwMWM0YWZmZl0gUEdUQUJMRQpbICAgIDAuMDAwMDAwXSBCUksgWzB4MDFj
NGIwMDAsIDB4MDFjNGJmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlf
bWFwcGluZzogW21lbSAweDQzZmUwMDAwMC0weDQzZmZmZmZmZl0KWyAgICAwLjAwMDAwMF0g
IFttZW0gMHg0M2ZlMDAwMDAtMHg0M2ZmZmZmZmZdIHBhZ2UgMUcKWyAgICAwLjAwMDAwMF0g
aW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweDQzYzAwMDAwMC0weDQzZmRmZmZmZl0KWyAg
ICAwLjAwMDAwMF0gIFttZW0gMHg0M2MwMDAwMDAtMHg0M2ZkZmZmZmZdIHBhZ2UgMUcKWyAg
ICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweDQwMDAwMDAwMC0weDQz
YmZmZmZmZl0KWyAgICAwLjAwMDAwMF0gIFttZW0gMHg0MDAwMDAwMDAtMHg0M2JmZmZmZmZd
IHBhZ2UgMUcKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweDAw
MTAwMDAwLTB4YmE2NjdmZmZdClsgICAgMC4wMDAwMDBdICBbbWVtIDB4MDAxMDAwMDAtMHgw
MDFmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSAgW21lbSAweDAwMjAwMDAwLTB4M2Zm
ZmZmZmZdIHBhZ2UgMk0KWyAgICAwLjAwMDAwMF0gIFttZW0gMHg0MDAwMDAwMC0weDdmZmZm
ZmZmXSBwYWdlIDFHClsgICAgMC4wMDAwMDBdICBbbWVtIDB4ODAwMDAwMDAtMHhiYTVmZmZm
Zl0gcGFnZSAyTQpbICAgIDAuMDAwMDAwXSAgW21lbSAweGJhNjAwMDAwLTB4YmE2NjdmZmZd
IHBhZ2UgNGsKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweGJj
YTM4MDAwLTB4YmNhMzhmZmZdClsgICAgMC4wMDAwMDBdICBbbWVtIDB4YmNhMzgwMDAtMHhi
Y2EzOGZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSBCUksgWzB4MDFjNGMwMDAsIDB4MDFj
NGNmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21l
bSAweGJjYzNmMDAwLTB4YmQwODJmZmZdClsgICAgMC4wMDAwMDBdICBbbWVtIDB4YmNjM2Yw
MDAtMHhiY2RmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSAgW21lbSAweGJjZTAwMDAw
LTB4YmNmZmZmZmZdIHBhZ2UgMk0KWyAgICAwLjAwMDAwMF0gIFttZW0gMHhiZDAwMDAwMC0w
eGJkMDgyZmZmXSBwYWdlIDRrClsgICAgMC4wMDAwMDBdIEJSSyBbMHgwMWM0ZDAwMCwgMHgw
MWM0ZGZmZl0gUEdUQUJMRQpbICAgIDAuMDAwMDAwXSBCUksgWzB4MDFjNGUwMDAsIDB4MDFj
NGVmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21l
bSAweGJkN2Y0MDAwLTB4YmQ3ZmZmZmZdClsgICAgMC4wMDAwMDBdICBbbWVtIDB4YmQ3ZjQw
MDAtMHhiZDdmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSBpbml0X21lbW9yeV9tYXBw
aW5nOiBbbWVtIDB4MTAwMDAxMDAwLTB4M2ZmZmZmZmZmXQpbICAgIDAuMDAwMDAwXSAgW21l
bSAweDEwMDAwMTAwMC0weDEwMDFmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSAgW21l
bSAweDEwMDIwMDAwMC0weDEzZmZmZmZmZl0gcGFnZSAyTQpbICAgIDAuMDAwMDAwXSAgW21l
bSAweDE0MDAwMDAwMC0weDNmZmZmZmZmZl0gcGFnZSAxRwpbICAgIDAuMDAwMDAwXSBBQ1BJ
OiBSU0RQIDAwMDAwMDAwYmE5NGMwMDAgMDAwMjQgKHYwMiBBTEFTS0EpClsgICAgMC4wMDAw
MDBdIEFDUEk6IFhTRFQgMDAwMDAwMDBiYTk0YzA3OCAwMDA2NCAodjAxIEFMQVNLQSAgICBB
IE0gSSAwMTA3MjAwOSBBTUkgIDAwMDEwMDEzKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBGQUNQ
IDAwMDAwMDAwYmE5NTMxZjAgMDAxMEMgKHYwNSBBTEFTS0EgICAgQSBNIEkgMDEwNzIwMDkg
QU1JICAwMDAxMDAxMykKWyAgICAwLjAwMDAwMF0gQUNQSSBCSU9TIFdhcm5pbmcgKGJ1Zyk6
IE9wdGlvbmFsIEZBRFQgZmllbGQgUG0yQ29udHJvbEJsb2NrIGhhcyB6ZXJvIGFkZHJlc3Mg
b3IgbGVuZ3RoOiAweDAwMDAwMDAwMDAwMDAwMDAvMHgxICgyMDEzMDcyNS90YmZhZHQtNjAz
KQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBEU0RUIDAwMDAwMDAwYmE5NGMxNzAgMDcwNzkgKHYw
MiBBTEFTS0EgICAgQSBNIEkgMDAwMDAwMDAgSU5UTCAyMDA1MTExNykKWyAgICAwLjAwMDAw
MF0gQUNQSTogRkFDUyAwMDAwMDAwMGJiNzUxZjgwIDAwMDQwClsgICAgMC4wMDAwMDBdIEFD
UEk6IEFQSUMgMDAwMDAwMDBiYTk1MzMwMCAwMDA3RSAodjAzIEFMQVNLQSAgICBBIE0gSSAw
MTA3MjAwOSBBTUkgIDAwMDEwMDEzKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBGUERUIDAwMDAw
MDAwYmE5NTMzODAgMDAwNDQgKHYwMSBBTEFTS0EgICAgQSBNIEkgMDEwNzIwMDkgQU1JICAw
MDAxMDAxMykKWyAgICAwLjAwMDAwMF0gQUNQSTogTUNGRyAwMDAwMDAwMGJhOTUzM2M4IDAw
MDNDICh2MDEgQUxBU0tBICAgIEEgTSBJIDAxMDcyMDA5IE1TRlQgMDAwMTAwMTMpClsgICAg
MC4wMDAwMDBdIEFDUEk6IEhQRVQgMDAwMDAwMDBiYTk1MzQwOCAwMDAzOCAodjAxIEFMQVNL
QSAgICBBIE0gSSAwMTA3MjAwOSBBTUkgIDAwMDAwMDA1KQpbICAgIDAuMDAwMDAwXSBBQ1BJ
OiBJVlJTIDAwMDAwMDAwYmE5NTNkOTAgMDAwRDggKHYwMSAgQU1EICAgICBSRDg5MFMgMDAy
MDIwMzEgQU1EICAwMDAwMDAwMCkKWyAgICAwLjAwMDAwMF0gQUNQSTogQkdSVCAwMDAwMDAw
MGJhOTUzNDk4IDAwMDM4ICh2MDAgQUxBU0tBICAgIEEgTSBJIDAxMDcyMDA5IEFNSSAgMDAw
MTAwMTMpClsgICAgMC4wMDAwMDBdIEFDUEk6IFNTRFQgMDAwMDAwMDBiYTk1MzRkMCAwMDhC
QyAodjAxIEFNRCAgICBQT1dFUk5PVyAwMDAwMDAwMSBBTUQgIDAwMDAwMDAxKQpbICAgIDAu
MDAwMDAwXSBBQ1BJOiBMb2NhbCBBUElDIGFkZHJlc3MgMHhmZWUwMDAwMApbICAgIDAuMDAw
MDAwXSAgW2ZmZmZlYTAwMDAwMDAwMDAtZmZmZmVhMDAxMGZmZmZmZl0gUE1EIC0+IFtmZmZm
ODgwNDJmNjAwMDAwLWZmZmY4ODA0M2Y1ZmZmZmZdIG9uIG5vZGUgMApbICAgIDAuMDAwMDAw
XSBab25lIHJhbmdlczoKWyAgICAwLjAwMDAwMF0gICBETUEgICAgICBbbWVtIDB4MDAwMDEw
MDAtMHgwMGZmZmZmZl0KWyAgICAwLjAwMDAwMF0gICBETUEzMiAgICBbbWVtIDB4MDEwMDAw
MDAtMHhmZmZmZmZmZl0KWyAgICAwLjAwMDAwMF0gICBOb3JtYWwgICBbbWVtIDB4MTAwMDAw
MDAwLTB4NDNmZmZmZmZmXQpbICAgIDAuMDAwMDAwXSBNb3ZhYmxlIHpvbmUgc3RhcnQgZm9y
IGVhY2ggbm9kZQpbICAgIDAuMDAwMDAwXSBFYXJseSBtZW1vcnkgbm9kZSByYW5nZXMKWyAg
ICAwLjAwMDAwMF0gICBub2RlICAgMDogW21lbSAweDAwMDAxMDAwLTB4MDAwOWZmZmZdClsg
ICAgMC4wMDAwMDBdICAgbm9kZSAgIDA6IFttZW0gMHgwMDEwMDAwMC0weGJhNjY3ZmZmXQpb
ICAgIDAuMDAwMDAwXSAgIG5vZGUgICAwOiBbbWVtIDB4YmNhMzgwMDAtMHhiY2EzOGZmZl0K
WyAgICAwLjAwMDAwMF0gICBub2RlICAgMDogW21lbSAweGJjYzNmMDAwLTB4YmQwODJmZmZd
ClsgICAgMC4wMDAwMDBdICAgbm9kZSAgIDA6IFttZW0gMHhiZDdmNDAwMC0weGJkN2ZmZmZm
XQpbICAgIDAuMDAwMDAwXSAgIG5vZGUgICAwOiBbbWVtIDB4MTAwMDAxMDAwLTB4NDNmZmZm
ZmZmXQpbICAgIDAuMDAwMDAwXSBPbiBub2RlIDAgdG90YWxwYWdlczogNDE3MjM3NQpbICAg
IDAuMDAwMDAwXSAgIERNQSB6b25lOiA2NCBwYWdlcyB1c2VkIGZvciBtZW1tYXAKWyAgICAw
LjAwMDAwMF0gICBETUEgem9uZTogMjcgcGFnZXMgcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0g
ICBETUEgem9uZTogMzk5OSBwYWdlcywgTElGTyBiYXRjaDowClsgICAgMC4wMDAwMDBdICAg
RE1BMzIgem9uZTogMTE4ODMgcGFnZXMgdXNlZCBmb3IgbWVtbWFwClsgICAgMC4wMDAwMDBd
ICAgRE1BMzIgem9uZTogNzYwNTA1IHBhZ2VzLCBMSUZPIGJhdGNoOjMxClsgICAgMC4wMDAw
MDBdICAgTm9ybWFsIHpvbmU6IDUzMjQ4IHBhZ2VzIHVzZWQgZm9yIG1lbW1hcApbICAgIDAu
MDAwMDAwXSAgIE5vcm1hbCB6b25lOiAzNDA3ODcxIHBhZ2VzLCBMSUZPIGJhdGNoOjMxClsg
ICAgMC4wMDAwMDBdIEFDUEk6IFBNLVRpbWVyIElPIFBvcnQ6IDB4ODA4ClsgICAgMC4wMDAw
MDBdIEFDUEk6IExvY2FsIEFQSUMgYWRkcmVzcyAweGZlZTAwMDAwClsgICAgMC4wMDAwMDBd
IEFDUEk6IExBUElDIChhY3BpX2lkWzB4MDFdIGxhcGljX2lkWzB4MDBdIGVuYWJsZWQpClsg
ICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3BpX2lkWzB4MDJdIGxhcGljX2lkWzB4MDFd
IGVuYWJsZWQpClsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3BpX2lkWzB4MDNdIGxh
cGljX2lkWzB4MDJdIGVuYWJsZWQpClsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3Bp
X2lkWzB4MDRdIGxhcGljX2lkWzB4MDNdIGVuYWJsZWQpClsgICAgMC4wMDAwMDBdIEFDUEk6
IExBUElDX05NSSAoYWNwaV9pZFsweGZmXSBoaWdoIGVkZ2UgbGludFsweDFdKQpbICAgIDAu
MDAwMDAwXSBBQ1BJOiBJT0FQSUMgKGlkWzB4MDVdIGFkZHJlc3NbMHhmZWMwMDAwMF0gZ3Np
X2Jhc2VbMF0pClsgICAgMC4wMDAwMDBdIElPQVBJQ1swXTogYXBpY19pZCA1LCB2ZXJzaW9u
IDMzLCBhZGRyZXNzIDB4ZmVjMDAwMDAsIEdTSSAwLTIzClsgICAgMC4wMDAwMDBdIEFDUEk6
IElPQVBJQyAoaWRbMHgwNl0gYWRkcmVzc1sweGZlYzIwMDAwXSBnc2lfYmFzZVsyNF0pClsg
ICAgMC4wMDAwMDBdIElPQVBJQ1sxXTogYXBpY19pZCA2LCB2ZXJzaW9uIDMzLCBhZGRyZXNz
IDB4ZmVjMjAwMDAsIEdTSSAyNC01NQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJTlRfU1JDX09W
UiAoYnVzIDAgYnVzX2lycSAwIGdsb2JhbF9pcnEgMiBkZmwgZGZsKQpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSA5IGdsb2JhbF9pcnEgOSBsb3cg
bGV2ZWwpClsgICAgMC4wMDAwMDBdIEFDUEk6IElSUTAgdXNlZCBieSBvdmVycmlkZS4KWyAg
ICAwLjAwMDAwMF0gQUNQSTogSVJRMiB1c2VkIGJ5IG92ZXJyaWRlLgpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBJUlE5IHVzZWQgYnkgb3ZlcnJpZGUuClsgICAgMC4wMDAwMDBdIFVzaW5nIEFD
UEkgKE1BRFQpIGZvciBTTVAgY29uZmlndXJhdGlvbiBpbmZvcm1hdGlvbgpbICAgIDAuMDAw
MDAwXSBBQ1BJOiBIUEVUIGlkOiAweDQzNTM4MjEwIGJhc2U6IDB4ZmVkMDAwMDAKWyAgICAw
LjAwMDAwMF0gc21wYm9vdDogQWxsb3dpbmcgNCBDUFVzLCAwIGhvdHBsdWcgQ1BVcwpbICAg
IDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNzIKWyAgICAwLjAwMDAwMF0gZTgyMDogW21lbSAw
eGJkODAwMDAwLTB4ZjdmZmZmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMKWyAgICAw
LjAwMDAwMF0gc2V0dXBfcGVyY3B1OiBOUl9DUFVTOjggbnJfY3B1bWFza19iaXRzOjggbnJf
Y3B1X2lkczo0IG5yX25vZGVfaWRzOjEKWyAgICAwLjAwMDAwMF0gUEVSQ1BVOiBFbWJlZGRl
ZCAyNyBwYWdlcy9jcHUgQGZmZmY4ODA0M2ZjMDAwMDAgczc5NDI0IHI4MTkyIGQyMjk3NiB1
NTI0Mjg4ClsgICAgMC4wMDAwMDBdIHBjcHUtYWxsb2M6IHM3OTQyNCByODE5MiBkMjI5NzYg
dTUyNDI4OCBhbGxvYz0xKjIwOTcxNTIKWyAgICAwLjAwMDAwMF0gcGNwdS1hbGxvYzogWzBd
IDAgMSAyIDMgClsgICAgMC4wMDAwMDBdIEJ1aWx0IDEgem9uZWxpc3RzIGluIFpvbmUgb3Jk
ZXIsIG1vYmlsaXR5IGdyb3VwaW5nIG9uLiAgVG90YWwgcGFnZXM6IDQxMDcxNTMKWyAgICAw
LjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTogQk9PVF9JTUFHRT0vYm9vdC92bWxpbnV6
LTMuMTIuMjMgcm9vdD0vZGV2L3NkYTIgcm8KWyAgICAwLjAwMDAwMF0gUElEIGhhc2ggdGFi
bGUgZW50cmllczogNDA5NiAob3JkZXI6IDMsIDMyNzY4IGJ5dGVzKQpbICAgIDAuMDAwMDAw
XSBEZW50cnkgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyMDk3MTUyIChvcmRlcjogMTIs
IDE2Nzc3MjE2IGJ5dGVzKQpbICAgIDAuMDAwMDAwXSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxl
IGVudHJpZXM6IDEwNDg1NzYgKG9yZGVyOiAxMSwgODM4ODYwOCBieXRlcykKWyAgICAwLjAw
MDAwMF0gTWVtb3J5OiAxNjExMDEyMEsvMTY2ODk1MDBLIGF2YWlsYWJsZSAoNjAwM0sga2Vy
bmVsIGNvZGUsIDU0MUsgcndkYXRhLCAyODk2SyByb2RhdGEsIDgzNksgaW5pdCwgOTI4SyBi
c3MsIDU3OTM4MEsgcmVzZXJ2ZWQpClsgICAgMC4wMDAwMDBdIFNMVUI6IEhXYWxpZ249NjQs
IE9yZGVyPTAtMywgTWluT2JqZWN0cz0wLCBDUFVzPTQsIE5vZGVzPTEKWyAgICAwLjAwMDAw
MF0gSGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAwMF0gCVJD
VSByZXN0cmljdGluZyBDUFVzIGZyb20gTlJfQ1BVUz04IHRvIG5yX2NwdV9pZHM9NC4KWyAg
ICAwLjAwMDAwMF0gTlJfSVJRUzo0MzUyIG5yX2lycXM6MTAyNCAxNgpbICAgIDAuMDAwMDAw
XSBDb25zb2xlOiBjb2xvdXIgZHVtbXkgZGV2aWNlIDgweDI1ClsgICAgMC4wMDAwMDBdIGNv
bnNvbGUgW3R0eTBdIGVuYWJsZWQKWyAgICAwLjAwMDAwMF0gaHBldCBjbG9ja2V2ZW50IHJl
Z2lzdGVyZWQKWyAgICAwLjAwMDAwMF0gdHNjOiBGYXN0IFRTQyBjYWxpYnJhdGlvbiB1c2lu
ZyBQSVQKWyAgICAwLjAwMzMzM10gdHNjOiBEZXRlY3RlZCAzNDY3Ljc5MSBNSHogcHJvY2Vz
c29yClsgICAgMC4wMDAwMDJdIENhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpLCB2
YWx1ZSBjYWxjdWxhdGVkIHVzaW5nIHRpbWVyIGZyZXF1ZW5jeS4uIDY5MzguNTYgQm9nb01J
UFMgKGxwaj0xMTU1OTMwMykKWyAgICAwLjAwMDAwN10gcGlkX21heDogZGVmYXVsdDogMzI3
NjggbWluaW11bTogMzAxClsgICAgMC4wMDAwMjJdIGluaXRfbWVtb3J5X21hcHBpbmc6IFtt
ZW0gMHhiYjc1NzAwMC0weGJjOWM5ZmZmXQpbICAgIDAuMDAwMDI1XSAgW21lbSAweGJiNzU3
MDAwLTB4YmI3ZmZmZmZdIHBhZ2UgNGsKWyAgICAwLjAwMDAyNl0gIFttZW0gMHhiYjgwMDAw
MC0weGJjN2ZmZmZmXSBwYWdlIDJNClsgICAgMC4wMDAwMjddICBbbWVtIDB4YmM4MDAwMDAt
MHhiYzljOWZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDQxXSBpbml0X21lbW9yeV9tYXBwaW5n
OiBbbWVtIDB4YmM5Y2EwMDAtMHhiY2EzN2ZmZl0KWyAgICAwLjAwMDA0M10gIFttZW0gMHhi
YzljYTAwMC0weGJjYTM3ZmZmXSBwYWdlIDRrClsgICAgMC4wMDAwNDhdIGluaXRfbWVtb3J5
X21hcHBpbmc6IFttZW0gMHhiZDA4MzAwMC0weGJkN2YzZmZmXQpbICAgIDAuMDAwMDUwXSAg
W21lbSAweGJkMDgzMDAwLTB4YmQxZmZmZmZdIHBhZ2UgNGsKWyAgICAwLjAwMDA1MV0gIFtt
ZW0gMHhiZDIwMDAwMC0weGJkNWZmZmZmXSBwYWdlIDJNClsgICAgMC4wMDAwNTJdICBbbWVt
IDB4YmQ2MDAwMDAtMHhiZDdmM2ZmZl0gcGFnZSA0awpbICAgIDAuMDA0ODY5XSBTZWN1cml0
eSBGcmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAwLjAwNDg3OF0gTW91bnQtY2FjaGUgaGFz
aCB0YWJsZSBlbnRyaWVzOiAyNTYKWyAgICAwLjAwNTAxOF0gSW5pdGlhbGl6aW5nIGNncm91
cCBzdWJzeXMgYmxraW8KWyAgICAwLjAwNTAzNF0gdHNlZzogMDBiZDgwMDAwMApbICAgIDAu
MDA1MDM2XSBDUFU6IFBoeXNpY2FsIFByb2Nlc3NvciBJRDogMApbICAgIDAuMDA1MDM4XSBD
UFU6IFByb2Nlc3NvciBDb3JlIElEOiAwClsgICAgMC4wMDUwNDFdIG1jZTogQ1BVIHN1cHBv
cnRzIDYgTUNFIGJhbmtzClsgICAgMC4wMDUwNDZdIExWVCBvZmZzZXQgMCBhc3NpZ25lZCBm
b3IgdmVjdG9yIDB4ZjkKWyAgICAwLjAwNTA1MF0gcHJvY2VzczogdXNpbmcgQU1EIEU0MDAg
YXdhcmUgaWRsZSByb3V0aW5lClsgICAgMC4wMDUwNTNdIExhc3QgbGV2ZWwgaVRMQiBlbnRy
aWVzOiA0S0IgNTEyLCAyTUIgMTYsIDRNQiA4Ckxhc3QgbGV2ZWwgZFRMQiBlbnRyaWVzOiA0
S0IgNTEyLCAyTUIgMTI4LCA0TUIgNjQKdGxiX2ZsdXNoYWxsX3NoaWZ0OiA0ClsgICAgMC4w
MDUxMjZdIEZyZWVpbmcgU01QIGFsdGVybmF0aXZlcyBtZW1vcnk6IDI0SyAoZmZmZmZmZmY4
MWI1YTAwMCAtIGZmZmZmZmZmODFiNjAwMDApClsgICAgMC4wMDUxMjldIEFDUEk6IENvcmUg
cmV2aXNpb24gMjAxMzA3MjUKWyAgICAwLjAwNjYyOV0gQUNQSTogQWxsIEFDUEkgVGFibGVz
IHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMjk1MTkxXSAuLlRJTUVSOiB2ZWN0b3I9
MHgzMCBhcGljMT0wIHBpbjE9MiBhcGljMj0tMSBwaW4yPS0xClsgICAgMC4zMjgxNjVdIHNt
cGJvb3Q6IENQVTA6IEFNRCBQaGVub20odG0pIElJIFg0IDk1NSBQcm9jZXNzb3IgKGZhbTog
MTAsIG1vZGVsOiAwNCwgc3RlcHBpbmc6IDAyKQpbICAgIDAuNDMzMDMwXSBQZXJmb3JtYW5j
ZSBFdmVudHM6IEFNRCBQTVUgZHJpdmVyLgpbICAgIDAuNDMzMDM1XSAuLi4gdmVyc2lvbjog
ICAgICAgICAgICAgICAgMApbICAgIDAuNDMzMDM3XSAuLi4gYml0IHdpZHRoOiAgICAgICAg
ICAgICAgNDgKWyAgICAwLjQzMzAzOF0gLi4uIGdlbmVyaWMgcmVnaXN0ZXJzOiAgICAgIDQK
WyAgICAwLjQzMzA0MF0gLi4uIHZhbHVlIG1hc2s6ICAgICAgICAgICAgIDAwMDBmZmZmZmZm
ZmZmZmYKWyAgICAwLjQzMzA0Ml0gLi4uIG1heCBwZXJpb2Q6ICAgICAgICAgICAgIDAwMDA3
ZmZmZmZmZmZmZmYKWyAgICAwLjQzMzA0M10gLi4uIGZpeGVkLXB1cnBvc2UgZXZlbnRzOiAg
IDAKWyAgICAwLjQzMzA0NV0gLi4uIGV2ZW50IG1hc2s6ICAgICAgICAgICAgIDAwMDAwMDAw
MDAwMDAwMGYKWyAgICAwLjQzMzE4M10gTUNFOiBJbi1rZXJuZWwgTUNFIGRlY29kaW5nIGVu
YWJsZWQuClsgICAgMC40NDYzNzRdIHByb2Nlc3M6IFN5c3RlbSBoYXMgQU1EIEMxRSBlbmFi
bGVkClsgICAgMC40NDYzODldIHByb2Nlc3M6IFN3aXRjaCB0byBicm9hZGNhc3QgbW9kZSBv
biBDUFUxClsgICAgMC40NTk1MzNdIHByb2Nlc3M6IFN3aXRjaCB0byBicm9hZGNhc3QgbW9k
ZSBvbiBDUFUyClsgICAgMC40MzMyNDhdIHNtcGJvb3Q6IEJvb3RpbmcgTm9kZSAgIDAsIFBy
b2Nlc3NvcnMgICMgICAxICMgICAyICMgICAzIE9LClsgICAgMC40NzI2NzRdIEJyb3VnaHQg
dXAgNCBDUFVzClsgICAgMC40NzI2NzddIHNtcGJvb3Q6IFRvdGFsIG9mIDQgcHJvY2Vzc29y
cyBhY3RpdmF0ZWQgKDI3NzUzLjI1IEJvZ29NSVBTKQpbICAgIDAuNDcyNjg1XSBwcm9jZXNz
OiBTd2l0Y2ggdG8gYnJvYWRjYXN0IG1vZGUgb24gQ1BVMwpbICAgIDAuNDc2NjIwXSBwcm9j
ZXNzOiBTd2l0Y2ggdG8gYnJvYWRjYXN0IG1vZGUgb24gQ1BVMApbICAgIDAuNDc2NzczXSBk
ZXZ0bXBmczogaW5pdGlhbGl6ZWQKWyAgICAwLjQ3NjkwNF0gUE06IFJlZ2lzdGVyaW5nIEFD
UEkgTlZTIHJlZ2lvbiBbbWVtIDB4YmE5NTQwMDAtMHhiYjc1NmZmZl0gKDE0NjkyMzUyIGJ5
dGVzKQpbICAgIDAuNDc3MDMwXSBQTTogUmVnaXN0ZXJpbmcgQUNQSSBOVlMgcmVnaW9uIFtt
ZW0gMHhiY2EzOTAwMC0weGJjYzNlZmZmXSAoMjEyMTcyOCBieXRlcykKWyAgICAwLjQ3NzE1
Ml0ga3dvcmtlci91ODowICgyNikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNTg2NCBi
eXRlcyBsZWZ0ClsgICAgMC40NzcyNDFdIHhvcjogbWVhc3VyaW5nIHNvZnR3YXJlIGNoZWNr
c3VtIHNwZWVkClsgICAgMC41MDk2ODFdICAgIHByZWZldGNoNjQtc3NlOiAxNDA3Mi40MDAg
TUIvc2VjClsgICAgMC41NDI5ODFdICAgIGdlbmVyaWNfc3NlOiAxMzM5MC44MDAgTUIvc2Vj
ClsgICAgMC41NDI5ODNdIHhvcjogdXNpbmcgZnVuY3Rpb246IHByZWZldGNoNjQtc3NlICgx
NDA3Mi40MDAgTUIvc2VjKQpbICAgIDAuNTQyOTg4XSBhdG9taWM2NCB0ZXN0IHBhc3NlZCBm
b3IgeDg2LTY0IHBsYXRmb3JtIHdpdGggQ1g4IGFuZCB3aXRoIFNTRQpbICAgIDAuNTQzMDAy
XSBSVEMgdGltZTogMTc6Mzk6MzQsIGRhdGU6IDExLzExLzE0ClsgICAgMC41NDMwMzldIE5F
VDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTYKWyAgICAwLjU0MzM1OF0gY3B1aWRs
ZTogdXNpbmcgZ292ZXJub3IgbGFkZGVyClsgICAgMC41NDMzNjBdIGNwdWlkbGU6IHVzaW5n
IGdvdmVybm9yIG1lbnUKWyAgICAwLjU0MzM2NV0gbm9kZSAwIGxpbmsgMDogaW8gcG9ydCBb
YjAwMCwgZmZmZl0KWyAgICAwLjU0MzM2N10gVE9NOiAwMDAwMDAwMGMwMDAwMDAwIGFrYSAz
MDcyTQpbICAgIDAuNTQzMzcwXSBGYW0gMTBoIG1tY29uZiBbbWVtIDB4ZTAwMDAwMDAtMHhl
ZmZmZmZmZl0KWyAgICAwLjU0MzM3Ml0gbm9kZSAwIGxpbmsgMDogbW1pbyBbYzAwMDAwMDAs
IGZlZjBmZmZmXSA9PT4gW2MwMDAwMDAwLCBkZmZmZmZmZl0gYW5kIFtmMDAwMDAwMCwgZmVm
MGZmZmZdClsgICAgMC41NDMzNzZdIFRPTTI6IDAwMDAwMDA0NDAwMDAwMDAgYWthIDE3NDA4
TQpbICAgIDAuNTQzMzc4XSBidXM6IFtidXMgMDAtMWZdIG9uIG5vZGUgMCBsaW5rIDAKWyAg
ICAwLjU0MzM3OV0gYnVzOiAwMCBbaW8gIDB4MDAwMC0weGZmZmZdClsgICAgMC41NDMzODBd
IGJ1czogMDAgW21lbSAweGMwMDAwMDAwLTB4ZGZmZmZmZmZdClsgICAgMC41NDMzODFdIGJ1
czogMDAgW21lbSAweGYwMDAwMDAwLTB4ZmZmZmZmZmZdClsgICAgMC41NDMzODJdIGJ1czog
MDAgW21lbSAweDQ0MDAwMDAwMC0weGZjZmZmZmZmZmZdClsgICAgMC41NDM0MTddIEFDUEk6
IGJ1cyB0eXBlIFBDSSByZWdpc3RlcmVkClsgICAgMC41NDM0ODddIFBDSTogTU1DT05GSUcg
Zm9yIGRvbWFpbiAwMDAwIFtidXMgMDAtZmZdIGF0IFttZW0gMHhlMDAwMDAwMC0weGVmZmZm
ZmZmXSAoYmFzZSAweGUwMDAwMDAwKQpbICAgIDAuNTQzNDkxXSBQQ0k6IG5vdCB1c2luZyBN
TUNPTkZJRwpbICAgIDAuNTQzNDkzXSBQQ0k6IFVzaW5nIGNvbmZpZ3VyYXRpb24gdHlwZSAx
IGZvciBiYXNlIGFjY2VzcwpbICAgIDAuNTQzNDk1XSBQQ0k6IFVzaW5nIGNvbmZpZ3VyYXRp
b24gdHlwZSAxIGZvciBleHRlbmRlZCBhY2Nlc3MKWyAgICAwLjU0NzgxMF0gYmlvOiBjcmVh
dGUgc2xhYiA8YmlvLTA+IGF0IDAKWyAgICAwLjYwMjkyNV0gcmFpZDY6IHNzZTJ4MSAgICA0
MzE3IE1CL3MKWyAgICAwLjY1OTUzNl0gcmFpZDY6IHNzZTJ4MiAgICA3MzA3IE1CL3MKWyAg
ICAwLjcxNjE1MV0gcmFpZDY6IHNzZTJ4NCAgICA4MTM5IE1CL3MKWyAgICAwLjcxNjE1M10g
cmFpZDY6IHVzaW5nIGFsZ29yaXRobSBzc2UyeDQgKDgxMzkgTUIvcykKWyAgICAwLjcxNjE1
NV0gcmFpZDY6IHVzaW5nIGludHgxIHJlY292ZXJ5IGFsZ29yaXRobQpbICAgIDAuNzE2MjMy
XSBBQ1BJOiBBZGRlZCBfT1NJKE1vZHVsZSBEZXZpY2UpClsgICAgMC43MTYyMzVdIEFDUEk6
IEFkZGVkIF9PU0koUHJvY2Vzc29yIERldmljZSkKWyAgICAwLjcxNjIzNl0gQUNQSTogQWRk
ZWQgX09TSSgzLjAgX1NDUCBFeHRlbnNpb25zKQpbICAgIDAuNzE2MjM4XSBBQ1BJOiBBZGRl
ZCBfT1NJKFByb2Nlc3NvciBBZ2dyZWdhdG9yIERldmljZSkKWyAgICAwLjcxNjcyN10gQUNQ
STogRUM6IExvb2sgdXAgRUMgaW4gRFNEVApbICAgIDAuNzE3MjIzXSBBQ1BJOiBFeGVjdXRl
ZCAyIGJsb2NrcyBvZiBtb2R1bGUtbGV2ZWwgZXhlY3V0YWJsZSBBTUwgY29kZQpbICAgIDAu
NzI5ODU3XSBBQ1BJOiBJbnRlcnByZXRlciBlbmFibGVkClsgICAgMC43Mjk4NjRdIEFDUEkg
RXhjZXB0aW9uOiBBRV9OT1RfRk9VTkQsIFdoaWxlIGV2YWx1YXRpbmcgU2xlZXAgU3RhdGUg
W1xfUzFfXSAoMjAxMzA3MjUvaHd4ZmFjZS01NzEpClsgICAgMC43Mjk4NjldIEFDUEkgRXhj
ZXB0aW9uOiBBRV9OT1RfRk9VTkQsIFdoaWxlIGV2YWx1YXRpbmcgU2xlZXAgU3RhdGUgW1xf
UzJfXSAoMjAxMzA3MjUvaHd4ZmFjZS01NzEpClsgICAgMC43Mjk4NzhdIEFDUEk6IChzdXBw
b3J0cyBTMCBTMyBTNSkKWyAgICAwLjcyOTg4MF0gQUNQSTogVXNpbmcgSU9BUElDIGZvciBp
bnRlcnJ1cHQgcm91dGluZwpbICAgIDAuNzI5OTczXSBQQ0k6IE1NQ09ORklHIGZvciBkb21h
aW4gMDAwMCBbYnVzIDAwLWZmXSBhdCBbbWVtIDB4ZTAwMDAwMDAtMHhlZmZmZmZmZl0gKGJh
c2UgMHhlMDAwMDAwMCkKWyAgICAwLjcyOTk5N10gUENJOiBNTUNPTkZJRyBhdCBbbWVtIDB4
ZTAwMDAwMDAtMHhlZmZmZmZmZl0gcmVzZXJ2ZWQgaW4gQUNQSSBtb3RoZXJib2FyZCByZXNv
dXJjZXMKWyAgICAwLjczOTc4M10gUENJOiBVc2luZyBob3N0IGJyaWRnZSB3aW5kb3dzIGZy
b20gQUNQSTsgaWYgbmVjZXNzYXJ5LCB1c2UgInBjaT1ub2NycyIgYW5kIHJlcG9ydCBhIGJ1
ZwpbICAgIDAuNzM5ODUxXSBBQ1BJOiBObyBkb2NrIGRldmljZXMgZm91bmQuClsgICAgMC43
NTU3MjFdIEFDUEk6IFBDSSBSb290IEJyaWRnZSBbUENJMF0gKGRvbWFpbiAwMDAwIFtidXMg
MDAtZmZdKQpbICAgIDAuNzU1NzI3XSBhY3BpIFBOUDBBMDM6MDA6IEFDUEkgX09TQyBzdXBw
b3J0IG5vdGlmaWNhdGlvbiBmYWlsZWQsIGRpc2FibGluZyBQQ0llIEFTUE0KWyAgICAwLjc1
NTczMF0gYWNwaSBQTlAwQTAzOjAwOiBVbmFibGUgdG8gcmVxdWVzdCBfT1NDIGNvbnRyb2wg
KF9PU0Mgc3VwcG9ydCBtYXNrOiAweDA4KQpbICAgIDAuNzU1OTI3XSBQQ0kgaG9zdCBicmlk
Z2UgdG8gYnVzIDAwMDA6MDAKWyAgICAwLjc1NTkzMV0gcGNpX2J1cyAwMDAwOjAwOiByb290
IGJ1cyByZXNvdXJjZSBbYnVzIDAwLWZmXQpbICAgIDAuNzU1OTMzXSBwY2lfYnVzIDAwMDA6
MDA6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAgMHgwMDAwLTB4MDNhZl0KWyAgICAwLjc1NTkz
Nl0gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbaW8gIDB4MDNlMC0weDBj
ZjddClsgICAgMC43NTU5MzhdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2Ug
W2lvICAweDAzYjAtMHgwM2RmXQpbICAgIDAuNzU1OTQxXSBwY2lfYnVzIDAwMDA6MDA6IHJv
b3QgYnVzIHJlc291cmNlIFtpbyAgMHgwZDAwLTB4ZmZmZl0KWyAgICAwLjc1NTk0NF0gcGNp
X2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4MDAwYTAwMDAtMHgwMDBi
ZmZmZl0KWyAgICAwLjc1NTk0N10gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJj
ZSBbbWVtIDB4MDAwYzAwMDAtMHgwMDBkZmZmZl0KWyAgICAwLjc1NTk0OV0gcGNpX2J1cyAw
MDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4YzAwMDAwMDAtMHhmZmZmZmZmZl0K
WyAgICAwLjc1NTk2Ml0gcGNpIDAwMDA6MDA6MDAuMDogWzEwMDI6NWExNF0gdHlwZSAwMCBj
bGFzcyAweDA2MDAwMApbICAgIDAuNzU2MDc2XSBwY2kgMDAwMDowMDowMC4yOiBbMTAwMjo1
YTIzXSB0eXBlIDAwIGNsYXNzIDB4MDgwNjAwClsgICAgMC43NTYxODRdIHBjaSAwMDAwOjAw
OjAyLjA6IFsxMDAyOjVhMTZdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAgICAwLjc1NjI0
N10gcGNpIDAwMDA6MDA6MDIuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2Nv
bGQKWyAgICAwLjc1NjI4NF0gcGNpIDAwMDA6MDA6MDIuMDogU3lzdGVtIHdha2V1cCBkaXNh
YmxlZCBieSBBQ1BJClsgICAgMC43NTYzMjddIHBjaSAwMDAwOjAwOjA0LjA6IFsxMDAyOjVh
MThdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAgICAwLjc1NjM1OF0gcGNpIDAwMDA6MDA6
MDQuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAwLjc1NjM5
M10gcGNpIDAwMDA6MDA6MDQuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJClsg
ICAgMC43NTY0MzRdIHBjaSAwMDAwOjAwOjA1LjA6IFsxMDAyOjVhMTldIHR5cGUgMDEgY2xh
c3MgMHgwNjA0MDAKWyAgICAwLjc1NjQ2NV0gcGNpIDAwMDA6MDA6MDUuMDogUE1FIyBzdXBw
b3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAwLjc1NjUwMF0gcGNpIDAwMDA6MDA6
MDUuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJClsgICAgMC43NTY1NDBdIHBj
aSAwMDAwOjAwOjA2LjA6IFsxMDAyOjVhMWFdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAg
ICAwLjc1NjU3MV0gcGNpIDAwMDA6MDA6MDYuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBE
M2hvdCBEM2NvbGQKWyAgICAwLjc1NjYwNl0gcGNpIDAwMDA6MDA6MDYuMDogU3lzdGVtIHdh
a2V1cCBkaXNhYmxlZCBieSBBQ1BJClsgICAgMC43NTY2NTFdIHBjaSAwMDAwOjAwOjA3LjA6
IFsxMDAyOjVhMWJdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAgICAwLjc1NjY4MV0gcGNp
IDAwMDA6MDA6MDcuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAg
ICAwLjc1NjcxN10gcGNpIDAwMDA6MDA6MDcuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBi
eSBBQ1BJClsgICAgMC43NTY3NzBdIHBjaSAwMDAwOjAwOjExLjA6IFsxMDAyOjQzOTFdIHR5
cGUgMDAgY2xhc3MgMHgwMTA2MDEKWyAgICAwLjc1Njc4NV0gcGNpIDAwMDA6MDA6MTEuMDog
cmVnIDB4MTA6IFtpbyAgMHhmMDQwLTB4ZjA0N10KWyAgICAwLjc1Njc5M10gcGNpIDAwMDA6
MDA6MTEuMDogcmVnIDB4MTQ6IFtpbyAgMHhmMDMwLTB4ZjAzM10KWyAgICAwLjc1NjgwMF0g
cGNpIDAwMDA6MDA6MTEuMDogcmVnIDB4MTg6IFtpbyAgMHhmMDIwLTB4ZjAyN10KWyAgICAw
Ljc1NjgwN10gcGNpIDAwMDA6MDA6MTEuMDogcmVnIDB4MWM6IFtpbyAgMHhmMDEwLTB4ZjAx
M10KWyAgICAwLjc1NjgxNF0gcGNpIDAwMDA6MDA6MTEuMDogcmVnIDB4MjA6IFtpbyAgMHhm
MDAwLTB4ZjAwZl0KWyAgICAwLjc1NjgyMl0gcGNpIDAwMDA6MDA6MTEuMDogcmVnIDB4MjQ6
IFttZW0gMHhmZWEwYjAwMC0weGZlYTBiM2ZmXQpbICAgIDAuNzU2OTI3XSBwY2kgMDAwMDow
MDoxMi4wOiBbMTAwMjo0Mzk3XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzEwClsgICAgMC43NTY5
MzddIHBjaSAwMDAwOjAwOjEyLjA6IHJlZyAweDEwOiBbbWVtIDB4ZmVhMGEwMDAtMHhmZWEw
YWZmZl0KWyAgICAwLjc1NzAwOF0gcGNpIDAwMDA6MDA6MTIuMDogU3lzdGVtIHdha2V1cCBk
aXNhYmxlZCBieSBBQ1BJClsgICAgMC43NTcwNTNdIHBjaSAwMDAwOjAwOjEyLjI6IFsxMDAy
OjQzOTZdIHR5cGUgMDAgY2xhc3MgMHgwYzAzMjAKWyAgICAwLjc1NzA2OF0gcGNpIDAwMDA6
MDA6MTIuMjogcmVnIDB4MTA6IFttZW0gMHhmZWEwOTAwMC0weGZlYTA5MGZmXQpbICAgIDAu
NzU3MTMwXSBwY2kgMDAwMDowMDoxMi4yOiBzdXBwb3J0cyBEMSBEMgpbICAgIDAuNzU3MTMx
XSBwY2kgMDAwMDowMDoxMi4yOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQxIEQyIEQzaG90
ClsgICAgMC43NTcxNjddIHBjaSAwMDAwOjAwOjEyLjI6IFN5c3RlbSB3YWtldXAgZGlzYWJs
ZWQgYnkgQUNQSQpbICAgIDAuNzU3MjExXSBwY2kgMDAwMDowMDoxMy4wOiBbMTAwMjo0Mzk3
XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzEwClsgICAgMC43NTcyMjFdIHBjaSAwMDAwOjAwOjEz
LjA6IHJlZyAweDEwOiBbbWVtIDB4ZmVhMDgwMDAtMHhmZWEwOGZmZl0KWyAgICAwLjc1NzI5
Ml0gcGNpIDAwMDA6MDA6MTMuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJClsg
ICAgMC43NTczNjldIHBjaSAwMDAwOjAwOjEzLjI6IFsxMDAyOjQzOTZdIHR5cGUgMDAgY2xh
c3MgMHgwYzAzMjAKWyAgICAwLjc1NzM4M10gcGNpIDAwMDA6MDA6MTMuMjogcmVnIDB4MTA6
IFttZW0gMHhmZWEwNzAwMC0weGZlYTA3MGZmXQpbICAgIDAuNzU3NDQ2XSBwY2kgMDAwMDow
MDoxMy4yOiBzdXBwb3J0cyBEMSBEMgpbICAgIDAuNzU3NDQ3XSBwY2kgMDAwMDowMDoxMy4y
OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQxIEQyIEQzaG90ClsgICAgMC43NTc0ODNdIHBj
aSAwMDAwOjAwOjEzLjI6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQpbICAgIDAu
NzU3NTI3XSBwY2kgMDAwMDowMDoxNC4wOiBbMTAwMjo0Mzg1XSB0eXBlIDAwIGNsYXNzIDB4
MGMwNTAwClsgICAgMC43NTc2NDFdIHBjaSAwMDAwOjAwOjE0LjI6IFsxMDAyOjQzODNdIHR5
cGUgMDAgY2xhc3MgMHgwNDAzMDAKWyAgICAwLjc1NzY1N10gcGNpIDAwMDA6MDA6MTQuMjog
cmVnIDB4MTA6IFttZW0gMHhmZWEwMDAwMC0weGZlYTAzZmZmIDY0Yml0XQpbICAgIDAuNzU3
NzA3XSBwY2kgMDAwMDowMDoxNC4yOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQz
Y29sZApbICAgIDAuNzU3NzQwXSBwY2kgMDAwMDowMDoxNC4yOiBTeXN0ZW0gd2FrZXVwIGRp
c2FibGVkIGJ5IEFDUEkKWyAgICAwLjc1Nzc4Ml0gcGNpIDAwMDA6MDA6MTQuMzogWzEwMDI6
NDM5ZF0gdHlwZSAwMCBjbGFzcyAweDA2MDEwMApbICAgIDAuNzU3ODk2XSBwY2kgMDAwMDow
MDoxNC40OiBbMTAwMjo0Mzg0XSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAxClsgICAgMC43NTc5
NTBdIHBjaSAwMDAwOjAwOjE0LjQ6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQpb
ICAgIDAuNzU3OTkwXSBwY2kgMDAwMDowMDoxNC41OiBbMTAwMjo0Mzk5XSB0eXBlIDAwIGNs
YXNzIDB4MGMwMzEwClsgICAgMC43NTgwMDFdIHBjaSAwMDAwOjAwOjE0LjU6IHJlZyAweDEw
OiBbbWVtIDB4ZmVhMDYwMDAtMHhmZWEwNmZmZl0KWyAgICAwLjc1ODA3Ml0gcGNpIDAwMDA6
MDA6MTQuNTogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJClsgICAgMC43NTgxMThd
IHBjaSAwMDAwOjAwOjE1LjA6IFsxMDAyOjQzYTBdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAK
WyAgICAwLjc1ODE3M10gcGNpIDAwMDA6MDA6MTUuMDogc3VwcG9ydHMgRDEgRDIKWyAgICAw
Ljc1ODIxMl0gcGNpIDAwMDA6MDA6MTUuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBB
Q1BJClsgICAgMC43NTgyNTJdIHBjaSAwMDAwOjAwOjE2LjA6IFsxMDAyOjQzOTddIHR5cGUg
MDAgY2xhc3MgMHgwYzAzMTAKWyAgICAwLjc1ODI2M10gcGNpIDAwMDA6MDA6MTYuMDogcmVn
IDB4MTA6IFttZW0gMHhmZWEwNTAwMC0weGZlYTA1ZmZmXQpbICAgIDAuNzU4MzM0XSBwY2kg
MDAwMDowMDoxNi4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjc1
ODM4MF0gcGNpIDAwMDA6MDA6MTYuMjogWzEwMDI6NDM5Nl0gdHlwZSAwMCBjbGFzcyAweDBj
MDMyMApbICAgIDAuNzU4Mzk0XSBwY2kgMDAwMDowMDoxNi4yOiByZWcgMHgxMDogW21lbSAw
eGZlYTA0MDAwLTB4ZmVhMDQwZmZdClsgICAgMC43NTg0NTZdIHBjaSAwMDAwOjAwOjE2LjI6
IHN1cHBvcnRzIEQxIEQyClsgICAgMC43NTg0NThdIHBjaSAwMDAwOjAwOjE2LjI6IFBNRSMg
c3VwcG9ydGVkIGZyb20gRDAgRDEgRDIgRDNob3QKWyAgICAwLjc1ODUyM10gcGNpIDAwMDA6
MDA6MTYuMjogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJClsgICAgMC43NTg1Njld
IHBjaSAwMDAwOjAwOjE4LjA6IFsxMDIyOjEyMDBdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAK
WyAgICAwLjc1ODY0MF0gcGNpIDAwMDA6MDA6MTguMTogWzEwMjI6MTIwMV0gdHlwZSAwMCBj
bGFzcyAweDA2MDAwMApbICAgIDAuNzU4NzEwXSBwY2kgMDAwMDowMDoxOC4yOiBbMTAyMjox
MjAyXSB0eXBlIDAwIGNsYXNzIDB4MDYwMDAwClsgICAgMC43NTg3NzldIHBjaSAwMDAwOjAw
OjE4LjM6IFsxMDIyOjEyMDNdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAKWyAgICAwLjc1ODg1
MV0gcGNpIDAwMDA6MDA6MTguNDogWzEwMjI6MTIwNF0gdHlwZSAwMCBjbGFzcyAweDA2MDAw
MApbICAgIDAuNzU4OTgxXSBwY2kgMDAwMDowMTowMC4wOiBbMTAwMjo2OGI4XSB0eXBlIDAw
IGNsYXNzIDB4MDMwMDAwClsgICAgMC43NTg5OTJdIHBjaSAwMDAwOjAxOjAwLjA6IHJlZyAw
eDEwOiBbbWVtIDB4YzAwMDAwMDAtMHhjZmZmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDAuNzU5
MDAyXSBwY2kgMDAwMDowMTowMC4wOiByZWcgMHgxODogW21lbSAweGZlOTIwMDAwLTB4ZmU5
M2ZmZmYgNjRiaXRdClsgICAgMC43NTkwMDhdIHBjaSAwMDAwOjAxOjAwLjA6IHJlZyAweDIw
OiBbaW8gIDB4ZTAwMC0weGUwZmZdClsgICAgMC43NTkwMTldIHBjaSAwMDAwOjAxOjAwLjA6
IHJlZyAweDMwOiBbbWVtIDB4ZmU5MDAwMDAtMHhmZTkxZmZmZiBwcmVmXQpbICAgIDAuNzU5
MDQ3XSBwY2kgMDAwMDowMTowMC4wOiBzdXBwb3J0cyBEMSBEMgpbICAgIDAuNzU5MTAwXSBw
Y2kgMDAwMDowMTowMC4xOiBbMTAwMjphYTU4XSB0eXBlIDAwIGNsYXNzIDB4MDQwMzAwClsg
ICAgMC43NTkxMTBdIHBjaSAwMDAwOjAxOjAwLjE6IHJlZyAweDEwOiBbbWVtIDB4ZmU5NDAw
MDAtMHhmZTk0M2ZmZiA2NGJpdF0KWyAgICAwLjc1OTE1NF0gcGNpIDAwMDA6MDE6MDAuMTog
c3VwcG9ydHMgRDEgRDIKWyAgICAwLjc2Mjg3Ml0gcGNpIDAwMDA6MDA6MDIuMDogUENJIGJy
aWRnZSB0byBbYnVzIDAxXQpbICAgIDAuNzYyODc3XSBwY2kgMDAwMDowMDowMi4wOiAgIGJy
aWRnZSB3aW5kb3cgW2lvICAweGUwMDAtMHhlZmZmXQpbICAgIDAuNzYyODc5XSBwY2kgMDAw
MDowMDowMi4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZlOTAwMDAwLTB4ZmU5ZmZmZmZd
ClsgICAgMC43NjI4ODJdIHBjaSAwMDAwOjAwOjAyLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVt
IDB4YzAwMDAwMDAtMHhjZmZmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDAuNzYyOTQ1XSBwY2kg
MDAwMDowMjowMC4wOiBbMTBlYzo4MTY4XSB0eXBlIDAwIGNsYXNzIDB4MDIwMDAwClsgICAg
MC43NjI5NTddIHBjaSAwMDAwOjAyOjAwLjA6IHJlZyAweDEwOiBbaW8gIDB4ZDAwMC0weGQw
ZmZdClsgICAgMC43NjI5NzZdIHBjaSAwMDAwOjAyOjAwLjA6IHJlZyAweDE4OiBbbWVtIDB4
ZDAwMDQwMDAtMHhkMDAwNGZmZiA2NGJpdCBwcmVmXQpbICAgIDAuNzYyOTg4XSBwY2kgMDAw
MDowMjowMC4wOiByZWcgMHgyMDogW21lbSAweGQwMDAwMDAwLTB4ZDAwMDNmZmYgNjRiaXQg
cHJlZl0KWyAgICAwLjc2MzA2OF0gcGNpIDAwMDA6MDI6MDAuMDogc3VwcG9ydHMgRDEgRDIK
WyAgICAwLjc2MzA3MF0gcGNpIDAwMDA6MDI6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBE
MCBEMSBEMiBEM2hvdCBEM2NvbGQKWyAgICAwLjc2OTUzMF0gcGNpIDAwMDA6MDA6MDQuMDog
UENJIGJyaWRnZSB0byBbYnVzIDAyXQpbICAgIDAuNzY5NTM1XSBwY2kgMDAwMDowMDowNC4w
OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGQwMDAtMHhkZmZmXQpbICAgIDAuNzY5NTM4XSBw
Y2kgMDAwMDowMDowNC4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQwMDAwMDAwLTB4ZDAw
ZmZmZmYgNjRiaXQgcHJlZl0KWyAgICAwLjc2OTYwM10gcGNpIDAwMDA6MDM6MDAuMDogWzFi
MjE6MTA0Ml0gdHlwZSAwMCBjbGFzcyAweDBjMDMzMApbICAgIDAuNzY5NjIwXSBwY2kgMDAw
MDowMzowMC4wOiByZWcgMHgxMDogW21lbSAweGZlODAwMDAwLTB4ZmU4MDdmZmYgNjRiaXRd
ClsgICAgMC43Njk3MDRdIHBjaSAwMDAwOjAzOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20g
RDNob3QgRDNjb2xkClsgICAgMC43NzYxOTFdIHBjaSAwMDAwOjAwOjA1LjA6IFBDSSBicmlk
Z2UgdG8gW2J1cyAwM10KWyAgICAwLjc3NjE5Nl0gcGNpIDAwMDA6MDA6MDUuMDogICBicmlk
Z2Ugd2luZG93IFttZW0gMHhmZTgwMDAwMC0weGZlOGZmZmZmXQpbICAgIDAuNzc2MjU4XSBw
Y2kgMDAwMDowNDowMC4wOiBbMWIyMTowNjEyXSB0eXBlIDAwIGNsYXNzIDB4MDEwNjAxClsg
ICAgMC43NzYyNjhdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAweDEwOiBbaW8gIDB4YzA1MC0w
eGMwNTddClsgICAgMC43NzYyNzZdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAweDE0OiBbaW8g
IDB4YzA0MC0weGMwNDNdClsgICAgMC43NzYyODNdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAw
eDE4OiBbaW8gIDB4YzAzMC0weGMwMzddClsgICAgMC43NzYyOTBdIHBjaSAwMDAwOjA0OjAw
LjA6IHJlZyAweDFjOiBbaW8gIDB4YzAyMC0weGMwMjNdClsgICAgMC43NzYyOThdIHBjaSAw
MDAwOjA0OjAwLjA6IHJlZyAweDIwOiBbaW8gIDB4YzAwMC0weGMwMWZdClsgICAgMC43NzYz
MDVdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAweDI0OiBbbWVtIDB4ZmU3MDAwMDAtMHhmZTcw
MDFmZl0KWyAgICAwLjc4Mjg0N10gcGNpIDAwMDA6MDA6MDYuMDogUENJIGJyaWRnZSB0byBb
YnVzIDA0XQpbICAgIDAuNzgyODUxXSBwY2kgMDAwMDowMDowNi4wOiAgIGJyaWRnZSB3aW5k
b3cgW2lvICAweGMwMDAtMHhjZmZmXQpbICAgIDAuNzgyODUzXSBwY2kgMDAwMDowMDowNi4w
OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZlNzAwMDAwLTB4ZmU3ZmZmZmZdClsgICAgMC43
ODI5MThdIHBjaSAwMDAwOjA1OjAwLjA6IFsxYjIxOjEwNDJdIHR5cGUgMDAgY2xhc3MgMHgw
YzAzMzAKWyAgICAwLjc4MjkzNV0gcGNpIDAwMDA6MDU6MDAuMDogcmVnIDB4MTA6IFttZW0g
MHhmZTYwMDAwMC0weGZlNjA3ZmZmIDY0Yml0XQpbICAgIDAuNzgzMDE4XSBwY2kgMDAwMDow
NTowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQzaG90IEQzY29sZApbICAgIDAuNzg5NTEw
XSBwY2kgMDAwMDowMDowNy4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDVdClsgICAgMC43ODk1
MTVdIHBjaSAwMDAwOjAwOjA3LjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmU2MDAwMDAt
MHhmZTZmZmZmZl0KWyAgICAwLjc4OTU3Ml0gcGNpIDAwMDA6MDY6MDUuMDogWzExMDI6MDAw
OF0gdHlwZSAwMCBjbGFzcyAweDA0MDEwMApbICAgIDAuNzg5NTg3XSBwY2kgMDAwMDowNjow
NS4wOiByZWcgMHgxMDogW2lvICAweGIwMDAtMHhiMDNmXQpbICAgIDAuNzg5NjUwXSBwY2kg
MDAwMDowNjowNS4wOiBzdXBwb3J0cyBEMSBEMgpbICAgIDAuNzg5NzE4XSBwY2kgMDAwMDow
MDoxNC40OiBQQ0kgYnJpZGdlIHRvIFtidXMgMDZdIChzdWJ0cmFjdGl2ZSBkZWNvZGUpClsg
ICAgMC43ODk3MjJdIHBjaSAwMDAwOjAwOjE0LjQ6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4
YjAwMC0weGJmZmZdClsgICAgMC43ODk3MjddIHBjaSAwMDAwOjAwOjE0LjQ6ICAgYnJpZGdl
IHdpbmRvdyBbaW8gIDB4MDAwMC0weDAzYWZdIChzdWJ0cmFjdGl2ZSBkZWNvZGUpClsgICAg
MC43ODk3MjldIHBjaSAwMDAwOjAwOjE0LjQ6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MDNl
MC0weDBjZjddIChzdWJ0cmFjdGl2ZSBkZWNvZGUpClsgICAgMC43ODk3MzBdIHBjaSAwMDAw
OjAwOjE0LjQ6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MDNiMC0weDAzZGZdIChzdWJ0cmFj
dGl2ZSBkZWNvZGUpClsgICAgMC43ODk3MzJdIHBjaSAwMDAwOjAwOjE0LjQ6ICAgYnJpZGdl
IHdpbmRvdyBbaW8gIDB4MGQwMC0weGZmZmZdIChzdWJ0cmFjdGl2ZSBkZWNvZGUpClsgICAg
MC43ODk3MzNdIHBjaSAwMDAwOjAwOjE0LjQ6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAw
YTAwMDAtMHgwMDBiZmZmZl0gKHN1YnRyYWN0aXZlIGRlY29kZSkKWyAgICAwLjc4OTczNV0g
cGNpIDAwMDA6MDA6MTQuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHgwMDBjMDAwMC0weDAw
MGRmZmZmXSAoc3VidHJhY3RpdmUgZGVjb2RlKQpbICAgIDAuNzg5NzM2XSBwY2kgMDAwMDow
MDoxNC40OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGMwMDAwMDAwLTB4ZmZmZmZmZmZdIChz
dWJ0cmFjdGl2ZSBkZWNvZGUpClsgICAgMC43ODk4MTVdIHBjaSAwMDAwOjA3OjAwLjA6IFsx
NGYxOjg4NTJdIHR5cGUgMDAgY2xhc3MgMHgwNDAwMDAKWyAgICAwLjc4OTgzOF0gcGNpIDAw
MDA6MDc6MDAuMDogcmVnIDB4MTA6IFttZW0gMHhmZTQwMDAwMC0weGZlNWZmZmZmIDY0Yml0
XQpbICAgIDAuNzg5OTU3XSBwY2kgMDAwMDowNzowMC4wOiBzdXBwb3J0cyBEMSBEMgpbICAg
IDAuNzg5OTU4XSBwY2kgMDAwMDowNzowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQx
IEQyIEQzaG90ClsgICAgMC43OTAwMjNdIHBjaSAwMDAwOjA3OjAwLjA6IGRpc2FibGluZyBB
U1BNIG9uIHByZS0xLjEgUENJZSBkZXZpY2UuICBZb3UgY2FuIGVuYWJsZSBpdCB3aXRoICdw
Y2llX2FzcG09Zm9yY2UnClsgICAgMC43OTAwMzRdIHBjaSAwMDAwOjAwOjE1LjA6IFBDSSBi
cmlkZ2UgdG8gW2J1cyAwN10KWyAgICAwLjc5MDA0MV0gcGNpIDAwMDA6MDA6MTUuMDogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhmZTQwMDAwMC0weGZlNWZmZmZmXQpbICAgIDAuNzkwMDcw
XSBwY2lfYnVzIDAwMDA6MDA6IG9uIE5VTUEgbm9kZSAwClsgICAgMC43OTAyNzFdIEFDUEk6
IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQV0gKElSUXMgNCA3IDEwIDExIDE0IDE1KSAqMApb
ICAgIDAuNzkwMzQxXSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0JdIChJUlFzIDQg
NyAxMCAxMSAxNCAxNSkgKjAKWyAgICAwLjc5MDM4OF0gQUNQSTogUENJIEludGVycnVwdCBM
aW5rIFtMTktDXSAoSVJRcyA0IDcgMTAgMTEgMTQgMTUpICowClsgICAgMC43OTA0MzNdIEFD
UEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRF0gKElSUXMgMyA0IDEwIDExIDE0IDE1KSAq
MApbICAgIDAuNzkwNDcwXSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0VdIChJUlFz
IDQgNyAxMCAxMSAxNCAxNSkgKjAKWyAgICAwLjc5MDUwMF0gQUNQSTogUENJIEludGVycnVw
dCBMaW5rIFtMTktGXSAoSVJRcyA0IDcgMTAgMTEgMTQgMTUpICowClsgICAgMC43OTA1Mjld
IEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LR10gKElSUXMgNCA3IDEwIDExIDE0IDE1
KSAqMApbICAgIDAuNzkwNTU5XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0hdIChJ
UlFzIDQgNyAxMCAxMSAxNCAxNSkgKjAKWyAgICAwLjc5MDY4N10gQUNQSTogRW5hYmxlZCAx
IEdQRXMgaW4gYmxvY2sgMDAgdG8gMUYKWyAgICAwLjc5MDY5M10gQUNQSTogXF9TQl8uUENJ
MDogbm90aWZ5IGhhbmRsZXIgaXMgaW5zdGFsbGVkClsgICAgMC43OTA3MTZdIEZvdW5kIDEg
YWNwaSByb290IGRldmljZXMKWyAgICAwLjc5MDcyOV0gQUNQSTogRUM6IEdQRSA9IDB4YSwg
SS9POiBjb21tYW5kL3N0YXR1cyA9IDB4NjYsIGRhdGEgPSAweDYyClsgICAgMC43OTA5MTNd
IFNDU0kgc3Vic3lzdGVtIGluaXRpYWxpemVkClsgICAgMC43OTA5ODFdIGxpYmF0YSB2ZXJz
aW9uIDMuMDAgbG9hZGVkLgpbICAgIDAuNzkwOTg1XSBBQ1BJOiBidXMgdHlwZSBVU0IgcmVn
aXN0ZXJlZApbICAgIDAuNzkxMDM2XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZh
Y2UgZHJpdmVyIHVzYmZzClsgICAgMC43OTEwNjNdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3
IGludGVyZmFjZSBkcml2ZXIgaHViClsgICAgMC43OTExMDFdIHVzYmNvcmU6IHJlZ2lzdGVy
ZWQgbmV3IGRldmljZSBkcml2ZXIgdXNiClsgICAgMC43OTEzMDFdIFBDSTogVXNpbmcgQUNQ
SSBmb3IgSVJRIHJvdXRpbmcKWyAgICAwLjc5Nzg0M10gUENJOiBwY2lfY2FjaGVfbGluZV9z
aXplIHNldCB0byA2NCBieXRlcwpbICAgIDAuNzk3OTAzXSBlODIwOiByZXNlcnZlIFJBTSBi
dWZmZXIgW21lbSAweGJhNjY4MDAwLTB4YmJmZmZmZmZdClsgICAgMC43OTc5MDVdIGU4MjA6
IHJlc2VydmUgUkFNIGJ1ZmZlciBbbWVtIDB4YmNhMzkwMDAtMHhiZmZmZmZmZl0KWyAgICAw
Ljc5NzkwNl0gZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFttZW0gMHhiZDA4MzAwMC0weGJm
ZmZmZmZmXQpbICAgIDAuNzk3OTA3XSBlODIwOiByZXNlcnZlIFJBTSBidWZmZXIgW21lbSAw
eGJkODAwMDAwLTB4YmZmZmZmZmZdClsgICAgMC43OTgwNzhdIE5ldExhYmVsOiBJbml0aWFs
aXppbmcKWyAgICAwLjc5ODA4MV0gTmV0TGFiZWw6ICBkb21haW4gaGFzaCBzaXplID0gMTI4
ClsgICAgMC43OTgwODJdIE5ldExhYmVsOiAgcHJvdG9jb2xzID0gVU5MQUJFTEVEIENJUFNP
djQKWyAgICAwLjc5ODA5MF0gTmV0TGFiZWw6ICB1bmxhYmVsZWQgdHJhZmZpYyBhbGxvd2Vk
IGJ5IGRlZmF1bHQKWyAgICAwLjc5ODEwNF0gaHBldDA6IGF0IE1NSU8gMHhmZWQwMDAwMCwg
SVJRcyAyLCA4LCAwClsgICAgMC43OTgxMDhdIGhwZXQwOiAzIGNvbXBhcmF0b3JzLCAzMi1i
aXQgMTQuMzE4MTgwIE1IeiBjb3VudGVyClsgICAgMC44MDAxNTddIFN3aXRjaGVkIHRvIGNs
b2Nrc291cmNlIGhwZXQKWyAgICAwLjgwMTM2OF0gcG5wOiBQblAgQUNQSSBpbml0ClsgICAg
MC44MDEzNzddIEFDUEk6IGJ1cyB0eXBlIFBOUCByZWdpc3RlcmVkClsgICAgMC44MDE0NjZd
IHN5c3RlbSAwMDowMDogW21lbSAweGUwMDAwMDAwLTB4ZWZmZmZmZmZdIGhhcyBiZWVuIHJl
c2VydmVkClsgICAgMC44MDE0NzFdIHN5c3RlbSAwMDowMDogUGx1ZyBhbmQgUGxheSBBQ1BJ
IGRldmljZSwgSURzIFBOUDBjMDEgKGFjdGl2ZSkKWyAgICAwLjgwMTc2NF0gc3lzdGVtIDAw
OjAxOiBbaW8gIDB4MDQwYl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjgwMTc2N10gc3lz
dGVtIDAwOjAxOiBbaW8gIDB4MDRkNl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjgwMTc3
MF0gc3lzdGVtIDAwOjAxOiBbaW8gIDB4MGMwMC0weDBjMDFdIGhhcyBiZWVuIHJlc2VydmVk
ClsgICAgMC44MDE3NzNdIHN5c3RlbSAwMDowMTogW2lvICAweDBjMTRdIGhhcyBiZWVuIHJl
c2VydmVkClsgICAgMC44MDE3NzVdIHN5c3RlbSAwMDowMTogW2lvICAweDBjNTAtMHgwYzUx
XSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxNzc4XSBzeXN0ZW0gMDA6MDE6IFtpbyAg
MHgwYzUyXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxNzgwXSBzeXN0ZW0gMDA6MDE6
IFtpbyAgMHgwYzZjXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxNzgyXSBzeXN0ZW0g
MDA6MDE6IFtpbyAgMHgwYzZmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxNzg1XSBz
eXN0ZW0gMDA6MDE6IFtpbyAgMHgwY2QwLTB4MGNkMV0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAg
ICAwLjgwMTc4N10gc3lzdGVtIDAwOjAxOiBbaW8gIDB4MGNkMi0weDBjZDNdIGhhcyBiZWVu
IHJlc2VydmVkClsgICAgMC44MDE3OTBdIHN5c3RlbSAwMDowMTogW2lvICAweDBjZDQtMHgw
Y2Q1XSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxNzkyXSBzeXN0ZW0gMDA6MDE6IFtp
byAgMHgwY2Q2LTB4MGNkN10gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjgwMTc5NV0gc3lz
dGVtIDAwOjAxOiBbaW8gIDB4MGNkOC0weDBjZGZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAg
MC44MDE3OTddIHN5c3RlbSAwMDowMTogW2lvICAweDA4MDAtMHgwODlmXSBjb3VsZCBub3Qg
YmUgcmVzZXJ2ZWQKWyAgICAwLjgwMTgwMF0gc3lzdGVtIDAwOjAxOiBbaW8gIDB4MGIyMC0w
eDBiM2ZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC44MDE4MDNdIHN5c3RlbSAwMDowMTog
W2lvICAweDA5MDAtMHgwOTBmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxODA1XSBz
eXN0ZW0gMDA6MDE6IFtpbyAgMHgwOTEwLTB4MDkxZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAg
ICAwLjgwMTgwOF0gc3lzdGVtIDAwOjAxOiBbaW8gIDB4ZmUwMC0weGZlZmVdIGhhcyBiZWVu
IHJlc2VydmVkClsgICAgMC44MDE4MTFdIHN5c3RlbSAwMDowMTogW21lbSAweGZlYzAwMDAw
LTB4ZmVjMDBmZmZdIGNvdWxkIG5vdCBiZSByZXNlcnZlZApbICAgIDAuODAxODE0XSBzeXN0
ZW0gMDA6MDE6IFttZW0gMHhmZWUwMDAwMC0weGZlZTAwZmZmXSBoYXMgYmVlbiByZXNlcnZl
ZApbICAgIDAuODAxODE4XSBzeXN0ZW0gMDA6MDE6IFttZW0gMHhmZWQ4MDAwMC0weGZlZDhm
ZmZmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxODIxXSBzeXN0ZW0gMDA6MDE6IFtt
ZW0gMHhmZWQ2MTAwMC0weGZlZDcwZmZmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAx
ODI0XSBzeXN0ZW0gMDA6MDE6IFttZW0gMHhmZWMxMDAwMC0weGZlYzEwZmZmXSBoYXMgYmVl
biByZXNlcnZlZApbICAgIDAuODAxODI2XSBzeXN0ZW0gMDA6MDE6IFttZW0gMHhmZWQwMDAw
MC0weGZlZDAwZmZmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxODI5XSBzeXN0ZW0g
MDA6MDE6IFttZW0gMHhmZjgwMDAwMC0weGZmZmZmZmZmXSBoYXMgYmVlbiByZXNlcnZlZApb
ICAgIDAuODAxODMyXSBzeXN0ZW0gMDA6MDE6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2Us
IElEcyBQTlAwYzAyIChhY3RpdmUpClsgICAgMC44MDE5NDBdIHN5c3RlbSAwMDowMjogW2lv
ICAweDAyOTAtMHgwMmFmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuODAxOTQzXSBzeXN0
ZW0gMDA6MDI6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3Rp
dmUpClsgICAgMC44MDE5NTJdIHBucCAwMDowMzogW2RtYSA0XQpbICAgIDAuODAxOTg0XSBw
bnAgMDA6MDM6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwMjAwIChhY3Rp
dmUpClsgICAgMC44MDIwMzBdIHBucCAwMDowNDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmlj
ZSwgSURzIFBOUDBiMDAgKGFjdGl2ZSkKWyAgICAwLjgwMjA2NV0gcG5wIDAwOjA1OiBQbHVn
IGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMDgwMCAoYWN0aXZlKQpbICAgIDAuODAy
MTI2XSBzeXN0ZW0gMDA6MDY6IFtpbyAgMHgwNGQwLTB4MDRkMV0gaGFzIGJlZW4gcmVzZXJ2
ZWQKWyAgICAwLjgwMjEzMF0gc3lzdGVtIDAwOjA2OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2
aWNlLCBJRHMgUE5QMGMwMiAoYWN0aXZlKQpbICAgIDAuODAyMTcxXSBwbnAgMDA6MDc6IFBs
dWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzA0IChhY3RpdmUpClsgICAgMC44
MDIyMThdIHN5c3RlbSAwMDowODogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBO
UDBjMDIgKGFjdGl2ZSkKWyAgICAwLjgwMjI3Ml0gcG5wIDAwOjA5OiBQbHVnIGFuZCBQbGF5
IEFDUEkgZGV2aWNlLCBJRHMgUE5QMDMwMyBQTlAwMzBiIChhY3RpdmUpClsgICAgMC44MDIz
NzddIHBucCAwMDowYTogW2RtYSAwIGRpc2FibGVkXQpbICAgIDAuODAyNDMzXSBwbnAgMDA6
MGE6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwNTAxIChhY3RpdmUpClsg
ICAgMC44MDI1MzddIHN5c3RlbSAwMDowYjogW21lbSAweGZlYjIwMDAwLTB4ZmViMjNmZmZd
IGNvdWxkIG5vdCBiZSByZXNlcnZlZApbICAgIDAuODAyNTQxXSBzeXN0ZW0gMDA6MGI6IFBs
dWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3RpdmUpClsgICAgMC44
MDI2MzBdIHN5c3RlbSAwMDowYzogW21lbSAweGZlYzIwMDAwLTB4ZmVjMjAwZmZdIGNvdWxk
IG5vdCBiZSByZXNlcnZlZApbICAgIDAuODAyNjM0XSBzeXN0ZW0gMDA6MGM6IFBsdWcgYW5k
IFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3RpdmUpClsgICAgMC44MDI4MTld
IHBucCAwMDowZDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAxMDMgKGFj
dGl2ZSkKWyAgICAwLjgwMjgyM10gcG5wOiBQblAgQUNQSTogZm91bmQgMTQgZGV2aWNlcwpb
ICAgIDAuODAyODI1XSBBQ1BJOiBidXMgdHlwZSBQTlAgdW5yZWdpc3RlcmVkClsgICAgMC44
MTIwMThdIHBjaSAwMDAwOjAwOjAyLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMV0KWyAgICAw
LjgxMjAyMl0gcGNpIDAwMDA6MDA6MDIuMDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhlMDAw
LTB4ZWZmZl0KWyAgICAwLjgxMjAyNl0gcGNpIDAwMDA6MDA6MDIuMDogICBicmlkZ2Ugd2lu
ZG93IFttZW0gMHhmZTkwMDAwMC0weGZlOWZmZmZmXQpbICAgIDAuODEyMDI5XSBwY2kgMDAw
MDowMDowMi4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGMwMDAwMDAwLTB4Y2ZmZmZmZmYg
NjRiaXQgcHJlZl0KWyAgICAwLjgxMjAzNF0gcGNpIDAwMDA6MDA6MDQuMDogUENJIGJyaWRn
ZSB0byBbYnVzIDAyXQpbICAgIDAuODEyMDM3XSBwY2kgMDAwMDowMDowNC4wOiAgIGJyaWRn
ZSB3aW5kb3cgW2lvICAweGQwMDAtMHhkZmZmXQpbICAgIDAuODEyMDQxXSBwY2kgMDAwMDow
MDowNC4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQwMDAwMDAwLTB4ZDAwZmZmZmYgNjRi
aXQgcHJlZl0KWyAgICAwLjgxMjA0NV0gcGNpIDAwMDA6MDA6MDUuMDogUENJIGJyaWRnZSB0
byBbYnVzIDAzXQpbICAgIDAuODEyMDQ5XSBwY2kgMDAwMDowMDowNS4wOiAgIGJyaWRnZSB3
aW5kb3cgW21lbSAweGZlODAwMDAwLTB4ZmU4ZmZmZmZdClsgICAgMC44MTIwNTNdIHBjaSAw
MDAwOjAwOjA2LjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwNF0KWyAgICAwLjgxMjA1Nl0gcGNp
IDAwMDA6MDA6MDYuMDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhjMDAwLTB4Y2ZmZl0KWyAg
ICAwLjgxMjA1OV0gcGNpIDAwMDA6MDA6MDYuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhm
ZTcwMDAwMC0weGZlN2ZmZmZmXQpbICAgIDAuODEyMDY0XSBwY2kgMDAwMDowMDowNy4wOiBQ
Q0kgYnJpZGdlIHRvIFtidXMgMDVdClsgICAgMC44MTIwNjddIHBjaSAwMDAwOjAwOjA3LjA6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmU2MDAwMDAtMHhmZTZmZmZmZl0KWyAgICAwLjgx
MjA3Ml0gcGNpIDAwMDA6MDA6MTQuNDogUENJIGJyaWRnZSB0byBbYnVzIDA2XQpbICAgIDAu
ODEyMDc1XSBwY2kgMDAwMDowMDoxNC40OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGIwMDAt
MHhiZmZmXQpbICAgIDAuODEyMDg1XSBwY2kgMDAwMDowMDoxNS4wOiBQQ0kgYnJpZGdlIHRv
IFtidXMgMDddClsgICAgMC44MTIwODldIHBjaSAwMDAwOjAwOjE1LjA6ICAgYnJpZGdlIHdp
bmRvdyBbbWVtIDB4ZmU0MDAwMDAtMHhmZTVmZmZmZl0KWyAgICAwLjgxMjA5Nl0gcGNpX2J1
cyAwMDAwOjAwOiByZXNvdXJjZSA0IFtpbyAgMHgwMDAwLTB4MDNhZl0KWyAgICAwLjgxMjA5
OF0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA1IFtpbyAgMHgwM2UwLTB4MGNmN10KWyAg
ICAwLjgxMjA5OV0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA2IFtpbyAgMHgwM2IwLTB4
MDNkZl0KWyAgICAwLjgxMjEwMF0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA3IFtpbyAg
MHgwZDAwLTB4ZmZmZl0KWyAgICAwLjgxMjEwMl0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJj
ZSA4IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXQpbICAgIDAuODEyMTAzXSBwY2lfYnVz
IDAwMDA6MDA6IHJlc291cmNlIDkgW21lbSAweDAwMGMwMDAwLTB4MDAwZGZmZmZdClsgICAg
MC44MTIxMDRdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgMTAgW21lbSAweGMwMDAwMDAw
LTB4ZmZmZmZmZmZdClsgICAgMC44MTIxMDZdIHBjaV9idXMgMDAwMDowMTogcmVzb3VyY2Ug
MCBbaW8gIDB4ZTAwMC0weGVmZmZdClsgICAgMC44MTIxMDddIHBjaV9idXMgMDAwMDowMTog
cmVzb3VyY2UgMSBbbWVtIDB4ZmU5MDAwMDAtMHhmZTlmZmZmZl0KWyAgICAwLjgxMjEwOF0g
cGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAyIFttZW0gMHhjMDAwMDAwMC0weGNmZmZmZmZm
IDY0Yml0IHByZWZdClsgICAgMC44MTIxMTBdIHBjaV9idXMgMDAwMDowMjogcmVzb3VyY2Ug
MCBbaW8gIDB4ZDAwMC0weGRmZmZdClsgICAgMC44MTIxMTFdIHBjaV9idXMgMDAwMDowMjog
cmVzb3VyY2UgMiBbbWVtIDB4ZDAwMDAwMDAtMHhkMDBmZmZmZiA2NGJpdCBwcmVmXQpbICAg
IDAuODEyMTEzXSBwY2lfYnVzIDAwMDA6MDM6IHJlc291cmNlIDEgW21lbSAweGZlODAwMDAw
LTB4ZmU4ZmZmZmZdClsgICAgMC44MTIxMTRdIHBjaV9idXMgMDAwMDowNDogcmVzb3VyY2Ug
MCBbaW8gIDB4YzAwMC0weGNmZmZdClsgICAgMC44MTIxMTVdIHBjaV9idXMgMDAwMDowNDog
cmVzb3VyY2UgMSBbbWVtIDB4ZmU3MDAwMDAtMHhmZTdmZmZmZl0KWyAgICAwLjgxMjExN10g
cGNpX2J1cyAwMDAwOjA1OiByZXNvdXJjZSAxIFttZW0gMHhmZTYwMDAwMC0weGZlNmZmZmZm
XQpbICAgIDAuODEyMTE4XSBwY2lfYnVzIDAwMDA6MDY6IHJlc291cmNlIDAgW2lvICAweGIw
MDAtMHhiZmZmXQpbICAgIDAuODEyMTIwXSBwY2lfYnVzIDAwMDA6MDY6IHJlc291cmNlIDQg
W2lvICAweDAwMDAtMHgwM2FmXQpbICAgIDAuODEyMTIxXSBwY2lfYnVzIDAwMDA6MDY6IHJl
c291cmNlIDUgW2lvICAweDAzZTAtMHgwY2Y3XQpbICAgIDAuODEyMTIyXSBwY2lfYnVzIDAw
MDA6MDY6IHJlc291cmNlIDYgW2lvICAweDAzYjAtMHgwM2RmXQpbICAgIDAuODEyMTIzXSBw
Y2lfYnVzIDAwMDA6MDY6IHJlc291cmNlIDcgW2lvICAweDBkMDAtMHhmZmZmXQpbICAgIDAu
ODEyMTI1XSBwY2lfYnVzIDAwMDA6MDY6IHJlc291cmNlIDggW21lbSAweDAwMGEwMDAwLTB4
MDAwYmZmZmZdClsgICAgMC44MTIxMjZdIHBjaV9idXMgMDAwMDowNjogcmVzb3VyY2UgOSBb
bWVtIDB4MDAwYzAwMDAtMHgwMDBkZmZmZl0KWyAgICAwLjgxMjEyN10gcGNpX2J1cyAwMDAw
OjA2OiByZXNvdXJjZSAxMCBbbWVtIDB4YzAwMDAwMDAtMHhmZmZmZmZmZl0KWyAgICAwLjgx
MjEyOV0gcGNpX2J1cyAwMDAwOjA3OiByZXNvdXJjZSAxIFttZW0gMHhmZTQwMDAwMC0weGZl
NWZmZmZmXQpbICAgIDAuODEyMTUzXSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5
IDIKWyAgICAwLjgxMjI2M10gVENQIGVzdGFibGlzaGVkIGhhc2ggdGFibGUgZW50cmllczog
MTMxMDcyIChvcmRlcjogOSwgMjA5NzE1MiBieXRlcykKWyAgICAwLjgxMjgwNV0gVENQIGJp
bmQgaGFzaCB0YWJsZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMp
ClsgICAgMC44MTMwNzRdIFRDUDogSGFzaCB0YWJsZXMgY29uZmlndXJlZCAoZXN0YWJsaXNo
ZWQgMTMxMDcyIGJpbmQgNjU1MzYpClsgICAgMC44MTMxMjJdIFRDUDogcmVubyByZWdpc3Rl
cmVkClsgICAgMC44MTMxMjddIFVEUCBoYXNoIHRhYmxlIGVudHJpZXM6IDgxOTIgKG9yZGVy
OiA2LCAyNjIxNDQgYnl0ZXMpClsgICAgMC44MTMyMDRdIFVEUC1MaXRlIGhhc2ggdGFibGUg
ZW50cmllczogODE5MiAob3JkZXI6IDYsIDI2MjE0NCBieXRlcykKWyAgICAwLjgxMzMxOF0g
TkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxClsgICAgMS4wODM0ODBdIHBjaSAw
MDAwOjAxOjAwLjA6IEJvb3QgdmlkZW8gZGV2aWNlClsgICAgMS4wODM2NTJdIFBDSTogQ0xT
IDY0IGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMS4wODQwMTJdIEFNRC1WaTogRm91bmQgSU9N
TVUgYXQgMDAwMDowMDowMC4yIGNhcCAweDQwClsgICAgMS4wODQwMTVdIEFNRC1WaTogSW50
ZXJydXB0IHJlbWFwcGluZyBlbmFibGVkClsgICAgMS4wODQwMjddIHBjaSAwMDAwOjAwOjAw
LjI6IGlycSA3MiBmb3IgTVNJL01TSS1YClsgICAgMS4wOTI1NTBdIEFNRC1WaTogTGF6eSBJ
Ty9UTEIgZmx1c2hpbmcgZW5hYmxlZApbICAgIDEuMTY5MTg3XSBQQ0ktRE1BOiBVc2luZyBz
b2Z0d2FyZSBib3VuY2UgYnVmZmVyaW5nIGZvciBJTyAoU1dJT1RMQikKWyAgICAxLjE2OTE5
MV0gc29mdHdhcmUgSU8gVExCIFttZW0gMHhhOTE5ODAwMC0weGFkMTk4MDAwXSAoNjRNQikg
bWFwcGVkIGF0IFtmZmZmODgwMGE5MTk4MDAwLWZmZmY4ODAwYWQxOTdmZmZdClsgICAgMS4x
NjkzMjFdIExWVCBvZmZzZXQgMSBhc3NpZ25lZCBmb3IgdmVjdG9yIDB4NDAwClsgICAgMS4x
NjkzMjZdIElCUzogTFZUIG9mZnNldCAxIGFzc2lnbmVkClsgICAgMS4xNjkzNDZdIHBlcmY6
IEFNRCBJQlMgZGV0ZWN0ZWQgKDB4MDAwMDAwMWYpClsgICAgMS4xNjk5MzVdIFNjYW5uaW5n
IGZvciBsb3cgbWVtb3J5IGNvcnJ1cHRpb24gZXZlcnkgNjAgc2Vjb25kcwpbICAgIDEuMTcx
MTA2XSBib3VuY2UgcG9vbCBzaXplOiA2NCBwYWdlcwpbICAgIDEuMTcxMTExXSBIdWdlVExC
IHJlZ2lzdGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxvY2F0ZWQgMCBwYWdlcwpbICAg
IDEuMTc0NjEzXSBtc2dtbmkgaGFzIGJlZW4gc2V0IHRvIDMxODgxClsgICAgMS4xNzUxNjBd
IEJsb2NrIGxheWVyIFNDU0kgZ2VuZXJpYyAoYnNnKSBkcml2ZXIgdmVyc2lvbiAwLjQgbG9h
ZGVkIChtYWpvciAyNTMpClsgICAgMS4xNzUxNjRdIGlvIHNjaGVkdWxlciBub29wIHJlZ2lz
dGVyZWQgKGRlZmF1bHQpClsgICAgMS4xNzUxNjZdIGlvIHNjaGVkdWxlciBkZWFkbGluZSBy
ZWdpc3RlcmVkClsgICAgMS4xNzUyMTVdIGlvIHNjaGVkdWxlciBjZnEgcmVnaXN0ZXJlZApb
ICAgIDEuMTc1ODc5XSBpbnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RN
OjAwL2RldmljZTowMC9QTlAwQzBDOjAwL2lucHV0L2lucHV0MApbICAgIDEuMTc1ODg1XSBB
Q1BJOiBQb3dlciBCdXR0b24gW1BXUkJdClsgICAgMS4xNzU5NDNdIGlucHV0OiBQb3dlciBC
dXR0b24gYXMgL2RldmljZXMvTE5YU1lTVE06MDAvTE5YUFdSQk46MDAvaW5wdXQvaW5wdXQx
ClsgICAgMS4xNzU5NDZdIEFDUEk6IFBvd2VyIEJ1dHRvbiBbUFdSRl0KWyAgICAxLjE3NjAz
OF0gQUNQSTogcHJvY2Vzc29yIGxpbWl0ZWQgdG8gbWF4IEMtc3RhdGUgMQpbICAgIDEuMTc2
NTc0XSBHSEVTOiBIRVNUIGlzIG5vdCBlbmFibGVkIQpbICAgIDEuMTc2ODQ1XSBOb24tdm9s
YXRpbGUgbWVtb3J5IGRyaXZlciB2MS4zClsgICAgMS4xNzY4NDhdIExpbnV4IGFncGdhcnQg
aW50ZXJmYWNlIHYwLjEwMwpbICAgIDEuMTc3MjE2XSBbZHJtXSBJbml0aWFsaXplZCBkcm0g
MS4xLjAgMjAwNjA4MTAKWyAgICAxLjE3NzI1Nl0gW2RybV0gcmFkZW9uIGtlcm5lbCBtb2Rl
c2V0dGluZyBlbmFibGVkLgpbICAgIDEuMTc3NTEwXSBbZHJtXSBpbml0aWFsaXppbmcga2Vy
bmVsIG1vZGVzZXR0aW5nIChKVU5JUEVSIDB4MTAwMjoweDY4QjggMHgxNjgyOjB4Mjk5MSku
ClsgICAgMS4xNzc1MjJdIFtkcm1dIHJlZ2lzdGVyIG1taW8gYmFzZTogMHhGRTkyMDAwMApb
ICAgIDEuMTc3NTI0XSBbZHJtXSByZWdpc3RlciBtbWlvIHNpemU6IDEzMTA3MgpbICAgIDEu
MTc3NTc3XSBBVE9NIEJJT1M6IEpVTklQRVIKWyAgICAxLjE3NzYyNV0gcmFkZW9uIDAwMDA6
MDE6MDAuMDogVlJBTTogMTAyNE0gMHgwMDAwMDAwMDAwMDAwMDAwIC0gMHgwMDAwMDAwMDNG
RkZGRkZGICgxMDI0TSB1c2VkKQpbICAgIDEuMTc3NjI5XSByYWRlb24gMDAwMDowMTowMC4w
OiBHVFQ6IDEwMjRNIDB4MDAwMDAwMDA0MDAwMDAwMCAtIDB4MDAwMDAwMDA3RkZGRkZGRgpb
ICAgIDEuMTc3NjMyXSBbZHJtXSBEZXRlY3RlZCBWUkFNIFJBTT0xMDI0TSwgQkFSPTI1Nk0K
WyAgICAxLjE3NzYzNF0gW2RybV0gUkFNIHdpZHRoIDEyOGJpdHMgRERSClsgICAgMS4xNzc3
MDVdIFtUVE1dIFpvbmUgIGtlcm5lbDogQXZhaWxhYmxlIGdyYXBoaWNzIG1lbW9yeTogODE2
MTcxOCBraUIKWyAgICAxLjE3NzcwN10gW1RUTV0gWm9uZSAgIGRtYTMyOiBBdmFpbGFibGUg
Z3JhcGhpY3MgbWVtb3J5OiAyMDk3MTUyIGtpQgpbICAgIDEuMTc3NzA5XSBbVFRNXSBJbml0
aWFsaXppbmcgcG9vbCBhbGxvY2F0b3IKWyAgICAxLjE3NzcxM10gW1RUTV0gSW5pdGlhbGl6
aW5nIERNQSBwb29sIGFsbG9jYXRvcgpbICAgIDEuMTc3NzMwXSBbZHJtXSByYWRlb246IDEw
MjRNIG9mIFZSQU0gbWVtb3J5IHJlYWR5ClsgICAgMS4xNzc3MzJdIFtkcm1dIHJhZGVvbjog
MTAyNE0gb2YgR1RUIG1lbW9yeSByZWFkeS4KWyAgICAxLjE3NzczOV0gW2RybV0gTG9hZGlu
ZyBKVU5JUEVSIE1pY3JvY29kZQpbICAgIDEuMTc3ODMzXSBbZHJtXSBHQVJUOiBudW0gY3B1
IHBhZ2VzIDI2MjE0NCwgbnVtIGdwdSBwYWdlcyAyNjIxNDQKWyAgICAxLjE3OTMxNF0gW2Ry
bV0gZW5hYmxpbmcgUENJRSBnZW4gMiBsaW5rIHNwZWVkcywgZGlzYWJsZSB3aXRoIHJhZGVv
bi5wY2llX2dlbjI9MApbICAgIDEuMTg0MDM5XSBbZHJtXSBQQ0lFIEdBUlQgb2YgMTAyNE0g
ZW5hYmxlZCAodGFibGUgYXQgMHgwMDAwMDAwMDAwMjVEMDAwKS4KWyAgICAxLjE4NDEyNF0g
cmFkZW9uIDAwMDA6MDE6MDAuMDogV0IgZW5hYmxlZApbICAgIDEuMTg0MTI3XSByYWRlb24g
MDAwMDowMTowMC4wOiBmZW5jZSBkcml2ZXIgb24gcmluZyAwIHVzZSBncHUgYWRkciAweDAw
MDAwMDAwNDAwMDBjMDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDQyY2JjY2MwMApbICAgIDEu
MTg0MTMxXSByYWRlb24gMDAwMDowMTowMC4wOiBmZW5jZSBkcml2ZXIgb24gcmluZyAzIHVz
ZSBncHUgYWRkciAweDAwMDAwMDAwNDAwMDBjMGMgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDQy
Y2JjY2MwYwpbICAgIDEuMTg0NTM1XSByYWRlb24gMDAwMDowMTowMC4wOiBmZW5jZSBkcml2
ZXIgb24gcmluZyA1IHVzZSBncHUgYWRkciAweDAwMDAwMDAwMDAwNWM0MTggYW5kIGNwdSBh
ZGRyIDB4ZmZmZmM5MDAxNTM5YzQxOApbICAgIDEuMTg0NTM5XSBbZHJtXSBTdXBwb3J0cyB2
YmxhbmsgdGltZXN0YW1wIGNhY2hpbmcgUmV2IDEgKDEwLjEwLjIwMTApLgpbICAgIDEuMTg0
NTQxXSBbZHJtXSBEcml2ZXIgc3VwcG9ydHMgcHJlY2lzZSB2YmxhbmsgdGltZXN0YW1wIHF1
ZXJ5LgpbICAgIDEuMTg0NTY0XSByYWRlb24gMDAwMDowMTowMC4wOiBpcnEgNzMgZm9yIE1T
SS9NU0ktWApbICAgIDEuMTg0NTczXSByYWRlb24gMDAwMDowMTowMC4wOiByYWRlb246IHVz
aW5nIE1TSS4KWyAgICAxLjE4NDU5Ml0gW2RybV0gcmFkZW9uOiBpcnEgaW5pdGlhbGl6ZWQu
ClsgICAgMS4yMDEwOTFdIFtkcm1dIHJpbmcgdGVzdCBvbiAwIHN1Y2NlZWRlZCBpbiAxIHVz
ZWNzClsgICAgMS4yMDExNDldIFtkcm1dIHJpbmcgdGVzdCBvbiAzIHN1Y2NlZWRlZCBpbiAx
IHVzZWNzClsgICAgMS40MDgwOTJdIFtkcm1dIHJpbmcgdGVzdCBvbiA1IHN1Y2NlZWRlZCBp
biAxIHVzZWNzClsgICAgMS40MDgwOTZdIFtkcm1dIFVWRCBpbml0aWFsaXplZCBzdWNjZXNz
ZnVsbHkuClsgICAgMS40MDg0NTRdIFtkcm1dIGliIHRlc3Qgb24gcmluZyAwIHN1Y2NlZWRl
ZCBpbiAwIHVzZWNzClsgICAgMS40MDg0NzRdIFtkcm1dIGliIHRlc3Qgb24gcmluZyAzIHN1
Y2NlZWRlZCBpbiAwIHVzZWNzClsgICAgMS41Njk3NjNdIFtkcm1dIGliIHRlc3Qgb24gcmlu
ZyA1IHN1Y2NlZWRlZApbICAgIDEuNTcwNjkwXSBbZHJtXSBSYWRlb24gRGlzcGxheSBDb25u
ZWN0b3JzClsgICAgMS41NzA2OTJdIFtkcm1dIENvbm5lY3RvciAwOgpbICAgIDEuNTcwNjk0
XSBbZHJtXSAgIERQLTEKWyAgICAxLjU3MDY5NV0gW2RybV0gICBIUEQ0ClsgICAgMS41NzA2
OTddIFtkcm1dICAgRERDOiAweDY0NDAgMHg2NDQwIDB4NjQ0NCAweDY0NDQgMHg2NDQ4IDB4
NjQ0OCAweDY0NGMgMHg2NDRjClsgICAgMS41NzA2OTldIFtkcm1dICAgRW5jb2RlcnM6Clsg
ICAgMS41NzA3MDFdIFtkcm1dICAgICBERlAxOiBJTlRFUk5BTF9VTklQSFkyClsgICAgMS41
NzA3MDJdIFtkcm1dIENvbm5lY3RvciAxOgpbICAgIDEuNTcwNzA0XSBbZHJtXSAgIEhETUkt
QS0xClsgICAgMS41NzA3MDVdIFtkcm1dICAgSFBENQpbICAgIDEuNTcwNzA3XSBbZHJtXSAg
IEREQzogMHg2NDMwIDB4NjQzMCAweDY0MzQgMHg2NDM0IDB4NjQzOCAweDY0MzggMHg2NDNj
IDB4NjQzYwpbICAgIDEuNTcwNzA5XSBbZHJtXSAgIEVuY29kZXJzOgpbICAgIDEuNTcwNzEx
XSBbZHJtXSAgICAgREZQMjogSU5URVJOQUxfVU5JUEhZMgpbICAgIDEuNTcwNzEyXSBbZHJt
XSBDb25uZWN0b3IgMjoKWyAgICAxLjU3MDcxNF0gW2RybV0gICBEVkktSS0xClsgICAgMS41
NzA3MTVdIFtkcm1dICAgSFBEMQpbICAgIDEuNTcwNzE3XSBbZHJtXSAgIEREQzogMHg2NDYw
IDB4NjQ2MCAweDY0NjQgMHg2NDY0IDB4NjQ2OCAweDY0NjggMHg2NDZjIDB4NjQ2YwpbICAg
IDEuNTcwNzE5XSBbZHJtXSAgIEVuY29kZXJzOgpbICAgIDEuNTcwNzIwXSBbZHJtXSAgICAg
REZQMzogSU5URVJOQUxfVU5JUEhZMQpbICAgIDEuNTcwNzIyXSBbZHJtXSAgICAgQ1JUMjog
SU5URVJOQUxfS0xEU0NQX0RBQzIKWyAgICAxLjU3MDcyM10gW2RybV0gQ29ubmVjdG9yIDM6
ClsgICAgMS41NzA3MjVdIFtkcm1dICAgRFZJLUktMgpbICAgIDEuNTcwNzI2XSBbZHJtXSAg
IEhQRDYKWyAgICAxLjU3MDcyOF0gW2RybV0gICBEREM6IDB4NjQ1MCAweDY0NTAgMHg2NDU0
IDB4NjQ1NCAweDY0NTggMHg2NDU4IDB4NjQ1YyAweDY0NWMKWyAgICAxLjU3MDczMF0gW2Ry
bV0gICBFbmNvZGVyczoKWyAgICAxLjU3MDczMl0gW2RybV0gICAgIERGUDQ6IElOVEVSTkFM
X1VOSVBIWQpbICAgIDEuNTcwNzMzXSBbZHJtXSAgICAgQ1JUMTogSU5URVJOQUxfS0xEU0NQ
X0RBQzEKWyAgICAxLjU3MDc3NV0gW2RybV0gSW50ZXJuYWwgdGhlcm1hbCBjb250cm9sbGVy
IHdpdGggZmFuIGNvbnRyb2wKWyAgICAxLjU3MDgzM10gW2RybV0gcmFkZW9uOiBwb3dlciBt
YW5hZ2VtZW50IGluaXRpYWxpemVkClsgICAgMS42NTUwMTddIFtkcm1dIGZiIG1hcHBhYmxl
IGF0IDB4QzA0NUUwMDAKWyAgICAxLjY1NTAyMl0gW2RybV0gdnJhbSBhcHBlciBhdCAweEMw
MDAwMDAwClsgICAgMS42NTUwMjRdIFtkcm1dIHNpemUgOTIxNjAwMApbICAgIDEuNjU1MDI1
XSBbZHJtXSBmYiBkZXB0aCBpcyAyNApbICAgIDEuNjU1MDI3XSBbZHJtXSAgICBwaXRjaCBp
cyA3NjgwClsgICAgMS42NTUxMzhdIGZiY29uOiByYWRlb25kcm1mYiAoZmIwKSBpcyBwcmlt
YXJ5IGRldmljZQpbICAgIDEuODY1NDUwXSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3Vy
IGZyYW1lIGJ1ZmZlciBkZXZpY2UgMjQweDc1ClsgICAgMS44NzEwOThdIHJhZGVvbiAwMDAw
OjAxOjAwLjA6IGZiMDogcmFkZW9uZHJtZmIgZnJhbWUgYnVmZmVyIGRldmljZQpbICAgIDEu
ODcxMTIzXSByYWRlb24gMDAwMDowMTowMC4wOiByZWdpc3RlcmVkIHBhbmljIG5vdGlmaWVy
ClsgICAgMS44NzExNDhdIFtkcm1dIEluaXRpYWxpemVkIHJhZGVvbiAyLjM0LjAgMjAwODA1
MjggZm9yIDAwMDA6MDE6MDAuMCBvbiBtaW5vciAwClsgICAgMS44NzE1MDJdIGFoY2kgMDAw
MDowMDoxMS4wOiB2ZXJzaW9uIDMuMApbICAgIDEuODcxNjUxXSBhaGNpIDAwMDA6MDA6MTEu
MDogQUhDSSAwMDAxLjAyMDAgMzIgc2xvdHMgNSBwb3J0cyA2IEdicHMgMHgxZiBpbXBsIFNB
VEEgbW9kZQpbICAgIDEuODcxNjk0XSBhaGNpIDAwMDA6MDA6MTEuMDogZmxhZ3M6IDY0Yml0
IG5jcSBzbnRmIGlsY2sgcG0gbGVkIGNsbyBwbXAgcGlvIHNsdW0gcGFydCAKWyAgICAxLjg3
Mjc1N10gc2NzaTAgOiBhaGNpClsgICAgMS44NzI4OTRdIHNjc2kxIDogYWhjaQpbICAgIDEu
ODczMDQ2XSBzY3NpMiA6IGFoY2kKWyAgICAxLjg3MzE3MV0gc2NzaTMgOiBhaGNpClsgICAg
MS44NzMyOTNdIHNjc2k0IDogYWhjaQpbICAgIDEuODczMzk0XSBhdGExOiBTQVRBIG1heCBV
RE1BLzEzMyBhYmFyIG0xMDI0QDB4ZmVhMGIwMDAgcG9ydCAweGZlYTBiMTAwIGlycSAxOQpb
ICAgIDEuODczNDMyXSBhdGEyOiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0xMDI0QDB4ZmVh
MGIwMDAgcG9ydCAweGZlYTBiMTgwIGlycSAxOQpbICAgIDEuODczNDcwXSBhdGEzOiBTQVRB
IG1heCBVRE1BLzEzMyBhYmFyIG0xMDI0QDB4ZmVhMGIwMDAgcG9ydCAweGZlYTBiMjAwIGly
cSAxOQpbICAgIDEuODczNTA3XSBhdGE0OiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0xMDI0
QDB4ZmVhMGIwMDAgcG9ydCAweGZlYTBiMjgwIGlycSAxOQpbICAgIDEuODczNTQ1XSBhdGE1
OiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0xMDI0QDB4ZmVhMGIwMDAgcG9ydCAweGZlYTBi
MzAwIGlycSAxOQpbICAgIDEuODczNjczXSBhaGNpIDAwMDA6MDQ6MDAuMDogaXJxIDc0IGZv
ciBNU0kvTVNJLVgKWyAgICAxLjg3MzcwMl0gYWhjaSAwMDAwOjA0OjAwLjA6IFNTUyBmbGFn
IHNldCwgcGFyYWxsZWwgYnVzIHNjYW4gZGlzYWJsZWQKWyAgICAxLjg3Mzc2MF0gYWhjaSAw
MDAwOjA0OjAwLjA6IEFIQ0kgMDAwMS4wMjAwIDMyIHNsb3RzIDIgcG9ydHMgNiBHYnBzIDB4
MyBpbXBsIFNBVEEgbW9kZQpbICAgIDEuODczODAxXSBhaGNpIDAwMDA6MDQ6MDAuMDogZmxh
Z3M6IDY0Yml0IG5jcSBzbnRmIHN0YWcgbGVkIGNsbyBwbXAgcGlvIHNsdW0gcGFydCBjY2Mg
c3hzIApbICAgIDEuODc0MzEyXSBzY3NpNSA6IGFoY2kKWyAgICAxLjg3NDQ0NV0gc2NzaTYg
OiBhaGNpClsgICAgMS44NzQ1NDVdIGF0YTY6IFNBVEEgbWF4IFVETUEvMTMzIGFiYXIgbTUx
MkAweGZlNzAwMDAwIHBvcnQgMHhmZTcwMDEwMCBpcnEgNzQKWyAgICAxLjg3NDU3NV0gYXRh
NzogU0FUQSBtYXggVURNQS8xMzMgYWJhciBtNTEyQDB4ZmU3MDAwMDAgcG9ydCAweGZlNzAw
MTgwIGlycSA3NApbICAgIDEuODc0OTE2XSBpODA0MjogUE5QOiBQUy8yIENvbnRyb2xsZXIg
W1BOUDAzMDM6UFMyS10gYXQgMHg2MCwweDY0IGlycSAxClsgICAgMS44NzQ5NDhdIGk4MDQy
OiBQTlA6IFBTLzIgYXBwZWFycyB0byBoYXZlIEFVWCBwb3J0IGRpc2FibGVkLCBpZiB0aGlz
IGlzIGluY29ycmVjdCBwbGVhc2UgYm9vdCB3aXRoIGk4MDQyLm5vcG5wClsgICAgMS44NzUx
MzldIHNlcmlvOiBpODA0MiBLQkQgcG9ydCBhdCAweDYwLDB4NjQgaXJxIDEKWyAgICAxLjg3
NTMwMV0gbW91c2VkZXY6IFBTLzIgbW91c2UgZGV2aWNlIGNvbW1vbiBmb3IgYWxsIG1pY2UK
WyAgICAxLjg3NTU2OF0gcnRjX2Ntb3MgMDA6MDQ6IFJUQyBjYW4gd2FrZSBmcm9tIFM0Clsg
ICAgMS44NzU3MDRdIHJ0Y19jbW9zIDAwOjA0OiBydGMgY29yZTogcmVnaXN0ZXJlZCBydGNf
Y21vcyBhcyBydGMwClsgICAgMS44NzU3NDZdIHJ0Y19jbW9zIDAwOjA0OiBhbGFybXMgdXAg
dG8gb25lIG1vbnRoLCB5M2ssIDExNCBieXRlcyBudnJhbSwgaHBldCBpcnFzClsgICAgMS44
NzU4MjJdIG1kOiByYWlkMSBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZvciBsZXZlbCAxClsg
ICAgMS44NzU4ODVdIG1kOiByYWlkNiBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZvciBsZXZl
bCA2ClsgICAgMS44NzU5MTBdIG1kOiByYWlkNSBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZv
ciBsZXZlbCA1ClsgICAgMS44NzU5MzFdIG1kOiByYWlkNCBwZXJzb25hbGl0eSByZWdpc3Rl
cmVkIGZvciBsZXZlbCA0ClsgICAgMS44NzU5NTRdIEVGSSBWYXJpYWJsZXMgRmFjaWxpdHkg
djAuMDggMjAwNC1NYXktMTcKWyAgICAxLjg4NTMwMF0gcHN0b3JlOiBSZWdpc3RlcmVkIGVm
aSBhcyBwZXJzaXN0ZW50IHN0b3JlIGJhY2tlbmQKWyAgICAxLjg4NTQzMV0gaGlkcmF3OiBy
YXcgSElEIGV2ZW50cyBkcml2ZXIgKEMpIEppcmkgS29zaW5hClsgICAgMS44ODU1NzFdIHVz
YmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkClsgICAgMS44
ODU1OTNdIHVzYmhpZDogVVNCIEhJRCBjb3JlIGRyaXZlcgpbICAgIDEuODg1Njc2XSBOZXRm
aWx0ZXIgbWVzc2FnZXMgdmlhIE5FVExJTksgdjAuMzAuClsgICAgMS44ODU3MDddIG5mX2Nv
bm50cmFjayB2ZXJzaW9uIDAuNS4wICgxNjM4NCBidWNrZXRzLCA2NTUzNiBtYXgpClsgICAg
MS44ODU4NjBdIGN0bmV0bGluayB2MC45MzogcmVnaXN0ZXJpbmcgd2l0aCBuZm5ldGxpbmsu
ClsgICAgMS44ODYxMTldIGlwX3RhYmxlczogKEMpIDIwMDAtMjAwNiBOZXRmaWx0ZXIgQ29y
ZSBUZWFtClsgICAgMS44ODYxNzZdIFRDUDogY3ViaWMgcmVnaXN0ZXJlZApbICAgIDEuODg2
MTkwXSBJbml0aWFsaXppbmcgWEZSTSBuZXRsaW5rIHNvY2tldApbICAgIDEuODg2NDM0XSBO
RVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDEwClsgICAgMS44ODY2NDZdIGlwNl90
YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVyIENvcmUgVGVhbQpbICAgIDEuODg2OTE2
XSBzaXQ6IElQdjYgb3ZlciBJUHY0IHR1bm5lbGluZyBkcml2ZXIKWyAgICAxLjg4NzExOF0g
TkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAgIDEuODg3NjMxXSByZWdp
c3RlcmVkIHRhc2tzdGF0cyB2ZXJzaW9uIDEKWyAgICAxLjg4OTE4NF0gICBNYWdpYyBudW1i
ZXI6IDY6NzkyOjY5MwpbICAgIDEuODkwMzI2XSBhY3BpLWNwdWZyZXE6IG92ZXJyaWRpbmcg
QklPUyBwcm92aWRlZCBfUFNEIGRhdGEKWyAgICAxLjg5OTYyNF0gaW5wdXQ6IEFUIFRyYW5z
bGF0ZWQgU2V0IDIga2V5Ym9hcmQgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8w
L2lucHV0L2lucHV0MgpbICAgIDIuMTY4OTcxXSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291
cmNlIGNhbGlicmF0aW9uOiAzNDY3Ljc3MCBNSHoKWyAgICAyLjE5MjMxOF0gYXRhMTogU0FU
QSBsaW5rIHVwIDMuMCBHYnBzIChTU3RhdHVzIDEyMyBTQ29udHJvbCAzMDApClsgICAgMi4x
OTY3MTFdIGF0YTY6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAwKQpb
ICAgIDIuMTk2NzE4XSBhdGE1OiBTQVRBIGxpbmsgdXAgNi4wIEdicHMgKFNTdGF0dXMgMTMz
IFNDb250cm9sIDMwMCkKWyAgICAyLjE5Njc1Nl0gYXRhMzogU0FUQSBsaW5rIHVwIDYuMCBH
YnBzIChTU3RhdHVzIDEzMyBTQ29udHJvbCAzMDApClsgICAgMi4xOTY3OTVdIGF0YTI6IFNB
VEEgbGluayB1cCA2LjAgR2JwcyAoU1N0YXR1cyAxMzMgU0NvbnRyb2wgMzAwKQpbICAgIDIu
MTk2ODM5XSBhdGE0OiBTQVRBIGxpbmsgdXAgNi4wIEdicHMgKFNTdGF0dXMgMTMzIFNDb250
cm9sIDMwMCkKWyAgICAyLjE5Nzg4M10gYXRhMy4wMDogQVRBLTg6IEhpdGFjaGkgSERTNUMz
MDIwQUxBNjMyLCBNTDZPQUExMCwgbWF4IFVETUEvMTMzClsgICAgMi4xOTc4ODVdIGF0YTMu
MDA6IDM5MDcwMjkxNjggc2VjdG9ycywgbXVsdGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEv
MzIpLCBBQQpbICAgIDIuMTk3OTMxXSBhdGEyLjAwOiBBVEEtODogSGl0YWNoaSBIRFM1QzMw
MjBBTEE2MzIsIE1MNk9BQTEwLCBtYXggVURNQS8xMzMKWyAgICAyLjE5NzkzMl0gYXRhMi4w
MDogMzkwNzAyOTE2OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJBNDggTkNRIChkZXB0aCAzMS8z
MiksIEFBClsgICAgMi4xOTc5NzFdIGF0YTQuMDA6IEFUQS04OiBIaXRhY2hpIEhEUzVDMzAy
MEFMQTYzMiwgTUw2T0FBMTAsIG1heCBVRE1BLzEzMwpbICAgIDIuMTk3OTcyXSBhdGE0LjAw
OiAzOTA3MDI5MTY4IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMy
KSwgQUEKWyAgICAyLjE5ODU2OV0gYXRhNS4wMDogc3VwcG9ydHMgRFJNIGZ1bmN0aW9ucyBh
bmQgbWF5IG5vdCBiZSBmdWxseSBhY2Nlc3NpYmxlClsgICAgMi4xOTg2MTZdIGF0YTUuMDA6
IGZhaWxlZCB0byBnZXQgTkNRIFNlbmQvUmVjdiBMb2cgRW1hc2sgMHgxClsgICAgMi4xOTg2
MTddIGF0YTUuMDA6IEFUQS05OiBTYW1zdW5nIFNTRCA4NDAgRVZPIDI1MEdCLCBFWFQwQkI2
USwgbWF4IFVETUEvMTMzClsgICAgMi4xOTg2MTldIGF0YTUuMDA6IDQ4ODM5NzE2OCBzZWN0
b3JzLCBtdWx0aSAxOiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSwgQUEKWyAgICAyLjE5ODc3
MF0gYXRhNS4wMDogc3VwcG9ydHMgRFJNIGZ1bmN0aW9ucyBhbmQgbWF5IG5vdCBiZSBmdWxs
eSBhY2Nlc3NpYmxlClsgICAgMi4xOTg4MTRdIGF0YTUuMDA6IGZhaWxlZCB0byBnZXQgTkNR
IFNlbmQvUmVjdiBMb2cgRW1hc2sgMHgxClsgICAgMi4xOTg4MTZdIGF0YTUuMDA6IGNvbmZp
Z3VyZWQgZm9yIFVETUEvMTMzClsgICAgMi4xOTkwNjBdIGF0YTMuMDA6IGNvbmZpZ3VyZWQg
Zm9yIFVETUEvMTMzClsgICAgMi4xOTkwODFdIGF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVE
TUEvMTMzClsgICAgMi4xOTkxMjJdIGF0YTQuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMz
ClsgICAgMi4yODMzODFdIGF0YTEuMDA6IEFUQS03OiBTQU1TVU5HIE1NQ1JFNjRHNU1YUC0w
VkIsIFZCTTE5MDFRLCBtYXggVURNQS8xMDAKWyAgICAyLjI4NTEzMV0gYXRhMS4wMDogMTI1
MDQ1NDI0IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSwgQUEK
WyAgICAyLjI4OTgxNV0gYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMDAKWyAgICAy
LjI5NDU2M10gc2NzaSAwOjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBTQU1T
VU5HIE1NQ1JFNjRHIFZCTTEgUFE6IDAgQU5TSTogNQpbICAgIDIuMjk2NjkyXSBzZCAwOjA6
MDowOiBbc2RhXSAxMjUwNDU0MjQgNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICg2NC4wIEdC
LzU5LjYgR2lCKQpbICAgIDIuMjk2ODg4XSBzZCAwOjA6MDowOiBBdHRhY2hlZCBzY3NpIGdl
bmVyaWMgc2cwIHR5cGUgMApbICAgIDIuMjk3MTk0XSBzY3NpIDE6MDowOjA6IERpcmVjdC1B
Y2Nlc3MgICAgIEFUQSAgICAgIEhpdGFjaGkgSERTNUMzMDIgTUw2TyBQUTogMCBBTlNJOiA1
ClsgICAgMi4yOTc2MzVdIHNkIDE6MDowOjA6IFtzZGJdIDM5MDcwMjkxNjggNTEyLWJ5dGUg
bG9naWNhbCBibG9ja3M6ICgyLjAwIFRCLzEuODEgVGlCKQpbICAgIDIuMjk3ODEwXSBzZCAx
OjA6MDowOiBbc2RiXSBXcml0ZSBQcm90ZWN0IGlzIG9mZgpbICAgIDIuMjk3ODEyXSBzZCAx
OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cxIHR5cGUgMApbICAgIDIuMjk3ODE3
XSBzZCAxOjA6MDowOiBbc2RiXSBNb2RlIFNlbnNlOiAwMCAzYSAwMCAwMApbICAgIDIuMjk3
ODg0XSBzZCAxOjA6MDowOiBbc2RiXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNo
ZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUEKWyAgICAyLjI5ODEwNl0g
c2NzaSAyOjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBIaXRhY2hpIEhEUzVD
MzAyIE1MNk8gUFE6IDAgQU5TSTogNQpbICAgIDIuMjk4NTQxXSBzZCAyOjA6MDowOiBbc2Rj
XSAzOTA3MDI5MTY4IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMi4wMCBUQi8xLjgxIFRp
QikKWyAgICAyLjI5ODY2MV0gc2QgMjowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNn
MiB0eXBlIDAKWyAgICAyLjI5ODY3M10gc2QgMjowOjA6MDogW3NkY10gV3JpdGUgUHJvdGVj
dCBpcyBvZmYKWyAgICAyLjI5ODY3N10gc2QgMjowOjA6MDogW3NkY10gTW9kZSBTZW5zZTog
MDAgM2EgMDAgMDAKWyAgICAyLjI5ODc3Ml0gc2QgMjowOjA6MDogW3NkY10gV3JpdGUgY2Fj
aGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8g
b3IgRlVBClsgICAgMi4yOTkwMjZdIHNjc2kgMzowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAg
QVRBICAgICAgSGl0YWNoaSBIRFM1QzMwMiBNTDZPIFBROiAwIEFOU0k6IDUKWyAgICAyLjI5
OTU0M10gc2QgMzowOjA6MDogW3NkZF0gMzkwNzAyOTE2OCA1MTItYnl0ZSBsb2dpY2FsIGJs
b2NrczogKDIuMDAgVEIvMS44MSBUaUIpClsgICAgMi4yOTk2OTVdIHNkIDM6MDowOjA6IFtz
ZGRdIFdyaXRlIFByb3RlY3QgaXMgb2ZmClsgICAgMi4yOTk2OTldIHNkIDM6MDowOjA6IFtz
ZGRdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwClsgICAgMi4yOTk3NDldIHNkIDM6MDowOjA6
IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzMgdHlwZSAwClsgICAgMi4yOTk3NzVdIHNkIDM6
MDowOjA6IFtzZGRdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVk
LCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQpbICAgIDIuMzAwMTQzXSBzY3NpIDQ6MDow
OjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIFNhbXN1bmcgU1NEIDg0MCAgRVhUMCBQ
UTogMCBBTlNJOiA1ClsgICAgMi4zMDA2MDZdIHNkIDQ6MDowOjA6IFtzZGVdIDQ4ODM5NzE2
OCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDI1MCBHQi8yMzIgR2lCKQpbICAgIDIuMzAw
NzU1XSBzZCA0OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2c0IHR5cGUgMApbICAg
IDIuMzAwODYyXSBzZCA0OjA6MDowOiBbc2RlXSBXcml0ZSBQcm90ZWN0IGlzIG9mZgpbICAg
IDIuMzAwODY2XSBzZCA0OjA6MDowOiBbc2RlXSBNb2RlIFNlbnNlOiAwMCAzYSAwMCAwMApb
ICAgIDIuMzAwOTEzXSBzZCA0OjA6MDowOiBbc2RlXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwg
cmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUEKWyAgICAy
LjMwODgyM10gIHNkZTogc2RlMQpbICAgIDIuMzA5NjUzXSBzZCA0OjA6MDowOiBbc2RlXSBB
dHRhY2hlZCBTQ1NJIGRpc2sKWyAgICAyLjM0MzcxMF0gc2QgMDowOjA6MDogW3NkYV0gV3Jp
dGUgUHJvdGVjdCBpcyBvZmYKWyAgICAyLjM0NTExMV0gc2QgMDowOjA6MDogW3NkYV0gTW9k
ZSBTZW5zZTogMDAgM2EgMDAgMDAKWyAgICAyLjM0NTEyMF0gc2QgMDowOjA6MDogW3NkYV0g
V3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3Vw
cG9ydCBEUE8gb3IgRlVBClsgICAgMi4zNDk4MTRdICBzZGE6IHNkYTEgc2RhMgpbICAgIDIu
MzUxNzc4XSBzZCAwOjA6MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAgICAyLjM2
OTc4OF0gIHNkYzogc2RjMSBzZGM5ClsgICAgMi4zNzMyMjJdICBzZGI6IHNkYjEgc2RiOQpb
ICAgIDIuMzc0MTUyXSBzZCAxOjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAg
ICAyLjM3NDI3MV0gIHNkZDogc2RkMSBzZGQ5ClsgICAgMi4zNzQ5OTVdIHNkIDM6MDowOjA6
IFtzZGRdIEF0dGFjaGVkIFNDU0kgZGlzawpbICAgIDIuMzk2ODgyXSBzZCAyOjA6MDowOiBb
c2RjXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAgICAyLjYxODU1M10gYXRhNzogU0FUQSBsaW5r
IGRvd24gKFNTdGF0dXMgMCBTQ29udHJvbCAzMDApClsgICAgMi42MjM4NzJdIG1kOiBXYWl0
aW5nIGZvciBhbGwgZGV2aWNlcyB0byBiZSBhdmFpbGFibGUgYmVmb3JlIGF1dG9kZXRlY3QK
WyAgICAyLjYyOTE1OV0gbWQ6IElmIHlvdSBkb24ndCB1c2UgcmFpZCwgdXNlIHJhaWQ9bm9h
dXRvZGV0ZWN0ClsgICAgMi42MzUwODJdIG1kOiBBdXRvZGV0ZWN0aW5nIFJBSUQgYXJyYXlz
LgpbICAgIDIuNjQwMzI4XSBtZDogU2Nhbm5lZCAwIGFuZCBhZGRlZCAwIGRldmljZXMuClsg
ICAgMi42NDU1MzVdIG1kOiBhdXRvcnVuIC4uLgpbICAgIDIuNjUwNjc3XSBtZDogLi4uIGF1
dG9ydW4gRE9ORS4KWyAgICAyLjY1NjQ4Nl0gRVhUMi1mcyAoc2RhMik6IGVycm9yOiBjb3Vs
ZG4ndCBtb3VudCBiZWNhdXNlIG9mIHVuc3VwcG9ydGVkIG9wdGlvbmFsIGZlYXR1cmVzICgy
NDQpClsgICAgMi42NjQxNjZdIEVYVDQtZnMgKHNkYTIpOiBJTkZPOiByZWNvdmVyeSByZXF1
aXJlZCBvbiByZWFkb25seSBmaWxlc3lzdGVtClsgICAgMi42NjYyNTddIEVYVDQtZnMgKHNk
YTIpOiB3cml0ZSBhY2Nlc3Mgd2lsbCBiZSBlbmFibGVkIGR1cmluZyByZWNvdmVyeQpbICAg
IDIuNjg5NjI4XSBFWFQ0LWZzIChzZGEyKTogcmVjb3ZlcnkgY29tcGxldGUKWyAgICAyLjY5
NjUwMV0gRVhUNC1mcyAoc2RhMik6IG1vdW50ZWQgZmlsZXN5c3RlbSB3aXRoIG9yZGVyZWQg
ZGF0YSBtb2RlLiBPcHRzOiAobnVsbCkKWyAgICAyLjY5ODU4MF0gVkZTOiBNb3VudGVkIHJv
b3QgKGV4dDQgZmlsZXN5c3RlbSkgcmVhZG9ubHkgb24gZGV2aWNlIDg6Mi4KWyAgICAyLjcw
MzE2MV0gZGV2dG1wZnM6IG1vdW50ZWQKWyAgICAyLjcwNjE3N10gRnJlZWluZyB1bnVzZWQg
a2VybmVsIG1lbW9yeTogODM2SyAoZmZmZmZmZmY4MWE4OTAwMCAtIGZmZmZmZmZmODFiNWEw
MDApClsgICAgMi43MDgyNTZdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCByZWFkLW9u
bHkgZGF0YTogMTAyNDBrClsgICAgMi43MTA3ODJdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBt
ZW1vcnk6IDEyOEsgKGZmZmY4ODAwMDE1ZTAwMDAgLSBmZmZmODgwMDAxNjAwMDAwKQpbICAg
IDIuNzE0MzkwXSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiAxMjAwSyAoZmZmZjg4
MDAwMThkNDAwMCAtIGZmZmY4ODAwMDFhMDAwMDApClsgICAgMi44NzU1NjZdIHNldGZvbnQg
KDkxNikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNTA3MiBieXRlcyBsZWZ0ClsgICAg
Mi45MDkxODldIGluaXQtZWFybHkuc2ggKDkxNSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0
aDogNDM2OCBieXRlcyBsZWZ0ClsgICAgMy4xNzE0NTBdIFN3aXRjaGVkIHRvIGNsb2Nrc291
cmNlIHRzYwpbICAgIDMuNDIxNjc3XSBzeXN0ZW1kLXVkZXZkWzEwOTddOiBzdGFydGluZyB2
ZXJzaW9uIDIxNgpbICAgIDMuNTQ4NzE5XSBlaGNpX2hjZDogVVNCIDIuMCAnRW5oYW5jZWQn
IEhvc3QgQ29udHJvbGxlciAoRUhDSSkgRHJpdmVyClsgICAgMy41NTAxMzVdIHBpaXg0X3Nt
YnVzIDAwMDA6MDA6MTQuMDogU01CdXMgSG9zdCBDb250cm9sbGVyIGF0IDB4YjAwLCByZXZp
c2lvbiAwClsgICAgMy41NTAxNjZdIHBpaXg0X3NtYnVzIDAwMDA6MDA6MTQuMDogU01CdXMg
SG9zdCBDb250cm9sbGVyIGF0IDB4YjIwClsgICAgMy41NTExNDNdIGVoY2ktcGNpOiBFSENJ
IFBDSSBwbGF0Zm9ybSBkcml2ZXIKWyAgICAzLjU1MTI0MF0gZWhjaS1wY2kgMDAwMDowMDox
Mi4yOiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMuNTUxMzAxXSBlaGNpLXBjaSAwMDAw
OjAwOjEyLjI6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIg
MQpbICAgIDMuNTUxMzE5XSBRVUlSSzogRW5hYmxlIEFNRCBQTEwgZml4ClsgICAgMy41NTEz
MjJdIGVoY2ktcGNpIDAwMDA6MDA6MTIuMjogYXBwbHlpbmcgQU1EIFNCNzAwL1NCODAwL0h1
ZHNvbi0yLzMgRUhDSSBkdW1teSBxaCB3b3JrYXJvdW5kClsgICAgMy41NTEzMzNdIGVoY2kt
cGNpIDAwMDA6MDA6MTIuMjogZGVidWcgcG9ydCAxClsgICAgMy41NTEzNzRdIGVoY2ktcGNp
IDAwMDA6MDA6MTIuMjogaXJxIDE3LCBpbyBtZW0gMHhmZWEwOTAwMApbICAgIDMuNTUyMTg3
XSBvaGNpX2hjZDogVVNCIDEuMSAnT3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2
ZXIKWyAgICAzLjU1MzcyOF0gb2hjaS1wY2k6IE9IQ0kgUENJIHBsYXRmb3JtIGRyaXZlcgpb
ICAgIDMuNTU2ODQzXSByODE2OSBHaWdhYml0IEV0aGVybmV0IGRyaXZlciAyLjNMSy1OQVBJ
IGxvYWRlZApbICAgIDMuNTU2ODUxXSByODE2OSAwMDAwOjAyOjAwLjA6IGNhbid0IGRpc2Fi
bGUgQVNQTTsgT1MgZG9lc24ndCBoYXZlIEFTUE0gY29udHJvbApbICAgIDMuNTU3MDQ1XSBy
ODE2OSAwMDAwOjAyOjAwLjA6IGlycSA3NSBmb3IgTVNJL01TSS1YClsgICAgMy41NTcxNzdd
IHI4MTY5IDAwMDA6MDI6MDAuMCBldGgwOiBSVEw4MTY4Zi84MTExZiBhdCAweGZmZmZjOTAw
MDAwMzYwMDAsIDYwOmE0OjRjOjYxOjE3OjY4LCBYSUQgMDgwMDA4MDAgSVJRIDc1ClsgICAg
My41NTcxNzldIHI4MTY5IDAwMDA6MDI6MDAuMCBldGgwOiBqdW1ibyBmZWF0dXJlcyBbZnJh
bWVzOiA5MjAwIGJ5dGVzLCB0eCBjaGVja3N1bW1pbmc6IGtvXQpbICAgIDMuNTYwNzk0XSBl
aGNpLXBjaSAwMDAwOjAwOjEyLjI6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwClsgICAg
My41NjA5NTNdIGh1YiAxLTA6MS4wOiBVU0IgaHViIGZvdW5kClsgICAgMy41NjA5NjJdIGh1
YiAxLTA6MS4wOiA1IHBvcnRzIGRldGVjdGVkClsgICAgMy41NjExMjFdIHhoY2lfaGNkIDAw
MDA6MDM6MDAuMDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgICAzLjU2MTI3Ml0geGhjaV9o
Y2QgMDAwMDowMzowMC4wOiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMg
bnVtYmVyIDIKWyAgICAzLjU4NTkwNV0gTGludXggdmlkZW8gY2FwdHVyZSBpbnRlcmZhY2U6
IHYyLjAwClsgICAgMy42MDU5MTVdIHNuZF9lbXUxMGsxIDAwMDA6MDY6MDUuMDogZW5hYmxp
bmcgZGV2aWNlICgwMDAwIC0+IDAwMDEpClsgICAgMy42MTY1NjZdIEF1ZGlneTIgdmFsdWU6
IFNwZWNpYWwgY29uZmlnLgpbICAgIDMuNjIwNjI3XSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6
IGlycSA3NiBmb3IgTVNJL01TSS1YClsgICAgMy42MjA2MzZdIHhoY2lfaGNkIDAwMDA6MDM6
MDAuMDogaXJxIDc3IGZvciBNU0kvTVNJLVgKWyAgICAzLjYyMDY0NV0geGhjaV9oY2QgMDAw
MDowMzowMC4wOiBpcnEgNzggZm9yIE1TSS9NU0ktWApbICAgIDMuNjIwNjUzXSB4aGNpX2hj
ZCAwMDAwOjAzOjAwLjA6IGlycSA3OSBmb3IgTVNJL01TSS1YClsgICAgMy42MjA2NjJdIHho
Y2lfaGNkIDAwMDA6MDM6MDAuMDogaXJxIDgwIGZvciBNU0kvTVNJLVgKWyAgICAzLjYyMDg1
NF0gaHViIDItMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjYyMDg2Ml0gaHViIDItMDox
LjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjYyMDkxOV0geGhjaV9oY2QgMDAwMDowMzow
MC4wOiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMuNjIwOTM2XSBlaGNpLXBjaSAwMDAw
OjAwOjEzLjI6IEVIQ0kgSG9zdCBDb250cm9sbGVyClsgICAgMy42MjA5NDldIHhoY2lfaGNk
IDAwMDA6MDM6MDAuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51
bWJlciAzClsgICAgMy42MjA5ODhdIGVoY2ktcGNpIDAwMDA6MDA6MTMuMjogbmV3IFVTQiBi
dXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA0ClsgICAgMy42MjA5OTRdIGVo
Y2ktcGNpIDAwMDA6MDA6MTMuMjogYXBwbHlpbmcgQU1EIFNCNzAwL1NCODAwL0h1ZHNvbi0y
LzMgRUhDSSBkdW1teSBxaCB3b3JrYXJvdW5kClsgICAgMy42MjEwMDldIGVoY2ktcGNpIDAw
MDA6MDA6MTMuMjogZGVidWcgcG9ydCAxClsgICAgMy42MjEwMzJdIGh1YiAzLTA6MS4wOiBV
U0IgaHViIGZvdW5kClsgICAgMy42MjEwNDBdIGh1YiAzLTA6MS4wOiAyIHBvcnRzIGRldGVj
dGVkClsgICAgMy42MjEwNTVdIGVoY2ktcGNpIDAwMDA6MDA6MTMuMjogaXJxIDIxLCBpbyBt
ZW0gMHhmZWEwNzAwMApbICAgIDMuNjI1NDc2XSBjeDIzODg1IGRyaXZlciB2ZXJzaW9uIDAu
MC4zIGxvYWRlZApbICAgIDMuNjI1NTAyXSBjeDIzODg1IDAwMDA6MDc6MDAuMDogZW5hYmxp
bmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpClsgICAgMy42MjU2NzVdIENPUkUgY3gyMzg4NVsw
XTogc3Vic3lzdGVtOiA0MjU0OjA5NTIsIGJvYXJkOiBEVkJTS1kgUzk1MiBbY2FyZD00MSxh
dXRvZGV0ZWN0ZWRdClsgICAgMy42MzA3MzldIGVoY2ktcGNpIDAwMDA6MDA6MTMuMjogVVNC
IDIuMCBzdGFydGVkLCBFSENJIDEuMDAKWyAgICAzLjYzMTYyOV0gaHViIDQtMDoxLjA6IFVT
QiBodWIgZm91bmQKWyAgICAzLjYzMjMzNV0gaHViIDQtMDoxLjA6IDUgcG9ydHMgZGV0ZWN0
ZWQKWyAgICAzLjYzMjc4NV0gZWhjaS1wY2kgMDAwMDowMDoxNi4yOiBFSENJIEhvc3QgQ29u
dHJvbGxlcgpbICAgIDMuNjMyODE5XSBlaGNpLXBjaSAwMDAwOjAwOjE2LjI6IG5ldyBVU0Ig
YnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNQpbICAgIDMuNjMyODIzXSBl
aGNpLXBjaSAwMDAwOjAwOjE2LjI6IGFwcGx5aW5nIEFNRCBTQjcwMC9TQjgwMC9IdWRzb24t
Mi8zIEVIQ0kgZHVtbXkgcWggd29ya2Fyb3VuZApbICAgIDMuNjMyOTA1XSBlaGNpLXBjaSAw
MDAwOjAwOjE2LjI6IGRlYnVnIHBvcnQgMQpbICAgIDMuNjMzMjIyXSBlaGNpLXBjaSAwMDAw
OjAwOjE2LjI6IGlycSAyMywgaW8gbWVtIDB4ZmVhMDQwMDAKWyAgICAzLjYzODY2M10gRURB
QyBNQzogVmVyOiAzLjAuMApbICAgIDMuNjM5OTU3XSBBTUQ2NCBFREFDIGRyaXZlciB2My40
LjAKWyAgICAzLjY0MDcxNV0gZWhjaS1wY2kgMDAwMDowMDoxNi4yOiBVU0IgMi4wIHN0YXJ0
ZWQsIEVIQ0kgMS4wMApbICAgIDMuNjQwODA4XSBodWIgNS0wOjEuMDogVVNCIGh1YiBmb3Vu
ZApbICAgIDMuNjQwODEyXSBodWIgNS0wOjEuMDogNCBwb3J0cyBkZXRlY3RlZApbICAgIDMu
NjQwOTQ0XSBvaGNpLXBjaSAwMDAwOjAwOjEyLjA6IE9IQ0kgUENJIGhvc3QgY29udHJvbGxl
cgpbICAgIDMuNjQwOTc3XSBvaGNpLXBjaSAwMDAwOjAwOjEyLjA6IG5ldyBVU0IgYnVzIHJl
Z2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNgpbICAgIDMuNjQxMDAwXSBvaGNpLXBj
aSAwMDAwOjAwOjEyLjA6IGlycSAxOCwgaW8gbWVtIDB4ZmVhMGEwMDAKWyAgICAzLjY1MTU2
OF0gbWljcm9jb2RlOiBDUFUwOiBwYXRjaF9sZXZlbD0weDAxMDAwMGM2ClsgICAgMy42NTM2
OTZdIG1pY3JvY29kZTogQ1BVMDogbmV3IHBhdGNoX2xldmVsPTB4MDEwMDAwZGIKWyAgICAz
LjY1MzcwOV0gbWljcm9jb2RlOiBDUFUxOiBwYXRjaF9sZXZlbD0weDAxMDAwMGM2ClsgICAg
My42NTM3MTRdIG1pY3JvY29kZTogQ1BVMTogbmV3IHBhdGNoX2xldmVsPTB4MDEwMDAwZGIK
WyAgICAzLjY1MzcyMF0gbWljcm9jb2RlOiBDUFUyOiBwYXRjaF9sZXZlbD0weDAxMDAwMGM2
ClsgICAgMy42NTM3MjZdIG1pY3JvY29kZTogQ1BVMjogbmV3IHBhdGNoX2xldmVsPTB4MDEw
MDAwZGIKWyAgICAzLjY1MzczMl0gbWljcm9jb2RlOiBDUFUzOiBwYXRjaF9sZXZlbD0weDAx
MDAwMGM2ClsgICAgMy42NTM3MzddIG1pY3JvY29kZTogQ1BVMzogbmV3IHBhdGNoX2xldmVs
PTB4MDEwMDAwZGIKWyAgICAzLjY1MzgwNl0gbWljcm9jb2RlOiBNaWNyb2NvZGUgVXBkYXRl
IERyaXZlcjogdjIuMDAgPHRpZ3JhbkBhaXZhemlhbi5mc25ldC5jby51az4sIFBldGVyIE9y
dWJhClsgICAgMy42NjQ4ODldIGt2bTogTmVzdGVkIFZpcnR1YWxpemF0aW9uIGVuYWJsZWQK
WyAgICAzLjY2NDg5M10ga3ZtOiBOZXN0ZWQgUGFnaW5nIGVuYWJsZWQKWyAgICAzLjY5ODMy
Ml0gaHViIDYtMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjY5ODMzMl0gaHViIDYtMDox
LjA6IDUgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjY5ODQ4OF0gRURBQyBhbWQ2NDogRFJBTSBF
Q0MgZW5hYmxlZC4KWyAgICAzLjY5ODQ5NV0gRURBQyBhbWQ2NDogRjEwaCBkZXRlY3RlZCAo
bm9kZSAwKS4KWyAgICAzLjY5ODUwOF0gRURBQyBNQzogRENUMCBjaGlwIHNlbGVjdHM6Clsg
ICAgMy42OTg1MDldIEVEQUMgYW1kNjQ6IE1DOiAwOiAgICAgME1CIDE6ICAgICAwTUIKWyAg
ICAzLjY5ODUxMF0gRURBQyBhbWQ2NDogTUM6IDI6ICA0MDk2TUIgMzogIDQwOTZNQgpbICAg
IDMuNjk4NTExXSBFREFDIGFtZDY0OiBNQzogNDogICAgIDBNQiA1OiAgICAgME1CClsgICAg
My42OTg1MTJdIEVEQUMgYW1kNjQ6IE1DOiA2OiAgICAgME1CIDc6ICAgICAwTUIKWyAgICAz
LjY5ODUxM10gRURBQyBNQzogRENUMSBjaGlwIHNlbGVjdHM6ClsgICAgMy42OTg1MTRdIEVE
QUMgYW1kNjQ6IE1DOiAwOiAgICAgME1CIDE6ICAgICAwTUIKWyAgICAzLjY5ODUxNV0gRURB
QyBhbWQ2NDogTUM6IDI6ICA0MDk2TUIgMzogIDQwOTZNQgpbICAgIDMuNjk4NTE2XSBFREFD
IGFtZDY0OiBNQzogNDogICAgIDBNQiA1OiAgICAgME1CClsgICAgMy42OTg1MTddIEVEQUMg
YW1kNjQ6IE1DOiA2OiAgICAgME1CIDc6ICAgICAwTUIKWyAgICAzLjY5ODUxN10gRURBQyBh
bWQ2NDogdXNpbmcgeDQgc3luZHJvbWVzLgpbICAgIDMuNjk4NTE4XSBFREFDIGFtZDY0OiBN
Q1QgY2hhbm5lbCBjb3VudDogMgpbICAgIDMuNjk4NTM2XSBFREFDIGFtZDY0OiBDUzI6IFVu
YnVmZmVyZWQgRERSMyBSQU0KWyAgICAzLjY5ODUzN10gRURBQyBhbWQ2NDogQ1MzOiBVbmJ1
ZmZlcmVkIEREUjMgUkFNClsgICAgMy42OTg2MTJdIEVEQUMgTUMwOiBHaXZpbmcgb3V0IGRl
dmljZSB0byAnYW1kNjRfZWRhYycgJ0YxMGgnOiBERVYgMDAwMDowMDoxOC4yClsgICAgMy42
OTg2MzddIEVEQUMgUENJMDogR2l2aW5nIG91dCBkZXZpY2UgdG8gbW9kdWxlICdhbWQ2NF9l
ZGFjJyBjb250cm9sbGVyICdFREFDIFBDSSBjb250cm9sbGVyJzogREVWICcwMDAwOjAwOjE4
LjInIChQT0xMRUQpClsgICAgMy42OTkwNzZdIG9oY2ktcGNpIDAwMDA6MDA6MTMuMDogT0hD
SSBQQ0kgaG9zdCBjb250cm9sbGVyClsgICAgMy42OTkxODFdIG9oY2ktcGNpIDAwMDA6MDA6
MTMuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA3Clsg
ICAgMy42OTkyMDBdIG9oY2ktcGNpIDAwMDA6MDA6MTMuMDogaXJxIDIwLCBpbyBtZW0gMHhm
ZWEwODAwMApbICAgIDMuNzMxMDY5XSB4aGNpX2hjZCAwMDAwOjA1OjAwLjA6IHhIQ0kgSG9z
dCBDb250cm9sbGVyClsgICAgMy43MzExOTFdIHhoY2lfaGNkIDAwMDA6MDU6MDAuMDogbmV3
IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA4ClsgICAgMy43NTQ5
NTZdIGh1YiA3LTA6MS4wOiBVU0IgaHViIGZvdW5kClsgICAgMy43NTQ5NzldIGh1YiA3LTA6
MS4wOiA1IHBvcnRzIGRldGVjdGVkClsgICAgMy43NTU0MjNdIG9oY2ktcGNpIDAwMDA6MDA6
MTQuNTogT0hDSSBQQ0kgaG9zdCBjb250cm9sbGVyClsgICAgMy43NTU1MjddIG9oY2ktcGNp
IDAwMDA6MDA6MTQuNTogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51
bWJlciA5ClsgICAgMy43NTU1NjBdIG9oY2ktcGNpIDAwMDA6MDA6MTQuNTogaXJxIDE4LCBp
byBtZW0gMHhmZWEwNjAwMApbICAgIDMuNzkwNjUzXSB4aGNpX2hjZCAwMDAwOjA1OjAwLjA6
IGlycSA4MSBmb3IgTVNJL01TSS1YClsgICAgMy43OTA2ODBdIHhoY2lfaGNkIDAwMDA6MDU6
MDAuMDogaXJxIDgyIGZvciBNU0kvTVNJLVgKWyAgICAzLjc5MDcwM10geGhjaV9oY2QgMDAw
MDowNTowMC4wOiBpcnEgODMgZm9yIE1TSS9NU0ktWApbICAgIDMuNzkwNzIzXSB4aGNpX2hj
ZCAwMDAwOjA1OjAwLjA6IGlycSA4NCBmb3IgTVNJL01TSS1YClsgICAgMy43OTA3NDNdIHho
Y2lfaGNkIDAwMDA6MDU6MDAuMDogaXJxIDg1IGZvciBNU0kvTVNJLVgKWyAgICAzLjc5MTE2
M10gaHViIDgtMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjc5MTE4MV0gaHViIDgtMDox
LjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjc5MTMzOF0geGhjaV9oY2QgMDAwMDowNTow
MC4wOiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMuNzkxNDIxXSB4aGNpX2hjZCAwMDAw
OjA1OjAwLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIg
MTAKWyAgICAzLjc5MTY3NV0gaHViIDEwLTA6MS4wOiBVU0IgaHViIGZvdW5kClsgICAgMy43
OTE3MTJdIGh1YiAxMC0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZApbICAgIDMuODExODg5XSBo
dWIgOS0wOjEuMDogVVNCIGh1YiBmb3VuZApbICAgIDMuODExOTEwXSBodWIgOS0wOjEuMDog
MiBwb3J0cyBkZXRlY3RlZApbICAgIDMuODEyMjYwXSBvaGNpLXBjaSAwMDAwOjAwOjE2LjA6
IE9IQ0kgUENJIGhvc3QgY29udHJvbGxlcgpbICAgIDMuODEyMzYxXSBvaGNpLXBjaSAwMDAw
OjAwOjE2LjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIg
MTEKWyAgICAzLjgxMjQxMV0gb2hjaS1wY2kgMDAwMDowMDoxNi4wOiBpcnEgMjIsIGlvIG1l
bSAweGZlYTA1MDAwClsgICAgMy44NjE3NDJdIGN4MjU4NDAgMTMtMDA0NDogY3gyMzg4NSBB
L1YgZGVjb2RlciBmb3VuZCBAIDB4ODggKGN4MjM4ODVbMF0pClsgICAgMy44NjgyMjldIGh1
YiAxMS0wOjEuMDogVVNCIGh1YiBmb3VuZApbICAgIDMuODY4MjUyXSBodWIgMTEtMDoxLjA6
IDQgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjkyMDUwOF0gdXNiIDEtNDogbmV3IGhpZ2gtc3Bl
ZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpLXBjaQpbICAgIDQuMDM0OTYwXSBT
UEw6IExvYWRlZCBtb2R1bGUgdjAuNi4zLXIwLWdlbnRvbwpbICAgIDQuMDM2MTcxXSB6bnZw
YWlyOiBtb2R1bGUgbGljZW5zZSAnQ0RETCcgdGFpbnRzIGtlcm5lbC4KWyAgICA0LjAzNjE3
M10gRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5nIGR1ZSB0byBrZXJuZWwgdGFpbnQKWyAgICA0
LjA0NjA2OF0gaHViIDEtNDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICA0LjA0NjM0NV0gaHVi
IDEtNDoxLjA6IDQgcG9ydHMgZGV0ZWN0ZWQKWyAgICA0LjA2NjAzMV0gWkZTOiBMb2FkZWQg
bW9kdWxlIHYwLjYuMy1yMC1nZW50b28sIFpGUyBwb29sIHZlcnNpb24gNTAwMCwgWkZTIGZp
bGVzeXN0ZW0gdmVyc2lvbiA1ClsgICAgNC41MDA3MjVdIGN4MjU4NDAgMTMtMDA0NDogbG9h
ZGVkIHY0bC1jeDIzODg1LWF2Y29yZS0wMS5mdyBmaXJtd2FyZSAoMTYzODIgYnl0ZXMpClsg
ICAgNC41MTc3MjddIGN4MjM4ODVfZHZiX3JlZ2lzdGVyKCkgYWxsb2NhdGluZyAxIGZyb250
ZW5kKHMpClsgICAgNC41MTc3MzFdIGN4MjM4ODVbMF06IGN4MjM4ODUgYmFzZWQgZHZiIGNh
cmQKWyAgICA0LjUyMjgzNl0gRFMzMDAwIGNoaXAgdmVyc2lvbjogZDAgYXR0YWNoZWQuClsg
ICAgNC41MjM2MzddIFRTMjAyeCBjaGlwIHZlcnNpb25bMV06IGMxIGF0dGFjaGVkLgpbICAg
IDQuNTM0MTAwXSBUUzIwMnggY2hpcCB2ZXJzaW9uWzJdOiBjMyBhdHRhY2hlZC4KWyAgICA0
LjU3MzU4N10gbTg4ZHMzMTAzX2xvYWRfZmlybXdhcmU6IFdhaXRpbmcgZm9yIGZpcm13YXJl
IHVwbG9hZCAoZHZiLWZlLWRzMzEwMy5mdykuLi4KWyAgICA0LjU3NDEzNl0gbTg4ZHMzMTAz
X2xvYWRfZmlybXdhcmU6IFdhaXRpbmcgZm9yIGZpcm13YXJlIHVwbG9hZCgyKS4uLgpbICAg
IDQuODQ2MjE5XSB1c2IgNy00OiBuZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAy
IHVzaW5nIG9oY2ktcGNpClsgICAgNS4wMTYzMTZdIGlucHV0OiBSYXplciBSYXplciBOYWdh
IDIwMTQgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEzLjAvdXNiNy83LTQvNy00
OjEuMC9pbnB1dC9pbnB1dDMKWyAgICA1LjAxNjQ5MF0gaGlkLWdlbmVyaWMgMDAwMzoxNTMy
OjAwNDAuMDAwMTogaW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2MS4xMSBNb3VzZSBbUmF6ZXIg
UmF6ZXIgTmFnYSAyMDE0XSBvbiB1c2ItMDAwMDowMDoxMy4wLTQvaW5wdXQwClsgICAgNS4w
MjU1NTNdIGlucHV0OiBSYXplciBSYXplciBOYWdhIDIwMTQgYXMgL2RldmljZXMvcGNpMDAw
MDowMC8wMDAwOjAwOjEzLjAvdXNiNy83LTQvNy00OjEuMS9pbnB1dC9pbnB1dDQKWyAgICA1
LjAyNTY2N10gaGlkLWdlbmVyaWMgMDAwMzoxNTMyOjAwNDAuMDAwMjogaW5wdXQsaGlkcmF3
MTogVVNCIEhJRCB2MS4xMSBLZXlib2FyZCBbUmF6ZXIgUmF6ZXIgTmFnYSAyMDE0XSBvbiB1
c2ItMDAwMDowMDoxMy4wLTQvaW5wdXQxClsgICAgNS4wMzE0ODldIGlucHV0OiBSYXplciBS
YXplciBOYWdhIDIwMTQgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEzLjAvdXNi
Ny83LTQvNy00OjEuMi9pbnB1dC9pbnB1dDUKWyAgICA1LjAzMTU5N10gaGlkLWdlbmVyaWMg
MDAwMzoxNTMyOjAwNDAuMDAwMzogaW5wdXQsaGlkcmF3MjogVVNCIEhJRCB2MS4xMSBLZXli
b2FyZCBbUmF6ZXIgUmF6ZXIgTmFnYSAyMDE0XSBvbiB1c2ItMDAwMDowMDoxMy4wLTQvaW5w
dXQyClsgICAgNS4wNzM5MDhdIFNQTDogdXNpbmcgaG9zdGlkIDB4MDAwMDAwMDAKWyAgICA1
LjE1OTI5NF0gdXNiIDYtMzogbmV3IGxvdy1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAyIHVz
aW5nIG9oY2ktcGNpClsgICAgNS4xODc4NzBdIHpwb29sICgxMjc4KSB1c2VkIGdyZWF0ZXN0
IHN0YWNrIGRlcHRoOiAyMDI0IGJ5dGVzIGxlZnQKWyAgICA1LjMzMjY2MF0gaGlkLWdlbmVy
aWMgMDAwMzowNjY1OjUxNjEuMDAwNDogaGlkZGV2MCxoaWRyYXczOiBVU0IgSElEIHYxLjAw
IERldmljZSBbSU5OTyBURUNIIFVTQiB0byBTZXJpYWxdIG9uIHVzYi0wMDAwOjAwOjEyLjAt
My9pbnB1dDAKWyAgICA1LjQ4NDMyMV0gRFZCOiByZWdpc3RlcmluZyBuZXcgYWRhcHRlciAo
Y3gyMzg4NVswXSkKWyAgICA1LjQ4NDMyNF0gY3gyMzg4NSAwMDAwOjA3OjAwLjA6IERWQjog
cmVnaXN0ZXJpbmcgYWRhcHRlciAwIGZyb250ZW5kIDAgKE1vbnRhZ2UgRFMzMTAzL1RTMjAy
MikuLi4KWyAgICA1LjUxMjE4OV0gRFZCU0tZIFBDSWUgTUFDPSAwMDoxNzo0Mjo1NDowOTo1
MgpbICAgIDUuNTEyMTkxXSBjeDIzODg1X2R2Yl9yZWdpc3RlcigpIGFsbG9jYXRpbmcgMSBm
cm9udGVuZChzKQpbICAgIDUuNTEyMjQwXSBjeDIzODg1WzBdOiBjeDIzODg1IGJhc2VkIGR2
YiBjYXJkClsgICAgNS41MTI3NjldIERTMzAwMCBjaGlwIHZlcnNpb246IGQwIGF0dGFjaGVk
LgpbICAgIDUuNTEzNTk3XSBUUzIwMnggY2hpcCB2ZXJzaW9uWzFdOiBjMSBhdHRhY2hlZC4K
WyAgICA1LjUyMzEyOV0gVFMyMDJ4IGNoaXAgdmVyc2lvblsyXTogYzMgYXR0YWNoZWQuClsg
ICAgNS41NjI2MDBdIG04OGRzMzEwM19sb2FkX2Zpcm13YXJlOiBXYWl0aW5nIGZvciBmaXJt
d2FyZSB1cGxvYWQgKGR2Yi1mZS1kczMxMDMuZncpLi4uClsgICAgNS41NjI2MTldIG04OGRz
MzEwM19sb2FkX2Zpcm13YXJlOiBXYWl0aW5nIGZvciBmaXJtd2FyZSB1cGxvYWQoMikuLi4K
WyAgICA1LjU4MjE4OF0gdXNiIDYtNTogbmV3IGxvdy1zcGVlZCBVU0IgZGV2aWNlIG51bWJl
ciAzIHVzaW5nIG9oY2ktcGNpClsgICAgNS43NDU4NzFdIGlucHV0OiBISUQgMDRmMzowMTAz
IGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxMi4wL3VzYjYvNi01LzYtNToxLjAv
aW5wdXQvaW5wdXQ2ClsgICAgNS43NDYwNjFdIGhpZC1nZW5lcmljIDAwMDM6MDRGMzowMTAz
LjAwMDU6IGlucHV0LGhpZHJhdzQ6IFVTQiBISUQgdjEuMTAgS2V5Ym9hcmQgW0hJRCAwNGYz
OjAxMDNdIG9uIHVzYi0wMDAwOjAwOjEyLjAtNS9pbnB1dDAKWyAgICA1Ljc1NDI0MF0gaW5w
dXQ6IEhJRCAwNGYzOjAxMDMgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEyLjAv
dXNiNi82LTUvNi01OjEuMS9pbnB1dC9pbnB1dDcKWyAgICA1Ljc1NDQyNF0gaGlkLWdlbmVy
aWMgMDAwMzowNEYzOjAxMDMuMDAwNjogaW5wdXQsaGlkcmF3NTogVVNCIEhJRCB2MS4xMCBE
ZXZpY2UgW0hJRCAwNGYzOjAxMDNdIG9uIHVzYi0wMDAwOjAwOjEyLjAtNS9pbnB1dDEKWyAg
ICA2LjQ3MjY1NV0gRFZCOiByZWdpc3RlcmluZyBuZXcgYWRhcHRlciAoY3gyMzg4NVswXSkK
WyAgICA2LjQ3MjY2MF0gY3gyMzg4NSAwMDAwOjA3OjAwLjA6IERWQjogcmVnaXN0ZXJpbmcg
YWRhcHRlciAxIGZyb250ZW5kIDAgKE1vbnRhZ2UgRFMzMTAzL1RTMjAyMikuLi4KWyAgICA2
LjUwMDU5MF0gRFZCU0tZIFBDSWUgTUFDPSAwMDoxNzo0Mjo1NDowOTo1MwpbICAgIDYuNTAw
NTkzXSBjeDIzODg1X2Rldl9jaGVja3JldmlzaW9uKCkgSGFyZHdhcmUgcmV2aXNpb24gPSAw
eGE1ClsgICAgNi41MDA1OThdIGN4MjM4ODVbMF0vMDogZm91bmQgYXQgMDAwMDowNzowMC4w
LCByZXY6IDQsIGlycTogMjAsIGxhdGVuY3k6IDAsIG1taW86IDB4ZmU0MDAwMDAKWyAgICA2
LjUyODAwOF0gUmVnaXN0ZXJlZCBJUiBrZXltYXAgcmMtZHZic2t5ClsgICAgNi41MjgxNTld
IGlucHV0OiBjeDIzODg1IElSIChEVkJTS1kgUzk1MikgYXMgL2RldmljZXMvcGNpMDAwMDow
MC8wMDAwOjAwOjE1LjAvMDAwMDowNzowMC4wL3JjL3JjMC9pbnB1dDgKWyAgICA2LjUzMTgx
Ml0gcmMwOiBjeDIzODg1IElSIChEVkJTS1kgUzk1MikgYXMgL2RldmljZXMvcGNpMDAwMDow
MC8wMDAwOjAwOjE1LjAvMDAwMDowNzowMC4wL3JjL3JjMApbICAgIDYuNTM0NzM1XSBJUiBO
RUMgcHJvdG9jb2wgaGFuZGxlciBpbml0aWFsaXplZApbICAgIDYuNTM0OTc5XSBJUiBSQzUo
eCkgcHJvdG9jb2wgaGFuZGxlciBpbml0aWFsaXplZApbICAgIDYuNTM1Mjg5XSBJUiBKVkMg
cHJvdG9jb2wgaGFuZGxlciBpbml0aWFsaXplZApbICAgIDYuNTM1NDkxXSBJUiBSQzYgcHJv
dG9jb2wgaGFuZGxlciBpbml0aWFsaXplZApbICAgIDYuNTM2MjQyXSBJUiBTb255IHByb3Rv
Y29sIGhhbmRsZXIgaW5pdGlhbGl6ZWQKWyAgICA2LjUzNjMxOV0gSVIgU0FOWU8gcHJvdG9j
b2wgaGFuZGxlciBpbml0aWFsaXplZApbICAgIDYuNTM3OTE5XSBsaXJjX2RldjogSVIgUmVt
b3RlIENvbnRyb2wgZHJpdmVyIHJlZ2lzdGVyZWQsIG1ham9yIDI1MCAKWyAgICA2LjUzODU0
MV0gcmMgcmMwOiBsaXJjX2RldjogZHJpdmVyIGlyLWxpcmMtY29kZWMgKGN4MjM4ODUpIHJl
Z2lzdGVyZWQgYXQgbWlub3IgPSAwClsgICAgNi41Mzg1NDRdIElSIExJUkMgYnJpZGdlIGhh
bmRsZXIgaW5pdGlhbGl6ZWQKWyAgICA2LjUzOTYzOF0gaW5wdXQ6IE1DRSBJUiBLZXlib2Fy
ZC9Nb3VzZSAoY3gyMzg4NSkgYXMgL2RldmljZXMvdmlydHVhbC9pbnB1dC9pbnB1dDkKWyAg
ICA2LjUzOTcwNF0gSVIgTUNFIEtleWJvYXJkL21vdXNlIHByb3RvY29sIGhhbmRsZXIgaW5p
dGlhbGl6ZWQKWyAgICA4LjM2NzUxOF0gRVhUNC1mcyAoc2RhMik6IHJlLW1vdW50ZWQuIE9w
dHM6IChudWxsKQpbICAgIDguNTM1MjQxXSBGQVQtZnMgKHNkYTEpOiBWb2x1bWUgd2FzIG5v
dCBwcm9wZXJseSB1bm1vdW50ZWQuIFNvbWUgZGF0YSBtYXkgYmUgY29ycnVwdC4gUGxlYXNl
IHJ1biBmc2NrLgpbICAgIDguNTQ3OTMxXSBFWFQ0LWZzIChzZGUxKTogbW91bnRlZCBmaWxl
c3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIE9wdHM6IGRpc2NhcmQKWyAgIDExLjQx
MjYxMl0gcjgxNjkgMDAwMDowMjowMC4wIGV0aDA6IGxpbmsgZG93bgpbICAgMTEuNDEyNjMx
XSByODE2OSAwMDAwOjAyOjAwLjAgZXRoMDogbGluayBkb3duClsgICAxMS40MTI2NjldIElQ
djY6IEFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90IHJlYWR5ClsgICAx
My41MjY1NjZdIHI4MTY5IDAwMDA6MDI6MDAuMCBldGgwOiBsaW5rIHVwClsgICAxMy41MjY1
OTldIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBldGgwOiBsaW5rIGJlY29tZXMg
cmVhZHkKWyAgIDE5LjA0ODUyMF0gaXQ4NzogRm91bmQgSVQ4NzIxRiBjaGlwIGF0IDB4Mjkw
LCByZXZpc2lvbiAxClsgICAxOS4wNjE4MjVdIGl0ODcgaXQ4Ny42NTY6IFNlbnNvciB0eXBl
IDIgaXMgZGVwcmVjYXRlZCwgcGxlYXNlIHVzZSA0IGluc3RlYWQKWyAgIDE5LjA2MTg1N10g
aXQ4NyBpdDg3LjY1NjogU2Vuc29yIHR5cGUgMiBpcyBkZXByZWNhdGVkLCBwbGVhc2UgdXNl
IDQgaW5zdGVhZApbICAgMjAuNTIxMDY4XSBpbnB1dDogUmF6ZXIgUmF6ZXIgTmFnYSAyMDE0
IGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxMy4wL3VzYjcvNy00LzctNDoxLjAv
aW5wdXQvaW5wdXQxMApbICAgMjAuNTIxNDAzXSBoaWQtZ2VuZXJpYyAwMDAzOjE1MzI6MDA0
MC4wMDA3OiBpbnB1dCxoaWRyYXcwOiBVU0IgSElEIHYxLjExIE1vdXNlIFtSYXplciBSYXpl
ciBOYWdhIDIwMTRdIG9uIHVzYi0wMDAwOjAwOjEzLjAtNC9pbnB1dDAKWyAgIDIwLjc0MTAy
NF0gaW5wdXQ6IFJhemVyIFJhemVyIE5hZ2EgMjAxNCBhcyAvZGV2aWNlcy9wY2kwMDAwOjAw
LzAwMDA6MDA6MTMuMC91c2I3LzctNC83LTQ6MS4wL2lucHV0L2lucHV0MTEKWyAgIDIwLjc0
MTM4MV0gaGlkLWdlbmVyaWMgMDAwMzoxNTMyOjAwNDAuMDAwODogaW5wdXQsaGlkcmF3MDog
VVNCIEhJRCB2MS4xMSBNb3VzZSBbUmF6ZXIgUmF6ZXIgTmFnYSAyMDE0XSBvbiB1c2ItMDAw
MDowMDoxMy4wLTQvaW5wdXQwClsgIDE0MS4xMTI2MzFdIFBNOiBTeW5jaW5nIGZpbGVzeXN0
ZW1zIC4uLiBkb25lLgpbICAxNDQuMTQyODU5XSBQTTogUHJlcGFyaW5nIHN5c3RlbSBmb3Ig
bWVtIHNsZWVwClsgIDE0NC4zOTE0NjNdIEZyZWV6aW5nIHVzZXIgc3BhY2UgcHJvY2Vzc2Vz
IC4uLiAoZWxhcHNlZCAwLjAwNCBzZWNvbmRzKSBkb25lLgpbICAxNDQuMzk1NTgyXSBGcmVl
emluZyByZW1haW5pbmcgZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjAwMSBzZWNv
bmRzKSBkb25lLgpbICAxNDQuMzk2OTYxXSBQTTogRW50ZXJpbmcgbWVtIHNsZWVwClsgIDE0
NC4zOTgyNjNdIFN1c3BlbmRpbmcgY29uc29sZShzKSAodXNlIG5vX2NvbnNvbGVfc3VzcGVu
ZCB0byBkZWJ1ZykKWyAgMTQ0LjM5OTE5OF0gc2QgNDowOjA6MDogW3NkZV0gU3luY2hyb25p
emluZyBTQ1NJIGNhY2hlClsgIDE0NC4zOTkyNDRdIHNkIDM6MDowOjA6IFtzZGRdIFN5bmNo
cm9uaXppbmcgU0NTSSBjYWNoZQpbICAxNDQuMzk5MzI3XSBzZCAzOjA6MDowOiBbc2RkXSBT
dG9wcGluZyBkaXNrClsgIDE0NC4zOTkzMzNdIHNkIDI6MDowOjA6IFtzZGNdIFN5bmNocm9u
aXppbmcgU0NTSSBjYWNoZQpbICAxNDQuMzk5NDA4XSBzZCAxOjA6MDowOiBbc2RiXSBTeW5j
aHJvbml6aW5nIFNDU0kgY2FjaGUKWyAgMTQ0LjM5OTQxMl0gc2QgMjowOjA6MDogW3NkY10g
U3RvcHBpbmcgZGlzawpbICAxNDQuMzk5NDg1XSBzZCAwOjA6MDowOiBbc2RhXSBTeW5jaHJv
bml6aW5nIFNDU0kgY2FjaGUKWyAgMTQ0LjM5OTQ4OV0gc2QgMTowOjA6MDogW3NkYl0gU3Rv
cHBpbmcgZGlzawpbICAxNDQuMzk5NzE2XSBzZCAwOjA6MDowOiBbc2RhXSBTdG9wcGluZyBk
aXNrClsgIDE0NC40MDEyODldIHNkIDQ6MDowOjA6IFtzZGVdIFN0b3BwaW5nIGRpc2sKWyAg
MTQ0LjQwMjI2MF0gaTgwNDIga2JkIDAwOjA5OiBTeXN0ZW0gd2FrZXVwIGVuYWJsZWQgYnkg
QUNQSQpbICAxNDUuMDQ2Nzc2XSBQTTogc3VzcGVuZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFm
dGVyIDY0OC42ODQgbXNlY3MKWyAgMTQ1LjA0NzIwNl0gUE06IGxhdGUgc3VzcGVuZCBvZiBk
ZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDAuNDI0IG1zZWNzClsgIDE0NS4wNDc2MDVdIHBjaWVw
b3J0IDAwMDA6MDA6MDcuMDogU3lzdGVtIHdha2V1cCBlbmFibGVkIGJ5IEFDUEkKWyAgMTQ1
LjA1ODI5OF0gcGNpZXBvcnQgMDAwMDowMDowNS4wOiBTeXN0ZW0gd2FrZXVwIGVuYWJsZWQg
YnkgQUNQSQpbICAxNDUuMDcxNjE1XSBwY2llcG9ydCAwMDAwOjAwOjA0LjA6IFN5c3RlbSB3
YWtldXAgZW5hYmxlZCBieSBBQ1BJClsgIDE0NS4wODUwNDFdIGVoY2ktcGNpIDAwMDA6MDA6
MTYuMjogU3lzdGVtIHdha2V1cCBlbmFibGVkIGJ5IEFDUEkKWyAgMTQ1LjA5ODE3N10gb2hj
aS1wY2kgMDAwMDowMDoxNi4wOiBTeXN0ZW0gd2FrZXVwIGVuYWJsZWQgYnkgQUNQSQpbICAx
NDUuMDk4MjQ5XSBvaGNpLXBjaSAwMDAwOjAwOjE0LjU6IFN5c3RlbSB3YWtldXAgZW5hYmxl
ZCBieSBBQ1BJClsgIDE0NS4wOTg0MTZdIGVoY2ktcGNpIDAwMDA6MDA6MTMuMjogU3lzdGVt
IHdha2V1cCBlbmFibGVkIGJ5IEFDUEkKWyAgMTQ1LjExMTQ4NV0gb2hjaS1wY2kgMDAwMDow
MDoxMy4wOiBTeXN0ZW0gd2FrZXVwIGVuYWJsZWQgYnkgQUNQSQpbICAxNDUuMTExNTI3XSBl
aGNpLXBjaSAwMDAwOjAwOjEyLjI6IFN5c3RlbSB3YWtldXAgZW5hYmxlZCBieSBBQ1BJClsg
IDE0NS4xMjQ4MDVdIG9oY2ktcGNpIDAwMDA6MDA6MTIuMDogU3lzdGVtIHdha2V1cCBlbmFi
bGVkIGJ5IEFDUEkKWyAgMTQ1LjEyNTA2NV0gUE06IG5vaXJxIHN1c3BlbmQgb2YgZGV2aWNl
cyBjb21wbGV0ZSBhZnRlciA3Ny45MzAgbXNlY3MKWyAgMTQ1LjEyNjI0NV0gQUNQSTogUHJl
cGFyaW5nIHRvIGVudGVyIHN5c3RlbSBzbGVlcCBzdGF0ZSBTMwpbICAxNDUuMTI2Mzk4XSBb
RmlybXdhcmUgQnVnXTogQUNQSTogQklPUyBfT1NJKExpbnV4KSBxdWVyeSBpZ25vcmVkClsg
IDE0NS4xMjc5OTBdIFBNOiBTYXZpbmcgcGxhdGZvcm0gTlZTIG1lbW9yeQpbICAxNDUuMTQ2
ODUzXSBEaXNhYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KWyAgMTQ1LjE0ODMwNV0gc21wYm9v
dDogQ1BVIDEgaXMgbm93IG9mZmxpbmUKWyAgMTQ1LjI1MTIwNF0gc21wYm9vdDogQ1BVIDIg
aXMgbm93IG9mZmxpbmUKWyAgMTQ1LjM1NDQ2MV0gc21wYm9vdDogQ1BVIDMgaXMgbm93IG9m
ZmxpbmUKWyAgMTQ1LjM1NzIyOV0gQUNQSTogTG93LWxldmVsIHJlc3VtZSBjb21wbGV0ZQpb
ICAxNDUuMzU3MjU5XSBQTTogUmVzdG9yaW5nIHBsYXRmb3JtIE5WUyBtZW1vcnkKWyAgMTQ1
LjUxNDQ3NV0gTFZUIG9mZnNldCAxIGFzc2lnbmVkIGZvciB2ZWN0b3IgMHg0MDAKWyAgMTQ1
LjUxNDQ4M10gSUJTOiBMVlQgb2Zmc2V0IDEgYXNzaWduZWQKWyAgMTQ1LjUxNDU0NV0gbWlj
cm9jb2RlOiBDUFUwOiBuZXcgcGF0Y2hfbGV2ZWw9MHgwMTAwMDBkYgpbICAxNDUuNTE0NTcz
XSBFbmFibGluZyBub24tYm9vdCBDUFVzIC4uLgpbICAxNDUuNTE0NjA3XSBzbXBib290OiBC
b290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMSBBUElDIDB4MQpbICAxNDUuNTI3NzM2XSBwcm9j
ZXNzOiBTd2l0Y2ggdG8gYnJvYWRjYXN0IG1vZGUgb24gQ1BVMQpbICAxNDUuNTI3ODg1XSBt
aWNyb2NvZGU6IENQVTE6IG5ldyBwYXRjaF9sZXZlbD0weDAxMDAwMGRiClsgIDE0NS41Mjc4
ODhdIENQVTEgaXMgdXAKWyAgMTQ1LjUyNzg5OV0gc21wYm9vdDogQm9vdGluZyBOb2RlIDAg
UHJvY2Vzc29yIDIgQVBJQyAweDIKWyAgMTQ1LjU0MTAxMF0gcHJvY2VzczogU3dpdGNoIHRv
IGJyb2FkY2FzdCBtb2RlIG9uIENQVTIKWyAgMTQ1LjU0MTE0MF0gbWljcm9jb2RlOiBDUFUy
OiBuZXcgcGF0Y2hfbGV2ZWw9MHgwMTAwMDBkYgpbICAxNDUuNTQxMTQzXSBDUFUyIGlzIHVw
ClsgIDE0NS41NDExNTJdIHNtcGJvb3Q6IEJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAzIEFQ
SUMgMHgzClsgIDE0NS41NTQyODhdIHByb2Nlc3M6IFN3aXRjaCB0byBicm9hZGNhc3QgbW9k
ZSBvbiBDUFUzClsgIDE0NS41NTQ0MTNdIG1pY3JvY29kZTogQ1BVMzogbmV3IHBhdGNoX2xl
dmVsPTB4MDEwMDAwZGIKWyAgMTQ1LjU1NDQxNl0gQ1BVMyBpcyB1cApbICAxNDUuNTYzMjQz
XSBBQ1BJOiBXYWtpbmcgdXAgZnJvbSBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMKWyAgMTQ1LjU2
Mzg4NV0gb2hjaS1wY2kgMDAwMDowMDoxMi4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5
IEFDUEkKWyAgMTQ1LjU3NzQxNl0gZWhjaS1wY2kgMDAwMDowMDoxMi4yOiBTeXN0ZW0gd2Fr
ZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgMTQ1LjU3NzQ1OV0gb2hjaS1wY2kgMDAwMDowMDox
My4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgMTQ1LjU5MDY5Nl0gZWhj
aS1wY2kgMDAwMDowMDoxMy4yOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAg
MTQ1LjU5MDc4OV0gb2hjaS1wY2kgMDAwMDowMDoxNC41OiBTeXN0ZW0gd2FrZXVwIGRpc2Fi
bGVkIGJ5IEFDUEkKWyAgMTQ1LjU5MDgzN10gb2hjaS1wY2kgMDAwMDowMDoxNi4wOiBTeXN0
ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgMTQ1LjYwNDAyNV0gZWhjaS1wY2kgMDAw
MDowMDoxNi4yOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgMTQ1LjY0NDAx
MV0gcGNpZXBvcnQgMDAwMDowMDowNS4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFD
UEkKWyAgMTQ1LjY3MDY2MV0gcGNpZXBvcnQgMDAwMDowMDowNy4wOiBTeXN0ZW0gd2FrZXVw
IGRpc2FibGVkIGJ5IEFDUEkKWyAgMTQ1LjY4NDI0OF0gUE06IG5vaXJxIHJlc3VtZSBvZiBk
ZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDEyMC42NTcgbXNlY3MKWyAgMTQ1LjY4NDU5OV0gUE06
IGVhcmx5IHJlc3VtZSBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDAuMjc2IG1zZWNzClsg
IDE0NS42ODUwMThdIHVzYiB1c2IyOiByb290IGh1YiBsb3N0IHBvd2VyIG9yIHdhcyByZXNl
dApbICAxNDUuNjg1MDIyXSB1c2IgdXNiMzogcm9vdCBodWIgbG9zdCBwb3dlciBvciB3YXMg
cmVzZXQKWyAgMTQ1LjY4NTA0M10gdXNiIHVzYjg6IHJvb3QgaHViIGxvc3QgcG93ZXIgb3Ig
d2FzIHJlc2V0ClsgIDE0NS42ODUwNDddIHVzYiB1c2IxMDogcm9vdCBodWIgbG9zdCBwb3dl
ciBvciB3YXMgcmVzZXQKWyAgMTQ1Ljc0NTMzNV0geGhjaV9oY2QgMDAwMDowNTowMC4wOiBp
cnEgNzYgZm9yIE1TSS9NU0ktWApbICAxNDUuNzQ1Mzc5XSB4aGNpX2hjZCAwMDAwOjA1OjAw
LjA6IGlycSA3NyBmb3IgTVNJL01TSS1YClsgIDE0NS43NDU0MTRdIHhoY2lfaGNkIDAwMDA6
MDU6MDAuMDogaXJxIDc4IGZvciBNU0kvTVNJLVgKWyAgMTQ1Ljc0NTQzN10geGhjaV9oY2Qg
MDAwMDowNTowMC4wOiBpcnEgNzkgZm9yIE1TSS9NU0ktWApbICAxNDUuNzQ1NDYxXSB4aGNp
X2hjZCAwMDAwOjAzOjAwLjA6IGlycSA4MCBmb3IgTVNJL01TSS1YClsgIDE0NS43NDU0NzFd
IHhoY2lfaGNkIDAwMDA6MDU6MDAuMDogaXJxIDgxIGZvciBNU0kvTVNJLVgKWyAgMTQ1Ljc0
NTQ5Ml0geGhjaV9oY2QgMDAwMDowMzowMC4wOiBpcnEgODIgZm9yIE1TSS9NU0ktWApbICAx
NDUuNzQ1NTM4XSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IGlycSA4MyBmb3IgTVNJL01TSS1Y
ClsgIDE0NS43NDU1NzRdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDogaXJxIDg0IGZvciBNU0kv
TVNJLVgKWyAgMTQ1Ljc0NTYwOV0geGhjaV9oY2QgMDAwMDowMzowMC4wOiBpcnEgODUgZm9y
IE1TSS9NU0ktWApbICAxNDUuNzQ3MDE5XSBpODA0MiBrYmQgMDA6MDk6IFN5c3RlbSB3YWtl
dXAgZGlzYWJsZWQgYnkgQUNQSQpbICAxNDUuNzQ3MDc0XSBwY2llcG9ydCAwMDAwOjAwOjA0
LjA6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQpbICAxNDUuNzY2MTE4XSBbZHJt
XSBlbmFibGluZyBQQ0lFIGdlbiAyIGxpbmsgc3BlZWRzLCBkaXNhYmxlIHdpdGggcmFkZW9u
LnBjaWVfZ2VuMj0wClsgIDE0NS43NjkxMTNdIEF1ZGlneTIgdmFsdWU6IFNwZWNpYWwgY29u
ZmlnLgpbICAxNDUuNzY5MTQ4XSBbZHJtXSBQQ0lFIEdBUlQgb2YgMTAyNE0gZW5hYmxlZCAo
dGFibGUgYXQgMHgwMDAwMDAwMDAwMjVEMDAwKS4KWyAgMTQ1Ljc2OTIyNF0gcmFkZW9uIDAw
MDA6MDE6MDAuMDogV0IgZW5hYmxlZApbICAxNDUuNzY5MjI2XSByYWRlb24gMDAwMDowMTow
MC4wOiBmZW5jZSBkcml2ZXIgb24gcmluZyAwIHVzZSBncHUgYWRkciAweDAwMDAwMDAwNDAw
MDBjMDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDQyY2JjY2MwMApbICAxNDUuNzY5MjI3XSBy
YWRlb24gMDAwMDowMTowMC4wOiBmZW5jZSBkcml2ZXIgb24gcmluZyAzIHVzZSBncHUgYWRk
ciAweDAwMDAwMDAwNDAwMDBjMGMgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDQyY2JjY2MwYwpb
ICAxNDUuNzY5NTk3XSByYWRlb24gMDAwMDowMTowMC4wOiBmZW5jZSBkcml2ZXIgb24gcmlu
ZyA1IHVzZSBncHUgYWRkciAweDAwMDAwMDAwMDAwNWM0MTggYW5kIGNwdSBhZGRyIDB4ZmZm
ZmM5MDAxNTM5YzQxOApbICAxNDUuNzg1NzYwXSBbZHJtXSByaW5nIHRlc3Qgb24gMCBzdWNj
ZWVkZWQgaW4gMCB1c2VjcwpbICAxNDUuNzg1ODIyXSBbZHJtXSByaW5nIHRlc3Qgb24gMyBz
dWNjZWVkZWQgaW4gMSB1c2VjcwpbICAxNDUuOTgzMTM0XSBbZHJtXSByaW5nIHRlc3Qgb24g
NSBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbICAxNDUuOTgzMTM4XSBbZHJtXSBVVkQgaW5pdGlh
bGl6ZWQgc3VjY2Vzc2Z1bGx5LgpbICAxNDUuOTgzMTczXSBbZHJtXSBpYiB0ZXN0IG9uIHJp
bmcgMCBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbICAxNDUuOTgzMjAyXSBbZHJtXSBpYiB0ZXN0
IG9uIHJpbmcgMyBzdWNjZWVkZWQgaW4gMSB1c2VjcwpbICAxNDUuOTg1NDkyXSByODE2OSAw
MDAwOjAyOjAwLjAgZXRoMDogbGluayBkb3duClsgIDE0Ni4wNjM0NDBdIGF0YTU6IFNBVEEg
bGluayB1cCA2LjAgR2JwcyAoU1N0YXR1cyAxMzMgU0NvbnRyb2wgMzAwKQpbICAxNDYuMDYz
NDgxXSBhdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9s
IDMwMCkKWyAgMTQ2LjA2NTM0NV0gYXRhNS4wMDogc3VwcG9ydHMgRFJNIGZ1bmN0aW9ucyBh
bmQgbWF5IG5vdCBiZSBmdWxseSBhY2Nlc3NpYmxlClsgIDE0Ni4wNjU0MTFdIGF0YTUuMDA6
IGZhaWxlZCB0byBnZXQgTkNRIFNlbmQvUmVjdiBMb2cgRW1hc2sgMHgxClsgIDE0Ni4wNjU2
MTZdIGF0YTUuMDA6IHN1cHBvcnRzIERSTSBmdW5jdGlvbnMgYW5kIG1heSBub3QgYmUgZnVs
bHkgYWNjZXNzaWJsZQpbICAxNDYuMDY1NjY0XSBhdGE1LjAwOiBmYWlsZWQgdG8gZ2V0IE5D
USBTZW5kL1JlY3YgTG9nIEVtYXNrIDB4MQpbICAxNDYuMDY1NjcxXSBhdGE1LjAwOiBjb25m
aWd1cmVkIGZvciBVRE1BLzEzMwpbICAxNDYuMDY3NTk5XSBhdGExLjAwOiBjb25maWd1cmVk
IGZvciBVRE1BLzEwMApbICAxNDYuMDc2ODY0XSBzZCA0OjA6MDowOiBbc2RlXSBTdGFydGlu
ZyBkaXNrClsgIDE0Ni4wODAxMThdIHNkIDA6MDowOjA6IFtzZGFdIFN0YXJ0aW5nIGRpc2sK
WyAgMTQ2LjEwMDA3MF0gYXRhNzogU0FUQSBsaW5rIGRvd24gKFNTdGF0dXMgMCBTQ29udHJv
bCAzMDApClsgIDE0Ni4xMDAxMDNdIGF0YTY6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAg
U0NvbnRyb2wgMzAwKQpbICAxNDYuMTU0NzgzXSBbZHJtXSBpYiB0ZXN0IG9uIHJpbmcgNSBz
dWNjZWVkZWQKWyAgMTQ4LjAwMzAzN10gcjgxNjkgMDAwMDowMjowMC4wIGV0aDA6IGxpbmsg
dXAKWyAgMTUxLjA3MTkxM10gYXRhMjogbGluayBpcyBzbG93IHRvIHJlc3BvbmQsIHBsZWFz
ZSBiZSBwYXRpZW50IChyZWFkeT0wKQpbICAxNTEuMTA4NTQ4XSBhdGE0OiBsaW5rIGlzIHNs
b3cgdG8gcmVzcG9uZCwgcGxlYXNlIGJlIHBhdGllbnQgKHJlYWR5PTApClsgIDE1MS4xMDg1
NTddIGF0YTM6IGxpbmsgaXMgc2xvdyB0byByZXNwb25kLCBwbGVhc2UgYmUgcGF0aWVudCAo
cmVhZHk9MCkKWyAgMTUxLjIzMTc2OV0gYXRhMjogU0FUQSBsaW5rIHVwIDYuMCBHYnBzIChT
U3RhdHVzIDEzMyBTQ29udHJvbCAzMDApClsgIDE1MS4yMzUwNjBdIGF0YTIuMDA6IGNvbmZp
Z3VyZWQgZm9yIFVETUEvMTMzClsgIDE1MS4yNDg0NjNdIHNkIDE6MDowOjA6IFtzZGJdIFN0
YXJ0aW5nIGRpc2sKWyAgMTUxLjMyMTY4NV0gYXRhNDogU0FUQSBsaW5rIHVwIDYuMCBHYnBz
IChTU3RhdHVzIDEzMyBTQ29udHJvbCAzMDApClsgIDE1MS4zMjQ5NDVdIGF0YTQuMDA6IGNv
bmZpZ3VyZWQgZm9yIFVETUEvMTMzClsgIDE1MS4zMzgzNTJdIHNkIDM6MDowOjA6IFtzZGRd
IFN0YXJ0aW5nIGRpc2sKWyAgMTUxLjQyODI0NF0gYXRhMzogU0FUQSBsaW5rIHVwIDYuMCBH
YnBzIChTU3RhdHVzIDEzMyBTQ29udHJvbCAzMDApClsgIDE1MS40MzE1MDldIGF0YTMuMDA6
IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzClsgIDE1MS40NDQ5MzFdIHNkIDI6MDowOjA6IFtz
ZGNdIFN0YXJ0aW5nIGRpc2sKWyAgMTUxLjQ2Nzk3NV0gUE06IHJlc3VtZSBvZiBkZXZpY2Vz
IGNvbXBsZXRlIGFmdGVyIDU3ODkuMDY4IG1zZWNzClsgIDE1MS40Njg1NTRdIFBNOiBGaW5p
c2hpbmcgd2FrZXVwLgpbICAxNTEuNDY4NTU4XSBSZXN0YXJ0aW5nIHRhc2tzIC4uLiBkb25l
LgpbICAxNTEuNDgxMzg4XSB1c2IgNi01OiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJl
ciAzClsgIDE1MS43NzExMzBdIHVzYiA2LTU6IG5ldyBsb3ctc3BlZWQgVVNCIGRldmljZSBu
dW1iZXIgNCB1c2luZyBvaGNpLXBjaQpbICAxNTEuOTM0OTU1XSBpbnB1dDogSElEIDA0ZjM6
MDEwMyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MTIuMC91c2I2LzYtNS82LTU6
MS4wL2lucHV0L2lucHV0MTIKWyAgMTUxLjkzNTA5M10gaGlkLWdlbmVyaWMgMDAwMzowNEYz
OjAxMDMuMDAwOTogaW5wdXQsaGlkcmF3MzogVVNCIEhJRCB2MS4xMCBLZXlib2FyZCBbSElE
IDA0ZjM6MDEwM10gb24gdXNiLTAwMDA6MDA6MTIuMC01L2lucHV0MApbICAxNTEuOTQzODM0
XSBpbnB1dDogSElEIDA0ZjM6MDEwMyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6
MTIuMC91c2I2LzYtNS82LTU6MS4xL2lucHV0L2lucHV0MTMKWyAgMTUxLjk0NDA4MF0gaGlk
LWdlbmVyaWMgMDAwMzowNEYzOjAxMDMuMDAwQTogaW5wdXQsaGlkcmF3NDogVVNCIEhJRCB2
MS4xMCBEZXZpY2UgW0hJRCAwNGYzOjAxMDNdIG9uIHVzYi0wMDAwOjAwOjEyLjAtNS9pbnB1
dDEK
--------------000806090107080401040107--
