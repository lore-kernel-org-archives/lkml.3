Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaHLTFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:05:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47370 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaHLTFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:05:16 -0400
Date: Tue, 12 Aug 2014 12:05:09 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: wlwifi - Microcode SW error detected.
Message-ID: <20140812190509.GA25906@falcon>
References: <20140207151942.GE5121@dhcp22.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB303D640E9@HASMSX103.ger.corp.intel.com>
 <20140210125404.GD7117@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210125404.GD7117@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this on linus/master right now...

$ uname -r
3.16.0-ec2-10567-gc7a19c7

$ dmesg
[...]
[   32.450641] ieee80211 phy0: Hardware restart was requested
[   32.451124] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[   32.451457] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[   32.726567] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   32.726572] iwlwifi 0000:04:00.0: CSR values:
[   32.726574] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   32.726586] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
[   32.726597] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X80000040
[   32.726608] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[   32.726618] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[   32.726629] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   32.726639] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[   32.726650] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[   32.726661] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[   32.726671] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000144
[   32.726682] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
[   32.726692] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X80000000
[   32.726703] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X803a0000
[   32.726713] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[   32.726724] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   32.726734] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   32.726745] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   32.726755] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   32.726766] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[   32.726777] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880d2aef
[   32.726787] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   32.726798] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[   32.726808] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
[   32.726819] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   32.726830] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   32.726831] iwlwifi 0000:04:00.0: FH register values:
[   32.726851] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2135fa00
[   32.726863] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02135fb0
[   32.726875] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000020
[   32.726886] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[   32.726898] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   32.726909] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   32.726921] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   32.726933] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   32.726945] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   32.727049] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[   32.727051] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[   32.727053] iwlwifi 0000:04:00.0: Loaded firmware version: 23.214.9.0
[   32.727055] iwlwifi 0000:04:00.0: 0x0000277B | ADVANCED_SYSASSERT
[   32.727056] iwlwifi 0000:04:00.0: 0x00A002B0 | uPc
[   32.727058] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[   32.727059] iwlwifi 0000:04:00.0: 0x00000BA4 | branchlink2
[   32.727061] iwlwifi 0000:04:00.0: 0x000166A4 | interruptlink1
[   32.727062] iwlwifi 0000:04:00.0: 0x00173B03 | interruptlink2
[   32.727064] iwlwifi 0000:04:00.0: 0x00000024 | data1
[   32.727065] iwlwifi 0000:04:00.0: 0x00000018 | data2
[   32.727066] iwlwifi 0000:04:00.0: 0xDEADBEEF | data3
[   32.727068] iwlwifi 0000:04:00.0: 0x003BE59F | beacon time
[   32.727069] iwlwifi 0000:04:00.0: 0x00041A80 | tsf low
[   32.727070] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[   32.727072] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[   32.727073] iwlwifi 0000:04:00.0: 0x00041A80 | time gp2
[   32.727075] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[   32.727076] iwlwifi 0000:04:00.0: 0x000417D6 | uCode version
[   32.727077] iwlwifi 0000:04:00.0: 0x00000144 | hw version
[   32.727079] iwlwifi 0000:04:00.0: 0x40489204 | board version
[   32.727080] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[   32.727081] iwlwifi 0000:04:00.0: 0x00022000 | isr0
[   32.727083] iwlwifi 0000:04:00.0: 0x01000000 | isr1
[   32.727084] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[   32.727085] iwlwifi 0000:04:00.0: 0x004040C0 | isr3
[   32.727087] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[   32.727088] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[   32.727090] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[   32.727091] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[   32.727092] iwlwifi 0000:04:00.0: 0x00010000 | l2p_duration
[   32.727094] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[   32.727095] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[   32.727097] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[   32.727098] iwlwifi 0000:04:00.0: 0x18051651 | timestamp
[   32.727099] iwlwifi 0000:04:00.0: 0x00002030 | flow_handler
[   32.727102] ieee80211 phy0: Hardware restart was requested
[   32.727583] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[   32.727910] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[...]

On Mon, Feb 10, 2014 at 4:54 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Sun 09-02-14 06:46:20, Grumbach, Emmanuel wrote:
> [...]
>> Is this a regression?
>
> No idea. I haven't tried to reproduce it.
>
>> To me, it looks like a pure firmware issue.
>
> The message points at FW but I have no idea what it actually tries to
> tell, except that something went really wrong.
> --
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

