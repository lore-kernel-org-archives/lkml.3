Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaESCyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:54:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:5414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbaESCyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:54:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513671990"
Message-ID: <53797207.4020909@intel.com>
Date: Mon, 19 May 2014 10:52:55 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: alan.cox@intel.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [goldfish] genirq: Flags mismatch irq 4. 00000000 (serial) vs.
 00000080 (goldfish_pdev_bus)
References: <53797084.20706@intel.com>
In-Reply-To: <53797084.20706@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forward to alan.cox@intel.com

On 05/19/2014 10:46 AM, Jet Chen wrote:
> Hi Alan,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-next
> commit 9b17aeec232a5f0a61ce3952c2e728a0eeddda8b
> Author:     Alan <alan@acox1-desk.ger.corp.intel.com>
> AuthorDate: Mon May 12 16:55:35 2014 +0100
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Thu May 15 13:19:01 2014 -0700
>
>      goldfish: Allow 64bit builds
>          We can now enable the 64bit option for the Goldfish 64bit emulator.
>          Signed-off-by: Alan Cox <alan@linux.intel.com>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> +----------------------------------------------------------+------------+------------+
> |                                                          | b8658bc810 | 9b17aeec23 |
> +----------------------------------------------------------+------------+------------+
> | boot_successes                                           | 60         | 0          |
> | boot_failures                                            | 0          | 20         |
> | genirq:Flags_mismatch_irq.(serial)vs.(goldfish_pdev_bus) | 0          | 20         |
> +----------------------------------------------------------+------------+------------+
>
>
> [    8.668148] ALSA device list:
> [    8.668419]   #0: Loopback 1
> [    8.668677]   #1: MTPAV on parallel port at 0x378
> [    8.669432] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.671901] Freeing unused kernel memory: 1196K (ffffffff82bf0000 - ffffffff82d1b000)
> [    8.672607] Write protecting the kernel read-only data: 18432k
> [    8.673681] Freeing unused kernel memory: 80K (ffff880001bec000 - ffff880001c00000)
> [    8.677081] Freeing unused kernel memory: 1076K (ffff8800020f3000 - ffff880002200000)
> [    8.678569] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.679593] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.680682] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.681640] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.682609] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.684017] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.685239] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.692514] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.693570] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.694499] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
> [    8.765477] gfs2: path_lookup on rootfs returned error -2
> [   60.373367] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 [   69.215881] random: nonblocking pool is initialized
>
> git bisect start 0856ad1ef175c45dc6a0bc629ca355fdfbb1001e v3.14 --
> git bisect good 200bde278d78318cbd10cd865f94016924e76c56  # 16:16     20+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 9ae8df66e6742271b49a1518c7bf0debdfc523cf  # 16:32     20+      0  Merge remote-tracking branch 'devicetree-current/devicetree/merge'
> git bisect good 77645accb67841c8557483afe029ec80a240d636  # 16:39     20+      0  Merge remote-tracking branch 'drm/drm-next'
> git bisect good 21dd17170d63646851debe993194e46811dbdb1b  # 16:47     20+      0  Merge remote-tracking branch 'ftrace/for-next'
> git bisect good 2fa6c75b02c032252eaf3c0b8885ddb1b9ad4840  # 16:55     20+      0  Merge remote-tracking branch 'usb-gadget/next'
> git bisect  bad 7dc48a5c223dddebc2bb263d6e77edb557c11f6f  # 17:00      0-      7  Merge remote-tracking branch 'dma-mapping/dma-mapping-next'
> git bisect  bad a75b5bfa061c14e14261aed3771e2b174df72450  # 17:09      0-      8  Merge remote-tracking branch 'cgroup/for-next'
> git bisect  bad 47bb948ff65de22da21d235cc768bba7802ad45f  # 17:15      0-     12  Merge remote-tracking branch 'staging/staging-next'
> git bisect good d5cef008e95ffdaf457e38254e67d145a927df96  # 17:25     20+      0  Merge tag 'iio-for-3.16a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next
> git bisect good a1f3b3fdba2ab124c1e8c2b6aa17cfcf5c99d756  # 17:34     20+      0  staging: rtl8188eu: Remove 'u32 ref_cnt' from struct recv_buf
> git bisect good be4c50604d22f0fd2c65853af18292f44d784b86  # 17:45     20+      0  staging: rtl8723au: Eliminate RTW_STATUS_CODE23a()
> git bisect  bad 2b46be68a1b67f40df4f288b90e79181c387eda6  # 17:53      0-      8  staging: dgnc: cleanup dgnc_finalize_board_init()
> git bisect good c7fff4e43ced0584bcbcef8a5f93bd9a813aac1b  # 18:01     20+      0  staging: rtl8723au: struct phy_info and struct odm_phy_info are identical
> git bisect  bad f6279717bbb20bf90ec414af17d2a31d843f5eb5  # 18:12      0-     10  goldfish: clean up staging ifdefs
> git bisect good 0cc6c3ab3cdbcf8a4a103d27599a6d0b44a6c315  # 18:18     20+      0  staging: rtl8723au: Remove unused pointer in rtw_wdev_free()
> git bisect good f10d8434201859d5ad7f51032dcd2d0c09e85ee2  # 18:25     20+      0  goldfish: add support for 64bit to the virtual bus
> git bisect good b8658bc81089d656fe54b12e21f0cae5116b6483  # 18:33     20+      0  goldfish: enable 64-bit tty driver
> git bisect  bad 9b17aeec232a5f0a61ce3952c2e728a0eeddda8b  # 18:39      0-      9  goldfish: Allow 64bit builds
> # first bad commit: [9b17aeec232a5f0a61ce3952c2e728a0eeddda8b] goldfish: Allow 64bit builds
> git bisect good b8658bc81089d656fe54b12e21f0cae5116b6483  # 18:41     60+      0  goldfish: enable 64-bit tty driver
> git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 18:41      0-     13  Add linux-next specific files for 20140516
> git bisect good 14186fea0cb06bc43181ce239efe0df6f1af260a  # 18:48     60+      0  Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
> git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 18:48      0-     13  Add linux-next specific files for 20140516
>
>
> This script may reproduce the error.
>
> -----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>
> kvm=(
>      qemu-system-x86_64 -cpu kvm64 -enable-kvm     -kernel $kernel
>      -initrd $initrd
>      -smp 2
>      -m 256M
>      -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>      -net user,vlan=0
>      -net nic,vlan=1,model=e1000
>      -net user,vlan=1
>      -boot order=nc
>      -no-reboot
>      -watchdog i6300esb
>      -serial stdio
>      -display none
>      -monitor null
> )
>
> append=(
>      debug
>      sched_debug
>      apic=debug
>      ignore_loglevel
>      sysrq_always_enabled
>      panic=10
>      prompt_ramdisk=0
>      earlyprintk=ttyS0,115200
>      console=ttyS0,115200
>      console=tty0
>      vga=normal
>      root=/dev/ram0
>      rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
>
> Thanks,
> Jet
>
