Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373Ab3CZJcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:32:33 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:43745 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab3CZJcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:32:31 -0400
Date: Tue, 26 Mar 2013 05:32:27 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Dave Jones <davej@redhat.com>
Message-ID: <1122269504.6445741.1364290347815.JavaMail.root@redhat.com>
In-Reply-To: <0000013da2b53120-1c207286-3e36-483e-9fd9-90fc529d48aa-000000@email.amazonses.com>
Subject: Re: BUG at kmem_cache_alloc
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Christoph Lameter" <cl@linux.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "David Rientjes" <rientjes@google.com>, "linux-mm" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, "Oleg
> Nesterov" <oleg@redhat.com>
> Sent: Tuesday, March 26, 2013 2:00:16 AM
> Subject: Re: BUG at kmem_cache_alloc
> 
> 
> Please enable CONFIG_SLUB_DEBUG_ON or run the kernel with slub_debug
> on
> the command line to get detailed diagnostics as to what causes this.
> 
Still running and will update ASAP. One thing I noticed was that trinity
threw out this error before the kernel crash.

[19380] Random reseed: 644697889 
trinity(19380): Randomness reseeded to 0x266d4f21 
trinity: trinity(19380) Randomness reseeded to 0x266d4f21 
[19380] Random reseed: 1927643389 
trinity(19380): Randomness reseeded to 0x72e580fd 
trinity: trinity(19380) Randomness reseeded to 0x72e580fd 
[watchdog] 9381710 iterations. [F:8140812 S:1240290] 
[watchdog] 9383499 iterations. [F:8142333 S:1240558] 
 
Session terminated, killing shell...      
BUG!:       
CHILD (pid:28825) GOT REPARENTED! parent pid:19380. Watchdog pid:19379 
      
BUG!:       
Last syscalls: 
[0]  pid:28515 call:settimeofday callno:10356 
[1]  pid:28822 call:setgid callno:322 
[2]  pid:28581 call:init_module callno:3622 
[3]  pid:28825 call:readlinkat callno:403 
child 28581 exiting 
child 28515 exiting 
 ...killed. 

Then, some tests in LTP called epoll triggered it eventually.

[ 9788.955733] BUG: unable to handle kernel paging request at 00000000fffffff7 
[ 9788.956687] IP: [<ffffffff811876a8>] kmem_cache_alloc+0x68/0x1e0 
[ 9788.956687] PGD bebd3067 PUD 0  
[ 9788.956687] Oops: 0000 [#1] SMP  
[ 9788.956687] Modules linked in: l2tp_ppp l2tp_netlink l2tp_core tun cmtp kernelcapi bnep fuse rfcomm hidp ipt_ULOG rds af_key pppoe pppox ppp_generic slhc af_802154 nfc atm ip6table_filter ip6_tables iptable_filter ip_tables btrfs zlib_deflate vfat fat nfs_layout_nfsv41_files nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp sctp sg i5000_edac coretemp edac_core kvm_intel iTCO_wdt iTCO_vendor_support kvm lpc_ich ipmi_si ipmi_msghandler i5k_amb mfd_core hpilo hpwdt shpchp serio_raw microcode pcspkr xfs sd_mod crc_t10dif sr_mod cdrom ata_generic hpsa pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm ata_piix libata i2c_core bnx2 bnx2x cciss 3w_9xxx libcrc32c dm_mirror dm_region_hash dm_log dm_mod iscsi_tcp be2iscsi bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi libiscsi_tcp qla4xxx libiscsi scsi_transport_iscsi iscsi_ibft iscsi_boot_sysfs [last unloaded: ipt_REJECT] 
[ 9788.956687] CPU 0  
[ 9788.956687] Pid: 25412, comm: epoll-ltp Tainted: G        W I  3.8.4+ #1 HP ProLiant DL380 G5 
[ 9788.956687] RIP: 0010:[<ffffffff811876a8>]  [<ffffffff811876a8>] kmem_cache_alloc+0x68/0x1e0 
[ 9788.956687] RSP: 0018:ffff8800bbee9dd0  EFLAGS: 00010246 
[ 9788.956687] RAX: 0000000000000000 RBX: ffff8801a356e5c0 RCX: 0000000000000000 
[ 9788.956687] RDX: 0000000000036b0a RSI: 00000000000080d0 RDI: ffff8801a906ad00 
[ 9788.956687] RBP: ffff8800bbee9e10 R08: 00000000000176b0 R09: ffffffff810fe2e2 
[ 9788.956687] R10: 0000000000000016 R11: ffffffffffffffdc R12: 00000000fffffff7 
[ 9788.956687] R13: 00000000000080d0 R14: ffff8801a906ad00 R15: ffff8801a906ad00 
[ 9788.956687] FS:  00007fbf42058740(0000) GS:ffff8801afc00000(0000) knlGS:0000000000000000 
[ 9788.956687] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[ 9788.956687] CR2: 00000000fffffff7 CR3: 00000000aece6000 CR4: 00000000000407f0 
[ 9788.956687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 9788.956687] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[ 9788.956687] Process epoll-ltp (pid: 25412, threadinfo ffff8800bbee8000, task ffff8801a6524c50) 
[ 9788.956687] Stack: 
[ 9788.956687]  ffffffff810fe2e2 ffffffff8108cf0f 0000000001200011 ffff8801a356e5c0 
[ 9788.956687]  0000000000000000 00007fbf42058a10 0000000000000000 ffff8801a356e5c0 
[ 9788.956687]  ffff8800bbee9e30 ffffffff810fe2e2 0000000000000000 0000000001200011 
[ 9788.956687] Call Trace: 
[ 9788.956687]  [<ffffffff810fe2e2>] ? __delayacct_tsk_init+0x22/0x40 
[ 9788.956687]  [<ffffffff8108cf0f>] ? prepare_creds+0xdf/0x190 
[ 9788.956687]  [<ffffffff810fe2e2>] __delayacct_tsk_init+0x22/0x40 
[ 9788.956687]  [<ffffffff8106027f>] copy_process.part.25+0x31f/0x13f0 
[ 9788.956687]  [<ffffffff8106765b>] ? do_wait+0x12b/0x250 
[ 9788.956687]  [<ffffffff81097f3e>] ? wake_up_new_task+0xfe/0x160 
[ 9788.956687]  [<ffffffff81061449>] do_fork+0xa9/0x350 
[ 9788.956687]  [<ffffffff81068810>] ? sys_wait4+0x80/0xf0 
[ 9788.956687]  [<ffffffff81061776>] sys_clone+0x16/0x20 
[ 9788.956687]  [<ffffffff8161a7f9>] stub_clone+0x69/0x90 
[ 9788.956687]  [<ffffffff8161a499>] ? system_call_fastpath+0x16/0x1b 
[ 9788.956687] Code: 90 4d 89 fe 4d 8b 06 65 4c 03 04 25 c8 db 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 2b 01 00 00 49 63 46 20 4d 8b 06 41 f6 c0 0f <49> 8b 1c 04 0f 85 55 01 00 00 48 8d 4a 01 4c 89 e0 65 49 0f c7  
[ 9788.956687] RIP  [<ffffffff811876a8>] kmem_cache_alloc+0x68/0x1e0 
[ 9788.956687]  RSP <ffff8800bbee9dd0> 
[ 9788.956687] CR2: 00000000fffffff7 
[ 9789.029177] ---[ end trace 001669df502cd1ce ]---

CAI Qian
