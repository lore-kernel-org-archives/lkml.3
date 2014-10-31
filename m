Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbaJaRim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:38:42 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55154 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756894AbaJaRil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:38:41 -0400
Message-ID: <5453C91D.9060702@hurleysoftware.com>
Date: Fri, 31 Oct 2014 13:38:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: 3.17.2. issue?
References: <5453AE33.8040802@xs4all.nl>
In-Reply-To: <5453AE33.8040802@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Hans Verkuil, Mauro Carvalho Chehab, linux-media ]

On 10/31/2014 11:43 AM, Udo van den Heuvel wrote:
> Hello,
> 
> Booting into 3.17.2 on one box I saw:
> 
> [   15.070260] microcode: CPU0: patch_level=0x010000b7
> [   15.279454] Linux video capture interface: v2.00
> [   15.315043] microcode: CPU0: new patch_level=0x010000c7
> [   15.319519] microcode: CPU1: patch_level=0x010000b7
> [   15.323966] microcode: CPU1: new patch_level=0x010000c7
> [   15.328493] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   15.750724] saa7146: register extension 'budget_av'
> [   15.757205] ------------[ cut here ]------------
> [   15.763300] WARNING: CPU: 0 PID: 468 at fs/proc/generic.c:341
> __proc_create+0x1a4/0x1c0()
> [   15.769475] name len 0
> [   15.774046] Modules linked in: budget_av(+) saa7146_vv
> videobuf_dma_sg videobuf_core v4l2_common videodev budget_core microcode
> ttpci_eeprom saa7146 dvb_core snd_hda_codec_realtek snd_hda_codec_hdmi
> snd_hda_codec_generic cp210x snd_hda_intel usbserial k10temp
> snd_hda_controller evdev snd_hda_codec snd_seq snd_seq_device snd_pcm
> i2c_piix4 snd_timer snd acpi_cpufreq processor button nfsd auth_rpcgss
> oid_registry exportfs nfs_acl lockd sunrpc hid_generic usbhid hid
> ata_generic ehci_pci ehci_hcd ohci_pci ohci_hcd sr_mod cdrom radeon
> fbcon bitblit softcursor font cfbfillrect cfbimgblt cfbcopyarea
> backlight drm_kms_helper ttm autofs4
> [   15.794125] CPU: 0 PID: 468 Comm: systemd-udevd Not tainted
> 3.17.2test-dirty #7
> [   15.799155] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./To be filled by O.E.M., BIOS 080015  05/04/2010
> [   15.804586]  0000000000000009 ffffffff81461238 ffff8800cf69ba60
> ffffffff81056271
> [   15.809771]  ffff8800cf69bb00 ffff8800cf69bab0 0000000000000002
> 000000000000416d
> [   15.814957]  0000000000000000 ffffffff810562e7 ffffffff8156510b
> ffffffff00000020
> [   15.820188] Call Trace:
> [   15.825314]  [<ffffffff81461238>] ? dump_stack+0x49/0x6a
> [   15.830457]  [<ffffffff81056271>] ? warn_slowpath_common+0x81/0xb0
> [   15.835535]  [<ffffffff810562e7>] ? warn_slowpath_fmt+0x47/0x50
> [   15.840565]  [<ffffffff81179c74>] ? __proc_create+0x1a4/0x1c0
> [   15.845613]  [<ffffffff81179f5f>] ? proc_mkdir_data+0x2f/0x70
> [   15.850605]  [<ffffffff81092b74>] ? register_handler_proc+0x114/0x130
> [   15.855497]  [<ffffffff8108f87b>] ? __setup_irq+0x3cb/0x500
> [   15.860273]  [<ffffffffa0362da0>] ? saa7146_remove_one+0x1c0/0x1c0
> [saa7146]
> [   15.865007]  [<ffffffff8108fb21>] ? request_threaded_irq+0xd1/0x170
> [   15.869728]  [<ffffffffa03630f3>] ? saa7146_init_one+0x103/0x740
> [saa7146]
> [   15.874377]  [<ffffffff81271158>] ? pci_device_probe+0x98/0xf0
> [   15.878911]  [<ffffffff81305356>] ? driver_probe_device+0x86/0x270
> [   15.883317]  [<ffffffff81305633>] ? __driver_attach+0x93/0xa0
> [   15.887659]  [<ffffffff813055a0>] ? __device_attach+0x60/0x60
> [   15.891919]  [<ffffffff81303653>] ? bus_for_each_dev+0x53/0x90
> [   15.896107]  [<ffffffff81304b68>] ? bus_add_driver+0x188/0x240
> [   15.900246]  [<ffffffffa0400000>] ? 0xffffffffa0400000
> [   15.904359]  [<ffffffff813059e6>] ? driver_register+0x56/0xd0
> [   15.908454]  [<ffffffff810002b4>] ? do_one_initcall+0x84/0x1b0
> [   15.912567]  [<ffffffff810b0774>] ? load_module+0x1c34/0x2190
> [   15.916648]  [<ffffffff810ad3c0>] ? store_uevent+0x50/0x50
> [   15.920716]  [<ffffffff810b0e25>] ? SyS_finit_module+0x85/0x90
> [   15.924768]  [<ffffffff81466092>] ? system_call_fastpath+0x16/0x1b
> [   15.928925] ---[ end trace b6ff19cfd9b0c411 ]---
> [   15.932953] saa7146: found saa7146 @ mem ffffc90000020c00 (revision
> 1, irq 20) (0x153b,0x1157)
> [   15.937071] saa7146 (0): dma buffer size 192512
> [   15.937071] saa7146 (0): dma buffer size 192512
> [   15.941161] DVB: registering new adapter (Terratec Cinergy 1200 DVB-T)
> [   15.981742] adapter failed MAC signature check
> [   15.987499] encoded MAC from EEPROM was
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> [   16.256557] budget_av: KNC1-0: MAC addr = 00:0a:ac:01:d6:87
> [   16.617698] budget_av 0000:03:05.0: DVB: registering adapter 0
> frontend 0 (Philips TDA10046H DVB-T)...
> [   16.624394] budget_av: ci interface initialised
> [   17.053409] EXT4-fs (dm-3): mounted filesystem with ordered data
> mode. Opts: (null)
> 
> What happened?
> 
> Kind regards,
> Udo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

