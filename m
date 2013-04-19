Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967919Ab3DSDdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 23:33:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967859Ab3DSDdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 23:33:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,506,1363104000"; 
   d="scan'208";a="7092695"
Message-ID: <5170BB00.8080200@cn.fujitsu.com>
Date: Fri, 19 Apr 2013 11:33:20 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
References: <516E5EF8.9090507@cn.fujitsu.com> <1366209997.8817.12.camel@pippen.local.home> <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk>
In-Reply-To: <20130418143014.GZ4816@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 11:31:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 11:31:32,
	Serialize complete at 2013/04/19 11:31:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 10:30 PM, Jens Axboe wrote:
> On Thu, Apr 18 2013, Wanlong Gao wrote:
>> On 04/18/2013 09:35 PM, Jens Axboe wrote:
>>> On Thu, Apr 18 2013, Wanlong Gao wrote:
>>>>> A bio is always fully initialized, regardless of which internal
>>>>> allocator it came from. If people are doing private kmallocs, then they
>>>>> better be using bio_init() as well.
>>>>>
>>>>> Wanlong, would it be possible to get a full dmesg on boot see I can see
>>>>> what drivers and file systems are in use? Anything special about your
>>>>> setup.
>>>>
>>>> Sure, attached.
>>>
>>> Does the below help?
>>
>> Still got panic with this patch. :-(
> 
> Could you capture the full dump? I'd like to see what rcx was, and that
> seems to have scrolled off.
> 

I got the panic message using netconsole:

EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
XFS (sda11): Mounting Filesystem
XFS (sda11): Ending clean mount
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda12): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (sda12): using internal journal
EXT3-fs (sda12): mounted filesystem with ordered data mode
XFS (sda13): Mounting Filesystem
XFS (sda13): Ending clean mount
xor: measuring software checksum speed
   prefetch64-sse:  7572.000 MB/sec
   generic_sse:  6300.000 MB/sec
xor: using function: prefetch64-sse (7572.000 MB/sec)
raid6: sse2x1    4796 MB/s
raid6: sse2x2    5449 MB/s
raid6: sse2x4    5816 MB/s
raid6: using algorithm sse2x4 (5816 MB/s)
raid6: using ssse3x2 recovery algorithm
Btrfs loaded
device fsid 01548710-abce-4290-801d-5f19dde14497 devid 1 transid 131526 /dev/sda14
BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
IP: [<ffffffff812484d3>] ftrace_raw_event_block_bio_complete+0x73/0xf0
PGD 0 
Oops: 0000 [#1] SMP 
Modules linked in: btrfs raid6_pq zlib_deflate xor xfs libcrc32c netconsole ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc cnic uio fcoe libfcoe libfc scsi_transport_fc scsi_tgt 8021q garp ppdev parport_pc parport fuse cpufreq_ondemand cachefiles fscache bridge stp llc ipv6 ext3 jbd dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support sg acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel microcode serio_raw pcspkr i2c_i801 lpc_ich mfd_core ioatdma i7core_edac edac_core igb dca i2c_algo_bit i2c_core ptp pps_core dm_mod ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
CPU 3 
Pid: 0, comm: swapper/3 Not tainted 3.9.0-rc7-4-gbb33db7 #1 Lenovo Lenovo WQ TR280 G3/TR350 G7/TB36D
RIP: 0010:[<ffffffff812484d3>]  [<ffffffff812484d3>] ftrace_raw_event_block_bio_complete+0x73/0xf0
RSP: 0018:ffff8802bfc63bb8  EFLAGS: 00010202
RAX: ffff8802b1e88698 RBX: ffff8802b05f6bc0 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8802b1e8869c
RBP: ffff8802bfc63c08 R08: 000000000000000a R09: 0000000000000000
R10: 000000000000002c R11: 0000000000000000 R12: ffffffff81a95b60
R13: 0000000000000100 R14: ffff8802b1e88694 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8802bfc60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000001 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/3 (pid: 0, threadinfo ffff8802b4598000, task ffff8802b4594a80)
Stack:
 ffff8802b4546c40 0000000000000286 0000000000000100 ffff8802b4546c40
 ffff8802bfc63c08 ffff8802b1f82160 ffff8802b05f6bc0 0000000000000000
 0000000000001000 0000000000000000 ffff8802bfc63c38 ffffffff811b6c10
Call Trace:
 <IRQ> 
 [<ffffffff811b6c10>] bio_endio+0x80/0x90
 [<ffffffffa0790d26>] btrfs_end_bio+0xf6/0x190 [btrfs]
 [<ffffffff811b6bcd>] bio_endio+0x3d/0x90
 [<ffffffff81249873>] req_bio_endio+0xa3/0xe0
 [<ffffffff8124af9f>] blk_update_request+0x10f/0x480
 [<ffffffff8124b337>] blk_update_bidi_request+0x27/0xb0
 [<ffffffff8124c52f>] blk_end_bidi_request+0x2f/0x80
 [<ffffffff8124c5d0>] blk_end_request+0x10/0x20
 [<ffffffff8139c1b0>] scsi_end_request+0x40/0xb0
 [<ffffffff8139c52f>] scsi_io_completion+0x9f/0x660
 [<ffffffff81393899>] scsi_finish_command+0xc9/0x130
 [<ffffffff8139cc57>] scsi_softirq_done+0x147/0x170
 [<ffffffff81252c52>] blk_done_softirq+0x82/0xa0
 [<ffffffff8105f537>] __do_softirq+0xe7/0x250
 [<ffffffff8105f7a5>] irq_exit+0xb5/0xc0
 [<ffffffff81570966>] do_IRQ+0x66/0xe0
 [<ffffffff8156662d>] common_interrupt+0x6d/0x6d
 <EOI> 
 [<ffffffff81449e30>] ? cpuidle_wrap_enter+0x50/0x90
 [<ffffffff81449e29>] ? cpuidle_wrap_enter+0x49/0x90
 [<ffffffff81449e80>] cpuidle_enter_tk+0x10/0x20
 [<ffffffff81449887>] cpuidle_enter_state+0x17/0x50
 [<ffffffff8144a0ca>] cpuidle_idle_call+0xaa/0x110
 [<ffffffff8101cd0f>] cpu_idle+0xcf/0x120
 [<ffffffff8155aa9a>] start_secondary+0xc8/0xca
Code: 8b 4d b8 ba 28 00 00 00 45 89 e8 e8 e8 2c eb ff 48 85 c0 49 89 c6 74 5a 48 89 c7 e8 08 c6 ea ff 48 8b 4b 10 31 d2 48 85 c9 74 02 <8b> 11 89 50 08 48 8b 13 48 8d 78 20 48 89 50 10 8b 53 30 44 89 
RIP  [<ffffffff812484d3>] ftrace_raw_event_block_bio_complete+0x73/0xf0
 RSP <ffff8802bfc63bb8>
CR2: 0000000000000001
---[ end trace b13662c9f1a097d8 ]---
Kernel panic - not syncing: Fatal exception in interrupt



Thanks,
Wanlong Gao

