Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563Ab3HIIEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:04:46 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:59536 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030545Ab3HIIET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:04:19 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.82
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Jackson <mpfj-list@newflow.co.uk>
Subject: Re: ARM: AM335x: Reboot broken in 3.11
Date: Fri, 9 Aug 2013 10:04:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <5203A21A.4060806@newflow.co.uk>
In-Reply-To: <5203A21A.4060806@newflow.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308091004.11463.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. August 2013, 15:50:18 schrieb Mark Jackson:
> Rebooting appears to have broken in 3.11 (at some point before rc1).
> 
> Here is the console output:-
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 3.11.0-rc1-00006-gf550793
> (mpfj@mpfj-nanobone) (gcc version 4.6.3 (Buildroot 2013.02-dirty) )
> #328 Thu Aug 8 14:36:16 BST 2013 ...
> Welcome to Buildroot
> nanobone login: root
> Password:
> # reboot
> #
> [   23.867076] UBIFS: background thread "ubifs_bgt0_0" stops
> The system is going down NOW!
> Sent SIGTERM to all processes
> Sent SIGKILL to all processes
> Requesting system reboot
> [   25.924496] reboot: Restarting system
> 
> ... and at this point the CPU seems to just freeze.
> 
> In 3v10, the board would reboot correctly back into uboot, etc.
> 
> I've also noticed that some of the output LEDs light up dim when the
> kernel is booting on, and they come on full brightness at the reboot
> "freeze" point. There are 4 LEDs affected and they are all connected to
> UART transmit pins.
> 
> Before I start bisecting, does anyone have any ideas ?

No problem here - at least not at -rc4:

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-rc4-00019-g7c4368e-dirty (larsi@lem-
wkst-02) (gcc version 4.4.3 (GCC) ) #90 PREEMPT Thu Aug 8 16:42:06 CEST 
2013
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), ....
....
bboxv3 login: root
root@bboxv3:~# reboot

Broadcast message from root@bboxv3 (ttyO2) (鈬hu May 16 16:59:11 2013):

INIT: Sending processes the TERM signal
INIT: SenStopping OpenBSD Secure Shell server: sshdstopped /usr/sbin/sshd 
(pid 416)
.
Stopping system message bus: Stopping syslogd/klogd: stopped syslogd (pid 
423)
stopped klogd (pid 425)
done
Stopping tcf-agent: OK
Stopping internet superserver: xinetd.
not deconfiguring network interfaces: network file systems still mounted.
Stopping Linux NFC daemon
Stopping Lighttpd Web Server: stopped /usr/sbin/lighttpd (pid 440)
lighttpd.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting... [   38.285126] reboot: Restarting system

U-Boot SPL 2013.04-rc2-00063-gcd27ec7-dirty (May 21 2013 - 15:14:45)
OMAP SD/MMC: 0
reading u-boot.img
reading u-boot.img

Regards,
Lars
