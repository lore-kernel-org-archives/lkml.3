Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3HLOSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:18:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59745 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3HLOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:18:53 -0400
MIME-Version: 1.0
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 12 Aug 2013 16:18:32 +0200
Message-ID: <CACQ1gAjDWvFENTieOy45T2LD7uzaJGyd5nvxWFFavoij-sAfLA@mail.gmail.com>
Subject: Regression V3.11-rc1 bisected: [readdir] convert procfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11c2e9b8c452b004e3c0cdc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2e9b8c452b004e3c0cdc4
Content-Type: text/plain; charset=UTF-8

Hi,

I've found something peculiar while I was testing v3.11:
There's a lot of directory missing (actually hiding) in /proc :

/proc/sys/, /proc/fs/, /proc/bus/ etc...
all the directories that are not PIDs are in "stealth mode":
they don't appear with an ls (nor a find), but I can list their contents.

I've bisecting that to the commit
f0c3b5093addc8bfe9fe3a5b01acb7ec7969eafa ( [readdir] convert procfs )

This happens on nfsroot, but also on UBIFS.

Here are my platform details:
- arm (at91sam9g35-ek)
- defconfig attached
- using uImage and at91sam9g35ek.dtb
- libuClibc-0.9.33.2.so


# ls -l /proc/
total 0
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 1/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 121/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 123/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 125/
dr-xr-xr-x    7 root     root             0 Dec 31 17:15 1306/
dr-xr-xr-x    7 root     root             0 Dec 31 17:15 1307/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 2/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 236/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 237/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 242/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 243/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 244/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 245/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 3/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 313/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 314/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 326/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 328/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 331/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 361/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 362/
dr-xr-xr-x    7 dbus     dbus             0 Dec 31 17:00 364/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 372/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 376/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 378/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 389/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 390/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 5/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 6/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 7/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 8/
dr-xr-xr-x    7 root     root             0 Dec 31 17:00 9/
-r--r--r--    1 root     root             0 Dec 31 17:15 buddyinfo
-r--r--r--    1 root     root             0 Dec 31 17:15 cmdline
-r--r--r--    1 root     root          8478 Dec 31 17:15 config.gz
-r--r--r--    1 root     root             0 Dec 31 17:15 consoles
-r--r--r--    1 root     root             0 Dec 31 17:15 cpuinfo
-r--r--r--    1 root     root             0 Dec 31 17:15 crypto
-r--r--r--    1 root     root             0 Dec 31 17:15 devices
-r--r--r--    1 root     root             0 Dec 31 17:15 diskstats
-r--r--r--    1 root     root             0 Dec 31 17:15 filesystems
-r--r--r--    1 root     root             0 Dec 31 17:15 interrupts
-r--r--r--    1 root     root             0 Dec 31 17:15 kallsyms
-r--r--r--    1 root     root             0 Dec 31 17:15 key-users
-r--------    1 root     root             0 Dec 31 17:15 kmsg
-r--------    1 root     root             0 Dec 31 17:15 kpagecount
-r--------    1 root     root             0 Dec 31 17:15 kpageflags
-r--r--r--    1 root     root             0 Dec 31 17:15 loadavg
-r--r--r--    1 root     root             0 Dec 31 17:15 locks
-r--r--r--    1 root     root             0 Dec 31 17:15 meminfo
-r--r--r--    1 root     root             0 Dec 31 17:15 pagetypeinfo
-r--r--r--    1 root     root             0 Dec 31 17:15 partitions
lrwxrwxrwx    1 root     root             0 Dec 31 17:00 self -> 1307/
-r--------    1 root     root             0 Dec 31 17:15 slabinfo
-r--r--r--    1 root     root             0 Dec 31 17:15 softirqs
-r--r--r--    1 root     root             0 Dec 31 17:15 stat
--w-------    1 root     root             0 Dec 31 17:15 sysrq-trigger
-r--r--r--    1 root     root             0 Dec 31 17:15 timer_list
-r--r--r--    1 root     root             0 Dec 31 17:15 uptime
-r--r--r--    1 root     root             0 Dec 31 17:15 version
-r--------    1 root     root             0 Dec 31 17:15 vmallocinfo
-r--r--r--    1 root     root             0 Dec 31 17:15 vmstat
-r--r--r--    1 root     root             0 Dec 31 17:15 zoneinfo
# ls -ld /proc/sy*
--w-------    1 root     root             0 Dec 31 17:15 /proc/sysrq-trigger
# ls -ld /proc/sys
dr-xr-xr-x    1 root     root             0 Dec 31 17:00 /proc/sys/
# ls -l /proc/sys/
total 0
dr-xr-xr-x    1 root     root             0 Dec 31 17:16 debug/
dr-xr-xr-x    1 root     root             0 Dec 31 17:16 dev/
dr-xr-xr-x    1 root     root             0 Dec 31 17:16 fs/
dr-xr-xr-x    1 root     root             0 Dec 31 17:00 kernel/
dr-xr-xr-x    1 root     root             0 Dec 31 17:00 net/
dr-xr-xr-x    1 root     root             0 Dec 31 17:16 vm/
# uname -a
Linux LNS 3.10.0-rc6-00032-gf0c3b50 #34 Mon Aug 12 15:30:14 CEST 2013
armv5tejl GNU/Linux
# cat /proc/cmdline
console=ttyS0,115200 loglevel=8 ip=dhcp root=/dev/nfs
nfsroot=10.128.0.9:/nfsroot,v3



Best regards,
Richard.

--001a11c2e9b8c452b004e3c0cdc4
Content-Type: application/octet-stream; name=defconfig
Content-Disposition: attachment; filename=defconfig
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk9r16w70

IyBDT05GSUdfQVJNX1BBVENIX1BIWVNfVklSVCBpcyBub3Qgc2V0CkNPTkZJR19QSFlTX09GRlNF
VD0weDIwMDAwMDAwCkNPTkZJR19LRVJORUxfTFpPPXkKQ09ORklHX0RFRkFVTFRfSE9TVE5BTUU9
InRlc3QiCiMgQ09ORklHX1NXQVAgaXMgbm90IHNldApDT05GSUdfU1lTVklQQz15CkNPTkZJR19J
S0NPTkZJRz15CkNPTkZJR19JS0NPTkZJR19QUk9DPXkKQ09ORklHX0tBTExTWU1TX0FMTD15CkNP
TkZJR19FTUJFRERFRD15CkNPTkZJR19TTEFCPXkKIyBDT05GSUdfTEJEQUYgaXMgbm90IHNldApD
T05GSUdfQkxLX0RFVl9CU0dMSUI9eQpDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEPXkKIyBDT05G
SUdfRUZJX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lPU0NIRURfREVBRExJTkUgaXMg
bm90IHNldAojIENPTkZJR19JT1NDSEVEX0NGUSBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0FUOTE9
eQpDT05GSUdfU09DX0FUOTFTQU05WDU9eQpDT05GSUdfTUFDSF9BVDkxU0FNOV9EVD15CkNPTkZJ
R19BVDkxX1BST0dSQU1NQUJMRV9DTE9DS1M9eQpDT05GSUdfQVQ5MV9USU1FUl9IWj0xMjgKQ09O
RklHX0FFQUJJPXkKIyBDT05GSUdfQ09NUEFDVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0NST1NT
X01FTU9SWV9BVFRBQ0ggaXMgbm90IHNldApDT05GSUdfVUFDQ0VTU19XSVRIX01FTUNQWT15CiMg
Q09ORklHX0FUQUdTIGlzIG5vdCBzZXQKQ09ORklHX1pCT09UX1JPTV9URVhUPTB4MApDT05GSUdf
WkJPT1RfUk9NX0JTUz0weDAKQ09ORklHX0FVVE9fWlJFTEFERFI9eQpDT05GSUdfRlBFX0ZBU1RG
UEU9eQojIENPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NVU1BFTkQgaXMgbm90IHNldApDT05GSUdfTkVUPXkKQ09ORklHX1BBQ0tFVD15CkNP
TkZJR19QQUNLRVRfRElBRz15CkNPTkZJR19VTklYPXkKQ09ORklHX1VOSVhfRElBRz15CkNPTkZJ
R19YRlJNX1VTRVI9eQpDT05GSUdfTkVUX0tFWT15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX1BO
UD15CkNPTkZJR19JUF9QTlBfREhDUD15CkNPTkZJR19JTkVUX0FIPXkKQ09ORklHX0lORVRfRVNQ
PXkKQ09ORklHX0lORVRfSVBDT01QPXkKQ09ORklHX0lORVRfVURQX0RJQUc9eQojIENPTkZJR19J
UFY2IGlzIG5vdCBzZXQKQ09ORklHX0ROU19SRVNPTFZFUj15CiMgQ09ORklHX1dJUkVMRVNTIGlz
IG5vdCBzZXQKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4vaG90cGx1ZyIKQ09ORklH
X0RFVlRNUEZTPXkKQ09ORklHX0RFVlRNUEZTX01PVU5UPXkKIyBDT05GSUdfU1RBTkRBTE9ORSBp
cyBub3Qgc2V0CiMgQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQgaXMgbm90IHNldApDT05G
SUdfUFJPQ19ERVZJQ0VUUkVFPXkKQ09ORklHX0JMS19ERVZfTE9PUD15CkNPTkZJR19CTEtfREVW
X1JBTT15CkNPTkZJR19CTEtfREVWX1JBTV9DT1VOVD00CkNPTkZJR19CTEtfREVWX1JBTV9TSVpF
PTgxOTIKQ09ORklHX0FUTUVMX1BXTT15CkNPTkZJR19BVE1FTF9UQ0xJQj15CkNPTkZJR19BVE1F
TF9TU0M9eQpDT05GSUdfRUVQUk9NXzkzQ1g2PXkKQ09ORklHX05FVERFVklDRVM9eQpDT05GSUdf
TUFDQj15CiMgQ09ORklHX05FVF9WRU5ET1JfQlJPQURDT00gaXMgbm90IHNldAojIENPTkZJR19O
RVRfVkVORE9SX0NJUlJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfRkFSQURBWSBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfSU5URUwgaXMgbm90IHNldAojIENPTkZJR19O
RVRfVkVORE9SX01BUlZFTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX01JQ1JFTCBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTkFUU0VNSSBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9WRU5ET1JfU0VFUSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfU01TQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfU1RNSUNSTyBpcyBub3Qgc2V0CiMgQ09ORklHX05F
VF9WRU5ET1JfV0laTkVUIGlzIG5vdCBzZXQKQ09ORklHX0RBVklDT01fUEhZPXkKIyBDT05GSUdf
V0xBTiBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9QT0xMREVWPXkKIyBDT05GSUdfSU5QVVRfTU9V
U0VERVYgaXMgbm90IHNldApDT05GSUdfSU5QVVRfRVZERVY9eQpDT05GSUdfSU5QVVRfRVZCVUc9
eQojIENPTkZJR19JTlBVVF9LRVlCT0FSRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01PVVNF
IGlzIG5vdCBzZXQKQ09ORklHX1NFUklPX0xJQlBTMj15CiMgQ09ORklHX0xFR0FDWV9QVFlTIGlz
IG5vdCBzZXQKQ09ORklHX1NFUklBTF9BVE1FTD15CkNPTkZJR19TRVJJQUxfQVRNRUxfQ09OU09M
RT15CiMgQ09ORklHX1NFUklBTF9BVE1FTF9QREMgaXMgbm90IHNldApDT05GSUdfR1BJT19TWVNG
Uz15CiMgQ09ORklHX0hXTU9OIGlzIG5vdCBzZXQKQ09ORklHX1dBVENIRE9HPXkKQ09ORklHX0FU
OTFTQU05WF9XQVRDSERPRz15CkNPTkZJR19TU0I9eQpDT05GSUdfSElEUkFXPXkKQ09ORklHX1VI
SUQ9eQojIENPTkZJR19VU0JfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19ORVdfTEVEUz15CkNP
TkZJR19MRURTX0NMQVNTPXkKQ09ORklHX0xFRFNfR1BJTz15CkNPTkZJR19MRURTX1RSSUdHRVJT
PXkKQ09ORklHX0xFRFNfVFJJR0dFUl9USU1FUj15CkNPTkZJR19MRURTX1RSSUdHRVJfT05FU0hP
VD15CkNPTkZJR19MRURTX1RSSUdHRVJfSEVBUlRCRUFUPXkKQ09ORklHX0xFRFNfVFJJR0dFUl9H
UElPPXkKQ09ORklHX0xFRFNfVFJJR0dFUl9ERUZBVUxUX09OPXkKQ09ORklHX0RNQURFVklDRVM9
eQpDT05GSUdfQVRfSERNQUM9eQojIENPTkZJR19JT01NVV9TVVBQT1JUIGlzIG5vdCBzZXQKQ09O
RklHX0ZBTk9USUZZPXkKQ09ORklHX1RNUEZTPXkKQ09ORklHX0NPTkZJR0ZTX0ZTPXkKIyBDT05G
SUdfTUlTQ19GSUxFU1lTVEVNUyBpcyBub3Qgc2V0CkNPTkZJR19ORlNfRlM9eQojIENPTkZJR19O
RlNfVjIgaXMgbm90IHNldApDT05GSUdfUk9PVF9ORlM9eQpDT05GSUdfUFJJTlRLX1RJTUU9eQpD
T05GSUdfREVGQVVMVF9NRVNTQUdFX0xPR0xFVkVMPTcKQ09ORklHX01BR0lDX1NZU1JRPXkKQ09O
RklHX1NUUklQX0FTTV9TWU1TPXkKQ09ORklHX0RFQlVHX0ZTPXkKQ09ORklHX0RFQlVHX1NFQ1RJ
T05fTUlTTUFUQ0g9eQojIENPTkZJR19TQ0hFRF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX0JVR1ZFUkJPU0UgaXMgbm90IHNldAojIENPTkZJR19GVFJBQ0UgaXMgbm90IHNldApDT05G
SUdfS0VZUz15CkNPTkZJR19DUllQVE9fRUNCPXkKQ09ORklHX0NSWVBUT19DUkMzMkM9eQpDT05G
SUdfQ1JZUFRPX01JQ0hBRUxfTUlDPXkKQ09ORklHX0NSWVBUT19BUkM0PXkKQ09ORklHX0NSWVBU
T19MWk89eQojIENPTkZJR19DUllQVE9fQU5TSV9DUFJORyBpcyBub3Qgc2V0CkNPTkZJR19DUllQ
VE9fVVNFUl9BUElfSEFTSD15CkNPTkZJR19DUllQVE9fVVNFUl9BUElfU0tDSVBIRVI9eQojIENP
TkZJR19DUllQVE9fSFcgaXMgbm90IHNldApDT05GSUdfQ1JDX0NDSVRUPXkKQ09ORklHX0NSQzE2
PXkKQ09ORklHX0NSQ19JVFVfVD15CkNPTkZJR19DUkM3PXkKQ09ORklHX0FWRVJBR0U9eQo=
--001a11c2e9b8c452b004e3c0cdc4--
