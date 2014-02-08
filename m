Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaBHIad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:30:33 -0500
Received: from mout.gmx.net ([212.227.17.22]:58095 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaBHIab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:30:31 -0500
Message-ID: <52F5EB23.4060204@gmx.de>
Date: Sat, 08 Feb 2014 09:30:27 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com>
In-Reply-To: <52E165B7.6020506@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:S/B4/JZ/P9AO5DlwYgIcHyYsgeCr7Oocq8Q7LCPEvVLhylhvvUp
 CbvI+PeHNyobGcG+gloPYrN5/Ra5v7scMAjlKPDGLezDYF92IzkshWVMDbWmjkMZ9MzaM4b
 SSWNngSWPNjzHwGiqjV2T3cfaD8O1Kl5f95B8qI7T6xhg+iJPfZJ2qjLZ0R8xqzXLx6YuJK
 0pOK0/grC7ZyoA/sVXC3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/23/2014 07:55 PM, Dave Hansen wrote:
> On 01/21/2014 08:38 AM, Toralf Förster wrote:
>> Jan 21 17:18:57 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 2}  (t=60001 jiffies g=18494 c=18493 q=183951)
>> Jan 21 17:18:57 n22 kernel: sending NMI to all CPUs:
>> Jan 21 17:18:57 n22 kernel: NMI backtrace for cpu 2
>> Jan 21 17:18:57 n22 kernel: CPU: 2 PID: 6779 Comm: qemu-system-x86 Not tainted 3.13.0 #3
>> Jan 21 17:18:57 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
>> Jan 21 17:18:57 n22 kernel: task: e921c370 ti: e5f36000 task.ti: e5f36000
> 
> I'm seeing a very similar hang with an ubuntu guest and a custom kernel.
>  I'm on commit 0dc3fd0249a, and it's 100% reproducible every time I run KVM.
> 
> Cc-ing a few more folks...
> 
With 3.12.2 at the same 32 bit Gentoo Linux I experienced a similar thingin a complete different scenario: I umounted a loop-mounted file, on which I created and filled a btrfs file system before (/usr/portage FWIW - I'm a Gentoo user) and the systems becomes very slowly and /var/log/messages shows :

Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: Current CMD queue read_ptr 100 write_ptr 101
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | OK
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | uPc
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | data1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | data2
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | line
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | beacon time
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf low
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp2
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp3
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | uCode version
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | hw version
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | board version
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | hcmd
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr0
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr1
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr2
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr3
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr4
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | wait_event
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | timestamp
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in log
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: set power fail, ret = -110
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: iwl_trans_wait_tx_queue_empty bad state = 0
Feb  7 22:46:46 n22 kernel: ieee80211 phy0: Hardware restart was requested
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Feb  7 22:46:46 n22 kernel: iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Fw not loaded - dropping CMD: 18
Feb  7 22:46:51 n22 kernel: wlp3s0: HW problem - can not stop rx aggregation for 08:96:d7:05:f9:2a tid 0
Feb  7 22:46:51 n22 kernel: iwlwifi 0000:03:00.0: Fw not loaded - dropping CMD: 18
Feb  7 22:46:51 n22 kernel: wlp3s0: HW problem - can not stop rx aggregation for 08:96:d7:05:f9:2a tid 6
Feb  7 22:47:06 n22 dhcpcd[5978]: wlp3s0: carrier lost
Feb  7 22:47:06 n22 dhcpcd[5978]: wlp3s0: deleting route to 192.168.178.0/24
Feb  7 22:47:06 n22 dhcpcd[5978]: wlp3s0: deleting default route via 192.168.178.1
Feb  7 22:47:06 n22 kernel: iwlwifi 0000:03:00.0: iwl_trans_wait_tx_queue_empty bad state = 0
Feb  7 22:47:06 n22 kernel: cfg80211: Calling CRDA to update world regulatory domain
Feb  7 22:47:06 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:06 n22 wpa_cli: interface wlp3s0 DISCONNECTED
Feb  7 22:47:06 n22 wpa_cli: executing 'false /etc/init.d/net.wlp3s0 --quiet stop' failed
Feb  7 22:47:07 n22 kernel: cfg80211: World regulatory domain updated:
Feb  7 22:47:07 n22 kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb  7 22:47:07 n22 kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb  7 22:47:07 n22 kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb  7 22:47:07 n22 kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb  7 22:47:07 n22 kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb  7 22:47:07 n22 kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb  7 22:47:07 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:08 n22 ntpd[6263]: Deleting interface #3 wlp3s0, 192.168.178.21#123, interface stats: received=279, sent=281, dropped=0, active_time=12050 secs
Feb  7 22:47:08 n22 ntpd[6263]: 144.76.117.245 interface 192.168.178.21 -> (none)
Feb  7 22:47:08 n22 ntpd[6263]: 193.175.73.151 interface 192.168.178.21 -> (none)
Feb  7 22:47:08 n22 ntpd[6263]: 78.47.93.200 interface 192.168.178.21 -> (none)
Feb  7 22:47:08 n22 ntpd[6263]: 130.149.220.125 interface 192.168.178.21 -> (none)
Feb  7 22:47:08 n22 ntpd[6263]: peers refreshed
Feb  7 22:47:08 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:09 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:10 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:11 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:12 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:13 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:14 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:15 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:16 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:17 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:18 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:19 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:20 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:21 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:22 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:23 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:24 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:25 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:26 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Feb  7 22:47:27 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
...


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF0EAREIAAYFAlL16yIACgkQxOrN3gB26U6ZLAD4+xOsxbCxkoLLyZm10XESUBxh
3SK0iNuGjBEamGth3gD9GgeZoyK2dwfA5SJX/r6IwWVvwgwQ03frfqCRWQNe6BU=
=Eyi4
-----END PGP SIGNATURE-----
