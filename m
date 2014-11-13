Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaKMOI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:08:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:2084 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756AbaKMOI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:08:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487185524"
Message-ID: <5464BB4B.7010505@linux.intel.com>
Date: Thu, 13 Nov 2014 22:08:11 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Yuanhan Liu <yuanhan.liu@intel.com>
Subject: Re: [x86, irq] BUG: kernel boot hang
References: <20141113134139.GA22488@wfg-t540p.sh.intel.com>
In-Reply-To: <20141113134139.GA22488@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,
	This seems like a bug caused by my changes, several
bisecting report the same commit. There's some subtle changes
in the way to write IOAPIC registers, will check it tomorrow:)
Thanks!
Gerry

On 2014/11/13 21:41, Fengguang Wu wrote:
> 
> Hi Jiang,
> 
> This is another bisect result.
> 
> https://github.com/jiangliu/linux.git irqdomain/p4v2
> commit b8c2d075135a41f69254a75c4f26162559503ab4 ("x86, irq: Use cached IOAPIC entry instead of reading from hardware")
> 
> 
> +----------------------+------------+------------+
> |                      | 384c30d19a | b8c2d07513 |
> +----------------------+------------+------------+
> | boot_successes       | 20         | 5          |
> | early-boot-hang      | 1          |            |
> | boot_failures        | 0          | 15         |
> | BUG:kernel_boot_hang | 0          | 15         |
> +----------------------+------------+------------+
> 
> 
> [  289.616037] Waiting up to 30 more seconds for network.
> [  299.616037] Waiting up to 20 more seconds for network.
> 
> BUG: kernel boot hang
> Elapsed time: 310
> qemu-system-x86_64 -enable-kvm -kernel /kernel/x86_64-lkp/349d0daa5e14b9b402a2dea3e602ef1cb109173b/vmlinuz-3.18.0-rc3-g349d0da -append 'user=lkp job=/lkp/scheduled/vm-vp-quantal-x86_64-27/rand_boot-1-quantal-core-x86_64.cgz-x86_64-lkp-349d0daa5e14b9b402a2dea3e602ef1cb109173b-1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/349d0daa5e14b9b402a2dea3e602ef1cb109173b/vmlinuz-3.18.0-rc3-g349d0da kconfig=x86_64-lkp commit=349d0daa5e14b9b402a2dea3e602ef1cb109173b branch=jiangliu/irqdomain/p4v2 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/vm-vp-quantal-x86_64/boot/1/quantal-core-x86_64.cgz/x86_64-lkp/349d0daa5e14b9b402a2dea3e602ef1cb109173b/0 ip=::::vm-vp-quantal-x86_64-27::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw drbd.minor_count=8'  -initrd /fs/sdf1/initrd-vm-vp-quantal-x86_64-27 -m 3
60 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-vm-vp-quantal-x86_64-27 -serial file:/dev/shm/kboot/serial-vm-vp-quantal-x86_64-27 -daemonize -display none -monitor null 
> 
> 
> 
> Thanks,
> Fengguang
> 
> 
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 
