Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaJEGiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 02:38:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:48638 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaJEGiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 02:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,658,1406617200"; 
   d="scan'208";a="583670764"
Date: Sat, 4 Oct 2014 23:38:02 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [x86LKP] PANIC: double fault, error_code: 0xffffffffffffffff
Message-ID: <20141005063802.GE3264@tassilo.jf.intel.com>
References: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [    5.087621] Freeing unused kernel memory: 1248K (ffff8800014c8000 - ffff880001600000)
> [    5.136856] Freeing unused kernel memory: 1936K (ffff88000181c000 - ffff880001a00000)
> [    5.167951] random: init urandom read with 5 bits of entropy available
> [   19.307116] PANIC: double fault, error_code: 0xffffffffffffffff
> [   19.309941] Kernel panic - not syncing: Machine halted.

That's odd. I actually tested it in KVM.

Will try with your config.

> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 2
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )

-Andi
