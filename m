Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaEARgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:36:24 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59563 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaEARgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:36:22 -0400
Message-ID: <1398965778.5439.7.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Date: Thu, 01 May 2014 19:36:18 +0200
In-Reply-To: <20140430114819.03e8c6ce@gandalf.local.home>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
	 <1398520699.28726.22.camel@marge.simpson.net>
	 <1398661784.30930.33.camel@marge.simpson.net>
	 <1398676186.30930.49.camel@marge.simpson.net>
	 <20140428101805.75032f45@gandalf.local.home>
	 <1398695832.14475.10.camel@marge.simpson.net>
	 <1398748869.5514.81.camel@marge.simpson.net>
	 <20140429201308.63292691@gandalf.local.home>
	 <1398843793.26071.52.camel@marge.simpson.net>
	 <1398863189.26071.97.camel@marge.simpson.net>
	 <20140430091550.1177bc90@gandalf.local.home>
	 <1398866403.26071.125.camel@marge.simpson.net>
	 <20140430101919.70b2f622@gandalf.local.home>
	 <20140430103308.1e46dd18@gandalf.local.home>
	 <1398869686.26071.151.camel@marge.simpson.net>
	 <20140430111100.72a7a71b@gandalf.local.home>
	 <1398870957.5220.2.camel@marge.simpson.net>
	 <20140430114819.03e8c6ce@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:48 -0400, Steven Rostedt wrote: 
> On Wed, 30 Apr 2014 17:15:57 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > On Wed, 2014-04-30 at 11:11 -0400, Steven Rostedt wrote:
> > 
> > > > Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
> > > > should be while (atomic_read(&done.nr_todo)) 
> > > > 
> > > > @@ -647,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
> > > >         ret = multi_cpu_stop(&msdata);
> > > > 
> > > >         /* Busy wait for completion. */
> > > > -       while (!completion_done(&done.completion))
> > > > +       while (!atomic_read(&done.nr_todo))
> >                    ^--- that ! needs to go away 
> > > 
> > > I don't see this in the code. That is, there is no "completion_done()"
> > > in stop_machine_from_inactive_cpu(). It is already an atomic_read().
> > 
> > Yes, but it should read "while (atomic_read(&done.nr_todo))"
> 
> Ah, this would have been better if you had sent a patch. I misread what
> you talked about.
> 
> Yes, this was the culprit of my failures. After removing the '!', it
> worked.

Hah!  I knew you were just hiding, you sneaky little SOB ;-)


[50661.070049] smpboot: Booting Node 0 Processor 15 APIC 0x36
[50661.142381] kvm: enabling virtualization on CPU15
[50661.142397] BUG: unable to handle kernel NULL pointer dereference at           (null)
[50661.142417] IP: [<ffffffff810922f1>] wake_up_process+0x1/0x40
[50661.142420] PGD 0
[50661.142422] Oops: 0000 [#1] PREEMPT SMP
[50661.142470] Modules linked in: nfsd(F) lockd(F) nfs_acl(F) auth_rpcgss(F) sunrpc(F) autofs4(F) binfmt_misc(F) edd(F) af_packet(F) bridge(F) stp(F) llc(F) cpufreq_conservative(F) cpufreq_ondemand(F) cpufreq_userspace(F) cpufreq_powersave(F) pcc_cpufreq(F) fuse(F) loop(F) md_mod(F) dm_mod(F) iTCO_wdt(F) iTCO_vendor_support(F) gpio_ich(F) vhost_net(F) macvtap(F) macvlan(F) vhost(F) tun(F) i7core_edac(F) netxen_nic(F) kvm_intel(F) joydev(F) shpchp(F) edac_core(F) hid_generic(F) kvm(F) ipmi_si(F) sr_mod(F) ipmi_msghandler(F) bnx2(F) cdrom(F) sg(F) hpilo(F) hpwdt(F) ehci_pci(F) lpc_ich(F) mfd_core(F) acpi_power_meter(F) pcspkr(F) button(F) ext4(F) jbd2(F) mbcache(F) crc16(F) usbhid(F) uhci_hcd(F) ehci_hcd(F) usbcore(F) sd_mod(F) usb_common(F) thermal(F) processor(F) scsi_dh_rdac(F) scsi_dh_alua(F) scsi_dh_emc(F)
[50661.142475]  scsi_dh_hp_sw(F) scsi_dh(F) ata_generic(F) ata_piix(F) libata(F) cciss(F) hpsa(F) scsi_mod(F)
[50661.142479] CPU: 39 PID: 283 Comm: migration/39 Tainted: GF            3.14.2-rt1 #667
[50661.142481] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[50661.142482] task: ffff880274515bb0 ti: ffff88027454e000 task.ti: ffff88027454e000
[50661.142486] RIP: 0010:[<ffffffff810922f1>]  [<ffffffff810922f1>] wake_up_process+0x1/0x40
[50661.142487] RSP: 0018:ffff88027454fda8  EFLAGS: 00010002
[50661.142488] RAX: 0000000080000001 RBX: ffff880275581eb8 RCX: 0000000000000000
[50661.142488] RDX: ffffffff81aacec0 RSI: 0000000000000100 RDI: 0000000000000000
[50661.142489] RBP: ffff8802772ee9b0 R08: 0000000000000000 R09: ffffffff81aacec0
[50661.142490] R10: 0000000000000000 R11: ffffffff8103d640 R12: ffffffff810f26c0
[50661.142490] R13: ffff880275581e88 R14: ffff8802772ee9b8 R15: ffff88027454e010
[50661.142492] FS:  0000000000000000(0000) GS:ffff8802772e0000(0000) knlGS:0000000000000000
[50661.142493] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[50661.142494] CR2: 0000000000000000 CR3: 0000000001a0f000 CR4: 00000000000007e0
[50661.142494] Stack:
[50661.142505]  ffff880275581eb8 ffffffff810f2555 ffff880274515bb0 0000000000000005
[50661.142508]  0000000000000001 0000000000000001 0140000000000000 0000000000000001
[50661.142512]  ffff880274515bb0 ffff88027454e000 ffff8802772f4020 0000000000000005
[50661.142512] Call Trace:
[50661.142526]  [<ffffffff810f2555>] ? cpu_stopper_thread+0x125/0x1a0
[50661.142530]  [<ffffffff8108ba2d>] ? smpboot_thread_fn+0x23d/0x320
[50661.142533]  [<ffffffff8108b7f0>] ? smpboot_create_threads+0x70/0x70
[50661.142535]  [<ffffffff8108b7f0>] ? smpboot_create_threads+0x70/0x70
[50661.142543]  [<ffffffff81083c32>] ? kthread+0xd2/0xe0
[50661.142545]  [<ffffffff81083b60>] ? kthreadd+0x330/0x330
[50661.142553]  [<ffffffff815337cc>] ? ret_from_fork+0x7c/0xb0
[50661.142555]  [<ffffffff81083b60>] ? kthreadd+0x330/0x330
[50661.142568] Code: fd ff ff 0f 1f 80 00 00 00 00 31 d2 e9 09 fd ff ff 66 0f 1f 84 00 00 00 00 00 ba 08 00 00 00 be 0f 00 00 00 e9 f1 fc ff ff 90 53 <48> 8b 07 48 89 fb a8 0c 75 08 48 8b 47 08 a8 0c 74 11 be ba 06
[50661.142570] RIP  [<ffffffff810922f1>] wake_up_process+0x1/0x40
[50661.142570]  RSP <ffff88027454fda8>
[50661.142571] CR2: 0000000000000000


