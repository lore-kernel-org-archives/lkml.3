Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3DZO1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:27:09 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:57620 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3DZO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:27:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/efi2] efivars: efivar_entry API
Thread-Topic: [tip:x86/efi2] efivars: efivar_entry API
Thread-Index: AQHOPHFEzrlus8pItEq77hQ4E6Icb5jkge3AgAQQugCAAAb/4A==
Date: Fri, 26 Apr 2013 14:25:52 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E2B@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AFCC9D0@USINDEM103.corp.hds.com>
 <517A4F2A.4080906@intel.com>
In-Reply-To: <517A4F2A.4080906@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-26_05:2013-04-26,2013-04-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304260107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3QERGjA004071

Matt,

Thanks.
With your patch, It works in case each entry is erased one by one as below.
# rm dmesg-efi-1
#rm dmesg-efi-2 

But, it still panics in case multiple entries are erased at the same time as below.
#rm dmsg-efi-*

SELinux: initialized (dev pstore, type pstore), not configured for labeling
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8142ea0f>] __efivar_entry_iter+0xcf/0x120
PGD 19483f067 PUD 195426067 PMD 0 
Oops: 0000 [#1] SMP 
Modules linked in: ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun uinput thinkpad_acpi iTCO_wdt iTCO_vendor_support wmi sg acpi_cpufreq freq_table mperf arc4 coretemp kvm_intel kvm iwldvm mac80211 crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode pcspkr i2c_i801 lpc_ich mfd_core iwlwifi cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc e1000e ptp pps_core ext4(F) mbcache(F) jbd2(F) sd_mod(F) crc_t10dif(F) sdhci_pci(F) sdhci(F) mmc_core(F) ahci(F) libahci(F) i915(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) i2c_core(F) video(F) dm_mirror(F) dm_region_!
 hash(F) dm
_log(F) dm_mod(F)
CPU 3 
Pid: 13472, comm: rm Tainted: GF            3.9.0-rc8-tip+ #6 LENOVO 4291EV7/4291EV7
RIP: 0010:[<ffffffff8142ea0f>]  [<ffffffff8142ea0f>] __efivar_entry_iter+0xcf/0x120
RSP: 0018:ffff880194395ca8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff81ab8de0 RCX: 000000000000000f
RDX: 0000000000000000 RSI: ffff880194395c59 RDI: ffff880194395c49
RBP: ffff880194395ce8 R08: 000000000000fff2 R09: 000000000000000a
R10: 0000000000000000 R11: 000000000000fff5 R12: ffffffff81430f10
R13: ffff880194395d88 R14: fffffffffffff7d8 R15: ffff880194395db0
FS:  00007f6e8afb4700(0000) GS:ffff88019e2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000194915000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 13472, threadinfo ffff880194394000, task ffff88019107f4e0)
Stack:
 ffff880194395cb8 ffff880195bc1000 ffff880194395cc8 000000005177ef75
 0000000000000000 000000000000000a 0000000000000000 0000000000000001
 ffff880194395e28 ffffffff81430ebf ffff88019107f4e0 ffff880194395db8
Call Trace:
 [<ffffffff81430ebf>] efi_pstore_erase+0xef/0x140
 [<ffffffff81003138>] ? math_error+0x288/0x2d0
 [<ffffffff811ea491>] pstore_unlink+0x41/0x60
 [<ffffffff811741ff>] vfs_unlink+0x9f/0x110
 [<ffffffff8117813b>] do_unlinkat+0x18b/0x280
 [<ffffffff8116d7e6>] ? sys_newfstatat+0x36/0x50
 [<ffffffff81178472>] sys_unlinkat+0x22/0x40
 [<ffffffff81543282>] system_call_fastpath+0x16/0x1b
Code: 8d 82 d8 f7 ff ff 48 89 45 c8 4c 8b b0 28 08 00 00 31 c0 48 39 d3 74 38 49 81 ee 28 08 00 00 eb 21 0f 1f 00 49 8d 96 28 08 00 00 <49> 8b 8e 28 08 00 00 48 39 d3 74 35 4c 89 75 c8 4c 8d b1 d8 f7 
RIP  [<ffffffff8142ea0f>] __efivar_entry_iter+0xcf/0x120
 RSP <ffff880194395ca8>
CR2: 0000000000000000
---[ end trace 1d19d659e0c71627 ]---

> -----Original Message-----
> From: Matt Fleming [mailto:matt.fleming@intel.com]
> Sent: Friday, April 26, 2013 5:56 AM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; mingo@kernel.org; hpa@zytor.com; mjg59@srcf.ucam.org; tony.luck@intel.com; jk@ozlabs.org;
> teg@jklm.no; tglx@linutronix.de; mikew@google.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
> 
> On 24/04/13 00:55, Seiji Aguchi wrote:
> > Hi,
> >
> > I tested a current tip tree to check if the new API works.
> > But pstore_erase() doesn't work...
> > I'm checking the source code right now.
> >
> > Seiji
> 
> [...]
> 
> > Call Trace:
> >  [<ffffffff8143001f>] efi_pstore_erase+0xdf/0x130
> >  [<ffffffff81200038>] ? cap_socket_create+0x8/0x10
> >  [<ffffffff811ea491>] pstore_unlink+0x41/0x60
> >  [<ffffffff811741ff>] vfs_unlink+0x9f/0x110
> >  [<ffffffff8117813b>] do_unlinkat+0x18b/0x280
> >  [<ffffffff81178472>] sys_unlinkat+0x22/0x40
> >  [<ffffffff81542402>] system_call_fastpath+0x16/0x1b
> 
> Does this patch fix things?
> 
> ---
> 
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index 47ae712..b820593 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -173,7 +173,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
>  			    struct timespec time, struct pstore_info *psi)
>  {
>  	struct pstore_erase_data edata;
> -	struct efivar_entry *entry;
> +	struct efivar_entry *entry = NULL;
>  	char name[DUMP_NAME_LEN];
>  	efi_char16_t efi_name[DUMP_NAME_LEN];
>  	int found, i;
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
