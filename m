Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3ENUBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:01:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46737 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab3ENUBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-pm@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10-rc1 system starts regular boot when waking from s2ram
Date: Tue, 14 May 2013 22:09:34 +0200
Message-ID: <1368567715.t1rym2H3RB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130514160108.GA5055@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 14, 2013 06:01:08 PM Michal Hocko wrote:
> Hi,
> I am not able to make my system wake up from s2ram with 3.10-rc1. The
> system simply starts booting as if it wasn't suspended. 3.9 works
> without any issues.
> 
> pm_test testing (with no_console_suspend) shows that platform is the
> last mode which wakes up normally. processors mode already starts with a
> regular boot. The log doesn't say anything interesting:
> 
> $ echo processors > /sys/power/pm_test
> $ echo mem > /sys/power/state
> [   61.012533] PM: Syncing filesystems ... done.
> [   61.017944] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   61.033050] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [   61.081647] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   61.081724] sd 0:0:0:0: [sda] Stopping disk
> 
> then it waits for 5s as expected and starts booting from scratch without
> anything in the log.
> 
> Same test with
> $ echo platform > /sys/power/pm_test
> $ echo mem > /sys/power/state
> [   34.960477] PM: Syncing filesystems ... done.
> [   34.967624] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   34.983936] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [   35.056655] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   35.056800] sd 0:0:0:0: [sda] Stopping disk
> [   41.255957] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   41.316267] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   41.316354] ata5: SATA link down (SStatus 0 SControl 300)
> [   41.316428] ata4: SATA link down (SStatus 0 SControl 300)
> [   41.316507] ata6: SATA link down (SStatus 0 SControl 300)
> [   41.316958] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [   41.388315] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [   41.389142] ata1.00: configured for UDMA/133
> [   41.391172] ata2.00: configured for UDMA/100
> [   41.396198] sd 0:0:0:0: [sda] Starting disk
> [   41.396533] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [   41.396767] iwlwifi 0000:02:00.0: Radio type=0x0-0x3-0x1
> [   41.638698] PM: resume of devices complete after 724.548 msecs
> [   41.638835] Restarting tasks ... done.
> [   41.640747] video LNXVIDEO:00: Restoring backlight state
> [   42.848988] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [   42.850380] e1000e 0000:00:19.0 eth0: Detected Hardware Unit Hang:
> [   42.850380]   TDH                  <0>
> [   42.850380]   TDT                  <11>
> [   42.850380]   next_to_use          <11>
> [   42.850380]   next_to_clean        <0>
> [   42.850380] buffer_info[next_to_clean]:
> [   42.850380]   time_stamp           <ffff034b>
> [   42.850380]   next_to_watch        <0>
> [   42.850380]   jiffies              <ffff04d9>
> [   42.850380]   next_to_watch.status <0>
> [   42.850380] MAC Status             <80000>
> [   42.850380] PHY Status             <7949>
> [   42.850380] PHY 1000BASE-T Status  <0>
> [   42.850380] PHY Extended Status    <3000>
> [   42.850380] PCI Status             <10>
> [   44.066855] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> 
> Is the issue known?

No.

> Can I provide more information to help with debugging this issue.

I'm not sure.

> I am quite busy to bisect this ATM but can do it
> if this is the only choice left.

Well, it probably is.  I'll try to reproduce it, but if I can't ...

Anyway, the general PM changes essentially are not so invasive as to cause
something like this to happen, so I'm kind of suspecting x86.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
