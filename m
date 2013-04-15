Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3DOBaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:30:23 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42867 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3DOBaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:30:20 -0400
MIME-Version: 1.0
Date: Sun, 14 Apr 2013 18:30:17 -0700
X-Google-Sender-Auth: 4OC5JJkSi2TvD1A7BaxGeIPj6fg
Message-ID: <CA+55aFx3oLCxZ=cVBf0AeNhnf=5nk6brbgF9OTH6W05_gAbuiw@mail.gmail.com>
Subject: Linux 3.9-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

This is mostly random one-liners, with a few slightly larger driver
fixes. The most interesting (to me, probably to nobody else) fix is a
fix for a rather subtle TLB invalidate bug that only hits 32-bit PAE
due to the weird way that works. Even then it only hits you if you
have some particularly insane mapping patterns, but we *suspect* that
this one might be the cause behind google chrome having triggered bugs
like

        chrome: Corrupted page table at address 34a03000
        *pdpt = 0000000000000000 *pde = 0000000000000000
        Bad pagetable: 000f [#1] PREEMPT SMP

however, the problem is so rare that we haven't been able to verify
that this really fixes it.

That said, this bug is much more common (and by "much more common" I
mean "still basically impossible to hit unless you were really
unlucky") on newer machines that have bigger TLB's and that could
happily have run in 64-bit mode without the disgusting abortion that
is x86 PAE, and a small part of me feels that anybody who hit this
problem on such a machine probably got whatever they deserved.

But if you've seen messages like this, and you still run PAE, give the
new -rc a try.

The rest of the fixes are probably more relevant to most people, but
hey, the PAE oen tickles my fancy. Anyway, go out and test regardless
of the PAE issue,

                        Linus

---

Al Viro (3):
      ecryptfs: close rmmod race
      procfs: add proc_remove_subtree()
      palinfo fixes

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Alex Williamson (1):
      vfio-pci: Fix possible integer overflow

Alexandre Belloni (1):
      gpio: pca953x: fix irq_domain_add_simple usage

Alexey Khoroshilov (1):
      tty: mxser: fix cycle termination condition in mxser_probe() and
mxser_module_init()

Alexey Pelykh (1):
      OMAP/serial: Revert bad fix of Rx FIFO threshold granularity

Andrea Arcangeli (2):
      x86/mm/cpa: Convert noop to functional fix
      x86/mm/cpa/selftest: Fix false positive in CPA self test

Andrey Vagin (1):
      mnt: release locks on error path in do_loopback

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Artem Savkov (1):
      cfg80211: sched_scan_mtx lock in cfg80211_conn_work()

Arun Easi (1):
      [SCSI] qla2xxx: Fix crash during firmware dump procedure.

Asai Thambi S P (3):
      mtip32xx: recovery from command timeout
      mtip32xx: return 0 from pci probe in case of rebuild
      mtip32xx: Add debugfs entry device_status

Asias He (7):
      tcm_vhost: Use ACCESS_ONCE for vs->vs_tpg[target] access
      tcm_vhost: Use vq->private_data to indicate if the endpoint is setup
      tcm_vhost: Initialize vq->last_used_idx when set endpoint
      tcm_vhost: Remove double check of response
      tcm_vhost: Fix tv_cmd leak in vhost_scsi_handle_vq
      tcm_vhost: Add vhost_scsi_send_bad_target() helper
      tcm_vhost: Send bad target to guest when cmd fails

Bing Zhao (1):
      mwifiex: complete last internal scan

Boris Ostrovsky (2):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
      x86/mm: Flush lazy MMU when DEBUG_PAGEALLOC is set

Brian King (1):
      [SCSI] ibmvscsi: Fix slave_configure deadlock

Calvin Owens (1):
      drm/nouveau: fix unconditional return waiting on memory

Charles Keepax (1):
      ASoC: compress: Cancel delayed power down if needed

Chen Gang (3):
      perf: Fix strncpy() use, always make sure it's NUL terminated
      perf: Fix strncpy() use, use strlcpy() instead of strncpy()
      ftrace: Fix strncpy() use, use strlcpy() instead of strncpy()

Chris Metcalf (1):
      tile: comment assumption about __insn_mtspr for <asm/irqflags.h>

Christian Ruppert (1):
      ARC: Add implicit compiler barrier to raw_local_irq* functions

Christoph Paasch (1):
      ipv6/tcp: Stop processing ICMPv6 redirect messages

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex,
not decimal.

Chuck Lever (1):
      SUNRPC: Remove extra xprt_put()

Daniel Vetter (1):
      drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event

Dave Airlie (1):
      udl: handle EDID failure properly.

Dave Hansen (1):
      x86-32: Fix possible incomplete TLB invalidate with PAE pagetables

David Woodhouse (1):
      libata: fix DMA to stack in reading devslp_timing parameters

Dirk Behme (1):
      ARM i.MX6: Fix ldb_di clock selection

Dirk Brandewie (1):
      cpufreq / intel_pstate: Set timer timeout correctly

Dmitry Tarnyagin (1):
      remoteproc/ste: fix memory leak on shutdown

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Eric Dumazet (1):
      selinux: add a skb_owned_by() hook

Franky Lin (1):
      brcmfmac: do not proceed if fail to download nvram to dongle

Gabor Juhos (1):
      rt2x00: rt2x00pci: fix build error on Ralink RT3x5x SoCs

Greg Ungerer (1):
      m68k: define a local gpio_request_one() function

Gregory CLEMENT (1):
      arm: mvebu: Fix the irq map function in SMP mode

Guennadi Liakhovetski (1):
      tty: Documentation: fix a path in a DocBook template

Guenter Roeck (1):
      misc/vmw_vmci: Add dependency on CONFIG_NET

Haiyang Zhang (2):
      hyperv: Fix a kernel warning from netvsc_linkstatus_callback()
      hyperv: Fix RNDIS send_completion code path

Hante Meuleman (3):
      brcmfmac: fix tkip mic tx/rx ap swap bug.
      brcmfmac: fix stopping AP.
      brcmfmac: fix returning cipher_suite for get_key operation.

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jens Axboe (2):
      mtip32xx: fix two smatch warnings
      Revert "loop: cleanup partitions when detaching loop device"

Jiri Pirko (2):
      net: ipv4: reset check_lifetime_work after changing lifetime
      net: ipv4: fix schedule while atomic bug in check_lifetime()

Joe Carnuccio (1):
      [SCSI] Revert "qla2xxx: Add setting of driver version string for
vendor application."

Joe Lawrence (1):
      [SCSI] st: Take additional queue ref in st_probe

John Gong (1):
      [SCSI] libsas: use right function to alloc smp response

Joonyoung Shim (1):
      ASoC: core: Fix to check return value of snd_soc_update_bits_locked()

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Kleber Sacilotto de Souza (1):
      [SCSI] ipr: fix addition of abort command to HRRQ free queue

Konrad Rzeszutek Wilk (1):
      xen/mmu: On early bootup, flush the TLB when changing RO->RW
bits Xen provided pagetables.

Krzysztof Mazur (1):
      [libata] Fix HDIO_DRIVE_* ioctl() Linux 3.9 regression

Lars-Peter Clausen (1):
      ASoC: tegra: Don't claim to support PCM pause and resume

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (4):
      spinlocks and preemption points need to be at least compiler barriers
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
      Add file_ns_capable() helper function for open-time capability checking
      Linux 3.9-rc7

Linus Walleij (1):
      crypto: ux500 - add missing comma

Lukasz Dorau (1):
      [SCSI] libsas: fix handling vacant phy in sas_set_ex_phy()

Marek Vasut (1):
      ARM: mxs: Slow down the I2C clock speed

Mark Brown (3):
      ASoC: wm5102: Correct lookup of arizona struct in SYSCLK event
      regmap: Back out work buffer fix
      MAINTAINERS: Update e-mail address

Mark Salter (1):
      add memory barrier to arch_local_irq_restore

Markus Pargmann (2):
      ARM: clk-imx35: Bugfix iomux clock
      ARM: imx35 Bugfix admux clock

Mathias Krause (16):
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in
rfcomm_sock_recvmsg()
      Bluetooth: SCO - Fix missing msg_namelen update in sco_sock_recvmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      l2tp: fix info leak in l2tp_ip6_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream
      VSOCK: vmci - fix possible info leak in vmci_transport_dgram_dequeue()
      VSOCK: Fix missing msg_namelen update in vsock_stream_recvmsg()

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition
being performed before the ANDCOND test

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Neil Horman (1):
      e100: Add dma mapping error check

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Nicolas Ferre (1):
      watchdog: Revert the AT91RM9200_WATCHDOG dependency

Nigel Roberts (2):
      ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED
      Fix GE0/GE1 init on ix2-200 as GE0 has no PHY

Padmavathi Venna (1):
      DMA: PL330: Add check if device tree compatible

Paul Moore (1):
      lsm: add the missing documentation for the security_skb_owned_by() hook

Peter Ujfalusi (1):
      dmaengine: omap-dma: Start DMA without delay for cyclic channels

Prathyush K (2):
      ASoC: Samsung: return error if drvdata is not set
      ASoC: Samsung: set drvdata before adding secondary device

Robert Shade (1):
      ath9k: Re-enable interrupts after a channel change failure

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Roland Stigge (1):
      MAINTAINERS: Add maintainer for LPC32xx

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Saurav Kashyap (3):
      [SCSI] qla2xxx: Update copyright dates information in
LICENSE.qla2xxx file.
      [SCSI] qla2xxx: Remove debug code that msleeps for random duration.
      [SCSI] qla2xxx: Update the driver version to 8.04.00.13-k.

Sean Young (1):
      Revert "tty/8250_pnp: serial port detection regression since v3.7"

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Shawn Guo (1):
      ARM: imx: provide twd clock lookup from device tree

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev

Sridhar Samudrala (1):
      sctp: remove 'sridhar' from maintainers list

Stanislaw Gruszka (1):
      sched/cputime: Fix accounting on multi-threaded processes

Stefan Raspl (1):
      qeth: fix qeth_wait_for_threads() deadlock for OSN devices

Stephane Eranian (2):
      perf/x86: Fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
      perf: Fix ring_buffer perf_output_space() boundary calculation

Steven Rostedt (Red Hat) (3):
      tracing: Fix race with update_max_tr_single and changing tracers
      ftrace: Do not call stub functions in control loop
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Suman Anna (1):
      remoteproc: fix the error check for idr_alloc

Sylwester Nawrocki (2):
      ARM: S3C24XX: Correct NR_IRQS definition for s3c2440
      ARM: S3C24XX: Fix interrupt pending register offset of the EINT controller

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Trond Myklebust (5):
      NFSv4: Fix a memory leak in nfs4_discover_server_trunking
      NFSv4/4.1: Fix bugs in nfs4[01]_walk_client_list
      SUNRPC: Fix a potential memory leak in rpc_new_client
      NFSv4: Fix another potential state manager deadlock
      NFSv4: Doh! Typo in the fix to nfs41_walk_client_list

Ursula Braun (1):
      af_iucv: fix recvmsg by replacing skb_pull() function

Wei Yongjun (4):
      netrom: fix invalid use of sizeof in nr_recvmsg()
      can: gw: use kmem_cache_free() instead of kfree()
      [SCSI] lpfc: fix potential NULL pointer dereference in lpfc_sli4_rq_put()
      perf: Fix error return code

Yaniv Rosner (1):
      bnx2x: Fix KR2 rapid link flap

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

Yuval Mintz (1):
      bnx2x: Prevent null pointer dereference in AFEX mode

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow

nikolay@redhat.com (2):
      Revert "bonding: remove sysfs before removing devices"
      bonding: fix bonding_masters race condition in bond unloading

wenxiong@linux.vnet.ibm.com (2):
      [SCSI] ipr: ipr_test_msi() fails when running with msi-x enabled adapter
      [SCSI] ipr: dlpar failed when adding an adapter back

willy tarreau (1):
      net: mvneta: enable features before registering the driver
