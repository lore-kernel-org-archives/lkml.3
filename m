Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKJLdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:33:25 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:50541 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaKJLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:33:23 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Mon, 10 Nov 2014 06:33:20 -0500
To: lkp@01.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [LKP] [sunrpc] WARNING: CPU: 1 PID: 1890 at lib/list_debug.c:36
 __list_add+0xcb/0xd0()
Message-ID: <20141110063320.344f6938@tlielax.poochiereds.net>
In-Reply-To: <20141110054026.GD1705@yliu-dev.sh.intel.com>
References: <20141110054026.GD1705@yliu-dev.sh.intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 13:40:26 +0800
lkp@01.org wrote:

> FYI, we noticed a wraning changes on
> 
> git://git.samba.org/jlayton/linux svc-pool-lock
> commit 3a41085d37f2374f6ae6539f5dca3d1d53e50431 ("sunrpc: search for a thread under RCU")
> 

Thanks. That branch has a bug in it (get_cpu leak) that is probably
responsible for this. I moved most of those patches to a different
branch last week and forgot to delete this one. Hopefully, the patches
in my nfsd-3.19 branch are OK.

> <5>[   21.635477] Key type id_legacy registered
> <4>[   21.638149] ------------[ cut here ]------------
> <4>[   21.638359] ------------[ cut here ]------------
> <4>[   21.638363] WARNING: CPU: 1 PID: 1890 at lib/list_debug.c:36 __list_add+0xcb/0xd0()
> <4>[   21.638364] list_add double add: new=ffff88007be38000, prev=ffff88007e835088, next=ffff88007be38000.
> <4>[   21.638376] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfsd auth_rpcgss ipmi_watchdog ipmi_msghandler sg sr_mod sd_mod cdrom ata_generic pata_acpi mxm_wmi pcspkr pata_marvell serio_raw firewire_ohci firewire_core ahci libahci crc_itu_t i2c_i801 libata parport_pc winbond_cir parport rc_core snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd wmi i7core_edac soundcore edac_core acpi_cpufreq
> <4>[   21.638377] CPU: 1 PID: 1890 Comm: nfsv4.0-svc Tainted: G          I    3.18.0-rc3-ga798bc5 #1
> <4>[   21.638378] Hardware name:                  /DX58SO, BIOS SOX5810J.86A.4196.2009.0715.1958 07/15/2009
> <4>[   21.638380]  0000000000000009 ffff88007bd03d48 ffffffff8188f71f 0000000025a825a8
> <4>[   21.638381]  ffff88007bd03d98 ffff88007bd03d88 ffffffff8106b3c1 ffff8800bf7c1b00
> <4>[   21.638381]  ffff88007be38000 ffff88007be38000 ffff88007e835088 ffff88007e835098
> <4>[   21.638382] Call Trace:
> <4>[   21.638385]  [<ffffffff8188f71f>] dump_stack+0x4e/0x68
> <4>[   21.638388]  [<ffffffff8106b3c1>] warn_slowpath_common+0x81/0xa0
> <4>[   21.638389]  [<ffffffff8106b426>] warn_slowpath_fmt+0x46/0x50
> <4>[   21.638390]  [<ffffffff8141932b>] __list_add+0xcb/0xd0
> <4>[   21.638392]  [<ffffffff8186c0da>] svc_recv+0x69a/0xa30
> <4>[   21.638399]  [<ffffffffa0270580>] ? nfs_callback_authenticate+0x50/0x50 [nfsv4]
> <4>[   21.638406]  [<ffffffffa0270580>] ? nfs_callback_authenticate+0x50/0x50 [nfsv4]
> <4>[   21.638412]  [<ffffffffa02705bb>] nfs4_callback_svc+0x3b/0x60 [nfsv4]
> <4>[   21.638414]  [<ffffffff8108ac0b>] kthread+0xdb/0x100
> <4>[   21.638415]  [<ffffffff8108ab30>] ? kthread_create_on_node+0x180/0x180
> <4>[   21.638417]  [<ffffffff81897afc>] ret_from_fork+0x7c/0xb0
> <4>[   21.638418]  [<ffffffff8108ab30>] ? kthread_create_on_node+0x180/0x180
> <4>[   21.638419] ---[ end trace a8ecfce57c7c54ab ]---
> <4>[   21.646613] WARNING: CPU: 2 PID: 1876 at lib/list_debug.c:36 __list_add+0xcb/0xd0()


-- 
Jeff Layton <jlayton@primarydata.com>
