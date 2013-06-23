Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FWQJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 12:09:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3FWQJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 12:09:17 -0400
Date: Sun, 23 Jun 2013 18:04:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130623160452.GA11740@redhat.com>
References: <20130619181302.GE5146@linux.vnet.ibm.com> <20130620001212.GB12151@redhat.com> <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623150603.GA32313@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Dave Jones wrote:
>
> On Sun, Jun 23, 2013 at 04:36:34PM +0200, Oleg Nesterov wrote:
>
>  > >  > Dave, I am sorry but all I can do is to ask you to do more testing.
>  > >  > Could you please reproduce the lockup again on the clean Linus's
>  > >  > current ? (and _without_ reverting 8aac6270, of course).
>  > >
>  > > I'll give it a shot.  Just rebuilt clean tree, and restarted the tests.
>  >
>  > Thanks a lot.
>
> ok, hit it on rc7 without the revert

Great, thanks.

> [11018.927809] [sched_delayed] sched: RT throttling activated
> [11054.897670] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:14482]
> [11054.898503] Modules linked in: bridge stp snd_seq_dummy tun fuse hidp bnep rfcomm can_raw ipt_ULOG can_bcm nfnetlink af_rxrpc llc2 rose caif_socket caif can netrom appletalk af_802154 scsi_transport_iscsi nfc pppoe pppox ppp_generic slhc ipx p8023 psnap p8022 llc ax25 irda crc_ccitt af_key bluetooth rfkill x25 rds atm phonet coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi microcode snd_hda_intel snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc ptp snd_timer pps_core snd soundcore xfs libcrc32c
> [11054.905490] irq event stamp: 3857095
> [11054.905926] hardirqs last  enabled at (3857094): [<ffffffff816ed9a0>] restore_args+0x0/0x30
> [11054.906945] hardirqs last disabled at (3857095): [<ffffffff816f64aa>] apic_timer_interrupt+0x6a/0x80
> [11054.908054] softirqs last  enabled at (3856322): [<ffffffff810542e4>] __do_softirq+0x194/0x440
> [11054.909102] softirqs last disabled at (3856325): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
> [11054.910088] CPU: 2 PID: 14482 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #31
> [11054.912900] task: ffff8801ae44ca40 ti: ffff88021fe60000 task.ti: ffff88021fe60000
> [11054.913800] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440

OK, __do_softirq() again. But this doesn't necessarily mean it
is the offender.

Just in case, did you change /proc/sys/kernel/watchdog_thresh ?
This times the numbers look different.

Could you please do the following:

	1. # cd /sys/kernel/debug/tracing
	   # echo 0 >> options/function-trace
	   # echo preemptirqsoff >> current_tracer

	2. reproduce the lockup again

	3. show the result of
	   # cat trace

Oleg.

