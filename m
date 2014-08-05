Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaHEN0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:26:53 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61077 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHEN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:26:52 -0400
Date: Tue, 5 Aug 2014 18:56:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] sound/oss/pss: Remove typedefs pss_mixerdata and pss_confdata
Message-ID: <20140805132647.GA17360@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedefs for pss_mixerdata
and pss_confdata.

The following Coccinelle semantic patch is used to make the change.

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 sound/oss/pss.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 145e36b..ca0d6e9 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -123,25 +123,25 @@ static bool pss_mixer;
 #endif
 
 
-typedef struct pss_mixerdata {
+struct pss_mixerdata {
 	unsigned int volume_l;
 	unsigned int volume_r;
 	unsigned int bass;
 	unsigned int treble;
 	unsigned int synth;
-} pss_mixerdata;
+};
 
-typedef struct pss_confdata {
+struct pss_confdata {
 	int             base;
 	int             irq;
 	int             dma;
 	int            *osp;
-	pss_mixerdata   mixer;
+	struct pss_mixerdata mixer;
 	int             ad_mixer_dev;
-} pss_confdata;
+};
   
-static pss_confdata pss_data;
-static pss_confdata *devc = &pss_data;
+static struct pss_confdata pss_data;
+static struct pss_confdata *devc = &pss_data;
 static DEFINE_SPINLOCK(lock);
 
 static int      pss_initialized;
@@ -150,7 +150,7 @@ static int	pss_cdrom_port = -1;	/* Parameter for the PSS cdrom port */
 static bool	pss_enable_joystick;    /* Parameter for enabling the joystick */
 static coproc_operations pss_coproc_operations;
 
-static void pss_write(pss_confdata *devc, int data)
+static void pss_write(struct pss_confdata *devc, int data)
 {
 	unsigned long i, limit;
 
@@ -206,7 +206,7 @@ static int __init probe_pss(struct address_info *hw_config)
 	return 1;
 }
 
-static int set_irq(pss_confdata * devc, int dev, int irq)
+static int set_irq(struct pss_confdata *devc, int dev, int irq)
 {
 	static unsigned short irq_bits[16] =
 	{
@@ -232,7 +232,7 @@ static int set_irq(pss_confdata * devc, int dev, int irq)
 	return 1;
 }
 
-static void set_io_base(pss_confdata * devc, int dev, int base)
+static void set_io_base(struct pss_confdata *devc, int dev, int base)
 {
 	unsigned short  tmp = inw(REG(dev)) & 0x003f;
 	unsigned short  bits = (base & 0x0ffc) << 4;
@@ -240,7 +240,7 @@ static void set_io_base(pss_confdata * devc, int dev, int base)
 	outw(bits | tmp, REG(dev));
 }
 
-static int set_dma(pss_confdata * devc, int dev, int dma)
+static int set_dma(struct pss_confdata *devc, int dev, int dma)
 {
 	static unsigned short dma_bits[8] =
 	{
@@ -264,7 +264,7 @@ static int set_dma(pss_confdata * devc, int dev, int dma)
 	return 1;
 }
 
-static int pss_reset_dsp(pss_confdata * devc)
+static int pss_reset_dsp(struct pss_confdata *devc)
 {
 	unsigned long   i, limit = jiffies + HZ/10;
 
@@ -275,7 +275,7 @@ static int pss_reset_dsp(pss_confdata * devc)
 	return 1;
 }
 
-static int pss_put_dspword(pss_confdata * devc, unsigned short word)
+static int pss_put_dspword(struct pss_confdata *devc, unsigned short word)
 {
 	int i, val;
 
@@ -291,7 +291,7 @@ static int pss_put_dspword(pss_confdata * devc, unsigned short word)
 	return 0;
 }
 
-static int pss_get_dspword(pss_confdata * devc, unsigned short *word)
+static int pss_get_dspword(struct pss_confdata *devc, unsigned short *word)
 {
 	int i, val;
 
@@ -307,7 +307,8 @@ static int pss_get_dspword(pss_confdata * devc, unsigned short *word)
 	return 0;
 }
 
-static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size, int flags)
+static int pss_download_boot(struct pss_confdata *devc, unsigned char *block,
+			     int size, int flags)
 {
 	int i, val, count;
 	unsigned long limit;
@@ -397,7 +398,7 @@ static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size
 }
 
 /* Mixer */
-static void set_master_volume(pss_confdata *devc, int left, int right)
+static void set_master_volume(struct pss_confdata *devc, int left, int right)
 {
 	static unsigned char log_scale[101] =  {
 		0xdb, 0xe0, 0xe3, 0xe5, 0xe7, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xed, 0xee,
@@ -416,7 +417,7 @@ static void set_master_volume(pss_confdata *devc, int left, int right)
 	pss_write(devc, log_scale[right] | 0x0100);
 }
 
-static void set_synth_volume(pss_confdata *devc, int volume)
+static void set_synth_volume(struct pss_confdata *devc, int volume)
 {
 	int vol = ((0x8000*volume)/100L);
 	pss_write(devc, 0x0080);
@@ -425,21 +426,21 @@ static void set_synth_volume(pss_confdata *devc, int volume)
 	pss_write(devc, vol);
 }
 
-static void set_bass(pss_confdata *devc, int level)
+static void set_bass(struct pss_confdata *devc, int level)
 {
 	int vol = (int)(((0xfd - 0xf0) * level)/100L) + 0xf0;
 	pss_write(devc, 0x0010);
 	pss_write(devc, vol | 0x0200);
 };
 
-static void set_treble(pss_confdata *devc, int level)
+static void set_treble(struct pss_confdata *devc, int level)
 {	
 	int vol = (((0xfd - 0xf0) * level)/100L) + 0xf0;
 	pss_write(devc, 0x0010);
 	pss_write(devc, vol | 0x0300);
 };
 
-static void pss_mixer_reset(pss_confdata *devc)
+static void pss_mixer_reset(struct pss_confdata *devc)
 {
 	set_master_volume(devc, 33, 33);
 	set_bass(devc, 50);
@@ -499,7 +500,8 @@ static int ret_vol_stereo(int left, int right)
 	return ((right << 8) | left);
 }
 
-static int call_ad_mixer(pss_confdata *devc,unsigned int cmd, void __user *arg)
+static int call_ad_mixer(struct pss_confdata *devc, unsigned int cmd,
+			 void __user *arg)
 {
 	if (devc->ad_mixer_dev != NO_WSS_MIXER) 
 		return mixer_devs[devc->ad_mixer_dev]->ioctl(devc->ad_mixer_dev, cmd, arg);
@@ -509,7 +511,7 @@ static int call_ad_mixer(pss_confdata *devc,unsigned int cmd, void __user *arg)
 
 static int pss_mixer_ioctl (int dev, unsigned int cmd, void __user *arg)
 {
-	pss_confdata *devc = mixer_devs[dev]->devc;
+	struct pss_confdata *devc = mixer_devs[dev]->devc;
 	int cmdf = cmd & 0xff;
 	
 	if ((cmdf != SOUND_MIXER_VOLUME) && (cmdf != SOUND_MIXER_BASS) &&
-- 
1.9.1

