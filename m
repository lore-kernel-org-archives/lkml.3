Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3EaVMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:12:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20912 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab3EaVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:12:02 -0400
Date: Fri, 31 May 2013 17:11:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@redhat.com, x86@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Baremetal during suspend gives: WARNING: at
 /home/konrad/linux/arch/x86/kernel/smp.c:123
 native_smp_send_reschedule+0x5b/0x60()
Message-ID: <20130531211116.GA5362@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Heya!

This is v3.10-rc3 with a revert of b5096566f6e1ee2b88324772f020ae9bc0cfa9a0
(drm/nv50/fifo: prevent races between clients updating playlists) since said
commit hangs resume.

Anyhow on a Fedora built type .config the machine during suspend throws this warning:


[  819.641298] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[  819.695579] PM: Saving platform NVS memory
[  819.701191] Disabling non-boot CPUs ...
[  819.705218] smpboot: CPU 1 is now offline
[  819.705652] CPU 1 offline: Remove Rx thread
[  819.705972] ------------[ cut here ]------------
[  819.705984] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.706040] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
[  819.706063]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
[  819.706067] CPU: 0 PID: 127 Comm: kworker/1:1 Not tainted 3.10.0-rc3+ #4
[  819.706068] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.706073] Workqueue: events od_dbs_timer
[  819.706080]  0000000000000009 ffff88042ff6dbf8 ffffffff8167edc5 ffff88042ff6dc38
[  819.706084]  ffffffff8105d380 0000000000000339 0000000000000001 ffff8804385e0000
[  819.706088]  000000010008056a 0000000000000001 ffff88044ec50b08 ffff88042ff6dc48
[  819.706089] Call Trace:
[  819.706097]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.706102]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.706107]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.706112]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.706116]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.706120]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.706125]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.706129]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.706133]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.706138]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.706141]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.706146]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.706150]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.706154]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.706158]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.706162]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.706166]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.706170]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.706173] ---[ end trace a5556efe295a5e63 ]---
[  819.706729] Broke affinity for irq 81
[  819.709704] smpboot: CPU 2 is now offline
[  819.710351] CPU 2 offline: Remove Rx thread
[  819.710995] ------------[ cut here ]------------
[  819.711000] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.711042] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
[  819.711060]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
[  819.711063] CPU: 0 PID: 112 Comm: kworker/2:1 Tainted: G        W    3.10.0-rc3+ #4
[  819.711064] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.711067] Workqueue: events od_dbs_timer
[  819.711073]  0000000000000009 ffff88042fd61bf8 ffffffff8167edc5 ffff88042fd61c38
[  819.711077]  ffffffff8105d380 0000000000000339 0000000000000002 ffff880438604000
[  819.711081]  0000000100080574 0000000000000002 ffff88044ec90b08 ffff88042fd61c48
[  819.711082] Call Trace:
[  819.711086]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.711091]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.711095]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.711099]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.711103]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.711107]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.711111]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.711115]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.711119]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.711123]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.711126]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.711131]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.711135]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.711139]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.711142]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.711146]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.711150]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.711153]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.711156] ---[ end trace a5556efe295a5e64 ]---
[  819.712428] smpboot: CPU 3 is now offline
[  819.712967] CPU 3 offline: Remove Rx thread
[  819.716711] smpboot: CPU 4 is now offline
[  819.717210] CPU 4 offline: Remove Rx thread
[  819.717924] Broke affinity for irq 18
[  819.717940] Broke affinity for irq 22
[  819.717946] Broke affinity for irq 23
[  819.719055] ------------[ cut here ]------------
[  819.719060] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.719098] ------------[ cut here ]------------
[  819.719113] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.719117] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
[  819.719119] Modules linked in:
[  819.719121]  snd_hwdep
[  819.719123]  bnep
[  819.719124]  snd_seq
[  819.719126]  bluetooth
[  819.719128]  snd_seq_device
[  819.719129]  fuse
[  819.719131]  snd_pcm
[  819.719133]  ebtable_nat
[  819.719135]  e1000e
[  819.719136]  xt_CHECKSUM
[  819.719139] smpboot: CPU 5 is now offline
[  819.719141]  snd_page_alloc
[  819.719142]  ipt_MASQUERADE
[  819.719144]  crc32c_intel
[  819.719146]  nf_conntrack_netbios_ns
[  819.719147]  snd_timer
[  819.719149]  nf_conntrack_broadcast
[  819.719151]  edac_core
[  819.719152]  ip6table_mangle
[  819.719154]  eeepc_wmi
[  819.719156]  ip6t_REJECT
[  819.719157]  ghash_clmulni_intel
[  819.719159]  nf_conntrack_ipv6
[  819.719160]  asus_wmi
[  819.719162]  nf_defrag_ipv6
[  819.719164]  snd
[  819.719165]  be2iscsi
[  819.719167]  sparse_keymap
[  819.719168]  iptable_nat
[  819.719170]  rfkill
[  819.719171]  iscsi_boot_sysfs
[  819.719173]  k10temp
[  819.719175]  nf_nat_ipv4
[  819.719176]  fam15h_power
[  819.719178]  bnx2i
[  819.719179]  microcode
[  819.719181]  nf_nat
[  819.719182]  serio_raw
[  819.719184]  cnic
[  819.719186]  edac_mce_amd
[  819.719187]  iptable_mangle
[  819.719189]  joydev
[  819.719190]  uio
[  819.719192]  pcspkr
[  819.719194]  bridge
[  819.719195]  sp5100_tco
[  819.719197]  cxgb4i
[  819.719198]  vhost_net
[  819.719200]  cxgb4
[  819.719202]  soundcore
[  819.719203]  nf_conntrack_ipv4
[  819.719205]  i2c_piix4
[  819.719207]  stp
[  819.719209]  r8169
[  819.719211]  llc
[  819.719213]  ptp
[  819.719215]  nf_defrag_ipv4
[  819.719217]  tun
[  819.719219]  cxgb3i
[  819.719221]  pps_core
[  819.719222]  xt_conntrack
[  819.719224]  mii
[  819.719226]  cxgb3
[  819.719228]  macvtap
[  819.719230]  nf_conntrack
[  819.719231]  macvlan
[  819.719233]  mdio
[  819.719235]  kvm_amd
[  819.719237]  libcxgbi
[  819.719239]  kvm
[  819.719241]  ib_iser
[  819.719243]  uinput
[  819.719245]  rdma_cm
[  819.719246]  nouveau
[  819.719248]  ebtable_filter
[  819.719250]  video
[  819.719252]  ib_addr
[  819.719253]  mxm_wmi
[  819.719255]  iw_cm
[  819.719256]  i2c_algo_bit
[  819.719259]  ebtables
[  819.719260]  drm_kms_helper
[  819.719262]  ib_cm
[  819.719264]  ttm
[  819.719266]  ib_sa
[  819.719267]  usb_storage
[  819.719270]  ip6table_filter
[  819.719271]  drm
[  819.719273]  ib_mad
[  819.719274]  hid_logitech_dj
[  819.719276]  ip6_tables
[  819.719278]  i2c_core
[  819.719279]  ib_core
[  819.719281]  wmi

[  819.719287] CPU: 0 PID: 2321 Comm: kworker/4:0 Tainted: G        W    3.10.0-rc3+ #4
[  819.719289] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.719293]  iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
[  819.719295] Workqueue: events od_dbs_timer

[  819.719300]  snd_hda_codec_hdmi snd_hda_codec_realtek
[  819.719302]  0000000000000009
[  819.719304]  snd_hda_intel
[  819.719306]  ffff8803fb159bf8
[  819.719308]  snd_hda_codec
[  819.719310]  ffffffff8167edc5
[  819.719313]  snd_hwdep
[  819.719314]  ffff8803fb159c38

[  819.719318]  snd_seq snd_seq_device
[  819.719320]  ffffffff8105d380
[  819.719321]  snd_pcm
[  819.719323]  0000000000000339
[  819.719325]  e1000e
[  819.719326]  0000000000000004
[  819.719329]  snd_page_alloc
[  819.719330]  ffff880438678000

[  819.719334]  crc32c_intel snd_timer
[  819.719336]  000000010008057e
[  819.719338]  edac_core
[  819.719339]  0000000000000004
[  819.719342]  eeepc_wmi
[  819.719344]  ffff88044ed10b08
[  819.719345]  ghash_clmulni_intel
[  819.719347]  ffff8803fb159c48

[  819.719351] Call Trace:
[  819.719353]  asus_wmi snd sparse_keymap
[  819.719359]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.719361]  rfkill k10temp
[  819.719368]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.719370]  fam15h_power microcode
[  819.719376]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.719378]  serio_raw edac_mce_amd
[  819.719384]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.719386]  joydev pcspkr
[  819.719390]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.719393]  sp5100_tco vhost_net
[  819.719397]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.719400]  soundcore i2c_piix4
[  819.719405]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.719407]  r8169 ptp
[  819.719412]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.719415]  tun pps_core
[  819.719419]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.719422]  mii macvtap
[  819.719426]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.719429]  macvlan kvm_amd
[  819.719433]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.719435]  kvm uinput
[  819.719440]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.719443]  nouveau video mxm_wmi
[  819.719448]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.719450]  i2c_algo_bit drm_kms_helper
[  819.719455]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.719457]  ttm usb_storage
[  819.719461]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.719464]  drm hid_logitech_dj i2c_core
[  819.719469]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719470]  wmi
[  819.719474]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.719479] CPU: 6 PID: 136 Comm: kworker/3:1 Tainted: G        W    3.10.0-rc3+ #4
[  819.719483] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.719486]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719493] ---[ end trace a5556efe295a5e65 ]---
[  819.719494] Workqueue: events od_dbs_timer
[  819.719502]  0000000000000009 ffff88042f823bf8 ffffffff8167edc5 ffff88042f823c38
[  819.719507]  ffffffff8105d380 0000000000000339 0000000000000003 ffff880438650000
[  819.719511]  000000010008057e 0000000000000003 ffff88044ecd0b08 ffff88042f823c48
[  819.719513] Call Trace:
[  819.719521]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.719528]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.719534]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.719539]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.719544]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.719549]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.719554]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.719559]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.719563]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.719569]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.719573]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.719578]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.719583]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.719588]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.719593]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.719598]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719603]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.719607]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719611] ---[ end trace a5556efe295a5e66 ]---
[  819.719680] CPU 5 offline: Remove Rx thread
[  819.719940] ------------[ cut here ]------------
[  819.719945] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.719988] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
[  819.720005]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
[  819.720008] CPU: 0 PID: 126 Comm: kworker/5:1 Tainted: G        W    3.10.0-rc3+ #4
[  819.720009] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.720012] Workqueue: events od_dbs_timer
[  819.720017]  0000000000000009 ffff88042ff11bf8 ffffffff8167edc5 ffff88042ff11c38
[  819.720021]  ffffffff8105d380 0000000000000339 0000000000000005 ffff88043869c000
[  819.720025]  000000010008057e 0000000000000005 ffff88044ed50b08 ffff88042ff11c48
[  819.720026] Call Trace:
[  819.720030]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.720034]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.720039]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.720043]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.720047]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.720050]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.720055]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.720058]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.720062]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.720066]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.720070]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.720074]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.720078]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.720082]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.720085]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.720090]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.720093]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.720097]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.720099] ---[ end trace a5556efe295a5e67 ]---
[  819.723294] smpboot: CPU 6 is now offline
[  819.723792] CPU 6 offline: Remove Rx thread
[  819.724289] Broke affinity for irq 19
[  819.725405] smpboot: CPU 7 is now offline
[  819.725840] CPU 7 offline: Remove Rx thread
[  819.729465] ACPI: Low-level resume complete
[  819.729494] PM: Restoring platform NVS memory
[  819.820651] microcode: CPU0: new patch_level=0x06000629
[  819.820717] ------------[ cut here ]------------
[  819.820723] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.820750] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
[  819.820761]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
[  819.820763] CPU: 0 PID: 257 Comm: kworker/6:2 Tainted: G        W    3.10.0-rc3+ #4
[  819.820764] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.820766] Workqueue: events od_dbs_timer
[  819.820769]  0000000000000009 ffff88042f33bbf8 ffffffff8167edc5 ffff88042f33bc38
[  819.820771]  ffffffff8105d380 0000000000000339 0000000000000006 ffff8804386dc000
[  819.820773]  0000000100080594 0000000000000006 ffff88044ed90b08 ffff88042f33bc48
[  819.820773] Call Trace:
[  819.820777]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.820779]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.820781]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.820783]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.820785]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.820787]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.820789]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.820791]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.820792]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.820794]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.820796]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.820797]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.820799]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.820801]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.820802]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.820804]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820806]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.820807]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820808] ---[ end trace a5556efe295a5e68 ]---
[  819.820811] ------------[ cut here ]------------
[  819.820813] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[  819.820830] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
[  819.820837]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
[  819.820838] CPU: 0 PID: 60 Comm: kworker/7:0 Tainted: G        W    3.10.0-rc3+ #4
[  819.820838] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
[  819.820839] Workqueue: events od_dbs_timer
[  819.820841]  0000000000000009 ffff88043870dbf8 ffffffff8167edc5 ffff88043870dc38
[  819.820843]  ffffffff8105d380 0000000000000339 0000000000000007 ffff880438720000
[  819.820844]  0000000100080594 0000000000000007 ffff88044edd0b08 ffff88043870dc48
[  819.820845] Call Trace:
[  819.820846]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.820848]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.820850]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.820852]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.820853]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.820854]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.820856]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.820858]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.820859]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.820861]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.820862]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.820864]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.820865]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.820867]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.820868]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.820870]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820871]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.820872]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820873] ---[ end trace a5556efe295a5e69 ]---

I did not dive in details so I hadn't even bisected it. I can certainly
do so on Monday - but figured I would first ask whether somebody
else had reported this.

Attached is the full dmesg.



--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename=d
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc3+ (konrad@phenom.dumpdata.com) (gc=
c version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #4 SMP Thu May 30 13:5=
7:14 EDT 2013
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.10.0-rc3+ root=3DUUI=
D=3Dfb5e4ab0-e637-439c-ac2a-013ec21a59c9 ro rd.md=3D0 rd.lvm=3D0 rd.dm=3D=
0 rd.luks=3D0 rhgb quiet radeon.modeset=3D0 LANG=3Den_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ad946fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000ad947000-0x00000000ad998fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000ad999000-0x00000000ad9a1fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000ad9a2000-0x00000000adad9fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000adada000-0x00000000adaeafff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000adaeb000-0x00000000adafffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000adb00000-0x00000000adb01fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000adb02000-0x00000000adb0afff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000adb0b000-0x00000000adb10fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000adb11000-0x00000000adb72fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000adb73000-0x00000000add75fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000add76000-0x00000000adefffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000044effffff] usa=
ble
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./M5A97, =
BIOS 1208 04/18/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x44f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000ADF00000 mask FFFFFFF00000 uncachable
[    0.000000]   3 base 0000AE000000 mask FFFFFE000000 uncachable
[    0.000000]   4 base 0000B0000000 mask FFFFF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000044f000000 aka 17648M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2783MB, range: 1MB, type UC
[    0.000000] reg 3, base: 2784MB, range: 32MB, type UC
[    0.000000] reg 4, base: 2816MB, range: 256MB, type UC
[    0.000000] total RAM covered: 2783M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 5  	lose cover =
RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 512MB, type WB
[    0.000000] reg 2, base: 2560MB, range: 256MB, type WB
[    0.000000] reg 3, base: 2783MB, range: 1MB, type UC
[    0.000000] reg 4, base: 2784MB, range: 32MB, type UC
[    0.000000] e820: update [mem 0xadf00000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xadf00 max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24=
576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fed000, 0x01fedfff] PGTABLE
[    0.000000] BRK [0x01fee000, 0x01feefff] PGTABLE
[    0.000000] BRK [0x01fef000, 0x01feffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x44ee00000-0x44effffff]
[    0.000000]  [mem 0x44ee00000-0x44effffff] page 2M
[    0.000000] BRK [0x01ff0000, 0x01ff0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x44c000000-0x44edfffff]
[    0.000000]  [mem 0x44c000000-0x44edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x44bffffff]
[    0.000000]  [mem 0x400000000-0x43fffffff] page 1G
[    0.000000]  [mem 0x440000000-0x44bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xad946fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xad7fffff] page 2M
[    0.000000]  [mem 0xad800000-0xad946fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xadd76000-0xadefffff]
[    0.000000]  [mem 0xadd76000-0xadefffff] page 4k
[    0.000000] BRK [0x01ff1000, 0x01ff1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100001000-0x3ffffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13fffffff] page 2M
[    0.000000]  [mem 0x140000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x33a9c000-0x35d45fff]
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000ad999068 00054 (v01 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000ad9a0040 000F4 (v04 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBloc=
k has zero address or length: 0x0000000000000000/0x1 (20130328/tbfadt-603=
)
[    0.000000] ACPI: DSDT 00000000ad999150 06EF0 (v02 ALASKA    A M I 000=
00000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000adb0bf80 00040
[    0.000000] ACPI: APIC 00000000ad9a0138 0009E (v03 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000ad9a01d8 0003C (v01 ALASKA    A M I 010=
72009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000ad9a0218 00038 (v01 ALASKA    A M I 010=
72009 AMI  00000004)
[    0.000000] ACPI: IVRS 00000000ad9a0250 000D8 (v01  AMD     RD890S 002=
02031 AMD  00000000)
[    0.000000] ACPI: SSDT 00000000ad9a0328 01714 (v01 AMD    POWERNOW 000=
00001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000044efffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x44effffff]
[    0.000000]   NODE_DATA [mem 0x44efe7000-0x44effafff]
[    0.000000]  [ffffea0000000000-ffffea00113fffff] PMD -> [ffff88043e600=
000-ffff88044e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x44effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xad946fff]
[    0.000000]   node   0: [mem 0xadd76000-0xadefffff]
[    0.000000]   node   0: [mem 0x100001000-0x44effffff]
[    0.000000] On node 0 totalpages: 4180588
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11052 pages used for memmap
[    0.000000]   DMA32 zone: 707281 pages, LIFO batch:31
[    0.000000]   Normal zone: 54208 pages used for memmap
[    0.000000]   Normal zone: 3469311 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 9, version 33, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 10, version 33, address 0xfec20000, GSI=
 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000=
009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 000000000=
0100000
[    0.000000] PM: Registered nosave memory: 00000000ad947000 - 00000000a=
d999000
[    0.000000] PM: Registered nosave memory: 00000000ad999000 - 00000000a=
d9a2000
[    0.000000] PM: Registered nosave memory: 00000000ad9a2000 - 00000000a=
dada000
[    0.000000] PM: Registered nosave memory: 00000000adada000 - 00000000a=
daeb000
[    0.000000] PM: Registered nosave memory: 00000000adaeb000 - 00000000a=
db00000
[    0.000000] PM: Registered nosave memory: 00000000adb00000 - 00000000a=
db02000
[    0.000000] PM: Registered nosave memory: 00000000adb02000 - 00000000a=
db0b000
[    0.000000] PM: Registered nosave memory: 00000000adb0b000 - 00000000a=
db11000
[    0.000000] PM: Registered nosave memory: 00000000adb11000 - 00000000a=
db73000
[    0.000000] PM: Registered nosave memory: 00000000adb73000 - 00000000a=
dd76000
[    0.000000] PM: Registered nosave memory: 00000000adf00000 - 00000000f=
ec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000f=
ec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000f=
ec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000f=
ec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000f=
ec20000
[    0.000000] PM: Registered nosave memory: 00000000fec20000 - 00000000f=
ec21000
[    0.000000] PM: Registered nosave memory: 00000000fec21000 - 00000000f=
ed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000f=
ed01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 - 00000000f=
ed61000
[    0.000000] PM: Registered nosave memory: 00000000fed61000 - 00000000f=
ed71000
[    0.000000] PM: Registered nosave memory: 00000000fed71000 - 00000000f=
ed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000f=
ed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000f=
ef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 000000010=
0000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 000000010=
0001000
[    0.000000] e820: [mem 0xadf00000-0xfebfffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8=
 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88044ec00000 s85888 r81=
92 d20608 u262144
[    0.000000] pcpu-alloc: s85888 r8192 d20608 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 4115243
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.10.0-rc3+ roo=
t=3DUUID=3Dfb5e4ab0-e637-439c-ac2a-013ec21a59c9 ro rd.md=3D0 rd.lvm=3D0 r=
d.dm=3D0 rd.luks=3D0 rhgb quiet radeon.modeset=3D0 LANG=3Den_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 720e000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ a4000000
[    0.000000] PM: Registered nosave memory: 00000000a4000000 - 00000000a=
8000000
[    0.000000] Memory: 16275556k/18071552k available (6728k kernel code, =
1349200k absent, 446796k reserved, 6559k data, 1424k init)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_ids=3D8=
.
[    0.000000] 	Experimental no-CBs for all CPUs
[    0.000000] 	Experimental no-CBs CPUs: 0-127.
[    0.000000] NO_HZ: Full dynticks CPUs: 1-127.
[    0.000000] NR_IRQS:8448 nr_irqs:1288 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 3901.053 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 7802.10 BogoMIPS (lpj=3D3901053)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000033] Security Framework initialized
[    0.000040] SELinux:  Initializing.
[    0.000047] SELinux:  Starting in permissive mode
[    0.001207] Dentry cache hash table entries: 2097152 (order: 12, 16777=
216 bytes)
[    0.005086] Inode-cache hash table entries: 1048576 (order: 11, 838860=
8 bytes)
[    0.006717] Mount-cache hash table entries: 256
[    0.006884] Initializing cgroup subsys memory
[    0.006894] Initializing cgroup subsys devices
[    0.006895] Initializing cgroup subsys freezer
[    0.006897] Initializing cgroup subsys net_cls
[    0.006898] Initializing cgroup subsys blkio
[    0.006899] Initializing cgroup subsys perf_event
[    0.006922] tseg: 00adf00000
[    0.006924] CPU: Physical Processor ID: 0
[    0.006924] CPU: Processor Core ID: 0
[    0.006926] mce: CPU supports 7 MCE banks
[    0.006932] LVT offset 1 assigned for vector 0xf9
[    0.006936] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
tlb_flushall_shift: 5
[    0.006999] Freeing SMP alternatives: 24k freed
[    0.007714] ACPI: Core revision 20130328
[    0.009764] ACPI: All ACPI Tables successfully acquired
[    0.156536] ftrace: allocating 25430 entries in 100 pages
[    0.165222] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
[    0.165227] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
[    0.165231] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found
[    0.165234] AMD-Vi: Disabling interrupt remapping
[    0.165648] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.175631] smpboot: CPU0: AMD FX(tm)-8150 Eight-Core Processor (fam: =
15, model: 01, stepping: 02)
[    0.277154] Performance Events:=20
[    0.277155] perf: AMD core performance counters detected
[    0.277158] AMD PMU driver.
[    0.277159] ... version:                0
[    0.277160] ... bit width:              48
[    0.277161] ... generic registers:      6
[    0.277162] ... value mask:             0000ffffffffffff
[    0.277163] ... max period:             00007fffffffffff
[    0.277164] ... fixed-purpose events:   0
[    0.277165] ... event mask:             000000000000003f
[    0.278436] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.278505] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #=
7 OK
[    0.371103] Brought up 8 CPUs
[    0.371107] smpboot: Total of 8 processors activated (62416.84 BogoMIP=
S)
[    0.383643] devtmpfs: initialized
[    0.383853] PM: Registering ACPI NVS region [mem 0xad947000-0xad998fff=
] (335872 bytes)
[    0.383861] PM: Registering ACPI NVS region [mem 0xadada000-0xadaeafff=
] (69632 bytes)
[    0.383863] PM: Registering ACPI NVS region [mem 0xadb00000-0xadb01fff=
] (8192 bytes)
[    0.383864] PM: Registering ACPI NVS region [mem 0xadb0b000-0xadb10fff=
] (24576 bytes)
[    0.383866] PM: Registering ACPI NVS region [mem 0xadb73000-0xadd75fff=
] (2109440 bytes)
[    0.384659] atomic64 test passed for x86-64 platform with CX8 and with=
 SSE
[    0.384678] RTC time: 18:45:27, date: 05/30/13
[    0.384717] NET: Registered protocol family 16
[    0.384892] ACPI: bus type PCI registered
[    0.384894] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.384944] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.384947] PCI: not using MMCONFIG
[    0.384948] PCI: Using configuration type 1 for base access
[    0.384949] PCI: Using configuration type 1 for extended access
[    0.385937] bio: create slab <bio-0> at 0
[    0.386085] ACPI: Added _OSI(Module Device)
[    0.386087] ACPI: Added _OSI(Processor Device)
[    0.386088] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.386089] ACPI: Added _OSI(Processor Aggregator Device)
[    0.386986] ACPI: EC: Look up EC in DSDT
[    0.387928] ACPI: Executed 2 blocks of module-level executable AML cod=
e
[    0.393551] ACPI: Interpreter enabled
[    0.393560] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20130328/hwxface-568)
[    0.393574] ACPI: (supports S0 S1 S3 S4 S5)
[    0.393576] ACPI: Using IOAPIC for interrupt routing
[    0.393709] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.393747] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in A=
CPI motherboard resources
[    0.408214] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.415731] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.416108] PCI host bridge to bus 0000:00
[    0.416111] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.416113] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.416115] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.416117] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.416118] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.416120] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.416121] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000df=
fff]
[    0.416123] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfffff=
fff]
[    0.416134] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.416232] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    0.416327] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.416358] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.416401] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.416432] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.416463] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.416507] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.416534] pci 0000:00:07.0: [1002:5a1b] type 01 class 0x060400
[    0.416564] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.416611] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.416637] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    0.416667] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.416717] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.416752] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.416767] pci 0000:00:11.0: reg 10: [io  0xf040-0xf047]
[    0.416774] pci 0000:00:11.0: reg 14: [io  0xf030-0xf033]
[    0.416781] pci 0000:00:11.0: reg 18: [io  0xf020-0xf027]
[    0.416789] pci 0000:00:11.0: reg 1c: [io  0xf010-0xf013]
[    0.416797] pci 0000:00:11.0: reg 20: [io  0xf000-0xf00f]
[    0.416805] pci 0000:00:11.0: reg 24: [mem 0xfd40b000-0xfd40b3ff]
[    0.416892] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.416903] pci 0000:00:12.0: reg 10: [mem 0xfd40a000-0xfd40afff]
[    0.416960] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.416990] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.417005] pci 0000:00:12.2: reg 10: [mem 0xfd409000-0xfd4090ff]
[    0.417067] pci 0000:00:12.2: supports D1 D2
[    0.417069] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.417092] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.417122] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.417132] pci 0000:00:13.0: reg 10: [mem 0xfd408000-0xfd408fff]
[    0.417192] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.417223] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.417238] pci 0000:00:13.2: reg 10: [mem 0xfd407000-0xfd4070ff]
[    0.417299] pci 0000:00:13.2: supports D1 D2
[    0.417301] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.417327] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.417358] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.417440] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.417456] pci 0000:00:14.2: reg 10: [mem 0xfd400000-0xfd403fff 64bit=
]
[    0.417506] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.417523] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.417547] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.417629] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.417668] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.417693] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.417704] pci 0000:00:14.5: reg 10: [mem 0xfd406000-0xfd406fff]
[    0.417769] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.417803] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.417858] pci 0000:00:15.0: supports D1 D2
[    0.417897] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.417924] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.417935] pci 0000:00:16.0: reg 10: [mem 0xfd405000-0xfd405fff]
[    0.417998] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.418030] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.418044] pci 0000:00:16.2: reg 10: [mem 0xfd404000-0xfd4040ff]
[    0.418106] pci 0000:00:16.2: supports D1 D2
[    0.418107] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.418136] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.418165] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    0.418239] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    0.418311] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    0.418381] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    0.418455] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    0.418523] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    0.418640] pci 0000:01:00.0: [10de:0402] type 00 class 0x030000
[    0.418649] pci 0000:01:00.0: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.418658] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit=
 pref]
[    0.418668] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit=
]
[    0.418674] pci 0000:01:00.0: reg 24: [io  0xe000-0xe07f]
[    0.418680] pci 0000:01:00.0: reg 30: [mem 0xfd000000-0xfd01ffff pref]
[    0.419877] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.419881] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.419883] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fff=
ff]
[    0.419887] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffff=
ff 64bit pref]
[    0.419932] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.419944] pci 0000:02:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.419963] pci 0000:02:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit=
 pref]
[    0.419975] pci 0000:02:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit=
 pref]
[    0.420027] pci 0000:02:00.0: supports D1 D2
[    0.420029] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.421874] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.421877] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.421881] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fff=
ff 64bit pref]
[    0.421930] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.421947] pci 0000:03:00.0: reg 10: [mem 0xfd300000-0xfd307fff 64bit=
]
[    0.422030] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.423869] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.423874] pci 0000:00:07.0:   bridge window [mem 0xfd300000-0xfd3fff=
ff]
[    0.423931] pci 0000:04:00.0: [8086:10d3] type 00 class 0x020000
[    0.423950] pci 0000:04:00.0: reg 10: [mem 0xfd2c0000-0xfd2dffff]
[    0.423964] pci 0000:04:00.0: reg 14: [mem 0xfd200000-0xfd27ffff]
[    0.423977] pci 0000:04:00.0: reg 18: [io  0xc000-0xc01f]
[    0.423990] pci 0000:04:00.0: reg 1c: [mem 0xfd2e0000-0xfd2e3fff]
[    0.424028] pci 0000:04:00.0: reg 30: [mem 0xfd280000-0xfd2bffff pref]
[    0.424100] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.425868] pci 0000:00:09.0: PCI bridge to [bus 04]
[    0.425871] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.425874] pci 0000:00:09.0:   bridge window [mem 0xfd200000-0xfd2fff=
ff]
[    0.425938] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive deco=
de)
[    0.425945] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (sub=
tractive decode)
[    0.425947] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (sub=
tractive decode)
[    0.425948] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (sub=
tractive decode)
[    0.425950] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.425951] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.425953] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dff=
ff] (subtractive decode)
[    0.425955] pci 0000:00:14.4:   bridge window [mem 0xb0000000-0xffffff=
ff] (subtractive decode)
[    0.426015] pci 0000:06:00.0: [1002:9440] type 00 class 0x030000
[    0.426035] pci 0000:06:00.0: reg 10: [mem 0xb0000000-0xbfffffff 64bit=
 pref]
[    0.426050] pci 0000:06:00.0: reg 18: [mem 0xfd120000-0xfd12ffff 64bit=
]
[    0.426060] pci 0000:06:00.0: reg 20: [io  0xb000-0xb0ff]
[    0.426079] pci 0000:06:00.0: reg 30: [mem 0xfd100000-0xfd11ffff pref]
[    0.426127] pci 0000:06:00.0: supports D1 D2
[    0.426173] pci 0000:06:00.1: [1002:aa30] type 00 class 0x040300
[    0.426192] pci 0000:06:00.1: reg 10: [mem 0xfd130000-0xfd133fff 64bit=
]
[    0.426283] pci 0000:06:00.1: supports D1 D2
[    0.427864] pci 0000:00:15.0: PCI bridge to [bus 06]
[    0.427869] pci 0000:00:15.0:   bridge window [io  0xb000-0xbfff]
[    0.427872] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fff=
ff]
[    0.427877] pci 0000:00:15.0:   bridge window [mem 0xb0000000-0xbfffff=
ff 64bit pref]
[    0.427893] acpi PNP0A03:00: ACPI _OSC support notification failed, di=
sabling PCIe ASPM
[    0.427895] acpi PNP0A03:00: Unable to request _OSC control (_OSC supp=
ort mask: 0x08)
[    0.428209] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.428277] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.428346] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.428414] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 10 11 14 15) *0
[    0.428469] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.428514] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.428558] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.428602] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.428728] acpi root: \_SB_.PCI0 notify handler is installed
[    0.428764] Found 1 acpi root devices
[    0.428781] ACPI: EC: GPE =3D 0xa, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.428879] ACPI: No dock devices found.
[    0.428980] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.428984] vgaarb: device added: PCI:0000:06:00.0,decodes=3Dio+mem,ow=
ns=3Dnone,locks=3Dnone
[    0.428985] vgaarb: loaded
[    0.428986] vgaarb: bridge control possible 0000:06:00.0
[    0.428987] vgaarb: bridge control possible 0000:01:00.0
[    0.429045] SCSI subsystem initialized
[    0.429047] ACPI: bus type ATA registered
[    0.429092] libata version 3.00 loaded.
[    0.429109] ACPI: bus type USB registered
[    0.429123] usbcore: registered new interface driver usbfs
[    0.429130] usbcore: registered new interface driver hub
[    0.429154] usbcore: registered new device driver usb
[    0.429227] PCI: Using ACPI for IRQ routing
[    0.435476] PCI: pci_cache_line_size set to 64 bytes
[    0.435534] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.435535] e820: reserve RAM buffer [mem 0xad947000-0xafffffff]
[    0.435537] e820: reserve RAM buffer [mem 0xadf00000-0xafffffff]
[    0.435538] e820: reserve RAM buffer [mem 0x44f000000-0x44fffffff]
[    0.435609] NetLabel: Initializing
[    0.435611] NetLabel:  domain hash size =3D 128
[    0.435611] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.435620] NetLabel:  unlabeled traffic allowed by default
[    0.435663] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.435666] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.437689] Switching to clocksource hpet
[    0.443197] pnp: PnP ACPI init
[    0.443206] ACPI: bus type PNP registered
[    0.443281] system 00:00: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.443284] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.443767] system 00:01: [io  0x040b] has been reserved
[    0.443769] system 00:01: [io  0x04d6] has been reserved
[    0.443771] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.443773] system 00:01: [io  0x0c14] has been reserved
[    0.443774] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.443776] system 00:01: [io  0x0c52] has been reserved
[    0.443778] system 00:01: [io  0x0c6c] has been reserved
[    0.443779] system 00:01: [io  0x0c6f] has been reserved
[    0.443781] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.443782] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.443784] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.443786] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.443787] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.443789] system 00:01: [io  0x0800-0x089f] has been reserved
[    0.443791] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.443792] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.443794] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.443797] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.443800] system 00:01: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.443802] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.443804] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserve=
d
[    0.443806] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserve=
d
[    0.443808] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserve=
d
[    0.443810] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserve=
d
[    0.443812] system 00:01: [mem 0xffc00000-0xffffffff] has been reserve=
d
[    0.443814] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.443947] system 00:02: [io  0x0290-0x02af] has been reserved
[    0.443950] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.443961] pnp 00:03: [dma 4]
[    0.443977] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.444004] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.444025] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.444074] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.444077] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.444098] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.444130] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.444301] pnp 00:09: [dma 0 disabled]
[    0.444341] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.444458] system 00:0a: [mem 0xfeb20000-0xfeb23fff] could not be res=
erved
[    0.444460] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.444562] system 00:0b: [mem 0xfec20000-0xfec200ff] could not be res=
erved
[    0.444564] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.444702] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.444712] pnp: PnP ACPI: found 13 devices
[    0.444713] ACPI: bus type PNP unregistered
[    0.451101] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.451104] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.451106] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fff=
ff]
[    0.451109] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffff=
ff 64bit pref]
[    0.451112] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.451113] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.451117] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fff=
ff 64bit pref]
[    0.451119] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.451122] pci 0000:00:07.0:   bridge window [mem 0xfd300000-0xfd3fff=
ff]
[    0.451125] pci 0000:00:09.0: PCI bridge to [bus 04]
[    0.451127] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.451129] pci 0000:00:09.0:   bridge window [mem 0xfd200000-0xfd2fff=
ff]
[    0.451133] pci 0000:00:14.4: PCI bridge to [bus 05]
[    0.451142] pci 0000:00:15.0: PCI bridge to [bus 06]
[    0.451144] pci 0000:00:15.0:   bridge window [io  0xb000-0xbfff]
[    0.451147] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fff=
ff]
[    0.451150] pci 0000:00:15.0:   bridge window [mem 0xb0000000-0xbfffff=
ff 64bit pref]
[    0.451423] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.451425] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.451427] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.451428] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.451430] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.451431] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.451433] pci_bus 0000:00: resource 10 [mem 0xb0000000-0xffffffff]
[    0.451434] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.451436] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfd0fffff]
[    0.451437] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64b=
it pref]
[    0.451439] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.451441] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd00fffff 64b=
it pref]
[    0.451442] pci_bus 0000:03: resource 1 [mem 0xfd300000-0xfd3fffff]
[    0.451444] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.451445] pci_bus 0000:04: resource 1 [mem 0xfd200000-0xfd2fffff]
[    0.451447] pci_bus 0000:05: resource 4 [io  0x0000-0x03af]
[    0.451448] pci_bus 0000:05: resource 5 [io  0x03e0-0x0cf7]
[    0.451450] pci_bus 0000:05: resource 6 [io  0x03b0-0x03df]
[    0.451451] pci_bus 0000:05: resource 7 [io  0x0d00-0xffff]
[    0.451453] pci_bus 0000:05: resource 8 [mem 0x000a0000-0x000bffff]
[    0.451454] pci_bus 0000:05: resource 9 [mem 0x000c0000-0x000dffff]
[    0.451456] pci_bus 0000:05: resource 10 [mem 0xb0000000-0xffffffff]
[    0.451457] pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
[    0.451459] pci_bus 0000:06: resource 1 [mem 0xfd100000-0xfd1fffff]
[    0.451460] pci_bus 0000:06: resource 2 [mem 0xb0000000-0xbfffffff 64b=
it pref]
[    0.451484] NET: Registered protocol family 2
[    0.451787] TCP established hash table entries: 131072 (order: 9, 2097=
152 bytes)
[    0.452240] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.452439] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.452469] TCP: reno registered
[    0.452492] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.452566] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.452677] NET: Registered protocol family 1
[    1.486980] pci 0000:01:00.0: Boot video device
[    1.487051] PCI: CLS 64 bytes, default 64
[    1.487097] Unpacking initramfs...
[    1.982950] Freeing initrd memory: 35496k freed
[    2.069053] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    2.069069] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    2.078855] AMD-Vi: Lazy IO/TLB flushing enabled
[    2.156841] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.156844] software IO TLB [mem 0xa9947000-0xad947000] (64MB) mapped =
at [ffff8800a9947000-ffff8800ad946fff]
[    2.157117] perf: AMD NB counters detected
[    2.157146] LVT offset 0 assigned for vector 0x400
[    2.157171] perf: AMD IBS detected (0x000000ff)
[    2.160252] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.160599] Initialise module verification
[    2.160628] audit: initializing netlink socket (disabled)
[    2.160636] type=3D2000 audit(1369939527.896:1): initialized
[    2.178542] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.180345] VFS: Disk quotas dquot_6.5.2
[    2.180382] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.180728] msgmni has been set to 31857
[    2.180779] SELinux:  Registering netfilter hooks
[    2.181698] alg: No test for stdrng (krng)
[    2.181707] NET: Registered protocol family 38
[    2.181709] Key type asymmetric registered
[    2.181711] Asymmetric key parser 'x509' registered
[    2.181736] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    2.181789] io scheduler noop registered
[    2.181790] io scheduler deadline registered
[    2.181813] io scheduler cfq registered (default)
[    2.181996] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.182008] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    2.182041] vesafb: mode is 1920x1200x32, linelength=3D7680, pages=3D0
[    2.182042] vesafb: scrolling: redraw
[    2.182044] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    2.182578] vesafb: framebuffer at 0xfb000000, mapped to 0xffffc90011c=
00000, using 9024k, total 9024k
[    2.208472] Console: switching to colour frame buffer device 240x75
[    2.233127] fb0: VESA VGA frame buffer device
[    2.233185] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    2.233188] ACPI: Power Button [PWRB]
[    2.233215] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    2.233217] ACPI: Power Button [PWRF]
[    2.233260] ACPI: acpi_idle registered with cpuidle
[    2.254932] GHES: HEST is not enabled!
[    2.255000] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.275490] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.275902] Non-volatile memory driver v1.3
[    2.275903] Linux agpgart interface v0.103
[    2.276701] loop: module loaded
[    2.276703] dummy-irq: no IRQ given.  Use irq=3DN
[    2.276833] ahci 0000:00:11.0: version 3.0
[    2.276987] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps =
0x3f impl SATA mode
[    2.276989] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo p=
mp pio slum part=20
[    2.277555] scsi0 : ahci
[    2.277619] scsi1 : ahci
[    2.277673] scsi2 : ahci
[    2.277725] scsi3 : ahci
[    2.277779] scsi4 : ahci
[    2.277831] scsi5 : ahci
[    2.277859] ata1: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
100 irq 19
[    2.277861] ata2: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
180 irq 19
[    2.277863] ata3: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
200 irq 19
[    2.277865] ata4: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
280 irq 19
[    2.277867] ata5: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
300 irq 19
[    2.277869] ata6: SATA max UDMA/133 abar m1024@0xfd40b000 port 0xfd40b=
380 irq 19
[    2.277944] libphy: Fixed MDIO Bus: probed
[    2.277987] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.277988] ehci-pci: EHCI PCI platform driver
[    2.278070] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.278106] ehci-pci 0000:00:12.2: new USB bus registered, assigned bu=
s number 1
[    2.278114] QUIRK: Enable AMD PLL fix
[    2.278116] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    2.278129] ehci-pci 0000:00:12.2: debug port 1
[    2.278158] ehci-pci 0000:00:12.2: irq 17, io mem 0xfd409000
[    2.283309] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.283328] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.283330] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.283332] usb usb1: Product: EHCI Host Controller
[    2.283333] usb usb1: Manufacturer: Linux 3.10.0-rc3+ ehci_hcd
[    2.283334] usb usb1: SerialNumber: 0000:00:12.2
[    2.283433] hub 1-0:1.0: USB hub found
[    2.283437] hub 1-0:1.0: 5 ports detected
[    2.283597] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.283628] ehci-pci 0000:00:13.2: new USB bus registered, assigned bu=
s number 2
[    2.283631] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    2.283640] ehci-pci 0000:00:13.2: debug port 1
[    2.283666] ehci-pci 0000:00:13.2: irq 21, io mem 0xfd407000
[    2.289298] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.289310] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.289312] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.289313] usb usb2: Product: EHCI Host Controller
[    2.289315] usb usb2: Manufacturer: Linux 3.10.0-rc3+ ehci_hcd
[    2.289316] usb usb2: SerialNumber: 0000:00:13.2
[    2.289402] hub 2-0:1.0: USB hub found
[    2.289405] hub 2-0:1.0: 5 ports detected
[    2.289555] ehci-pci 0000:00:16.2: EHCI Host Controller
[    2.289590] ehci-pci 0000:00:16.2: new USB bus registered, assigned bu=
s number 3
[    2.289593] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    2.289601] ehci-pci 0000:00:16.2: debug port 1
[    2.289629] ehci-pci 0000:00:16.2: irq 23, io mem 0xfd404000
[    2.295286] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.295298] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.295300] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.295301] usb usb3: Product: EHCI Host Controller
[    2.295302] usb usb3: Manufacturer: Linux 3.10.0-rc3+ ehci_hcd
[    2.295304] usb usb3: SerialNumber: 0000:00:16.2
[    2.295387] hub 3-0:1.0: USB hub found
[    2.295390] hub 3-0:1.0: 4 ports detected
[    2.295463] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.295534] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.295570] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bu=
s number 4
[    2.295588] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfd40a000
[    2.350208] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.350210] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.350211] usb usb4: Product: OHCI Host Controller
[    2.350212] usb usb4: Manufacturer: Linux 3.10.0-rc3+ ohci_hcd
[    2.350214] usb usb4: SerialNumber: 0000:00:12.0
[    2.350296] hub 4-0:1.0: USB hub found
[    2.350301] hub 4-0:1.0: 5 ports detected
[    2.350439] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.350474] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bu=
s number 5
[    2.350493] ohci_hcd 0000:00:13.0: irq 20, io mem 0xfd408000
[    2.405098] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.405100] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.405102] usb usb5: Product: OHCI Host Controller
[    2.405103] usb usb5: Manufacturer: Linux 3.10.0-rc3+ ohci_hcd
[    2.405104] usb usb5: SerialNumber: 0000:00:13.0
[    2.405188] hub 5-0:1.0: USB hub found
[    2.405193] hub 5-0:1.0: 5 ports detected
[    2.405336] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.405374] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bu=
s number 6
[    2.405387] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfd406000
[    2.459995] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.459997] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.459999] usb usb6: Product: OHCI Host Controller
[    2.460000] usb usb6: Manufacturer: Linux 3.10.0-rc3+ ohci_hcd
[    2.460001] usb usb6: SerialNumber: 0000:00:14.5
[    2.460093] hub 6-0:1.0: USB hub found
[    2.460098] hub 6-0:1.0: 2 ports detected
[    2.460214] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.460248] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bu=
s number 7
[    2.460266] ohci_hcd 0000:00:16.0: irq 22, io mem 0xfd405000
[    2.514892] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.514895] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.514896] usb usb7: Product: OHCI Host Controller
[    2.514898] usb usb7: Manufacturer: Linux 3.10.0-rc3+ ohci_hcd
[    2.514899] usb usb7: SerialNumber: 0000:00:16.0
[    2.514980] hub 7-0:1.0: USB hub found
[    2.514986] hub 7-0:1.0: 4 ports detected
[    2.515054] uhci_hcd: USB Universal Host Controller Interface driver
[    2.515113] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    2.515152] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bu=
s number 8
[    2.576152] xhci_hcd 0000:03:00.0: irq 73 for MSI/MSI-X
[    2.576159] xhci_hcd 0000:03:00.0: irq 74 for MSI/MSI-X
[    2.576165] xhci_hcd 0000:03:00.0: irq 75 for MSI/MSI-X
[    2.576170] xhci_hcd 0000:03:00.0: irq 76 for MSI/MSI-X
[    2.576175] xhci_hcd 0000:03:00.0: irq 77 for MSI/MSI-X
[    2.576180] xhci_hcd 0000:03:00.0: irq 78 for MSI/MSI-X
[    2.576185] xhci_hcd 0000:03:00.0: irq 79 for MSI/MSI-X
[    2.576190] xhci_hcd 0000:03:00.0: irq 80 for MSI/MSI-X
[    2.576280] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.576282] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.576284] usb usb8: Product: xHCI Host Controller
[    2.576285] usb usb8: Manufacturer: Linux 3.10.0-rc3+ xhci_hcd
[    2.576286] usb usb8: SerialNumber: 0000:03:00.0
[    2.576350] xHCI xhci_add_endpoint called for root hub
[    2.576351] xHCI xhci_check_bandwidth called for root hub
[    2.576367] hub 8-0:1.0: USB hub found
[    2.576372] hub 8-0:1.0: 2 ports detected
[    2.576425] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    2.576459] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bu=
s number 9
[    2.576485] usb usb9: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    2.576486] usb usb9: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.576488] usb usb9: Product: xHCI Host Controller
[    2.576489] usb usb9: Manufacturer: Linux 3.10.0-rc3+ xhci_hcd
[    2.576490] usb usb9: SerialNumber: 0000:03:00.0
[    2.576544] xHCI xhci_add_endpoint called for root hub
[    2.576545] xHCI xhci_check_bandwidth called for root hub
[    2.576561] hub 9-0:1.0: USB hub found
[    2.576565] hub 9-0:1.0: 2 ports detected
[    2.580802] usbcore: registered new interface driver usbserial
[    2.580809] usbcore: registered new interface driver usbserial_generic
[    2.580816] usbserial: USB Serial support registered for generic
[    2.580841] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    2.581176] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.581183] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.581258] mousedev: PS/2 mouse device common for all mice
[    2.581395] rtc_cmos 00:04: RTC can wake from S4
[    2.581492] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.581512] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[    2.581728] ata6: SATA link down (SStatus 0 SControl 300)
[    2.581743] device-mapper: uevent: version 1.0.3
[    2.581766] ata3: SATA link down (SStatus 0 SControl 300)
[    2.581797] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialise=
d: dm-devel@redhat.com
[    2.581897] cpuidle: using governor ladder
[    2.582006] cpuidle: using governor menu
[    2.582175] hidraw: raw HID events driver (C) Jiri Kosina
[    2.582244] usbcore: registered new interface driver usbhid
[    2.582244] usbhid: USB HID core driver
[    2.582269] drop_monitor: Initializing network drop monitor service
[    2.582324] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.582381] TCP: cubic registered
[    2.582383] Initializing XFRM netlink socket
[    2.582462] NET: Registered protocol family 10
[    2.582614] mip6: Mobile IPv6
[    2.582616] NET: Registered protocol family 17
[    2.582722] ata5: SATA link down (SStatus 0 SControl 300)
[    2.582747] ata1: SATA link down (SStatus 0 SControl 300)
[    2.583005] PM: Hibernation image not present or could not be loaded.
[    2.583007] Loading module verification certificates
[    2.583823] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 0ea1=
002481fd383c48bd4dd9f425685addcb1d84'
[    2.583837] registered taskstats version 1
[    2.584949]   Magic number: 13:394:798
[    2.585017] rtc_cmos 00:04: setting system clock to 2013-05-30 18:45:2=
9 UTC (1369939529)
[    2.585098] acpi-cpufreq: overriding BIOS provided _PSD data
[    2.736526] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.737325] ata2.00: ATA-9: OCZ-AGILITY4, 1.5.2, max UDMA/133
[    2.737332] ata2.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    2.738103] ata2.00: configured for UDMA/133
[    2.738398] scsi 1:0:0:0: Direct-Access     ATA      OCZ-AGILITY4     =
1.5. PQ: 0 ANSI: 5
[    2.738695] sd 1:0:0:0: [sda] 500118192 512-byte logical blocks: (256 =
GB/238 GiB)
[    2.738728] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.738970] sd 1:0:0:0: [sda] Write Protect is off
[    2.738977] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.739033] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.741730]  sda: sda1 sda2 sda3
[    2.742572] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.094782] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    3.156658] tsc: Refined TSC clocksource calibration: 3901.082 MHz
[    3.156665] Switching to clocksource tsc
[    3.211701] usb 3-1: New USB device found, idVendor=3D058f, idProduct=3D=
6366
[    3.211708] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    3.211713] usb 3-1: Product: Mass Storage Device
[    3.211717] usb 3-1: Manufacturer: Generic
[    3.211720] usb 3-1: SerialNumber: 058F63666471
[    3.941344] usb 7-3: new full-speed USB device number 2 using ohci_hcd
[    4.090028] usb 7-3: New USB device found, idVendor=3D20a0, idProduct=3D=
4107
[    4.090036] usb 7-3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.090040] usb 7-3: Product: Crypto Stick v1.2
[    4.090044] usb 7-3: Manufacturer: German Privacy Foundation
[    4.318619] usb 7-4: new full-speed USB device number 3 using ohci_hcd
[    4.466323] usb 7-4: New USB device found, idVendor=3D04a9, idProduct=3D=
220e
[    4.466330] usb 7-4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.466335] usb 7-4: Product: CanoScan
[    4.466338] usb 7-4: Manufacturer: Canon
[    4.591109] usb 4-3: new low-speed USB device number 2 using ohci_hcd
[    4.758764] usb 4-3: New USB device found, idVendor=3D045e, idProduct=3D=
00db
[    4.758771] usb 4-3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.758776] usb 4-3: Product: Natural=AE Ergonomic Keyboard 4000
[    4.758779] usb 4-3: Manufacturer: Microsoft
[    4.771076] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as /de=
vices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input2
[    4.771290] microsoft 0003:045E:00DB.0001: input,hidraw0: USB HID v1.1=
1 Keyboard [Microsoft Natural=AE Ergonomic Keyboard 4000] on usb-0000:00:=
12.0-3/input0
[    4.786912] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as /de=
vices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.1/input/input3
[    4.787121] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.1=
1 Device [Microsoft Natural=AE Ergonomic Keyboard 4000] on usb-0000:00:12=
.0-3/input1
[    5.013176] usb 4-5: new full-speed USB device number 3 using ohci_hcd
[    5.166997] usb 4-5: New USB device found, idVendor=3D046d, idProduct=3D=
c52b
[    5.167005] usb 4-5: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    5.167009] usb 4-5: Product: USB Receiver
[    5.167013] usb 4-5: Manufacturer: Logitech
[    8.082437] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.082781] ata4.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/1=
33
[    8.082788] ata4.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
[    8.083182] ata4.00: configured for UDMA/133
[    8.083376] scsi 3:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 =
2CV1 PQ: 0 ANSI: 5
[    8.083662] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    8.083697] sd 3:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0=
 GB/74.5 GiB)
[    8.083907] sd 3:0:0:0: [sdb] Write Protect is off
[    8.083914] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    8.083969] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    8.084987]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    8.086016] sd 3:0:0:0: [sdb] Attached SCSI disk
[    8.087623] Freeing unused kernel memory: 1424k freed
[    8.088150] Write protecting the kernel read-only data: 12288k
[    8.095279] Freeing unused kernel memory: 1452k freed
[    8.101544] Freeing unused kernel memory: 1192k freed
[    8.108013] systemd[1]: systemd 195 running in system mode. (+PAM +LIB=
WRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; fedo=
ra)
[    8.108110] systemd[1]: Running in initial RAM disk.
[    8.108205] systemd[1]: Set hostname to <phenom.dumpdata.com>.
[    8.118610] systemd[1]: Starting udev Kernel Socket.
[    8.118654] systemd[1]: Listening on udev Kernel Socket.
[    8.118723] systemd[1]: Starting udev Control Socket.
[    8.118781] systemd[1]: Listening on udev Control Socket.
[    8.118794] systemd[1]: Starting Journal Socket.
[    8.118888] systemd[1]: Listening on Journal Socket.
[    8.118904] systemd[1]: Starting dracut cmdline hook...
[    8.119790] systemd[1]: Started Load Kernel Modules.
[    8.119812] systemd[1]: Starting Journal Service...
[    8.120470] systemd[1]: Started Journal Service.
[    8.120773] systemd[1]: Starting Sockets.
[    8.120810] systemd[1]: Reached target Sockets.
[    8.120834] systemd[1]: Starting Swap.
[    8.120858] systemd[1]: Reached target Swap.
[    8.120875] systemd[1]: Starting Local File Systems.
[    8.120900] systemd[1]: Reached target Local File Systems.
[    8.245558] systemd-udevd[185]: starting version 195
[    8.323352] wmi: Mapper loaded
[    8.344152] logitech-djreceiver 0003:046D:C52B.0005: hiddev0,hidraw2: =
USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-5/input2
[    8.349190] input: Logitech Unifying Device. Wireless PID:1028 as /dev=
ices/pci0000:00/0000:00:12.0/usb4/4-5/4-5:1.2/0003:046D:C52B.0005/input/i=
nput4
[    8.349379] logitech-djdevice 0003:046D:C52B.0006: input,hidraw3: USB =
HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:1028] on usb-0000=
:00:12.0-5:1
[    8.396448] [drm] Initialized drm 1.1.0 20060810
[    8.415086] usb-storage 3-1:1.0: USB Mass Storage device detected
[    8.415312] scsi6 : usb-storage 3-1:1.0
[    8.415611] usbcore: registered new interface driver usb-storage
[    8.601112] [drm:radeon_init] *ERROR* No UMS support in radeon module!
[    8.861015] checking generic (fb000000 8d0000) vs hw (c0000000 1000000=
0)
[    8.861018] checking generic (fb000000 8d0000) vs hw (fa000000 2000000=
)
[    8.861019] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removi=
ng generic driver
[    8.861034] Console: switching to colour dummy device 80x25
[    8.861416] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x084200a2
[    8.861418] nouveau  [  DEVICE][0000:01:00.0] Chipset: G84 (NV84)
[    8.861420] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
[    8.862357] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for imag=
e...
[    8.908853] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    8.908854] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
[    8.908942] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    8.908944] nouveau  [   VBIOS][0000:01:00.0] version 60.84.52.00.51
[    8.929182] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR3
[    8.929190] nouveau  [     PFB][0000:01:00.0] RAM size: 256 MiB
[    8.929194] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 1892 tags
[    8.954799] nouveau  [  PTHERM][0000:01:00.0] FAN control: PWM
[    8.954812] nouveau  [  PTHERM][0000:01:00.0] fan management: disabled
[    8.954814] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    8.954833] nouveau E[  PTHERM][0000:01:00.0] unhandled intr 0x0000018=
1
[    8.954947] [TTM] Zone  kernel: Available graphics memory: 8157572 kiB
[    8.954949] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    8.954950] [TTM] Initializing pool allocator
[    8.954955] [TTM] Initializing DMA pool allocator
[    8.980618] nouveau  [     DRM] VRAM: 256 MiB
[    8.980621] nouveau  [     DRM] GART: 512 MiB
[    8.980625] nouveau  [     DRM] TMDS table version 2.0
[    8.980626] nouveau  [     DRM] DCB version 4.0
[    8.980628] nouveau  [     DRM] DCB outp 00: 02000300 00000028
[    8.980630] nouveau  [     DRM] DCB outp 01: 01000302 00020030
[    8.980631] nouveau  [     DRM] DCB outp 02: 04011310 00000028
[    8.980633] nouveau  [     DRM] DCB outp 03: 02011312 00020030
[    8.980634] nouveau  [     DRM] DCB outp 04: 010223f1 00c0c083
[    8.980636] nouveau  [     DRM] DCB conn 00: 2030
[    8.980638] nouveau  [     DRM] DCB conn 01: 1130
[    8.980639] nouveau  [     DRM] DCB conn 02: 0210
[    8.980640] nouveau  [     DRM] DCB conn 03: 0211
[    8.980641] nouveau  [     DRM] DCB conn 04: 0213
[    8.987187] nouveau W[     DRM] failed to create encoder 0/1/0: -19
[    8.987189] nouveau W[     DRM] TV-1 has no encoders, removing
[    8.987210] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
.
[    8.987211] [drm] No driver support for vblank timestamp query.
[    8.987327] nouveau  [     DRM] 1 available performance level(s)
[    8.987330] nouveau  [     DRM] 0: core 540MHz shader 1188MHz memory 7=
00MHz fanspeed 100%
[    8.987332] nouveau  [     DRM] c: core 540MHz shader 1188MHz memory 7=
02MHz voltage 1320mV fanspeed 29%
[    8.994062] nouveau  [     DRM] MM: using CRYPT for buffer copies
[    9.054503] nouveau  [     DRM] allocated 1920x1200 fb: 0x70000, bo ff=
ff8804385ef000
[    9.054795] fbcon: nouveaufb (fb0) is primary device
[    9.151365] Console: switching to colour frame buffer device 240x75
[    9.153034] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    9.153035] nouveau 0000:01:00.0: registered panic notifier
[    9.153038] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 =
on minor 0
[    9.194191] EXT4-fs (sdb3): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.275418] EXT4-fs (sdb3): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.369833] systemd-journald[141]: Received SIGTERM
[    9.415967] scsi 6:0:0:0: Direct-Access     Multi    Flash Reader     =
1.00 PQ: 0 ANSI: 0
[    9.416462] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    9.418481] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    9.470567] type=3D1404 audit(1369939536.396:2): enforcing=3D1 old_enf=
orcing=3D0 auid=3D4294967295 ses=3D4294967295
[    9.523813] SELinux: 2048 avtab hash slots, 94087 rules.
[    9.539015] SELinux: 2048 avtab hash slots, 94087 rules.
[    9.656079] SELinux:  9 users, 15 roles, 4356 types, 237 bools, 1 sens=
, 1024 cats
[    9.656082] SELinux:  83 classes, 94087 rules
[    9.660378] SELinux:  Permission attach_queue in class tun_socket not =
defined in policy.
[    9.660380] SELinux: the above unknown classes and permissions will be=
 allowed
[    9.660387] SELinux:  Completing initialization.
[    9.660388] SELinux:  Setting up existing superblocks.
[    9.660393] SELinux: initialized (dev sysfs, type sysfs), uses genfs_c=
ontexts
[    9.660397] SELinux: initialized (dev rootfs, type rootfs), uses genfs=
_contexts
[    9.660406] SELinux: initialized (dev bdev, type bdev), uses genfs_con=
texts
[    9.660409] SELinux: initialized (dev proc, type proc), uses genfs_con=
texts
[    9.660415] SELinux: initialized (dev tmpfs, type tmpfs), uses transit=
ion SIDs
[    9.660440] SELinux: initialized (dev devtmpfs, type devtmpfs), uses t=
ransition SIDs
[    9.661492] SELinux: initialized (dev sockfs, type sockfs), uses task =
SIDs
[    9.661496] SELinux: initialized (dev debugfs, type debugfs), uses gen=
fs_contexts
[    9.662240] SELinux: initialized (dev pipefs, type pipefs), uses task =
SIDs
[    9.662244] SELinux: initialized (dev anon_inodefs, type anon_inodefs)=
, uses genfs_contexts
[    9.662246] SELinux: initialized (dev devpts, type devpts), uses trans=
ition SIDs
[    9.662260] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses=
 transition SIDs
[    9.662266] SELinux: initialized (dev mqueue, type mqueue), uses trans=
ition SIDs
[    9.662271] SELinux: initialized (dev selinuxfs, type selinuxfs), uses=
 genfs_contexts
[    9.662282] SELinux: initialized (dev sysfs, type sysfs), uses genfs_c=
ontexts
[    9.662704] SELinux: initialized (dev securityfs, type securityfs), us=
es genfs_contexts
[    9.662706] SELinux: initialized (dev tmpfs, type tmpfs), uses transit=
ion SIDs
[    9.662710] SELinux: initialized (dev tmpfs, type tmpfs), uses transit=
ion SIDs
[    9.662802] SELinux: initialized (dev tmpfs, type tmpfs), uses transit=
ion SIDs
[    9.662835] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662839] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662844] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662862] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662869] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662873] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662876] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662880] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662888] SELinux: initialized (dev cgroup, type cgroup), uses genfs=
_contexts
[    9.662895] SELinux: initialized (dev sdb3, type ext4), uses xattr
[    9.673461] type=3D1403 audit(1369939536.600:3): policy loaded auid=3D=
4294967295 ses=3D4294967295
[    9.679621] systemd[1]: Successfully loaded SELinux policy in 212ms 90=
4us.
[    9.732841] systemd[1]: Relabelled /dev and /run in 24ms 554us.
[    9.904621] systemd-readahead[326]: Bumped block_nr parameter of 8:16 =
to 20480. This is a temporary hack and should be removed one day.
[    9.906022] SELinux: initialized (dev autofs, type autofs), uses genfs=
_contexts
[    9.920976] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses=
 transition SIDs
[    9.958747] EXT4-fs (sdb3): re-mounted. Opts: (null)
[    9.962906] systemd-udevd[338]: starting version 195
[    9.965317] SELinux: initialized (dev tmpfs, type tmpfs), uses transit=
ion SIDs
[    9.997477] SELinux: initialized (dev configfs, type configfs), uses g=
enfs_contexts
[   10.148112] kvm: Nested Virtualization enabled
[   10.148119] kvm: Nested Paging enabled
[   10.179126] pps_core: LinuxPPS API ver. 1 registered
[   10.179130] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[   10.182089] tun: Universal TUN/TAP device driver, 1.6
[   10.182092] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.198232] PTP clock support registered
[   10.198383] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, =
revision 0
[   10.198486] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.198722] r8169 0000:02:00.0: irq 81 for MSI/MSI-X
[   10.198923] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc9000=
187e000, c8:60:00:da:61:a6, XID 0c900800 IRQ 81
[   10.198926] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 byte=
s, tx checksumming: ko]
[   10.252446] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   10.252537] sp5100_tco: PCI Revision ID: 0x42
[   10.252571] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[   10.252606] sp5100_tco: Last reboot was not triggered by watchdog.
[   10.252745] sp5100_tco: initialized (0xffffc90011bc4b00). heartbeat=3D=
60 sec (nowayout=3D0)
[   10.268958] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.274690] MCE: In-kernel MCE decoding enabled.
[   10.276155] microcode: CPU0: patch_level=3D0x06000626
[   10.285428] systemd-udevd[413]: renamed network interface eth0 to p4p1
[   10.330709] microcode: CPU0: new patch_level=3D0x06000629
[   10.330729] microcode: CPU1: patch_level=3D0x06000626
[   10.330752] microcode: CPU2: patch_level=3D0x06000626
[   10.345645] microcode: CPU2: new patch_level=3D0x06000629
[   10.345851] microcode: CPU3: patch_level=3D0x06000626
[   10.345865] microcode: CPU4: patch_level=3D0x06000626
[   10.379616] microcode: CPU4: new patch_level=3D0x06000629
[   10.379651] microcode: CPU5: patch_level=3D0x06000626
[   10.379671] microcode: CPU6: patch_level=3D0x06000626
[   10.401996] microcode: CPU6: new patch_level=3D0x06000629
[   10.402026] microcode: CPU7: patch_level=3D0x06000626
[   10.402211] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
.fsnet.co.uk>, Peter Oruba
[   10.409272] asus_wmi: ASUS WMI generic driver loaded
[   10.416563] asus_wmi: Initialization: 0x0
[   10.416596] asus_wmi: BIOS WMI version: 0.9
[   10.416665] asus_wmi: SFUN value: 0x0
[   10.417135] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/i=
nput/input6
[   10.418181] asus_wmi: Disabling ACPI video driver
[   10.419594] EDAC MC: Ver: 3.0.0
[   10.441799] AMD64 EDAC driver v3.4.0
[   10.442896] EDAC amd64: DRAM ECC disabled.
[   10.442909] EDAC amd64: ECC disabled in the BIOS or no ECC capability,=
 module will not load.
 Either enable ECC checking or force module loading by setting 'ecc_enabl=
e_override'.
 (Note that use of the override may cause unknown side effects.)
[   10.468665] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   10.468668] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   10.468690] e1000e 0000:04:00.0: Disabling ASPM L0s L1
[   10.468832] e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
[   10.468852] e1000e 0000:04:00.0: irq 82 for MSI/MSI-X
[   10.468857] e1000e 0000:04:00.0: irq 83 for MSI/MSI-X
[   10.468862] e1000e 0000:04:00.0: irq 84 for MSI/MSI-X
[   10.569522] e1000e 0000:04:00.0 eth0: registered PHC clock
[   10.569532] e1000e 0000:04:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 0=
0:1b:21:61:49:00
[   10.569537] e1000e 0000:04:00.0 eth0: Intel(R) PRO/1000 Network Connec=
tion
[   10.569553] e1000e 0000:04:00.0 eth0: MAC: 3, PHY: 8, PBA No: E46981-0=
03
[   10.572392] Adding 8159228k swap on /dev/sdb2.  Priority:-1 extents:1 =
across:8159228k SSFS
[   10.674158] ALSA hda_intel.c:3276 0000:00:14.2: Using LPIB position fi=
x
[   10.677628] ALSA hda_intel.c:1763 0000:00:14.2: Enable sync_write for =
stable communication
[   10.695939] EXT4-fs (sdb1): mounted filesystem with ordered data mode.=
 Opts: (null)
[   10.696128] SELinux: initialized (dev sdb1, type ext4), uses xattr
[   10.702211] ALSA patch_realtek.c:414 SKU: Nid=3D0x1d sku_cfg=3D0x4005e=
601
[   10.702224] ALSA patch_realtek.c:416 SKU: port_connectivity=3D0x1
[   10.702228] ALSA patch_realtek.c:417 SKU: enable_pcbeep=3D0x0
[   10.702232] ALSA patch_realtek.c:418 SKU: check_sum=3D0x00000005
[   10.702236] ALSA patch_realtek.c:419 SKU: customization=3D0x000000e6
[   10.702239] ALSA patch_realtek.c:420 SKU: external_amp=3D0x0
[   10.702242] ALSA patch_realtek.c:421 SKU: platform_type=3D0x0
[   10.702245] ALSA patch_realtek.c:422 SKU: swap=3D0x0
[   10.702247] ALSA patch_realtek.c:423 SKU: override=3D0x1
[   10.702764] ALSA hda_auto_parser.c:393 autoconfig: line_outs=3D4 (0x14=
/0x15/0x16/0x17/0x0) type:line
[   10.702770] ALSA hda_auto_parser.c:397    speaker_outs=3D0 (0x0/0x0/0x=
0/0x0/0x0)
[   10.702778] ALSA hda_auto_parser.c:401    hp_outs=3D1 (0x1b/0x0/0x0/0x=
0/0x0)
[   10.702781] ALSA hda_auto_parser.c:402    mono: mono_out=3D0x0
[   10.702785] ALSA hda_auto_parser.c:405    dig-out=3D0x11/0x1e
[   10.702788] ALSA hda_auto_parser.c:406    inputs:
[   10.702793] ALSA hda_auto_parser.c:410      Front Mic=3D0x19
[   10.702800] ALSA hda_auto_parser.c:410      Rear Mic=3D0x18
[   10.702803] ALSA hda_auto_parser.c:410      Line=3D0x1a
[   10.702807] ALSA patch_realtek.c:486 realtek: No valid SSID, checking =
pincfg 0x4005e601 for NID 0x1d
[   10.702810] ALSA patch_realtek.c:502 realtek: Enabling init ASM_ID=3D0=
xe601 CODEC_ID=3D10ec0887
[   10.723643] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0=
000:00:14.2/sound/card0/input7
[   10.723836] input: HDA ATI SB Line Out Side as /devices/pci0000:00/000=
0:00:14.2/sound/card0/input8
[   10.723937] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/000=
0:00:14.2/sound/card0/input9
[   10.724034] input: HDA ATI SB Line Out Surround as /devices/pci0000:00=
/0000:00:14.2/sound/card0/input10
[   10.724135] input: HDA ATI SB Line Out Front as /devices/pci0000:00/00=
00:00:14.2/sound/card0/input11
[   10.724226] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2=
/sound/card0/input12
[   10.724315] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:=
14.2/sound/card0/input13
[   10.724399] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00=
:14.2/sound/card0/input14
[   10.725110] ALSA hda_intel.c:3084 0000:06:00.1: Handle VGA-switcheroo =
audio client
[   10.725113] ALSA hda_intel.c:3276 0000:06:00.1: Using LPIB position fi=
x
[   10.725156] snd_hda_intel 0000:06:00.1: irq 85 for MSI/MSI-X
[   10.727539] ALSA hda_intel.c:1763 0000:06:00.1: Enable sync_write for =
stable communication
[   10.748481] input: HDA ATI HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:00=
/0000:00:15.0/0000:06:00.1/sound/card1/input15
[   10.819950] [drm:radeon_init] *ERROR* No UMS support in radeon module!
[   10.822613] systemd-udevd[379]: renamed network interface eth0 to p9p1
[   11.114983] EXT4-fs (sda2): mounted filesystem with ordered data mode.=
 Opts: (null)
[   11.114998] SELinux: initialized (dev sda2, type ext4), uses xattr
[   11.290777] systemd-journald[348]: Received SIGUSR1
[   11.485882] Loading iSCSI transport class v2.0-870.
[   11.519856] iscsi: registered transport (tcp)
[   11.578936] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   11.614988] Ebtables v2.0 registered
[   11.659241] iscsi: registered transport (iser)
[   11.683692] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, ag=
e 0xf, 4 bits.
[   11.683696] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp i=
dx 0.
[   11.757353] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.769756] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   11.769785] iscsi: registered transport (cxgb3i)
[   11.866059] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   11.866092] iscsi: registered transport (cxgb4i)
[   11.876457] Bridge firewalling registered
[   11.922317] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec =
05, 2012)
[   11.991175] r8169 0000:02:00.0 p4p1: link down
[   11.991209] r8169 0000:02:00.0 p4p1: link down
[   11.991241] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   11.995275] device p4p1 entered promiscuous mode
[   12.032654] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25,=
 2012)
[   12.032702] iscsi: registered transport (bnx2i)
[   12.081818] iscsi: registered transport (be2iscsi)
[   12.081822] In beiscsi_module_init, tt=3Dffffffffa0596000
[   12.094696] IPv6: ADDRCONF(NETDEV_UP): switch: link is not ready
[   12.184697] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
[   12.184699] vgaarb: transferring owner from PCI:0000:01:00.0 to PCI:00=
00:06:00.0
[   14.387361] r8169 0000:02:00.0 p4p1: link up
[   14.387371] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   14.387898] switch: port 1(p4p1) entered forwarding state
[   14.387906] switch: port 1(p4p1) entered forwarding state
[   14.387934] IPv6: ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
[   17.846995] scsi7 : iSCSI Initiator over TCP/IP
[   18.106091] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           =
4.0  PQ: 0 ANSI: 5
[   18.106784] sd 7:0:0:0: Attached scsi generic sg3 type 0
[   18.106914] sd 7:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.0=
0 TB/931 GiB)
[   18.108630] sd 7:0:0:0: [sdd] Write Protect is off
[   18.108634] sd 7:0:0:0: [sdd] Mode Sense: 2f 00 00 00
[   18.109173] sd 7:0:0:0: [sdd] Write cache: disabled, read cache: enabl=
ed, doesn't support DPO or FUA
[   18.113304]  sdd: unknown partition table
[   18.115108] sd 7:0:0:0: [sdd] Attached SCSI disk
[   19.513722] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   20.145997] cgroup: libvirtd (1491) created nested cgroup for controll=
er "memory" which has incomplete hierarchy support. Nested cgroups may ch=
ange behavior in the future.
[   20.146003] cgroup: "memory" requires setting use_hierarchy to 1 on th=
e root.
[   20.146283] cgroup: libvirtd (1491) created nested cgroup for controll=
er "blkio" which has incomplete hierarchy support. Nested cgroups may cha=
nge behavior in the future.
[   20.781092] SELinux: initialized (dev mqueue, type mqueue), uses trans=
ition SIDs
[   20.781176] SELinux: initialized (dev proc, type proc), uses genfs_con=
texts
[   20.797136] SELinux: initialized (dev mqueue, type mqueue), uses trans=
ition SIDs
[   20.799041] SELinux: initialized (dev proc, type proc), uses genfs_con=
texts
[   49.233166] fuse init (API version 7.22)
[   49.235518] SELinux: initialized (dev fuse, type fuse), uses genfs_con=
texts
[   49.255441] SELinux: initialized (dev fusectl, type fusectl), uses gen=
fs_contexts
[   50.057288] Bluetooth: Core ver 2.16
[   50.057376] NET: Registered protocol family 31
[   50.057377] Bluetooth: HCI device and connection manager initialized
[   50.057386] Bluetooth: HCI socket layer initialized
[   50.057389] Bluetooth: L2CAP socket layer initialized
[   50.057396] Bluetooth: SCO socket layer initialized
[   50.086337] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   50.086342] Bluetooth: BNEP filters: protocol multicast
[   50.086353] Bluetooth: BNEP socket layer initialized
[   51.569300] SELinux: initialized (dev proc, type proc), uses genfs_con=
texts
[  355.862347] usb 7-3: USB disconnect, device number 2
[  467.734121]  connection1:0: detected conn error (1020)
[  757.083224] SELinux: initialized (dev proc, type proc), uses genfs_con=
texts
[  809.007313] usb 7-4: USB disconnect, device number 3
[  816.401848] PM: Syncing filesystems ... done.
[  816.417857] PM: Preparing system for mem sleep
[  816.597713] Freezing user space processes ... (elapsed 0.01 seconds) d=
one.
[  816.612164] Freezing remaining freezable tasks ... (elapsed 0.01 secon=
ds) done.
[  816.623024] PM: Entering mem sleep
[  816.623429] Suspending console(s) (use no_console_suspend to debug)
[  816.624105] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  816.624224] sd 3:0:0:0: [sdb] Stopping disk
[  816.624388] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  816.624869] serial 00:09: disabled
[  816.624885] serial 00:09: System wakeup disabled by ACPI
[  816.625528] nouveau  [     DRM] suspending fbcon...
[  816.625539] nouveau  [     DRM] suspending display...
[  816.625569] nouveau  [     DRM] unpinning framebuffer(s)...
[  816.625603] nouveau  [     DRM] evicting buffers...
[  816.626014] sd 1:0:0:0: [sda] Stopping disk
[  817.303041] nouveau  [     DRM] waiting for kernel channels to go idle=
...
[  817.303046] nouveau  [     DRM] suspending client object trees...
[  817.303723] nouveau  [     DRM] suspending kernel object tree...
[  819.572589] PM: suspend of devices complete after 2954.351 msecs
[  819.572920] PM: late suspend of devices complete after 0.327 msecs
[  819.573330] pcieport 0000:00:09.0: System wakeup enabled by ACPI
[  819.584337] pcieport 0000:00:07.0: System wakeup enabled by ACPI
[  819.595270] pcieport 0000:00:04.0: System wakeup enabled by ACPI
[  819.606276] ehci-pci 0000:00:16.2: System wakeup enabled by ACPI
[  819.617184] ohci_hcd 0000:00:16.0: System wakeup enabled by ACPI
[  819.617246] ohci_hcd 0000:00:14.5: System wakeup enabled by ACPI
[  819.617340] ehci-pci 0000:00:13.2: System wakeup enabled by ACPI
[  819.628161] ohci_hcd 0000:00:13.0: System wakeup enabled by ACPI
[  819.628198] ehci-pci 0000:00:12.2: System wakeup enabled by ACPI
[  819.639140] ohci_hcd 0000:00:12.0: System wakeup enabled by ACPI
[  819.639298] PM: noirq suspend of devices complete after 66.499 msecs
[  819.641158] ACPI: Preparing to enter system sleep state S3
[  819.641298] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[  819.695579] PM: Saving platform NVS memory
[  819.701191] Disabling non-boot CPUs ...
[  819.705218] smpboot: CPU 1 is now offline
[  819.705652] CPU 1 offline: Remove Rx thread
[  819.705972] ------------[ cut here ]------------
[  819.705984] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.706040] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq=
_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core ee=
epc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam=
15h_power
[  819.706063]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco=
 vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan=
 kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm=
 usb_storage drm hid_logitech_dj i2c_core wmi
[  819.706067] CPU: 0 PID: 127 Comm: kworker/1:1 Not tainted 3.10.0-rc3+ =
#4
[  819.706068] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.706073] Workqueue: events od_dbs_timer
[  819.706080]  0000000000000009 ffff88042ff6dbf8 ffffffff8167edc5 ffff88=
042ff6dc38
[  819.706084]  ffffffff8105d380 0000000000000339 0000000000000001 ffff88=
04385e0000
[  819.706088]  000000010008056a 0000000000000001 ffff88044ec50b08 ffff88=
042ff6dc48
[  819.706089] Call Trace:
[  819.706097]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.706102]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.706107]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.706112]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.706116]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.706120]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.706125]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.706129]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.706133]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.706138]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.706141]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.706146]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.706150]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.706154]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.706158]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.706162]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.706166]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.706170]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.706173] ---[ end trace a5556efe295a5e63 ]---
[  819.706729] Broke affinity for irq 81
[  819.709704] smpboot: CPU 2 is now offline
[  819.710351] CPU 2 offline: Remove Rx thread
[  819.710995] ------------[ cut here ]------------
[  819.711000] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.711042] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq=
_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core ee=
epc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam=
15h_power
[  819.711060]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco=
 vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan=
 kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm=
 usb_storage drm hid_logitech_dj i2c_core wmi
[  819.711063] CPU: 0 PID: 112 Comm: kworker/2:1 Tainted: G        W    3=
.10.0-rc3+ #4
[  819.711064] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.711067] Workqueue: events od_dbs_timer
[  819.711073]  0000000000000009 ffff88042fd61bf8 ffffffff8167edc5 ffff88=
042fd61c38
[  819.711077]  ffffffff8105d380 0000000000000339 0000000000000002 ffff88=
0438604000
[  819.711081]  0000000100080574 0000000000000002 ffff88044ec90b08 ffff88=
042fd61c48
[  819.711082] Call Trace:
[  819.711086]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.711091]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.711095]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.711099]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.711103]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.711107]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.711111]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.711115]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.711119]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.711123]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.711126]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.711131]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.711135]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.711139]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.711142]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.711146]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.711150]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.711153]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.711156] ---[ end trace a5556efe295a5e64 ]---
[  819.712428] smpboot: CPU 3 is now offline
[  819.712967] CPU 3 offline: Remove Rx thread
[  819.716711] smpboot: CPU 4 is now offline
[  819.717210] CPU 4 offline: Remove Rx thread
[  819.717924] Broke affinity for irq 18
[  819.717940] Broke affinity for irq 22
[  819.717946] Broke affinity for irq 23
[  819.719055] ------------[ cut here ]------------
[  819.719060] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.719098] ------------[ cut here ]------------
[  819.719113] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.719117] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec
[  819.719119] Modules linked in:
[  819.719121]  snd_hwdep
[  819.719123]  bnep
[  819.719124]  snd_seq
[  819.719126]  bluetooth
[  819.719128]  snd_seq_device
[  819.719129]  fuse
[  819.719131]  snd_pcm
[  819.719133]  ebtable_nat
[  819.719135]  e1000e
[  819.719136]  xt_CHECKSUM
[  819.719139] smpboot: CPU 5 is now offline
[  819.719141]  snd_page_alloc
[  819.719142]  ipt_MASQUERADE
[  819.719144]  crc32c_intel
[  819.719146]  nf_conntrack_netbios_ns
[  819.719147]  snd_timer
[  819.719149]  nf_conntrack_broadcast
[  819.719151]  edac_core
[  819.719152]  ip6table_mangle
[  819.719154]  eeepc_wmi
[  819.719156]  ip6t_REJECT
[  819.719157]  ghash_clmulni_intel
[  819.719159]  nf_conntrack_ipv6
[  819.719160]  asus_wmi
[  819.719162]  nf_defrag_ipv6
[  819.719164]  snd
[  819.719165]  be2iscsi
[  819.719167]  sparse_keymap
[  819.719168]  iptable_nat
[  819.719170]  rfkill
[  819.719171]  iscsi_boot_sysfs
[  819.719173]  k10temp
[  819.719175]  nf_nat_ipv4
[  819.719176]  fam15h_power
[  819.719178]  bnx2i
[  819.719179]  microcode
[  819.719181]  nf_nat
[  819.719182]  serio_raw
[  819.719184]  cnic
[  819.719186]  edac_mce_amd
[  819.719187]  iptable_mangle
[  819.719189]  joydev
[  819.719190]  uio
[  819.719192]  pcspkr
[  819.719194]  bridge
[  819.719195]  sp5100_tco
[  819.719197]  cxgb4i
[  819.719198]  vhost_net
[  819.719200]  cxgb4
[  819.719202]  soundcore
[  819.719203]  nf_conntrack_ipv4
[  819.719205]  i2c_piix4
[  819.719207]  stp
[  819.719209]  r8169
[  819.719211]  llc
[  819.719213]  ptp
[  819.719215]  nf_defrag_ipv4
[  819.719217]  tun
[  819.719219]  cxgb3i
[  819.719221]  pps_core
[  819.719222]  xt_conntrack
[  819.719224]  mii
[  819.719226]  cxgb3
[  819.719228]  macvtap
[  819.719230]  nf_conntrack
[  819.719231]  macvlan
[  819.719233]  mdio
[  819.719235]  kvm_amd
[  819.719237]  libcxgbi
[  819.719239]  kvm
[  819.719241]  ib_iser
[  819.719243]  uinput
[  819.719245]  rdma_cm
[  819.719246]  nouveau
[  819.719248]  ebtable_filter
[  819.719250]  video
[  819.719252]  ib_addr
[  819.719253]  mxm_wmi
[  819.719255]  iw_cm
[  819.719256]  i2c_algo_bit
[  819.719259]  ebtables
[  819.719260]  drm_kms_helper
[  819.719262]  ib_cm
[  819.719264]  ttm
[  819.719266]  ib_sa
[  819.719267]  usb_storage
[  819.719270]  ip6table_filter
[  819.719271]  drm
[  819.719273]  ib_mad
[  819.719274]  hid_logitech_dj
[  819.719276]  ip6_tables
[  819.719278]  i2c_core
[  819.719279]  ib_core
[  819.719281]  wmi

[  819.719287] CPU: 0 PID: 2321 Comm: kworker/4:0 Tainted: G        W    =
3.10.0-rc3+ #4
[  819.719289] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.719293]  iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
[  819.719295] Workqueue: events od_dbs_timer

[  819.719300]  snd_hda_codec_hdmi snd_hda_codec_realtek
[  819.719302]  0000000000000009
[  819.719304]  snd_hda_intel
[  819.719306]  ffff8803fb159bf8
[  819.719308]  snd_hda_codec
[  819.719310]  ffffffff8167edc5
[  819.719313]  snd_hwdep
[  819.719314]  ffff8803fb159c38

[  819.719318]  snd_seq snd_seq_device
[  819.719320]  ffffffff8105d380
[  819.719321]  snd_pcm
[  819.719323]  0000000000000339
[  819.719325]  e1000e
[  819.719326]  0000000000000004
[  819.719329]  snd_page_alloc
[  819.719330]  ffff880438678000

[  819.719334]  crc32c_intel snd_timer
[  819.719336]  000000010008057e
[  819.719338]  edac_core
[  819.719339]  0000000000000004
[  819.719342]  eeepc_wmi
[  819.719344]  ffff88044ed10b08
[  819.719345]  ghash_clmulni_intel
[  819.719347]  ffff8803fb159c48

[  819.719351] Call Trace:
[  819.719353]  asus_wmi snd sparse_keymap
[  819.719359]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.719361]  rfkill k10temp
[  819.719368]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.719370]  fam15h_power microcode
[  819.719376]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.719378]  serio_raw edac_mce_amd
[  819.719384]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.719386]  joydev pcspkr
[  819.719390]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.719393]  sp5100_tco vhost_net
[  819.719397]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.719400]  soundcore i2c_piix4
[  819.719405]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.719407]  r8169 ptp
[  819.719412]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.719415]  tun pps_core
[  819.719419]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.719422]  mii macvtap
[  819.719426]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.719429]  macvlan kvm_amd
[  819.719433]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.719435]  kvm uinput
[  819.719440]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.719443]  nouveau video mxm_wmi
[  819.719448]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.719450]  i2c_algo_bit drm_kms_helper
[  819.719455]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.719457]  ttm usb_storage
[  819.719461]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.719464]  drm hid_logitech_dj i2c_core
[  819.719469]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719470]  wmi
[  819.719474]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.719479] CPU: 6 PID: 136 Comm: kworker/3:1 Tainted: G        W    3=
.10.0-rc3+ #4
[  819.719483] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.719486]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719493] ---[ end trace a5556efe295a5e65 ]---
[  819.719494] Workqueue: events od_dbs_timer
[  819.719502]  0000000000000009 ffff88042f823bf8 ffffffff8167edc5 ffff88=
042f823c38
[  819.719507]  ffffffff8105d380 0000000000000339 0000000000000003 ffff88=
0438650000
[  819.719511]  000000010008057e 0000000000000003 ffff88044ecd0b08 ffff88=
042f823c48
[  819.719513] Call Trace:
[  819.719521]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.719528]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.719534]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.719539]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.719544]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.719549]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.719554]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.719559]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.719563]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.719569]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.719573]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.719578]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.719583]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.719588]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.719593]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.719598]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719603]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.719607]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.719611] ---[ end trace a5556efe295a5e66 ]---
[  819.719680] CPU 5 offline: Remove Rx thread
[  819.719940] ------------[ cut here ]------------
[  819.719945] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.719988] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq=
_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core ee=
epc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam=
15h_power
[  819.720005]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco=
 vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan=
 kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm=
 usb_storage drm hid_logitech_dj i2c_core wmi
[  819.720008] CPU: 0 PID: 126 Comm: kworker/5:1 Tainted: G        W    3=
.10.0-rc3+ #4
[  819.720009] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.720012] Workqueue: events od_dbs_timer
[  819.720017]  0000000000000009 ffff88042ff11bf8 ffffffff8167edc5 ffff88=
042ff11c38
[  819.720021]  ffffffff8105d380 0000000000000339 0000000000000005 ffff88=
043869c000
[  819.720025]  000000010008057e 0000000000000005 ffff88044ed50b08 ffff88=
042ff11c48
[  819.720026] Call Trace:
[  819.720030]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.720034]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.720039]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.720043]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.720047]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.720050]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.720055]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.720058]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.720062]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.720066]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.720070]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.720074]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.720078]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.720082]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.720085]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.720090]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.720093]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.720097]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.720099] ---[ end trace a5556efe295a5e67 ]---
[  819.723294] smpboot: CPU 6 is now offline
[  819.723792] CPU 6 offline: Remove Rx thread
[  819.724289] Broke affinity for irq 19
[  819.725405] smpboot: CPU 7 is now offline
[  819.725840] CPU 7 offline: Remove Rx thread
[  819.729465] ACPI: Low-level resume complete
[  819.729494] PM: Restoring platform NVS memory
[  819.820651] microcode: CPU0: new patch_level=3D0x06000629
[  819.820717] ------------[ cut here ]------------
[  819.820723] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.820750] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq=
_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core ee=
epc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam=
15h_power
[  819.820761]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco=
 vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan=
 kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm=
 usb_storage drm hid_logitech_dj i2c_core wmi
[  819.820763] CPU: 0 PID: 257 Comm: kworker/6:2 Tainted: G        W    3=
.10.0-rc3+ #4
[  819.820764] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.820766] Workqueue: events od_dbs_timer
[  819.820769]  0000000000000009 ffff88042f33bbf8 ffffffff8167edc5 ffff88=
042f33bc38
[  819.820771]  ffffffff8105d380 0000000000000339 0000000000000006 ffff88=
04386dc000
[  819.820773]  0000000100080594 0000000000000006 ffff88044ed90b08 ffff88=
042f33bc48
[  819.820773] Call Trace:
[  819.820777]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.820779]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.820781]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.820783]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.820785]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.820787]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.820789]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.820791]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.820792]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.820794]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.820796]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.820797]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.820799]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.820801]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.820802]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.820804]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820806]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.820807]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820808] ---[ end trace a5556efe295a5e68 ]---
[  819.820811] ------------[ cut here ]------------
[  819.820813] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 n=
ative_smp_send_reschedule+0x5b/0x60()
[  819.820830] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHEC=
KSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6tab=
le_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_n=
at iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio brid=
ge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntr=
ack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_ad=
dr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core i=
scsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq=
_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core ee=
epc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam=
15h_power
[  819.820837]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco=
 vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan=
 kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm=
 usb_storage drm hid_logitech_dj i2c_core wmi
[  819.820838] CPU: 0 PID: 60 Comm: kworker/7:0 Tainted: G        W    3.=
10.0-rc3+ #4
[  819.820838] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./M5A97, BIOS 1208 04/18/2012
[  819.820839] Workqueue: events od_dbs_timer
[  819.820841]  0000000000000009 ffff88043870dbf8 ffffffff8167edc5 ffff88=
043870dc38
[  819.820843]  ffffffff8105d380 0000000000000339 0000000000000007 ffff88=
0438720000
[  819.820844]  0000000100080594 0000000000000007 ffff88044edd0b08 ffff88=
043870dc48
[  819.820845] Call Trace:
[  819.820846]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
[  819.820848]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
[  819.820850]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
[  819.820852]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
[  819.820853]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
[  819.820854]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
[  819.820856]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
[  819.820858]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
[  819.820859]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
[  819.820861]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
[  819.820862]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
[  819.820864]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
[  819.820865]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
[  819.820867]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
[  819.820868]  [<ffffffff81082960>] kthread+0xc0/0xd0
[  819.820870]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820871]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
[  819.820872]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
[  819.820873] ---[ end trace a5556efe295a5e69 ]---
[  819.820876] Enabling non-boot CPUs ...
[  819.820905] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  819.832357] LVT offset 0 assigned for vector 0x400
[  819.834716] bnx2i: CPU 1 online: Create Rx thread
[  819.834751] CPU1 is up
[  819.834766] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  819.861211] microcode: CPU2: new patch_level=3D0x06000629
[  819.861224] bnx2i: CPU 2 online: Create Rx thread
[  819.861253] CPU2 is up
[  819.861270] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  819.874592] bnx2i: CPU 3 online: Create Rx thread
[  819.874620] CPU3 is up
[  819.874635] smpboot: Booting Node 0 Processor 4 APIC 0x14
[  819.901100] microcode: CPU4: new patch_level=3D0x06000629
[  819.901103] bnx2i: CPU 4 online: Create Rx thread
[  819.901137] CPU4 is up
[  819.901152] smpboot: Booting Node 0 Processor 5 APIC 0x15
[  819.914504] bnx2i: CPU 5 online: Create Rx thread
[  819.914532] CPU5 is up
[  819.914546] smpboot: Booting Node 0 Processor 6 APIC 0x16
[  819.941074] microcode: CPU6: new patch_level=3D0x06000629
[  819.941077] bnx2i: CPU 6 online: Create Rx thread
[  819.941109] CPU6 is up
[  819.941123] smpboot: Booting Node 0 Processor 7 APIC 0x17
[  819.954562] bnx2i: CPU 7 online: Create Rx thread
[  819.954588] CPU7 is up
[  819.967418] ACPI: Waking up from system sleep state S3
[  820.011410] ohci_hcd 0000:00:12.0: System wakeup disabled by ACPI
[  820.022055] ehci-pci 0000:00:12.2: System wakeup disabled by ACPI
[  820.022077] ohci_hcd 0000:00:13.0: System wakeup disabled by ACPI
[  820.033031] ehci-pci 0000:00:13.2: System wakeup disabled by ACPI
[  820.044052] ohci_hcd 0000:00:14.5: System wakeup disabled by ACPI
[  820.044098] ohci_hcd 0000:00:16.0: System wakeup disabled by ACPI
[  820.054989] ehci-pci 0000:00:16.2: System wakeup disabled by ACPI
[  820.087950] pcieport 0000:00:07.0: System wakeup disabled by ACPI
[  820.110007] PM: noirq resume of devices complete after 98.929 msecs
[  820.110139] PM: early resume of devices complete after 0.085 msecs
[  820.110294] usb usb8: root hub lost power or was reset
[  820.110296] usb usb9: root hub lost power or was reset
[  820.110402] pcieport 0000:00:04.0: System wakeup disabled by ACPI
[  820.110439] pcieport 0000:00:09.0: System wakeup disabled by ACPI
[  820.110447] e1000e 0000:04:00.0: Disabling ASPM L0s L1
[  820.110485] e1000e 0000:04:00.0: irq 82 for MSI/MSI-X
[  820.110491] e1000e 0000:04:00.0: irq 83 for MSI/MSI-X
[  820.110496] e1000e 0000:04:00.0: irq 84 for MSI/MSI-X
[  820.112296] nouveau  [     DRM] re-enabling device...
[  820.112305] nouveau  [     DRM] resuming kernel object tree...
[  820.112311] nouveau  [   VBIOS][0000:01:00.0] running init tables
[  820.112348] snd_hda_intel 0000:06:00.1: irq 85 for MSI/MSI-X
[  820.113021] serial 00:09: activated
[  820.171374] xhci_hcd 0000:03:00.0: irq 73 for MSI/MSI-X
[  820.171380] xhci_hcd 0000:03:00.0: irq 74 for MSI/MSI-X
[  820.171384] xhci_hcd 0000:03:00.0: irq 75 for MSI/MSI-X
[  820.171389] xhci_hcd 0000:03:00.0: irq 76 for MSI/MSI-X
[  820.171394] xhci_hcd 0000:03:00.0: irq 77 for MSI/MSI-X
[  820.171398] xhci_hcd 0000:03:00.0: irq 78 for MSI/MSI-X
[  820.171402] xhci_hcd 0000:03:00.0: irq 79 for MSI/MSI-X
[  820.171406] xhci_hcd 0000:03:00.0: irq 80 for MSI/MSI-X
[  820.262462] nouveau E[  PTHERM][0000:01:00.0] unhandled intr 0x0000018=
1
[  820.262941] nouveau  [     DRM] resuming client object trees...
[  820.263466] nouveau  [     DRM] resuming display...
[  820.266330] r8169 0000:02:00.0 p4p1: link down
[  820.270948] switch: port 1(p4p1) entered disabled state
[  820.316525] usb 4-5: reset full-speed USB device number 3 using ohci_h=
cd
[  820.417293] ata3: SATA link down (SStatus 0 SControl 300)
[  820.417361] ata6: SATA link down (SStatus 0 SControl 300)
[  820.417402] ata1: SATA link down (SStatus 0 SControl 300)
[  820.417426] ata5: SATA link down (SStatus 0 SControl 300)
[  820.572055] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  820.573293] ata2.00: configured for UDMA/133
[  820.573415] sd 1:0:0:0: [sda] Starting disk
[  820.727765] usb 4-3: reset low-speed USB device number 2 using ohci_hc=
d
[  822.573177] r8169 0000:02:00.0 p4p1: link up
[  822.573652] switch: port 1(p4p1) entered forwarding state
[  822.573656] switch: port 1(p4p1) entered forwarding state
[  823.939439]  connection1:0: detected conn error (1020)
[  825.917954] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  825.918416] ata4.00: configured for UDMA/133
[  825.918543] sd 3:0:0:0: [sdb] Starting disk
[  825.918745] PM: resume of devices complete after 5819.514 msecs
[  825.956448] PM: Finishing wakeup.
[  825.956449] Restarting tasks ... done.
[ 1516.473045] PM: Syncing filesystems ... done.
[ 1516.484656] PM: Preparing system for mem sleep
[ 1516.641700] Freezing user space processes ... (elapsed 0.01 seconds) d=
one.
[ 1516.654225] Freezing remaining freezable tasks ... (elapsed 0.01 secon=
ds) done.
[ 1516.665150] PM: Entering mem sleep
[ 1516.665341] Suspending console(s) (use no_console_suspend to debug)
[ 1516.665728] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[ 1516.665814] sd 3:0:0:0: [sdb] Stopping disk
[ 1516.666028] serial 00:09: disabled
[ 1516.666032] serial 00:09: System wakeup disabled by ACPI
[ 1516.666486] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 1516.667197] nouveau  [     DRM] suspending fbcon...
[ 1516.667204] nouveau  [     DRM] suspending display...
[ 1516.667209] nouveau  [     DRM] unpinning framebuffer(s)...
[ 1516.667227] nouveau  [     DRM] evicting buffers...
[ 1516.668111] sd 1:0:0:0: [sda] Stopping disk
[ 1517.306172] nouveau  [     DRM] waiting for kernel channels to go idle=
...
[ 1517.306177] nouveau  [     DRM] suspending client object trees...
[ 1517.306937] nouveau  [     DRM] suspending kernel object tree...
[ 1519.293349] PM: suspend of devices complete after 2632.776 msecs
[ 1519.293520] PM: late suspend of devices complete after 0.169 msecs
[ 1519.293732] pcieport 0000:00:09.0: System wakeup enabled by ACPI
[ 1519.304262] pcieport 0000:00:07.0: System wakeup enabled by ACPI
[ 1519.315181] pcieport 0000:00:04.0: System wakeup enabled by ACPI
[ 1519.326151] ehci-pci 0000:00:16.2: System wakeup enabled by ACPI
[ 1519.337094] ohci_hcd 0000:00:16.0: System wakeup enabled by ACPI
[ 1519.337136] ohci_hcd 0000:00:14.5: System wakeup enabled by ACPI
[ 1519.337203] ehci-pci 0000:00:13.2: System wakeup enabled by ACPI
[ 1519.348069] ohci_hcd 0000:00:13.0: System wakeup enabled by ACPI
[ 1519.348093] ehci-pci 0000:00:12.2: System wakeup enabled by ACPI
[ 1519.359053] ohci_hcd 0000:00:12.0: System wakeup enabled by ACPI
[ 1519.359140] PM: noirq suspend of devices complete after 65.740 msecs
[ 1519.359859] ACPI: Preparing to enter system sleep state S3
[ 1519.407218] PM: Saving platform NVS memory
[ 1519.409596] Disabling non-boot CPUs ...
[ 1519.411893] smpboot: CPU 1 is now offline
[ 1519.412127] CPU 1 offline: Remove Rx thread
[ 1519.412627] Broke affinity for irq 81
[ 1519.414390] smpboot: CPU 2 is now offline
[ 1519.414612] CPU 2 offline: Remove Rx thread
[ 1519.416154] smpboot: CPU 3 is now offline
[ 1519.416315] CPU 3 offline: Remove Rx thread
[ 1519.417728] smpboot: CPU 4 is now offline
[ 1519.417926] CPU 4 offline: Remove Rx thread
[ 1519.418706] Broke affinity for irq 18
[ 1519.418712] Broke affinity for irq 19
[ 1519.418724] Broke affinity for irq 23
[ 1519.419790] smpboot: CPU 5 is now offline
[ 1519.419946] CPU 5 offline: Remove Rx thread
[ 1519.422011] smpboot: CPU 6 is now offline
[ 1519.422159] CPU 6 offline: Remove Rx thread
[ 1519.423469] smpboot: CPU 7 is now offline
[ 1519.423629] CPU 7 offline: Remove Rx thread
[ 1519.426023] ACPI: Low-level resume complete
[ 1519.426053] PM: Restoring platform NVS memory
[ 1519.517208] microcode: CPU0: new patch_level=3D0x06000629
[ 1519.517249] Enabling non-boot CPUs ...
[ 1519.517279] smpboot: Booting Node 0 Processor 1 APIC 0x11
[ 1519.528722] LVT offset 0 assigned for vector 0x400
[ 1519.531102] bnx2i: CPU 1 online: Create Rx thread
[ 1519.531137] CPU1 is up
[ 1519.531152] smpboot: Booting Node 0 Processor 2 APIC 0x12
[ 1519.557588] microcode: CPU2: new patch_level=3D0x06000629
[ 1519.557591] bnx2i: CPU 2 online: Create Rx thread
[ 1519.557622] CPU2 is up
[ 1519.557637] smpboot: Booting Node 0 Processor 3 APIC 0x13
[ 1519.570957] bnx2i: CPU 3 online: Create Rx thread
[ 1519.570985] CPU3 is up
[ 1519.571000] smpboot: Booting Node 0 Processor 4 APIC 0x14
[ 1519.597458] microcode: CPU4: new patch_level=3D0x06000629
[ 1519.597461] bnx2i: CPU 4 online: Create Rx thread
[ 1519.597493] CPU4 is up
[ 1519.597508] smpboot: Booting Node 0 Processor 5 APIC 0x15
[ 1519.610873] bnx2i: CPU 5 online: Create Rx thread
[ 1519.610900] CPU5 is up
[ 1519.610915] smpboot: Booting Node 0 Processor 6 APIC 0x16
[ 1519.635572] microcode: CPU6: new patch_level=3D0x06000629
[ 1519.635575] bnx2i: CPU 6 online: Create Rx thread
[ 1519.635608] CPU6 is up
[ 1519.635623] smpboot: Booting Node 0 Processor 7 APIC 0x17
[ 1519.649072] bnx2i: CPU 7 online: Create Rx thread
[ 1519.649099] CPU7 is up
[ 1519.662029] ACPI: Waking up from system sleep state S3
[ 1519.706252] ohci_hcd 0000:00:12.0: System wakeup disabled by ACPI
[ 1519.716891] ehci-pci 0000:00:12.2: System wakeup disabled by ACPI
[ 1519.716912] ohci_hcd 0000:00:13.0: System wakeup disabled by ACPI
[ 1519.727862] ehci-pci 0000:00:13.2: System wakeup disabled by ACPI
[ 1519.738883] ohci_hcd 0000:00:14.5: System wakeup disabled by ACPI
[ 1519.738930] ohci_hcd 0000:00:16.0: System wakeup disabled by ACPI
[ 1519.749820] ehci-pci 0000:00:16.2: System wakeup disabled by ACPI
[ 1519.782781] pcieport 0000:00:07.0: System wakeup disabled by ACPI
[ 1519.804841] PM: noirq resume of devices complete after 98.922 msecs
[ 1519.804974] PM: early resume of devices complete after 0.086 msecs
[ 1519.805120] usb usb8: root hub lost power or was reset
[ 1519.805122] usb usb9: root hub lost power or was reset
[ 1519.805251] pcieport 0000:00:04.0: System wakeup disabled by ACPI
[ 1519.805291] pcieport 0000:00:09.0: System wakeup disabled by ACPI
[ 1519.805301] e1000e 0000:04:00.0: Disabling ASPM L0s L1
[ 1519.805338] e1000e 0000:04:00.0: irq 82 for MSI/MSI-X
[ 1519.805343] e1000e 0000:04:00.0: irq 83 for MSI/MSI-X
[ 1519.805348] e1000e 0000:04:00.0: irq 84 for MSI/MSI-X
[ 1519.808445] nouveau  [     DRM] re-enabling device...
[ 1519.808459] nouveau  [     DRM] resuming kernel object tree...
[ 1519.808465] nouveau  [   VBIOS][0000:01:00.0] running init tables
[ 1519.808501] snd_hda_intel 0000:06:00.1: irq 85 for MSI/MSI-X
[ 1519.809067] serial 00:09: activated
[ 1519.866193] xhci_hcd 0000:03:00.0: irq 73 for MSI/MSI-X
[ 1519.866198] xhci_hcd 0000:03:00.0: irq 74 for MSI/MSI-X
[ 1519.866202] xhci_hcd 0000:03:00.0: irq 75 for MSI/MSI-X
[ 1519.866206] xhci_hcd 0000:03:00.0: irq 76 for MSI/MSI-X
[ 1519.866211] xhci_hcd 0000:03:00.0: irq 77 for MSI/MSI-X
[ 1519.866215] xhci_hcd 0000:03:00.0: irq 78 for MSI/MSI-X
[ 1519.866219] xhci_hcd 0000:03:00.0: irq 79 for MSI/MSI-X
[ 1519.866223] xhci_hcd 0000:03:00.0: irq 80 for MSI/MSI-X
[ 1519.985150] nouveau E[  PTHERM][0000:01:00.0] unhandled intr 0x0000018=
1
[ 1519.985677] nouveau  [     DRM] resuming client object trees...
[ 1519.986270] nouveau  [     DRM] resuming display...
[ 1519.986959] r8169 0000:02:00.0 p4p1: link down
[ 1519.993703] switch: port 1(p4p1) entered disabled state
[ 1520.113115] ata1: SATA link down (SStatus 0 SControl 300)
[ 1520.113187] ata5: SATA link down (SStatus 0 SControl 300)
[ 1520.115113] ata3: SATA link down (SStatus 0 SControl 300)
[ 1520.115132] ata6: SATA link down (SStatus 0 SControl 300)
[ 1520.164085] usb 4-3: reset low-speed USB device number 2 using ohci_hc=
d
[ 1520.269818] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1520.271055] ata2.00: configured for UDMA/133
[ 1520.271185] sd 1:0:0:0: [sda] Starting disk
[ 1520.579300] usb 4-5: reset full-speed USB device number 3 using ohci_h=
cd
[ 1522.253555] r8169 0000:02:00.0 p4p1: link up
[ 1522.254031] switch: port 1(p4p1) entered forwarding state
[ 1522.254035] switch: port 1(p4p1) entered forwarding state
[ 1523.641461]  connection1:0: ping timeout of 5 secs expired, recv timeo=
ut 5, last rx 4296187248, last ping 4296192256, now 4296197264
[ 1523.641466]  connection1:0: detected conn error (1011)
[ 1525.612853] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1525.613321] ata4.00: configured for UDMA/133
[ 1525.613441] sd 3:0:0:0: [sdb] Starting disk
[ 1525.613640] PM: resume of devices complete after 5819.568 msecs
[ 1525.651154] PM: Finishing wakeup.
[ 1525.651156] Restarting tasks ... done.
[ 1527.093320] TCP: lp registered

--k+w/mQv8wyuph6w0--
