Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3K0NNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:13:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:46940 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750972Ab3K0NNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:13:49 -0500
Date: Wed, 27 Nov 2013 08:13:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, bitbucket@online.de,
        benh@kernel.crashing.org, anton@samba.org, Morten.Rasmussen@arm.com,
        pjt@google.com, mikey@neuling.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUG] in sched fair on v3.13-rc1+ doing hotplug
Message-ID: <20131127081345.0cab8b15@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/m_sKg7FtHBf4Eatuz5lawCE"
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/m_sKg7FtHBf4Eatuz5lawCE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Running my tests on 3.13-rc1 I hit the following crash with my cpu
hotplug stress test (attached):

[   82.455572] BUG: unable to handle kernel paging request at 0000016d00000010
[   82.456109] IP: [<ffffffff81069183>] set_cpu_sd_state_idle+0x42/0x54
[   82.456109] PGD 0 
[   82.456109] Oops: 0000 [#1] PREEMPT SMP 
[   82.456109] Modules linked in: ipt_MASQUERADE sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_idt snd_hda_intel snd_hda_codec
 snd_hwdep kvm_intel kvm snd_seq snd_seq_device snd_pcm snd_page_alloc shpchp snd_timer snd microcode soundcore i2c_i801 pata_acpi firewire_ohci firewire_core crc_itu_t ata_generic
 i915 drm_kms_helper drm i2c_algo_bit i2c_core video
[   82.456109] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc1-test+ #33
[   82.456109] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[   82.456109] task: ffff88007a329290 ti: ffff88007a32a000 task.ti: ffff88007a32a000
[   82.456109] RIP: 0010:[<ffffffff81069183>]  [<ffffffff81069183>] set_cpu_sd_state_idle+0x42/0x54
[   82.456109] RSP: 0018:ffff88007a32bea8  EFLAGS: 00010246
[   82.456109] RAX: 0000016d00000000 RBX: 0000000000000003 RCX: ffff88007a32a000
[   82.456109] RDX: ffff88007d58d1f8 RSI: ffffffff8107a025 RDI: ffffffff8150104e
[   82.456109] RBP: ffff88007a32beb8 R08: ffff88007a32a000 R09: 0000000000000001
[   82.456109] R10: 0000000000000001 R11: 0000000000000400 R12: ffff88007a32a000
[   82.456109] R13: ffff88007a32bfd8 R14: 0000000000000000 R15: 0000000000000000
[   82.456109] FS:  0000000000000000(0000) GS:ffff88007d580000(0000) knlGS:0000000000000000
[   82.456109] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.456109] CR2: 0000016d00000010 CR3: 0000000077e9a000 CR4: 00000000000007e0
[   82.456109] Stack:
[   82.456109]  ffff88007a32a000 ffff88007a32a000 ffff88007a32bed8 ffffffff8108b38e
[   82.456109]  ffffffff8150104e ffff88007a32a000 ffff88007a32bf18 ffffffff81079ed3
[   82.456109]  ffff88007a32bf08 2c5c9774106fa5f0 50a2f20e3f906ad7 000000000000cd80
[   82.456109] Call Trace:
[   82.456109]  [<ffffffff8108b38e>] tick_nohz_idle_enter+0x38/0x6d
[   82.456109]  [<ffffffff8150104e>] ? schedule_preempt_disabled+0x22/0x24
[   82.456109]  [<ffffffff81079ed3>] cpu_startup_entry+0x77/0x1d0
[   82.456109]  [<ffffffff810263c1>] start_secondary+0x254/0x25b
[   82.456109] Code: 48 63 c3 48 c7 c2 f8 d1 00 00 48 03 14 c5 30 ea ac 81 48 8b 02 48 85 c0 74 19 83 78 4c 00 75 13 c7 40 4c 01 00 00 00 48 8b 40 10 <48> 8b 40 10 f0 ff 48 1c e8 05 58 01 00 41 5b 5b 5d c3 66 66 66 
[   82.456109] RIP  [<ffffffff81069183>] set_cpu_sd_state_idle+0x42/0x54
[   82.456109]  RSP <ffff88007a32bea8>
[   82.456109] CR2: 0000016d00000010
[   82.456109] ---[ end trace 725ad8735a6099b4 ]---
[   82.456109] Kernel panic - not syncing: Attempted to kill the idle task!

According to gdb, the bug happened here:

static inline void set_cpu_sd_state_busy(void)
{
        struct sched_domain *sd;
        int cpu = smp_processor_id();

        rcu_read_lock();
        sd = rcu_dereference(per_cpu(sd_busy, cpu));

        if (!sd || !sd->nohz_idle)
                goto unlock;
        sd->nohz_idle = 0;

        atomic_inc(&sd->groups->sgp->nr_busy_cpus);  <<---- BUG
unlock:
        rcu_read_unlock();
}



I bisected it down to this commit:

commit 37dc6b50cee97954c4e6edcd5b1fa614b76038ee
Author: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date:   Wed Oct 30 08:42:52 2013 +0530

    sched: Remove unnecessary iteration over sched domains to update nr_busy_cpus

I can send a config if you want.

-- Steve

--MP_/m_sKg7FtHBf4Eatuz5lawCE
Content-Type: application/octet-stream; name=stress-cpu-hotplug
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=stress-cpu-hotplug

IyEvYmluL2Jhc2gKCk1BWENQVVM9MTIKCiMgZmluZCBjcHVzCgpDUFVTPWBscyAtZCAvc3lzL2Rl
dmljZXMvc3lzdGVtL2NwdS9jcHVbMS05XSpgCk5SPWBlY2hvICRDUFVTIHwgd2MgLXdgCgpsZXQg
eD0wCmZvciBjcHUgaW4gJENQVVM7IGRvCiAgICBmaWxlPSRjcHUvb25saW5lCiAgICBDUFVPTkxJ
TkVbJHhdPSRmaWxlCiAgICBFTkJbJHhdPWBjYXQgJGZpbGVgCiAgICBDUFVbJHhdPWBiYXNlbmFt
ZSAkY3B1YAogICAgbGV0IHg9JHgrMQpkb25lCgpsZXQgTUFYQ05UPSR4CgpNU0tDTlQ9JE1BWENO
VAoKaWYgWyAkTUFYQ05UIC1ndCAkTUFYQ1BVUyBdOyB0aGVuCiAgICBNU0tDTlQ9JE1BWENQVVMK
ZmkKCmxldCBNU0tDTlQ9MioqJE1TS0NOVAoKaG90cGx1ZygpIHsKICAgIE1TSz0kMQogICAgRUNI
Tz0iJE1TSyIKICAgIENNRD0iIgogICAgeD0wCiAgICB3aGlsZSBbICRNU0sgLWd0IDAgXTsgZG8K
CWxldCBiaXQ9JE1TSycmJzEKCWlmIFsgJGJpdCAtZXEgMSBdOyB0aGVuCgkgICAgaWYgWyAke0VO
QlskeF19IC1lcSAxIF07IHRoZW4KCQljbWQ9ImRpc2FibGluZyIKCQlFTkJbJHhdPTAKCQludW09
MAoJICAgIGVsc2UKCQljbWQ9ImVuYWJsaW5nIgoJCUVOQlskeF09MQoJCW51bT0xCgkgICAgZmkK
CSAgICBDTUQ9IiRDTUQgZWNobyAkbnVtID4gJHtDUFVPTkxJTkVbJHhdfTsiCgkgICAgRUNITz0i
JEVDSE8gJGNtZCAke0NQVVskeF19IgoJZmkKCWxldCB4PSR4KzEKCWxldCBNU0s9JE1TSyc+Picx
CiAgICBkb25lCiAgICBlY2hvICRFQ0hPCiAgICBldmFsICRDTUQKfQoKbGV0IE1TS0NOVD0kTVNL
Q05ULTEKZm9yIGkgaW4gYHNlcSAkTVNLQ05UYDsgZG8KICAgIGhvdHBsdWcgJGkKZG9uZQpmb3Ig
aSBpbiBgc2VxICRNU0tDTlRgOyBkbwogICAgaG90cGx1ZyAkaQpkb25lCgpleGl0IDAK

--MP_/m_sKg7FtHBf4Eatuz5lawCE--
