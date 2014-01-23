Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaAWTuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:50:19 -0500
Received: from mout.gmx.net ([212.227.17.21]:49854 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaAWTuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:50:15 -0500
Message-ID: <52E17273.2030200@gmx.de>
Date: Thu, 23 Jan 2014 20:50:11 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com> <52E16E83.6060301@intel.com>
In-Reply-To: <52E16E83.6060301@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:wa0c+9mRG1IHDq5vYHt8T4CRQ5ogJwrvDKhIduS2JSo3pglQMrd
 48LgJJbSzIQtwetFgN6QpIAQAO8xCTDr0unxF+9tYh+6XbA3zc9M3TgiBG+gdGQAVsPgGMD
 LeeicowrBO+syLGzgQFORtVtjn4usDsiLtdmqeGmnQJy/QU2w+YJvo/Z8fOIhLchA8L7OCg
 8SVDpOQn9T5/V7BQS9lgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/23/2014 08:33 PM, Dave Hansen wrote:
> On 01/23/2014 10:55 AM, Dave Hansen wrote:
>> On 01/21/2014 08:38 AM, Toralf Förster wrote:
>>> Jan 21 17:18:57 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 2}  (t=60001 jiffies g=18494 c=18493 q=183951)
>>> Jan 21 17:18:57 n22 kernel: sending NMI to all CPUs:
>>> Jan 21 17:18:57 n22 kernel: NMI backtrace for cpu 2
>>> Jan 21 17:18:57 n22 kernel: CPU: 2 PID: 6779 Comm: qemu-system-x86 Not tainted 3.13.0 #3
>>> Jan 21 17:18:57 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
>>> Jan 21 17:18:57 n22 kernel: task: e921c370 ti: e5f36000 task.ti: e5f36000
>>
>> I'm seeing a very similar hang with an ubuntu guest and a custom kernel.
>> I'm on commit 0dc3fd0249a, and it's 100% reproducible every time I run KVM.
> 
> Did a little more LKML digging and found this:
> 
> 	http://marc.info/?l=linux-kernel&m=139038631607917&q=raw
> 
Hhm, that patch cannot be applied to 3.13.0 kernel :-(

> Peter's fix works for me.  I'm also running a CONFIG_PREEMPT_VOLUNTARY=y
> config.
> 
I do have :

n22 /usr/src/linux # zgrep CONFIG_PREEMPT /proc/config.gz
# CONFIG_PREEMPT_RCU is not set
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set

> 

What makes the situation really annyoing - sometimes I just can restart my wlan device it the system works normal, but sometimes the whole system hangs and for those cases then sometimes not even sysrq buttons do work.

What I see in /var/log/messages are those lines :

Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: Current CMD queue read_ptr 158 write_ptr 159
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | OK                          Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | uPc
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | data1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | data2
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | line
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | beacon time
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf low
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp2
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp3
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | uCode version
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | hw version
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | board version
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | hcmd
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr0
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr1
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr2
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr3
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr4
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | wait_event
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | timestamp
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in log
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: set power fail, ret = -110
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: iwl_trans_wait_tx_queue_empty bad state = 0
Jan 23 19:23:15 n22 kernel: ieee80211 phy0: Hardware restart was requested
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Jan 23 19:23:15 n22 kernel: iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
Jan 23 19:23:20 n22 kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
Jan 23 19:23:20 n22 kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
Jan 23 19:23:20 n22 kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
Jan 23 19:23:20 n22 kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
Jan 23 19:23:28 n22 dhcpcd[4878]: wlp3s0: carrier lost
Jan 23 19:23:28 n22 kernel: iwlwifi 0000:03:00.0: Fw not loaded - dropping CMD: 1e                                                                     Jan 23 19:23:28 n22 kernel: iwlwifi 0000:03:00.0: Couldn't flush the AGG queue                                                                         Jan 23 19:23:28 n22 kernel: iwlwifi 0000:03:00.0: Fw not loaded - dropping CMD: 18                                                                     Jan 23 19:23:28 n22 kernel: wlp3s0: HW problem - can not stop rx aggregation for 08:96:d7:05:f9:2a tid 0                                               Jan 23 19:23:28 n22 kernel: iwlwifi 0000:03:00.0: iwl_trans_wait_tx_queue_empty bad state = 0                                                          Jan 23 19:23:28 n22 kernel: cfg80211: Calling CRDA to update world regulatory domain                                                                   Jan 23 19:23:28 n22 kernel: cfg80211: World regulatory domain updated:                       
                                                          Jan 23 19:23:28 n22 kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)                                              Jan 23 19:23:28 n22 kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)                                                   Jan 23 19:23:28 n22 kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)                                                   Jan 23 19:23:28 n22 kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)                                                   Jan 23 19:23:28 n22 kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)                                                   Jan 23 19:23:28 n22 kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 23 19:23:28 n22 wpa_cli: interface wlp3s0 DISCONNECTED
Jan 23 19:23:28 n22 wpa_cli: executing 'false /etc/init.d/net.wlp3s0 --quiet stop' failed
Jan 23 19:23:28 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Jan 23 19:23:29 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Jan 23 19:23:29 n22 ntpd[5421]: Deleting interface #3 wlp3s0, 192.168.178.21#123, interface stats: received=12, sent=12, dropped=0, active_time=188 secs
Jan 23 19:23:29 n22 ntpd[5421]: 62.116.162.126 interface 192.168.178.21 -> (none)
Jan 23 19:23:29 n22 ntpd[5421]: 131.188.3.220 interface 192.168.178.21 -> (none)
Jan 23 19:23:29 n22 ntpd[5421]: 46.165.212.205 interface 192.168.178.21 -> (none)
Jan 23 19:23:29 n22 ntpd[5421]: 46.4.54.78 interface 192.168.178.21 -> (none)
Jan 23 19:23:29 n22 ntpd[5421]: peers refreshed
Jan 23 19:23:30 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Jan 23 19:23:31 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Jan 23 19:23:32 n22 kernel: iwlwifi 0000:03:00.0: Request scan called when driver not ready.


The last line now repeats every second till I either restart the wlan0 device or the system completely hangs.



- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLhcnMACgkQxOrN3gB26U5pNgD9Gnd/2LOwCL/Ca2s3eeDje+Zz
lzAZKSoLk+VQXn5R0qgA/RZV4WW4BTT/xSc1E378TlmctXQ+AX7iJ/FbgfZXyLvB
=Tw8L
-----END PGP SIGNATURE-----
