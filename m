Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3IZCKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:10:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42097 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755105Ab3IZCKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:10:31 -0400
Date: Wed, 25 Sep 2013 22:10:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace eperm BUG.
Message-ID: <20130925221025.3aa1db07@gandalf.local.home>
In-Reply-To: <20130926014112.GA1991@redhat.com>
References: <20130926014112.GA1991@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Can you give me any more information on this? Like what you did to
trigger it. Was it just loading the fuse module? Or was there more
involved. Also, what kernel and what config?

Thanks,

-- Steve


On Wed, 25 Sep 2013 21:41:12 -0400
Dave Jones <davej@redhat.com> wrote:

> WARNING: CPU: 0 PID: 30602 at kernel/trace/ftrace.c:1701 ftrace_bug+0x206/0x270()
> Modules linked in: fuse(+) bnep rfcomm hidp ipt_ULOG scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can_raw can_bcm can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq xfs crct10dif_pclmul crc32c_intel libcrc32c snd_seq_device ghash_clmulni_intel snd_pcm snd_page_alloc e1000e snd_timer usb_debug microcode pcspkr serio_raw snd ptp pps_core shpchp soundcore
> CPU: 0 PID: 30602 Comm: modprobe Not tainted 3.12.0-rc2+ #85 
>  ffffffff81a2ab24 ffff880238b2dc30 ffffffff81729bb7 0000000000000000
>  ffff880238b2dc68 ffffffff8105523d 0000000000000000 ffffffffa0514000
>  ffff88022e3a2f78 0000000000000000 ffff88022e187000 ffff880238b2dc78
> Call Trace:
>  [<ffffffff81729bb7>] dump_stack+0x4e/0x82
>  [<ffffffff8105523d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffffa0514000>] ? 0xffffffffa0513fff
>  [<ffffffff8105531a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff811206e6>] ftrace_bug+0x206/0x270
>  [<ffffffffa0514000>] ? 0xffffffffa0513fff
>  [<ffffffff81120a5c>] ftrace_process_locs+0x30c/0x640
>  [<ffffffff81120dce>] ftrace_module_notify_enter+0x3e/0x50
>  [<ffffffff817382a6>] notifier_call_chain+0x66/0x150
>  [<ffffffff8108b107>] __blocking_notifier_call_chain+0x67/0xc0
>  [<ffffffff8108b176>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff810dad4d>] load_module+0x1f7d/0x26a0
>  [<ffffffff810d5f00>] ? store_uevent+0x40/0x40
>  [<ffffffff810db606>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8173cce4>] tracesys+0xdd/0xe2
> ---[ end trace 47a8e162ec529291 ]---
> ftrace faulted on writing [<ffffffffa0514000>] fuse_dev_pipe_buf_steal+0x0/0x10 [fuse]
> 
> <total lock-up>

