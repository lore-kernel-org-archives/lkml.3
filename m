Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3FXCAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 22:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3FXCAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 22:00:31 -0400
Date: Sun, 23 Jun 2013 22:00:14 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624020014.GB12811@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
 <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623160452.GA11740@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 06:04:52PM +0200, Oleg Nesterov wrote:
 
 > Could you please do the following:
 > 
 > 	1. # cd /sys/kernel/debug/tracing
 > 	   # echo 0 >> options/function-trace
 > 	   # echo preemptirqsoff >> current_tracer

dammit.

WARNING: at include/linux/list.h:385 rb_head_page_deactivate.isra.39+0x61/0x80()
 check_list_nodes corruption. next->prev should be prev (ffff88023b8a1a08), but was 00ffff88023b8a1a. (next=ffff880243288001).
 Modules linked in: coretemp hwmon snd_hda_codec_realtek kvm_intel kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc ptp snd_timer snd pps_core soundcore xfs libcrc32c
 CPU: 1 PID: 474 Comm: bash Not tainted 3.10.0-rc7+ #33
  ffffffff81a1762e ffff88023c659ce0 ffffffff816e467d ffff88023c659d18
  ffffffff8104a0c1 ffff88023b8a1a08 ffff8802434b9040 ffff8802434b8fe8
  0000000000000282 ffff88023109a620 ffff88023c659d78 ffffffff8104a12c
 Call Trace:
  [<ffffffff816e467d>] dump_stack+0x19/0x1b
  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
  [<ffffffff8104a12c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff81112c61>] rb_head_page_deactivate.isra.39+0x61/0x80
  [<ffffffff81113353>] ring_buffer_reset_cpu+0xa3/0x250
  [<ffffffff81111f4a>] ? ring_buffer_time_stamp+0x1a/0x30
  [<ffffffff81119d1a>] tracing_reset_online_cpus+0x5a/0xb0
  [<ffffffff8111ee13>] tracing_set_tracer+0x223/0x310
  [<ffffffff8111f16d>] tracing_set_trace_write+0xad/0xf0
  [<ffffffff811ad6bb>] ? vfs_write+0x1bb/0x1f0
  [<ffffffff812b9ca1>] ? security_file_permission+0x21/0xa0
  [<ffffffff811ad5c0>] vfs_write+0xc0/0x1f0
  [<ffffffff811cc487>] ? fget_light+0x387/0x4f0
  [<ffffffff811adfcc>] SyS_write+0x4c/0xa0
  [<ffffffff816f5d94>] tracesys+0xdd/0xe2
 ---[ end trace d4694abee6ec3f10 ]---


hopefully despite that it'll actually function as intended.

	Dave

