Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182Ab3GLRIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:08:23 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:33413 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029Ab3GLRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:08:21 -0400
Message-ID: <51E03809.5030307@opengridcomputing.com>
Date: Fri, 12 Jul 2013 12:08:25 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Oops mystery
References: <51E02545.7080106@opengridcomputing.com> <20130712164816.GE1020@redhat.com> <51E0348A.2030208@opengridcomputing.com> <20130712170046.GB1537@redhat.com>
In-Reply-To: <20130712170046.GB1537@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 12:00 PM, Dave Jones wrote:
> On Fri, Jul 12, 2013 at 11:53:30AM -0500, Steve Wise wrote:
>   > On 7/12/2013 11:48 AM, Dave Jones wrote:
>   > > On Fri, Jul 12, 2013 at 10:48:21AM -0500, Steve Wise wrote:
>   > >
>   > >   > So 'movb   $0x0,0xe(%rax,%rdx,1)' should be storing 0 into the byte
>   > >   > location:
>   > >   >
>   > >   > %rax + 0xe + (%rdx * 1) ==
>   > >   > 0x40fc+ 0xe + 0xffff8808b5500000 ==
>   > >   > 0xffff8808b5540fce.
>   > >   >
>   > >   > That address is readable in the crash dump:
>   > >   >
>   > >   > crash> x/8b 0x0000000000040fc0+0xe+0xffff8808b5500000
>   > >   > 0xffff8808b5540fce:     0x00    0x00    0x00    0x00    0x00 0x00
>   > >   > 0x00    0x00
>   > >   >
>   > >   > And why does the page fault show 0x40fc0 as the faulting address?  It
>   > >   > should be 0xffff8808b5540fce and it shouldn't have caused a page fault.
>   > >   >
>   > >   > What am I missing?
>   > >
>   > > Random guess: Is that page marked read-only perhaps ?
>   >
>   > It shouldn't be. :)  How can I get this info via the crash dump? The
>   > memory was allocated with dma_alloc_coherent().   Why would the page
>   > fault occur on 0x40fc0 though?  That makes me think my analysis so far
>   > is incorrect.
>
> Hmm, good point. Do you have the Code: line from the oops ?
> Does that match the disassembly ?
>
>

There is no 'Code:' line in the log.  I thought about that that too, but 
I don't see it dumping the code.   The kernel is a SLES11sp1 kernel, 
1.6.32.54-0.3-default.

[ 1053.156266] BUG: unable to handle kernel paging request at 
0000000000040fc0
[ 1053.216620] IP: [<ffffffffa02b202e>] c4iw_ev_handler+0x2e/0x84 [iw_cxgb4]
[ 1053.216638] PGD 8b9877067 PUD 86cd37067 PMD 0
[ 1053.216642] Oops: 0002 [#1] SMP
[ 1053.216644] last sysfs file: 
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[ 1053.216647] Die func triggered, code:1
[ 1053.788600] User stack address error, stack is (null)
[ 1053.935798] Watch Dog Data write ef!
[ 1053.987676] scsi 0:0:12:0: [sg13] Sense Key : Illegal Request [current]
[ 1053.987682] scsi 0:0:12:0: [sg13] Add. Sense: Invalid command 
operation code
[ 1054.353008] CR2: 0000000000040fc0
[ 1054.392493] sending NMI to all CPUs:
[ 1054.392499] NMI backtrace for cpu 4
[ 1054.392500] CPU 4:
[ 1054.392502] Modules linked in: smb2(N) smb(N) smb_manager(N) 
nas_netlink(N) af_packet nfsd nfs_common(N) lockd auth_rpcgss nas_acl(N) 
nas_proto_vfs(N) sunrpc snas_ts(N) ipmi_devintf snas_cafs(PN) snas_ca(N) 
ipmi_si ipmi_msghandler snas_mds(PN) snas_ds(N) nm(PN) snas_nvcache(PN) 
snas_dlm(PN) snas_trns(PN) snas_cm_sdd(PN) snas_cm_pma(PN) 
disk_online_diagnostic(N) snas_monc(N) snas_fc(N) snas_mml(PN) cstl(PN) 
ptlrpc(N) ko2iblnd(N) ksocklnd(N) obdclass(N) lnet(N) lvfs(PN) libcfs(N) 
snas_base(PN) nofs(N) usos(N) zlib_deflate cpufreq_conservative 
cpufreq_userspace cpufreq_powersave acpi_cpufreq t3k_mpt2sas_vdl(N) 
raidrepair(N) ib_ipoib ib_umad iw_nes crc32c libcrc32c iw_cxgb3 cxgb3 
ib_qib(N) dca mlx4_ib mlx4_en mlx4_core ib_mthca nvdimm_mapping(N) 
smbuspci(N) microcode t4_tom(N) toecore(N) rdma_ucm ib_uverbs rdma_cm 
ib_cm iw_cm ib_sa ib_mad ib_addr ipv6 iw_cxgb4(N) ib_core 
soft_watchdog(PN) kbox(PN) fuse loop dm_mod tpm_tis tpm iTCO_wdt 
rtc_cmos tpm_bios i2c_i801 cxgb4(N) pcspkr iTCO_vendor_support i2c_core 
rtc_core ses sg rtc_lib bnx2 enclosure wmi button container usbhid hid 
ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan processor 
mpt2sas scsi_transport_sas raid_class scsi_mod thermal thermal_sys hwmon 
[last unloaded: ipmi_msghandler]
[ 1054.392565] Supported: Yes, External
[ 1054.392568] Pid: 12915, comm: DSI_SvrReceiveR Tainted: P N  
2.6.32.54-0.3-default #1 T3500 G3
[ 1054.392570] RIP: 0010:[<ffffffff8101fce9>] [<ffffffff8101fce9>] 
x2apic_send_IPI_mask+0x59/0x90
[ 1054.392576] RSP: 0018:ffff880751c09e48  EFLAGS: 00000046
[ 1054.392578] RAX: 0000000000000c00 RBX: 000000000000ce54 RCX: 
0000000000000830
[ 1054.392580] RDX: 0000000000020004 RSI: 0000000000000005 RDI: 
0000000000000c00
[ 1054.392582] RBP: 0000000000000002 R08: 0000000000000080 R09: 
ffffffff81927a80
[ 1054.392584] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffffffff81927a80
[ 1054.392585] R13: 0000000000000830 R14: 0000000000000092 R15: 
ffff880c3dbf1480
[ 1054.392588] FS:  0000000000000000(0000) GS:ffff880751c00000(0000) 
knlGS:0000000000000000
[ 1054.392590] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1054.392592] CR2: 0000000000040fc0 CR3: 000000089d140000 CR4: 
00000000000406e0
[ 1054.392594] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1054.392596] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 
0000000000000400
[ 1054.392598] Call Trace:
[ 1054.392605]  [<ffffffff8101b7e9>] 
arch_trigger_all_cpu_backtrace+0x49/0x80
[ 1054.392613]  [<ffffffffa02863f7>] 
kbox_mon_crash_save_vmcoreinfo+0x37/0x80 [kbox]
[ 1054.392622]  [<ffffffff8139fc75>] post_kprobe_handler+0x165/0x250
[ 1054.392628]  [<ffffffff813a03ed>] kprobe_exceptions_notify+0x3d/0x90
[ 1054.392632]  [<ffffffff813a0b97>] notifier_call_chain+0x37/0x70
[ 1054.392637]  [<ffffffff8106a14d>] notify_die+0x2d/0x40
[ 1054.392641]  [<ffffffff8139e5f0>] do_debug+0xa0/0x170
[ 1054.392646]  [<ffffffff8139e18d>] debug+0x2d/0x40
[ 1054.392653]  [<ffffffff81088494>] crash_save_vmcoreinfo+0x4/0x80
[ 1054.392658]  [<ffffffff8108876c>] crash_kexec+0x4c/0x110
[ 1054.392663]  [<ffffffff8139efe0>] oops_end+0xb0/0xf0
[ 1054.392667]  [<ffffffff8102ed15>] __bad_area_nosemaphore+0x155/0x230
[ 1054.392672]  [<ffffffff8139e25f>] page_fault+0x1f/0x30
[ 1054.392679]  [<ffffffffa02b202e>] c4iw_ev_handler+0x2e/0x84 [iw_cxgb4]
[ 1054.392688]  [<ffffffffa02bd591>] c4iw_uld_rx_handler+0xa6/0x41c 
[iw_cxgb4]
[ 1054.392701]  [<ffffffffa01d907b>] uldrx_handler+0x3b/0xb0 [cxgb4]
[ 1054.392712]  [<ffffffffa01f8d6c>] process_responses+0x56c/0x580 [cxgb4]
[ 1054.392739]  [<ffffffffa01f8d9c>] napi_rx_handler+0x1c/0x80 [cxgb4]
[ 1054.392762]  [<ffffffff812f8bc3>] net_rx_action+0xe3/0x1a0
[ 1054.392766]  [<ffffffff810545af>] __do_softirq+0xbf/0x170
[ 1054.392770]  [<ffffffff810040bc>] call_softirq+0x1c/0x30
[ 1054.392774]  [<ffffffff81005cfd>] do_softirq+0x4d/0x80
[ 1054.392778]  [<ffffffff81054435>] irq_exit+0x85/0x90
[ 1054.392782]  [<ffffffff8100525e>] do_IRQ+0x6e/0xe0
[ 1054.392787]  [<ffffffff81003913>] ret_from_intr+0x0/0xa
[ 1054.392792]  [<ffffffff8139ded5>] _spin_unlock_irqrestore+0x5/0x10
[ 1054.392800]  [<ffffffffa097be3c>] libcfs_debug_vmsg2+0x56c/0xba0 [libcfs]
[ 1054.392823]  [<ffffffffa0ae761b>] 
ptlrpc_server_log_handled_request+0x23b/0x240 [ptlrpc]
[ 1054.392853]  [<ffffffffa0ae9072>] ptlrpc_main+0x1372/0x2c90 [ptlrpc]
[ 1054.392874]  [<ffffffff81003fba>] child_rip+0xa/0x20
<snip>

Steve

