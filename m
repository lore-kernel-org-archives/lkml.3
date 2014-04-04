Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaDDQJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:09:20 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:55998 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753475AbaDDQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:09:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:1:41:69:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2636:2828:2904:3138:3139:3140:3141:3142:3865:3866:3868:3871:3872:4250:4321:4384:4419:4605:5007:6119:6120:7652:7901:7903:9121:9389:9592:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sack79_6d5292856e158
X-Filterd-Recvd-Size: 11053
Message-ID: <1396627748.2863.9.camel@joe-AO722>
Subject: [PATCH] sound/oss: Remove uncompilable DBG macro use
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 Apr 2014 09:09:08 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of it duplicates function tracing and one
of them has an uncompilable printf %P use.
Others have format/argument mismatches.

Remove unused DBG1 macro definition

Neaten uart401.c use of ok test around this
DBG macro removal.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/oss/ad1848.c       |  4 ----
 sound/oss/opl3.c         |  3 ---
 sound/oss/pas2_mixer.c   |  9 ---------
 sound/oss/pas2_pcm.c     | 18 ------------------
 sound/oss/sb_common.c    |  4 ----
 sound/oss/sb_ess.c       |  4 ----
 sound/oss/sequencer.c    |  6 ------
 sound/oss/sound_config.h |  4 ----
 sound/oss/soundcard.c    |  6 ------
 sound/oss/uart401.c      | 11 ++---------
 10 files changed, 2 insertions(+), 67 deletions(-)

diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 4918b71..ec1ee07 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -50,8 +50,6 @@
 #include <linux/pnp.h>
 #include <linux/spinlock.h>
 
-#define DEB(x)
-#define DEB1(x)
 #include "sound_config.h"
 
 #include "ad1848.h"
@@ -1016,8 +1014,6 @@ static void ad1848_close(int dev)
 	ad1848_info    *devc = (ad1848_info *) audio_devs[dev]->devc;
 	ad1848_port_info *portc = (ad1848_port_info *) audio_devs[dev]->portc;
 
-	DEB(printk("ad1848_close(void)\n"));
-
 	devc->intr_active = 0;
 	ad1848_halt(dev);
 
diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index c5c2440..4709e59 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -275,7 +275,6 @@ static int opl3_kill_note  (int devno, int voice, int note, int velocity)
 	 devc->v_alloc->map[voice] = 0;
 
 	 map = &pv_map[devc->lv_map[voice]];
-	 DEB(printk("Kill note %d\n", voice));
 
 	 if (map->voice_mode == 0)
 		 return 0;
@@ -873,8 +872,6 @@ static void opl3_aftertouch(int dev, int voice, int pressure)
 
 	map = &pv_map[devc->lv_map[voice]];
 
-	DEB(printk("Aftertouch %d\n", voice));
-
 	if (map->voice_mode == 0)
 		return;
 
diff --git a/sound/oss/pas2_mixer.c b/sound/oss/pas2_mixer.c
index a0bcb85..50b5bd5 100644
--- a/sound/oss/pas2_mixer.c
+++ b/sound/oss/pas2_mixer.c
@@ -21,10 +21,6 @@
 
 #include "pas2.h"
 
-#ifndef DEB
-#define DEB(what)		/* (what) */
-#endif
-
 extern int      pas_translate_code;
 extern char     pas_model;
 extern int     *pas_osp;
@@ -120,8 +116,6 @@ pas_mixer_set(int whichDev, unsigned int level)
 {
 	int             left, right, devmask, changed, i, mixer = 0;
 
-	DEB(printk("static int pas_mixer_set(int whichDev = %d, unsigned int level = %X)\n", whichDev, level));
-
 	left = level & 0x7f;
 	right = (level & 0x7f00) >> 8;
 
@@ -207,8 +201,6 @@ pas_mixer_reset(void)
 {
 	int             foo;
 
-	DEB(printk("pas2_mixer.c: void pas_mixer_reset(void)\n"));
-
 	for (foo = 0; foo < SOUND_MIXER_NRDEVICES; foo++)
 		pas_mixer_set(foo, levels[foo]);
 
@@ -220,7 +212,6 @@ static int pas_mixer_ioctl(int dev, unsigned int cmd, void __user *arg)
 	int level,v ;
 	int __user *p = (int __user *)arg;
 
-	DEB(printk("pas2_mixer.c: int pas_mixer_ioctl(unsigned int cmd = %X, unsigned int arg = %X)\n", cmd, arg));
 	if (cmd == SOUND_MIXER_PRIVATE1) { /* Set loudness bit */
 		if (get_user(level, p))
 			return -EFAULT;
diff --git a/sound/oss/pas2_pcm.c b/sound/oss/pas2_pcm.c
index 6f13ab4..474803b 100644
--- a/sound/oss/pas2_pcm.c
+++ b/sound/oss/pas2_pcm.c
@@ -22,10 +22,6 @@
 
 #include "pas2.h"
 
-#ifndef DEB
-#define DEB(WHAT)
-#endif
-
 #define PAS_PCM_INTRBITS (0x08)
 /*
  * Sample buffer timer interrupt enable
@@ -156,8 +152,6 @@ static int pas_audio_ioctl(int dev, unsigned int cmd, void __user *arg)
 	int val, ret;
 	int __user *p = arg;
 
-	DEB(printk("pas2_pcm.c: static int pas_audio_ioctl(unsigned int cmd = %X, unsigned int arg = %X)\n", cmd, arg));
-
 	switch (cmd) 
 	{
 	case SOUND_PCM_WRITE_RATE:
@@ -204,8 +198,6 @@ static int pas_audio_ioctl(int dev, unsigned int cmd, void __user *arg)
 
 static void pas_audio_reset(int dev)
 {
-	DEB(printk("pas2_pcm.c: static void pas_audio_reset(void)\n"));
-
 	pas_write(pas_read(0xF8A) & ~0x40, 0xF8A);	/* Disable PCM */
 }
 
@@ -214,8 +206,6 @@ static int pas_audio_open(int dev, int mode)
 	int             err;
 	unsigned long   flags;
 
-	DEB(printk("pas2_pcm.c: static int pas_audio_open(int mode = %X)\n", mode));
-
 	spin_lock_irqsave(&pas_lock, flags);
 	if (pcm_busy)
 	{
@@ -239,8 +229,6 @@ static void pas_audio_close(int dev)
 {
 	unsigned long   flags;
 
-	DEB(printk("pas2_pcm.c: static void pas_audio_close(void)\n"));
-
 	spin_lock_irqsave(&pas_lock, flags);
 
 	pas_audio_reset(dev);
@@ -256,8 +244,6 @@ static void pas_audio_output_block(int dev, unsigned long buf, int count,
 {
 	unsigned long   flags, cnt;
 
-	DEB(printk("pas2_pcm.c: static void pas_audio_output_block(char *buf = %P, int count = %X)\n", buf, count));
-
 	cnt = count;
 	if (audio_devs[dev]->dmap_out->dma > 3)
 		cnt >>= 1;
@@ -303,8 +289,6 @@ static void pas_audio_start_input(int dev, unsigned long buf, int count,
 	unsigned long   flags;
 	int             cnt;
 
-	DEB(printk("pas2_pcm.c: static void pas_audio_start_input(char *buf = %P, int count = %X)\n", buf, count));
-
 	cnt = count;
 	if (audio_devs[dev]->dmap_out->dma > 3)
 		cnt >>= 1;
@@ -388,8 +372,6 @@ static struct audio_driver pas_audio_driver =
 
 void __init pas_pcm_init(struct address_info *hw_config)
 {
-	DEB(printk("pas2_pcm.c: long pas_pcm_init()\n"));
-
 	pcm_bitsok = 8;
 	if (pas_read(0xEF8B) & 0x08)
 		pcm_bitsok |= 16;
diff --git a/sound/oss/sb_common.c b/sound/oss/sb_common.c
index 851a1da..3d50fb4 100644
--- a/sound/oss/sb_common.c
+++ b/sound/oss/sb_common.c
@@ -226,8 +226,6 @@ int sb_dsp_reset(sb_devc * devc)
 {
 	int loopc;
 
-	DEB(printk("Entered sb_dsp_reset()\n"));
-
 	if (devc->model == MDL_ESS) return ess_dsp_reset (devc);
 
 	/* This is only for non-ESS chips */
@@ -246,8 +244,6 @@ int sb_dsp_reset(sb_devc * devc)
 		return 0;	/* Sorry */
 	}
 
-	DEB(printk("sb_dsp_reset() OK\n"));
-
 	return 1;
 }
 
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 0e7254b..b47a690 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -865,8 +865,6 @@ printk(KERN_INFO "FKS: ess_dsp_reset 1\n");
 ess_show_mixerregs (devc);
 #endif
 
-	DEB(printk("Entered ess_dsp_reset()\n"));
-
 	outb(3, DSP_RESET); /* Reset FIFO too */
 
 	udelay(10);
@@ -881,8 +879,6 @@ ess_show_mixerregs (devc);
 	}
 	ess_extended (devc);
 
-	DEB(printk("sb_dsp_reset() OK\n"));
-
 #ifdef FKS_LOGGING
 printk(KERN_INFO "FKS: dsp_reset 2\n");
 ess_show_mixerregs (devc);
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 9b9f7d3..c0eea1d 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -216,8 +216,6 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
 
 	dev = dev >> 4;
 
-	DEB(printk("sequencer_write(dev=%d, count=%d)\n", dev, count));
-
 	if (mode == OPEN_READ)
 		return -EIO;
 
@@ -959,8 +957,6 @@ int sequencer_open(int dev, struct file *file)
 	dev = dev >> 4;
 	mode = translate_mode(file);
 
-	DEB(printk("sequencer_open(dev=%d)\n", dev));
-
 	if (!sequencer_ok)
 	{
 /*		printk("Sound card: sequencer not initialized\n");*/
@@ -1133,8 +1129,6 @@ void sequencer_release(int dev, struct file *file)
 
 	dev = dev >> 4;
 
-	DEB(printk("sequencer_release(dev=%d)\n", dev));
-
 	/*
 	 * Wait until the queue is empty (if we don't have nonblock)
 	 */
diff --git a/sound/oss/sound_config.h b/sound/oss/sound_config.h
index 9d35c4c..f2554ab 100644
--- a/sound/oss/sound_config.h
+++ b/sound/oss/sound_config.h
@@ -123,10 +123,6 @@ static inline int translate_mode(struct file *file)
 #include "sound_calls.h"
 #include "dev_table.h"
 
-#ifndef DEB
-#define DEB(x)
-#endif
-
 #ifndef DDB
 #define DDB(x) do {} while (0)
 #endif
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index e778034..b70c7c8 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -154,7 +154,6 @@ static ssize_t sound_read(struct file *file, char __user *buf, size_t count, lof
 	 
 	mutex_lock(&soundcard_mutex);
 	
-	DEB(printk("sound_read(dev=%d, count=%d)\n", dev, count));
 	switch (dev & 0x0f) {
 	case SND_DEV_DSP:
 	case SND_DEV_DSP16:
@@ -180,7 +179,6 @@ static ssize_t sound_write(struct file *file, const char __user *buf, size_t cou
 	int ret = -EINVAL;
 	
 	mutex_lock(&soundcard_mutex);
-	DEB(printk("sound_write(dev=%d, count=%d)\n", dev, count));
 	switch (dev & 0x0f) {
 	case SND_DEV_SEQ:
 	case SND_DEV_SEQ2:
@@ -206,7 +204,6 @@ static int sound_open(struct inode *inode, struct file *file)
 	int dev = iminor(inode);
 	int retval;
 
-	DEB(printk("sound_open(dev=%d)\n", dev));
 	if ((dev >= SND_NDEVS) || (dev < 0)) {
 		printk(KERN_ERR "Invalid minor device %d\n", dev);
 		return -ENXIO;
@@ -257,7 +254,6 @@ static int sound_release(struct inode *inode, struct file *file)
 	int dev = iminor(inode);
 
 	mutex_lock(&soundcard_mutex);
-	DEB(printk("sound_release(dev=%d)\n", dev));
 	switch (dev & 0x0f) {
 	case SND_DEV_CTL:
 		module_put(mixer_devs[dev >> 4]->owner);
@@ -351,7 +347,6 @@ static long sound_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (!access_ok(VERIFY_WRITE, p, len))
 				return -EFAULT;
 	}
-	DEB(printk("sound_ioctl(dev=%d, cmd=0x%x, arg=0x%x)\n", dev, cmd, arg));
 	if (cmd == OSS_GETVERSION)
 		return __put_user(SOUND_VERSION, (int __user *)p);
 	
@@ -409,7 +404,6 @@ static unsigned int sound_poll(struct file *file, poll_table * wait)
 	struct inode *inode = file_inode(file);
 	int dev = iminor(inode);
 
-	DEB(printk("sound_poll(dev=%d)\n", dev));
 	switch (dev & 0x0f) {
 	case SND_DEV_SEQ:
 	case SND_DEV_SEQ2:
diff --git a/sound/oss/uart401.c b/sound/oss/uart401.c
index 5433c6f..62b8869 100644
--- a/sound/oss/uart401.c
+++ b/sound/oss/uart401.c
@@ -274,19 +274,12 @@ static int reset_uart401(uart401_devc * devc)
 		}
 	}
 
-
+	/* Flush input before enabling interrupts */
 	if (ok)
-	{
-		DEB(printk("Reset UART401 OK\n"));
-	}
+		uart401_input_loop(devc);
 	else
 		DDB(printk("Reset UART401 failed - No hardware detected.\n"));
 
-	if (ok)
-		uart401_input_loop(devc);	/*
-						 * Flush input before enabling interrupts
-						 */
-
 	return ok;
 }
 


