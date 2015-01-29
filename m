Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbbA2Nom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:44:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55161 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbA2Noj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:44:39 -0500
Date: Thu, 29 Jan 2015 14:44:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/3] perf: Add a bit of paranoia
Message-ID: <20150129134434.GB26304@twins.programming.kicks-ass.net>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.150481799@infradead.org>
 <20150126162639.GA21418@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1501271621550.5038@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1501282114320.8031@vincent-weaver-1.umelst.maine.edu>
 <20150129075126.GC7781@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129075126.GC7781@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 08:51:26AM +0100, Jiri Olsa wrote:
> > [162118.235829] ------------[ cut here ]------------
> > [162118.241388] WARNING: CPU: 5 PID: 13571 at kernel/events/core.c:1644 perf_remove_from_context+0xf5/0x120()
> > [162118.252183] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm crct10dif_pclmul snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_controller aesni_intel snd_hda_codec aes_x86_64 snd_hwdep lrw gf128mul snd_pcm ppdev glue_helper xhci_pci mei_me iTCO_wdt iTCO_vendor_support i915 snd_timer drm_kms_helper snd drm ablk_helper lpc_ich mfd_core evdev pcspkr parport_pc psmouse cryptd soundcore i2c_i801 serio_raw parport xhci_hcd mei wmi tpm_tis tpm video battery button processor i2c_algo_bit sg sr_mod sd_mod cdrom ahci libahci e1000e ehci_pci libata ptp ehci_hcd crc32c_intel usbcore scsi_mod usb_common pps_core thermal fan thermal_sys
> > [162118.325574] CPU: 5 PID: 13571 Comm: perf_fuzzer Tainted: G        W      3.19.0-rc6+ #126
> > [162118.334984] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> > [162118.343581]  ffffffff81a3f194 ffff8800c8463b48 ffffffff816b6761 0000000000000000
> > [162118.352277]  0000000000000000 ffff8800c8463b88 ffffffff8106dcda ffff8800c9286c40
> > [162118.360962]  ffff8800c8c01800 ffff8800c8c3a090 ffff8800c8c3a090 ffff8800c71b4800
> > [162118.369669] Call Trace:
> > [162118.372984]  [<ffffffff816b6761>] dump_stack+0x45/0x57
> > [162118.379170]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
> > [162118.386267]  [<ffffffff8106ddca>] warn_slowpath_null+0x1a/0x20
> > [162118.393160]  [<ffffffff811554b5>] perf_remove_from_context+0xf5/0x120
> > [162118.400706]  [<ffffffff811571c5>] put_event+0x115/0x170
> > [162118.407004]  [<ffffffff81157101>] ? put_event+0x51/0x170
> > [162118.413340]  [<ffffffff816bc06e>] ? mutex_unlock+0xe/0x10
> > [162118.419792]  [<ffffffff81157255>] perf_release+0x15/0x20
> > [162118.426144]  [<ffffffff811e234f>] __fput+0xdf/0x1f0
> > [162118.432009]  [<ffffffff811e24ae>] ____fput+0xe/0x10
> > [162118.437895]  [<ffffffff8108bbc7>] task_work_run+0xa7/0xe0
> > [162118.444377]  [<ffffffff81070799>] do_exit+0x319/0xac0
> > [162118.450443]  [<ffffffff8107cc99>] ? get_signal+0xe9/0x770
> > [162118.456906]  [<ffffffff8107cf09>] ? get_signal+0x359/0x770
> > [162118.463427]  [<ffffffff81070fe4>] do_group_exit+0x54/0xe0
> > [162118.469887]  [<ffffffff8107ce46>] get_signal+0x296/0x770
> > [162118.476237]  [<ffffffff8105ded2>] ? __do_page_fault+0x1f2/0x580
> > [162118.483251]  [<ffffffff81013578>] do_signal+0x28/0xbb0
> > [162118.489392]  [<ffffffff8105e282>] ? do_page_fault+0x22/0x30
> > [162118.496055]  [<ffffffff81014170>] do_notify_resume+0x70/0x90
> > [162118.502811]  [<ffffffff816bf662>] retint_signal+0x48/0x86
> > [162118.509272] ---[ end trace 55752a03ec8ab978 ]---
> > 
> 
> 
> hum, I dont see a way how the event->ctx could be changed once the task is
> already in exit, but should we access the event->ctx after the refcnt check?
> 

So what I suspect; but I'm in zombie mode today it seems; is that while
I initially thought that it was impossible for ctx to change when
refcount dropped to 0, I now suspect its possible.

Note that until perf_remove_from_context() the event is still active and
visible on the lists. So a concurrent sys_perf_event_open() from another
task into this task can race.

In this particular case it seems very narrow, since the syscall has to
start before the task goes into shutdown mode otherwise
find_get_context()'s PF_EXITING test would've bailed.


---
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -947,7 +947,8 @@ static void put_ctx(struct perf_event_co
  *	    perf_event::mmap_mutex
  *	    mmap_sem
  */
-static struct perf_event_context *perf_event_ctx_lock(struct perf_event *event)
+static struct perf_event_context *
+perf_event_ctx_lock_nested(struct perf_event *event, int nesting)
 {
 	struct perf_event_context *ctx;
 
@@ -960,7 +961,7 @@ static struct perf_event_context *perf_e
 	}
 	rcu_read_unlock();
 
-	mutex_lock(&ctx->mutex);
+	mutex_lock_nested(&ctx->mutex, nesting);
 	if (event->ctx != ctx) {
 		mutex_unlock(&ctx->mutex);
 		put_ctx(ctx);
@@ -970,6 +971,12 @@ static struct perf_event_context *perf_e
 	return ctx;
 }
 
+static inline struct perf_event_context *
+perf_event_ctx_lock(struct perf_event *event)
+{
+	return perf_event_ctx_lock_nested(event, 0);
+}
+
 static void perf_event_ctx_unlock(struct perf_event *event,
 				  struct perf_event_context *ctx)
 {
@@ -3572,7 +3579,7 @@ static void perf_remove_from_owner(struc
  */
 static void put_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
+	struct perf_event_context *ctx;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
 		return;
@@ -3580,7 +3587,6 @@ static void put_event(struct perf_event
 	if (!is_kernel_event(event))
 		perf_remove_from_owner(event);
 
-	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
 	 *
@@ -3593,7 +3599,8 @@ static void put_event(struct perf_event
 	 *     the last filedesc died, so there is no possibility
 	 *     to trigger the AB-BA case.
 	 */
-	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
+	ctx = perf_event_ctx_lock_nested(event, SINGLE_DEPTH_NESTING);
+	WARN_ON_ONCE(ctx->parent_ctx);
 	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
 
