Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3FJUir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:38:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3FJUiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:38:46 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eB9Tj_0eLcoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XIlBwW5Cg4gA:10 a=qd-EdIyTuWqUUCcXU7IA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370896723.9844.113.camel@gandalf.local.home>
Subject: Re: Another RCU trace. (3.10-rc5)
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Date: Mon, 10 Jun 2013 16:38:43 -0400
In-Reply-To: <20130610195145.GA26068@redhat.com>
References: <20130610195145.GA26068@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 15:51 -0400, Dave Jones wrote:
> Something in this code still isn't right in rc5.
> I got a pretty mangled trace (and then total lockup) pretty quickly..
> 
> [ 1300.705212] ===============================
> [ 1300.707514] [ INFO: suspicious RCU usage. ]
> [ 1300.709794] 3.10.0-rc5+ #6 Not tainted
> [ 1300.712064] -------------------------------
> [ 1300.714363] include/linux/rcupdate.h:780 rcu_read_lock() used illegally while idle!
> [ 1300.717516] 
> [ 1300.717516] other info that might help us debug this:
> [ 1300.717516] 
> [ 1300.723450] 
> [ 1300.723450] RCU used illegally from idle CPU!
> [ 1300.723450] rcu_scheduler_active = 1, debug_locks = 0
> [ 1300.730124] RCU used illegally from extended quiescent state!
> [ 1300.732971] 2 locks held by kworker/0:0/12904:
> [ 1300.735395]  #0:  (&(&(&p->vtime_seqlock)->lock)->rlock){-.-.-.}, at: [<ffffffff8109203e>] vtime_account_system.part.1+0x1e/0x50
> [ 1300.740229]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810a5815>] cpuacct_account_field+0x5/0x200
> [ 1300.744305] 
> [ 1300.744305] stack backtrace:
> [ 1300.747817] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6 
> [ 1300.756486] ------------[ cut here ]------------
> [ 1300.759463] WARNING: at kernel/sched/cputime.c:652 get_vtime_delta+0x64/0x80()
> [ 1300.780868] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6
> [ 1300.783521] ------------[ cut here ]------------
> [ 1300.784848] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x357/0x380()
> [ 1300.792216] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6
> [ 1300.795211] ------------[ cut here ]------------
> [ 1300.796734] WARNING: at kernel/sched/cputime.c:652 get_vtime_delta+0x64/0x80()
> [ 1300.804965] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6
> [ 1300.808270] ------------[ cut here ]------------
> [ 1300.809921] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x357/0x380()
> [ 1300.811591] Modules linked in: tun rfcomm fuse bnep hidp ipt_ULOG nfnetlink scsi_transport_iscsi can_raw af_rxrpc rds nfc can_bcm netrom decnet rose af_key af_802154 can appletalk x25 bluetooth llc2 rfkill pppoe caif_socket pppox caif ppp_generic slhc irda ipx p8023 psnap p8022 llc crc_ccitt atm ax25 phonet nfsv3 nfs_acl nfs lockd sunrpc fscache coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq e1000e snd_seq_device usb_debug snd_pcm ptp snd_page_alloc pps_core snd_timer snd soundcore xfs libcrc32c
> [ 1300.818924] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6
> [ 1300.822581] ------------[ cut here ]------------
> [ 1300.824419] WARNING: at kernel/sched/cputime.c:652 get_vtime_delta+0x64/0x80()
> [ 1300.826271] Modules linked in: tun rfcomm fuse bnep hidp ipt_ULOG nfnetlink scsi_transport_iscsi can_raw af_rxrpc rds nfc can_bcm netrom decnet rose af_key af_802154 can appletalk x25 bluetooth llc2 rfkill pppoe caif_socket pppox caif ppp_generic slhc irda ipx p8023 psnap p8022 llc crc_ccitt atm ax25 phonet nfsv3 nfs_acl nfs lockd sunrpc fscache coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq e1000e snd_seq_device usb_debug snd_pcm ptp snd_page_alloc pps_core snd_timer snd soundcore xfs libcrc32c
> [ 1300.834252] CPU: 0 PID: 12904 Comm: kworker/0:0 Not tainted 3.10.0-rc5+ #6
> [ 1300.838244] ------------[ cut here ]------------
> [ 1300.840231] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x357/0x380()
> [ 1300.895079] WARNING: at kernel/sched/cputime.c:652 get_v[ 1300.8 af_802154 can appletalk x25 bluetooth llc2 rfkill pppoe nfs_acl nfs lockd sunrpc fscache coretemp hwmon kvm_intel snd_h snd_hda_intel snd_hda_codec snd_hwdep snd_seq e1000e sn
> [ 1300.907729] CPU: 0 PID: 12904 Comm: kworker/0:0 Not
> [ 1300.914988]  ffffffff8104a1b1 000000000b89a53f ffff
> [ 1300.917385]  0000000000000008 ffffffff81101b57 ffff
> [ 1300.919760] Call Trace:
> [ 1300.922120]  [<ffffffff816e39db>] dump_stack+0x19/0x1b
> [ 1300.924429]  [<ffffffff8104a1b1>] warn_slowpath_common+0x61/0x80
> [ 1300.926721]  [<ffffffff81101b57>] ? rcu_eqs_exit_common+0x357/0x380
> [ 1300.928993]  [<ffffffff8104a28a>] warn_slowpath_null+0x1a/0x20
> [ 1300.931243]  [<ffffffff81091b94>] get_vtime_delta+0x64/0x80
> [ 1300.933487]  [<ffffffff810922f9>] vtime_account_user+0x29/0x[ 1300.935702]  [<ffffffff81145285>] user_exit+0[ 1300.937882]  [<ffffffff816f0591>] do_page_fau[ 1300.940037]  [<ffffffff816ed162>] page_fault+0x22/0x3[ 1300.942158]  [<ffffffff81101b57>] ? rcu_eqs_e[ 1300.944270]  [<ffffffff81308fb9>] ? copy_user[ 1300.946365]  [<ffffffff8114b46c>] ? __probe_k[ 1300.948437]  [<ffffffff81072598>] print_worke[ 1300.950502]  [<ffffffff8104de32>] dump_stack_[ 1300.952543]  [<ffffffff816e39d2>] dum[ 1300.954546]  [<ffffffff8104a1b1>] warn_slowpa[ 1300.956525]  [<ffffffff8104a28a>] warn_slowpa[ 1300.958471]  [<ffffffff81101b57>] rcu[ 1300.960401]  [<ffffffff81091b94>] ? get_vtime[ 1300.962309]  [<ffffffff81101bda>] rcu[ 1300.964196]  [<ffffffff811039e3>] rcu_user_ex[ 1300.966071]  [<ffffffff81145275>] use[ 1300.967911]  [<ffffffff816f0591>] do_[ 1300.969729]  [<ffffffff816ed162>] pag[ 1300.971510]  [<ffffffff81091b94>] ? get_vtime[ 1300.973270]  [<ffffffff81308fb9>] ? c[ 1300.975014]  [ 1300.989735]  [ 1300.991250]  [<ffffffff816f05[ 1300.992759]  [<ffffffff816ed1[ 1300.994234]  [<ffffffff81101b57>] ? r[ 1300.995698]  [<ffffffff81308f[ 1300.997130]  [<ffffffff8114b4[ 1300.998534]  [<ffffffff810725[ 1300.999918]  [<ffffffff8104de[ 1301.001284]  [<ffffffff816e39[ 1301.002620]  [<ffffffff8104a1[ 1301.003955]  [<ffffff[ 1301.005255]  [<ffffffff81101b[ 1301.006533]  [<ffffffff81091b[ 1301.007780]  [<ffffff[ 1301.008997]  [<ffffffff811039[ 1301.010190]  [<ffffff[ 1301.011355]  [<ffffff[ 1301.012504]  [<ffffffff816ed1[ 1301.013642]  [<ffffff[ 1301.014758]  [<ffffff[ 1301.015852]  [<ffffff[ 1301.016913]  [<ffffff[ 1301.017948]  [<ffffff[ 1301.018965]  [<ffffff[ 1301.019951]  [<ffffff[ 1301.020924]  [ 1301.021895]  [<ffffff[ 1301.022861]  [<ffffff[ 1301.023820]  [<ffffff[ 1301.024776]  [<ffffff[ 1301.025726]  [ 1301.026679]  [<ffffff[ 1301.027626]  [<ffffff[ 1301.028585]  [<ffffff[ 1301.029544]  [ 1301.030502]  [<ffffff[ 1301.031463]  [<ffffff[ 1301.032430]  [<ffffff[ 1301.033391]  [<ffffff[ 1301.034351]  [ 1301.035305]  [<ffffff[ 1301.036264]  [<ffffff[ 1301.037218]  [ 1301.038171]  [<ffffff[ 1301.039122]  [<ffffff[ 1301.040069]  [<ffffff[ 1301.041018]  [ 1301.041965]  [<ffffff[ 1301.042916]  [<ffffff[ 1301.043880]  [<ffffff[ 1301.044842]  [<ffffff[ 1301.045808]  [ 1301.046780]  [<ffffff[ 1301.047737]  [<ffffff[ 1301.048705]  [<ffffff[ 1301.049669]  [ 1301.050632]  [<ffffff[ 1301.051594]  [<ffffff[ 1301.052557]  [<ffffff[ 1301.053517]  [<ffffff[ 1301.054476]  [ 1301.055430]  [<ffffff[ 1301.056392]  [<ffffff[ 1301.057361]  [<ffffff[ 1301.058329]  [ 1301.059303]  [<ffffff[ 1301.060281]  [<ffffff[ 1301.061247]  [<ffffff[ 1301.062217]  [<ffffff[ 1301.063180]  [ 1301.064146]  [<ffffff[ 1301.065110]  [<ffffff[ 1301.066069]  [<ffffff[ 1301.067028]  [<ffffff[ 1301.067982]  [ 1301.068944]  [<ffffff[ 1301.069899]  [<ffffff[ 1301.070860]  [<ffffff[ 1301.071834]  [ 1301.072808]  [<ffffff[ 1301.073781]  [<ffffff[ 1301.074761]  [<ffffff[ 1301.075732]  [<ffffff[ 1301.0[ 1301.0[ 1301.092183]  [<ffffff[ 1301.093150]  [ 1301.094113]  [<ffffff[ 1301.095081]  [<ffffff[ 1301.096050]  [<ffffff[ 1301.097011]  [<ffffff[ 1301.097975]  [ 1301.098944]  [<ffffff[ 1301.099917]  [<ffffff[ 1301.100891]  [<ffffff[ 1301.101859]  [<ffffff[ 1301.102834] -[ 1301.103835] Thread ov
> 
> and then total lockup.
> 
> 
> I saw some of Steven's patches get merged on Friday, is there anything else
> outstanding that didn't make it in yet that I could test ?
> Or is this another new bug ?

Looks to be another bug. Can you post the config you were using. Or is
this the same config as before?

Also, I don't see any tracing going on, so this could just be a context
tracking bug.

-- Steve


