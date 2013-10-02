Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3JBQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3JBQxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:53:19 -0400
Date: Wed, 2 Oct 2013 12:53:08 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20131002165308.GC17276@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828111746.35369b84@gandalf.local.home>
 <20130828182710.GA14103@redhat.com>
 <20130828182902.GB14103@redhat.com>
 <20130828152745.18a73c4e@gandalf.local.home>
 <20130930171201.GA10474@redhat.com>
 <1380599766.16752.6.camel@pippen.local.home>
 <20131001042025.GA7038@redhat.com>
 <1380630531.16752.9.camel@pippen.local.home>
 <20131002141650.GA11305@redhat.com>
 <1380732206.12351.4.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380732206.12351.4.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:43:26PM -0400, Steven Rostedt wrote:
 
 > > I keep hititng that other ftrace bug instead:
 > > 
 > > WARNING: CPU: 2 PID: 15596 at kernel/trace/ftrace.c:1701 ftrace_bug+0x206/0x270()
 > > Modules linked in: snd_seq_dummy(+) rfcomm hidp bnep nfnetlink scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc can_raw can_bcm bluetooth rfkill can llc2 pppoe ppp
 > > ox ppp_generic slhc irda crc_ccitt rds ipt_ULOG af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 coretemp hwmon x86_pkg_temp_thermal kvm_intel xfs kvm libcrc32c snd_hda_codec_hdm
 > > i snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul snd_seq_device crc32c_intel ghash_clmulni_intel snd_pcm e1000e microcode serio_raw pcspkr snd_page_alloc shpch
 > > p usb_debug snd_timer ptp snd pps_core soundcore
 > > CPU: 2 PID: 15596 Comm: modprobe Not tainted 3.12.0-rc3+ #92 
 > >  ffffffff81a2a214 ffff880236abfc30 ffffffff8172a363 0000000000000000
 > >  ffff880236abfc68 ffffffff8105523d 0000000000000000 ffffffffa034a000
 > >  ffff880239d5b0e0 0000000000000000 ffff880234edb000 ffff880236abfc78
 > > Call Trace:
 > >  [<ffffffff8172a363>] dump_stack+0x4e/0x82
 > >  [<ffffffff8105523d>] warn_slowpath_common+0x7d/0xa0
 > >  [<ffffffffa034a000>] ? 0xffffffffa0349fff
 > >  [<ffffffff8105531a>] warn_slowpath_null+0x1a/0x20
 > >  [<ffffffff81120776>] ftrace_bug+0x206/0x270
 > >  [<ffffffffa034a000>] ? 0xffffffffa0349fff
 > >  [<ffffffff81120aec>] ftrace_process_locs+0x30c/0x640
 > >  [<ffffffff81120e5e>] ftrace_module_notify_enter+0x3e/0x50
 > >  [<ffffffff81738aa6>] notifier_call_chain+0x66/0x150
 > >  [<ffffffff8108b197>] __blocking_notifier_call_chain+0x67/0xc0
 > >  [<ffffffff8108b206>] blocking_notifier_call_chain+0x16/0x20
 > >  [<ffffffff810daddd>] load_module+0x1f7d/0x26a0
 > 
 > So trinity is loading a module?

It probably triggered it by reading some /dev node.

 > >  [<ffffffff810d5f90>] ? store_uevent+0x40/0x40
 > >  [<ffffffff810db696>] SyS_finit_module+0x86/0xb0
 > >  [<ffffffff8173d4e4>] tracesys+0xdd/0xe2
 > > ---[ end trace d2b5caf2401c5667 ]---
 > > ftrace faulted on writing [<ffffffffa034a000>] dummy_free+0x0/0x10 [snd_seq_dummy]
 > 
 > Is this module compiled for this kernel?

should be.

 > What happened was that the
 > address it tried to write to wasn't writable. Does function tracing
 > normally work?

example you want me to try ?

 > Speaking of which, the trace-cmd line I gave should not
 > have started function tracing, so something else must have done it.

/sys/kernel/debug is 0700 so the trinity processes shouldn't have had
abilities to even do anything there.

	Dave

