Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3HTHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:17:55 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40090 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HTHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130820040648.GG27005@ZenIV.linux.org.uk>
References: <20130706000949.GD16853@hostway.ca>
	<CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
	<CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
	<20130820040648.GG27005@ZenIV.linux.org.uk>
Date: Tue, 20 Aug 2013 00:17:52 -0700
Message-ID: <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Ian Applegate <ia@cloudflare.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Simon Kirby <sim@hostway.ca>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are also seeing this or a similar issue. On a fairly widespread
deployment of 3.10.1 & 3.10.6 this occurred fairly consistently on the
order of 36 days (combined MTBF.)

[28974.739774] ------------[ cut here ]------------
[28974.744980] kernel BUG at mm/slub.c:3352!
[28974.749502] invalid opcode: 0000 [#1] SMP
[28974.754143] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler
dm_mod md_mod nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
ip6table_raw ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
iptable_filter xt_tcpudp xt_CT nf_conntrack xt_multiport iptable_raw
ip_tables x_tables rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 fuse
nfsv3 nfs_acl nfs fscache lockd sunrpc bonding tcp_cubic sg sfc(O) mtd
mdio igb dca i2c_algo_bit i2c_core ptp pps_core coretemp kvm_intel kvm
crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper
aes_x86_64 acpi_cpufreq evdev sd_mod crc_t10dif snd_pcm tpm_tis
microcode tpm snd_timer tpm_bios snd soundcore snd_page_alloc pcspkr
ahci libahci uhci_hcd ehci_pci ehci_hcd lpc_ich libata mfd_core
usbcore usb_common hpsa scsi_mod mperf button processor thermal_sys
[28974.835407] CPU: 17 PID: 21400 Comm: nginx-fl Tainted: G
O 3.10.1-cloudflare-trace+ #2
[28974.845307] Hardware name: HP ProLiant DL180 G6  , BIOS O20 01/24/2011
[28974.852653] task: ffff8805bea7b390 ti: ffff8809a5f0e000 task.ti:
ffff8809a5f0e000
[28974.861095] RIP: 0010:[<ffffffff810ebcb2>]  [<ffffffff810ebcb2>]
kfree+0x59/0xe7
[28974.869453] RSP: 0018:ffff8809a5f0fe30  EFLAGS: 00010246
[28974.875434] RAX: 0000000000000000 RBX: ffff880b21e79d40 RCX: 0000000000000028
[28974.883458] RDX: 006ffc0000080068 RSI: 000000000001183c RDI: ffffea002c879e40
[28974.891483] RBP: ffffea002c879e40 R08: 0000000000017100 R09: ffffea0009ea0480
[28974.899507] R10: ffff880ae9746250 R11: 0000000000000000 R12: ffffffff81119456
[28974.907533] R13: 000000000000000a R14: ffff8809a5f0ff48 R15: 0000000000013b80
[28974.915558] FS:  00007fb36c115710(0000) GS:ffff880627d60000(0000)
knlGS:0000000000000000
[28974.924681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28974.931149] CR2: ffffffffff600400 CR3: 0000000761b93000 CR4: 00000000000007e0
[28974.939173] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[28974.947190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[28974.955205] Stack:
[28974.957486]  ffff880a3e72a700 000000000001183c 0000000000000000
ffffffff81119456
[28974.965873]  ffff8809a5f0fe48 0000000000000000 ffff880b21e79d40
000000000000c350
[28974.974253]  ffff8809a5f0fec0 ffff8802b4781bc0 0000000000000200
ffffffff811d96eb
[28974.982646] Call Trace:
[28974.985419]  [<ffffffff81119456>] ? do_readv_writev+0xfc/0x135
[28974.991987]  [<ffffffff811d96eb>] ? ep_poll+0x215/0x286
[28974.997875]  [<ffffffff8112ccb4>] ? fget_light+0x2e/0x7c
[28975.003861]  [<ffffffff811182fd>] ? fdget+0x16/0x1c
[28975.009359]  [<ffffffff8111956c>] ? SyS_readv+0x5a/0xb0
[28975.015245]  [<ffffffff811da1ae>] ? SyS_epoll_wait+0x86/0xc1
[28975.021622]  [<ffffffff814e4d92>] ? system_call_fastpath+0x16/0x1b
[28975.028578] Code: 48 83 fb 10 0f 86 aa 00 00 00 48 89 df e8 8c de
ff ff 48 89 c7 48 89 c5 e8 b5 d7 ff ff 85 c0 75 22 48 f7 45 00 00 c0
00 00 75 02 <0f> 0b 48 89 ef e8 a8 d7 ff ff 5b 48 89 ef 89 c6 5d 41 5c
e9 9a
[28975.050651] RIP  [<ffffffff810ebcb2>] kfree+0x59/0xe7
[28975.056354]  RSP <ffff8809a5f0fe30>
[28975.062479] ---[ end trace 29f90372a2c3b0ac ]---

The machine hobbles along until all processes crash at this point.

[14064.855658] =============================================================================
[14064.864884] BUG kmalloc-192 (Tainted: G        W   ): Poison overwritten
[14064.872424] -----------------------------------------------------------------------------
[14064.872424]
[14064.883322] Disabling lock debugging due to kernel taint
[14064.889304] INFO: 0xffff880930a54824-0xffff880930a54824. First byte
0x6c instead of 0x6b
[14064.898433] INFO: Allocated in alloc_pipe_info+0x17/0x94 age=80
cpu=8 pid=28897
[14064.906684]  set_track+0x5c/0xd7
[14064.910332]  alloc_debug_processing+0x76/0xfd
[14064.915250]  __slab_alloc+0x3e0/0x417
[14064.919386]  alloc_inode+0x26/0x6c
[14064.923232]  alloc_pipe_info+0x17/0x94
[14064.927467]  kmem_cache_alloc_trace+0xbe/0x14e
[14064.932486]  alloc_pipe_info+0x17/0x94
[14064.936721]  alloc_pipe_info+0x17/0x94
[14064.940956]  create_pipe_files+0x3c/0x1e5
[14064.945481]  __do_pipe_flags+0x23/0xa7
[14064.949718]  SyS_pipe2+0x18/0x86
[14064.953374]  system_call_fastpath+0x16/0x1b
[14064.958098] INFO: Freed in pipe_release+0xc4/0xcd age=76 cpu=23 pid=28897
[14064.965740]  set_track+0x5c/0xd7
[14064.969389]  free_debug_processing+0x11d/0x1a9
[14064.974391]  __slab_free+0x32/0x30a
[14064.978334]  free_pages_prepare+0x104/0x128
[14064.983053]  pipe_release+0xc4/0xcd
[14064.986991]  __fput+0xe1/0x1e4
[14064.990443]  task_work_run+0x7b/0x8f
[14064.994482]  do_notify_resume+0x59/0x68
[14064.998816]  int_signal+0x12/0x17
[14065.002561] INFO: Slab 0xffffea0024c29500 objects=31 used=28
fp=0xffff880930a570c0 flags=0x6ffc0000004080
[14065.013341] INFO: Object 0xffff880930a54820 @offset=2080
fp=0xffff880930a55040
[14065.023177] Bytes b4 ffff880930a54810: 4d fa 14 00 01 00 00 00 5a
5a 5a 5a 5a 5a 5a 5a  M.......ZZZZZZZZ
[14065.033864] Object ffff880930a54820: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
[14065.044354] Object ffff880930a54830: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.054845] Object ffff880930a54840: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.065335] Object ffff880930a54850: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.075827] Object ffff880930a54860: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.086321] Object ffff880930a54870: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.096806] Object ffff880930a54880: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.107298] Object ffff880930a54890: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.117788] Object ffff880930a548a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.128278] Object ffff880930a548b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.138770] Object ffff880930a548c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[14065.149262] Object ffff880930a548d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[14065.159751] Redzone ffff880930a548e0: bb bb bb bb bb bb bb bb
                   ........
[14065.169559] Padding ffff880930a54a20: 5a 5a 5a 5a 5a 5a 5a 5a
                   ZZZZZZZZ
[14065.179372] CPU: 10 PID: 7969 Comm: nginx-cache Tainted: G    B   W
   3.10.6-cloudflare-debug+ #5
[14065.189469] Hardware name: HP ProLiant DL180 G6  , BIOS O20 01/24/2011
[14065.196807]  0000000000000000 ffffffff810ee8d2 ffff880930a54820
ffffffff81827fe7
[14065.205185]  ffffea0024c29500 ffff880627804900 ffff880930a54820
ffffea0024c29500
[14065.213576]  ffffffff81223ebb ffff880930a54820 ffffea0024c29500
ffffffff810ee9fe
[14065.221965] Call Trace:
[14065.224743]  [<ffffffff810ee8d2>] ? check_bytes_and_report+0xa7/0xf4
[14065.231902]  [<ffffffff81223ebb>] ? kmem_alloc+0x43/0x6d
[14065.237890]  [<ffffffff810ee9fe>] ? check_object+0xdf/0x19e
[14065.244170]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.250154]  [<ffffffff814e834d>] ? alloc_debug_processing+0x5c/0xfd
[14065.257310]  [<ffffffff814e87ce>] ? __slab_alloc+0x3e0/0x417
[14065.263687]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.269671]  [<ffffffff810efe41>] ? __kmalloc+0x15b/0x191
[14065.275755]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.281733]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.287709]  [<ffffffff8124ce2f>] ? xfs_idata_realloc+0xd5/0xf7
[14065.294378]  [<ffffffff810efde0>] ? __kmalloc+0xfa/0x191
[14065.300366]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.306354]  [<ffffffff81223e9d>] ? kmem_alloc+0x25/0x6d
[14065.312340]  [<ffffffff8125c4ab>] ? xfs_log_commit_cil+0xe8/0x3ce
[14065.319202]  [<ffffffff812589a1>] ? xfs_trans_commit+0x5c/0x1c5
[14065.325873]  [<ffffffff81222ed4>] ? xfs_create+0x404/0x527
[14065.332055]  [<ffffffff8121d07d>] ? xfs_vn_mknod+0xb4/0x15e
[14065.338334]  [<ffffffff8112d010>] ? vfs_create+0x5f/0x84
[14065.344318]  [<ffffffff8112e0f6>] ? do_last+0x54b/0x9b7
[14065.350206]  [<ffffffff8112e624>] ? path_openat+0xc2/0x327
[14065.356386]  [<ffffffff81123b89>] ? do_readv_writev+0x119/0x135
[14065.363053]  [<ffffffff8112eb2c>] ? do_filp_open+0x2a/0x6e
[14065.369232]  [<ffffffff8112bda0>] ? getname_flags.part.32+0x22/0x10a
[14065.376386]  [<ffffffff8113791b>] ? __alloc_fd+0xcc/0xdb
[14065.382373]  [<ffffffff81122803>] ? do_sys_open+0x5c/0xe0
[14065.388457]  [<ffffffff814f43d2>] ? system_call_fastpath+0x16/0x1b
[14065.395413] FIX kmalloc-192: Restoring
0xffff880930a54824-0xffff880930a54824=0x6b
[14065.395413]
[14065.405533] FIX kmalloc-192: Marking all objects used

On Mon, Aug 19, 2013 at 9:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Aug 19, 2013 at 02:16:36PM -0700, Linus Torvalds wrote:
>> On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
>> > On Mon, 19 Aug 2013, Simon Kirby wrote:
>> >
>> >>    [... ]  The
>> >> alloc/free traces are always the same -- always alloc_pipe_info and
>> >> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
>> >>
>> >> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
>> >
>> > This looks like an increment after free in the second 32 bit value of the
>> > structure. First 32 bit value's poison is unchanged.
>>
>> Ugh. If that is "struct pipe_inode_info" and I read it right, that's
>> the "wait_lock" spinlock that is part of the mutex.
>>
>> Doing a "spin_lock()" could indeed cause an increment operation. But
>> it still sounds like a very odd case. And even for some wild pointer
>> I'd then expect the spin_unlock to also happen, and to then increment
>> the next byte (or word) too. More importantly, for a mutex, I'd expect
>> the *other* fields to be corrupted too (the "waiter" field etc). That
>> is, unless we're still spinning waiting for the mutex, but with that
>> value we shouldn't, as far as I can see.
>
> Point...  I would probably start with CONFIG_DEBUG_MUTEXES and see if
> it screams about mutex magic, etc. having been buggered.  FWIW, pipe is
> neither a FIFO nor an internal per-task one - it's a usual pipe(2) one,
> which should've excluded most of the weird codepaths...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
