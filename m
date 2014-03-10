Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaCJX2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:28:20 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:33603 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752262AbaCJX2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:28:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:1:41:69:355:379:421:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:2638:2828:2899:2902:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4605:5007:6119:7652:7875:7903:7904:9010:9040:9389:9592:10004:10848:11026:11232:11473:11658:11914:12043:12291:12295:12296:12438:12517:12519:12555:12679:12683:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bee95_ded3bedea73d
X-Filterd-Recvd-Size: 12838
Message-ID: <1394494094.21085.22.camel@joe-AO722>
Subject: [PATCH] sound: sound_core: Reduce checkpatch noise
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 16:28:14 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly whitespace cleanups (spaces around operators, remove
trailing spaces and unnecessary blank lines, etc) and

o Reduce indent of switch/case labels
o Use pr_<level> for printks, add pr_fmt
o Move braces to appropriate locations
o Wrap arguments to 80 columns
o Remove unnecessary braces

Mostly done with checkpatch --fix
and some typing.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/sound_core.c | 183 ++++++++++++++++++++++++-----------------------------
 1 file changed, 82 insertions(+), 101 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 11e953a..952ec83 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -4,6 +4,8 @@
  *	is used OSS or emulation of it.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /*
  * First, the common part.
  */
@@ -68,7 +70,7 @@ module_exit(cleanup_soundcore);
 #ifdef CONFIG_SOUND_OSS_CORE
 /*
  *	OSS sound core handling. Breaks out sound functions to submodules
- *	
+ *
  *	Author:		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Fixes:
@@ -80,9 +82,9 @@ module_exit(cleanup_soundcore);
  *	2 of the License, or (at your option) any later version.
  *
  *                         --------------------
- * 
+ *
  *	Top level handler for the sound subsystem. Various devices can
- *	plug into this. The fact they don't all go via OSS doesn't mean 
+ *	plug into this. The fact they don't all go via OSS doesn't mean
  *	they don't have to implement the OSS API. There is a lot of logic
  *	to keeping much of the OSS weight out of the code in a compatibility
  *	module, but it's up to the driver to rember to load it...
@@ -111,8 +113,7 @@ module_exit(cleanup_soundcore);
 
 #define SOUND_STEP 16
 
-struct sound_unit
-{
+struct sound_unit {
 	int unit_minor;
 	const struct file_operations *unit_fops;
 	struct sound_unit *next;
@@ -151,15 +152,14 @@ extern int msnd_pinnacle_init(void);
 #ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
 static int preclaim_oss = 1;
 #else
-static int preclaim_oss = 0;
+static int preclaim_oss;
 #endif
 
 module_param(preclaim_oss, int, 0444);
 
 static int soundcore_open(struct inode *, struct file *);
 
-static const struct file_operations soundcore_fops =
-{
+static const struct file_operations soundcore_fops = {
 	/* We must have an owner or the module locking fails */
 	.owner	= THIS_MODULE,
 	.open	= soundcore_open,
@@ -171,72 +171,72 @@ static const struct file_operations soundcore_fops =
  *	join into it. Called with the lock asserted
  */
 
-static int __sound_insert_unit(struct sound_unit * s, struct sound_unit **list, const struct file_operations *fops, int index, int low, int top)
+static int __sound_insert_unit(struct sound_unit *s, struct sound_unit **list,
+			       const struct file_operations *fops, int index,
+			       int low, int top)
 {
-	int n=low;
+	int n = low;
 
 	if (index < 0) {	/* first free */
 
-		while (*list && (*list)->unit_minor<n)
-			list=&((*list)->next);
+		while (*list && (*list)->unit_minor < n)
+			list = &((*list)->next);
 
-		while(n<top)
-		{
+		while (n < top) {
 			/* Found a hole ? */
-			if(*list==NULL || (*list)->unit_minor>n)
+			if (*list == NULL || (*list)->unit_minor > n)
 				break;
-			list=&((*list)->next);
-			n+=SOUND_STEP;
+			list = &((*list)->next);
+			n += SOUND_STEP;
 		}
 
-		if(n>=top)
+		if (n >= top)
 			return -ENOENT;
 	} else {
-		n = low+(index*16);
+		n = low + (index * 16);
 		while (*list) {
-			if ((*list)->unit_minor==n)
+			if ((*list)->unit_minor == n)
 				return -EBUSY;
-			if ((*list)->unit_minor>n)
+			if ((*list)->unit_minor > n)
 				break;
-			list=&((*list)->next);
+			list = &((*list)->next);
 		}
-	}	
-		
+	}
+
 	/*
 	 *	Fill it in
 	 */
-	 
-	s->unit_minor=n;
-	s->unit_fops=fops;
-	
+
+	s->unit_minor = n;
+	s->unit_fops = fops;
+
 	/*
 	 *	Link it
 	 */
-	 
-	s->next=*list;
-	*list=s;
-	
-	
+
+	s->next = *list;
+	*list = s;
+
+
 	return n;
 }
 
 /*
  *	Remove a node from the chain. Called with the lock asserted
  */
- 
-static struct sound_unit *__sound_remove_unit(struct sound_unit **list, int unit)
+
+static struct sound_unit *__sound_remove_unit(struct sound_unit **list,
+					      int unit)
 {
-	while(*list)
-	{
-		struct sound_unit *p=*list;
-		if(p->unit_minor==unit)
-		{
-			*list=p->next;
+	while (*list) {
+		struct sound_unit *p = *list;
+		if (p->unit_minor == unit) {
+			*list = p->next;
 			return p;
 		}
-		list=&(p->next);
+		list = &(p->next);
 	}
-	printk(KERN_ERR "Sound device %d went missing!\n", unit);
+	pr_err("Sound device %d went missing!\n", unit);
 	return NULL;
 }
 
@@ -251,7 +251,10 @@ static DEFINE_SPINLOCK(sound_loader_lock);
  *	list. Acquires locks as needed
  */
 
-static int sound_insert_unit(struct sound_unit **list, const struct file_operations *fops, int index, int low, int top, const char *name, umode_t mode, struct device *dev)
+static int sound_insert_unit(struct sound_unit **list,
+			     const struct file_operations *fops, int index,
+			     int low, int top, const char *name, umode_t mode,
+			     struct device *dev)
 {
 	struct sound_unit *s = kmalloc(sizeof(*s), GFP_KERNEL);
 	int r;
@@ -263,7 +266,7 @@ static int sound_insert_unit(struct sound_unit **list, const struct file_operati
 retry:
 	r = __sound_insert_unit(s, list, fops, index, low, top);
 	spin_unlock(&sound_loader_lock);
-	
+
 	if (r < 0)
 		goto fail;
 	else if (r < SOUND_STEP)
@@ -305,7 +308,7 @@ fail:
  *	completed the removal before their file operations become
  *	invalid.
  */
- 	
+
 static void sound_remove_unit(struct sound_unit **list, int unit)
 {
 	struct sound_unit *p;
@@ -349,7 +352,7 @@ static struct sound_unit *chains[SOUND_STEP];
  *	register_sound_special_device - register a special sound node
  *	@fops: File operations for the driver
  *	@unit: Unit number to allocate
- *      @dev: device pointer
+ *	@dev: device pointer
  *
  *	Allocate a special sound device by minor number from the sound
  *	subsystem.
@@ -357,7 +360,6 @@ static struct sound_unit *chains[SOUND_STEP];
  *	Return: The allocated number is returned on success. On failure,
  *	a negative error code is returned.
  */
- 
 int register_sound_special_device(const struct file_operations *fops, int unit,
 				  struct device *dev)
 {
@@ -367,69 +369,65 @@ int register_sound_special_device(const struct file_operations *fops, int unit,
 	char _name[16];
 
 	switch (chain) {
-	    case 0:
+	case 0:
 		name = "mixer";
 		break;
-	    case 1:
+	case 1:
 		name = "sequencer";
 		if (unit >= SOUND_STEP)
 			goto __unknown;
 		max_unit = unit + 1;
 		break;
-	    case 2:
+	case 2:
 		name = "midi";
 		break;
-	    case 3:
+	case 3:
 		name = "dsp";
 		break;
-	    case 4:
+	case 4:
 		name = "audio";
 		break;
-	    case 5:
+	case 5:
 		name = "dspW";
 		break;
-	    case 8:
+	case 8:
 		name = "sequencer2";
 		if (unit >= SOUND_STEP)
 			goto __unknown;
 		max_unit = unit + 1;
 		break;
-	    case 9:
+	case 9:
 		name = "dmmidi";
 		break;
-	    case 10:
+	case 10:
 		name = "dmfm";
 		break;
-	    case 12:
+	case 12:
 		name = "adsp";
 		break;
-	    case 13:
+	case 13:
 		name = "amidi";
 		break;
-	    case 14:
+	case 14:
 		name = "admmidi";
 		break;
-	    default:
-	    	{
-		    __unknown:
-			sprintf(_name, "unknown%d", chain);
-		    	if (unit >= SOUND_STEP)
-		    		strcat(_name, "-");
-		    	name = _name;
-		}
+__unknown:
+	default:
+		sprintf(_name, "unknown%d", chain);
+		if (unit >= SOUND_STEP)
+			strcat(_name, "-");
+		name = _name;
 		break;
 	}
 	return sound_insert_unit(&chains[chain], fops, -1, unit, max_unit,
 				 name, S_IRUSR | S_IWUSR, dev);
 }
- 
 EXPORT_SYMBOL(register_sound_special_device);
 
 int register_sound_special(const struct file_operations *fops, int unit)
 {
 	return register_sound_special_device(fops, unit, NULL);
 }
-
 EXPORT_SYMBOL(register_sound_special);
 
 /**
@@ -443,13 +441,11 @@ EXPORT_SYMBOL(register_sound_special);
  *	Return: On success, the allocated number is returned. On failure,
  *	a negative error code is returned.
  */
-
 int register_sound_mixer(const struct file_operations *fops, int dev)
 {
 	return sound_insert_unit(&chains[0], fops, dev, 0, 128,
 				 "mixer", S_IRUSR | S_IWUSR, NULL);
 }
-
 EXPORT_SYMBOL(register_sound_mixer);
 
 /**
@@ -469,14 +465,13 @@ int register_sound_midi(const struct file_operations *fops, int dev)
 	return sound_insert_unit(&chains[2], fops, dev, 2, 130,
 				 "midi", S_IRUSR | S_IWUSR, NULL);
 }
-
 EXPORT_SYMBOL(register_sound_midi);
 
 /*
  *	DSP's are registered as a triple. Register only one and cheat
  *	in open - see below.
  */
- 
+
 /**
  *	register_sound_dsp - register a DSP device
  *	@fops: File operations for the driver
@@ -491,13 +486,11 @@ EXPORT_SYMBOL(register_sound_midi);
  *	Return: On success, the allocated number is returned. On failure,
  *	a negative error code is returned.
  */
-
 int register_sound_dsp(const struct file_operations *fops, int dev)
 {
 	return sound_insert_unit(&chains[3], fops, dev, 3, 131,
 				 "dsp", S_IWUSR | S_IRUSR, NULL);
 }
-
 EXPORT_SYMBOL(register_sound_dsp);
 
 /**
@@ -508,13 +501,10 @@ EXPORT_SYMBOL(register_sound_dsp);
  *	register_sound_special(). The unit passed is the return value from
  *	the register function.
  */
-
-
 void unregister_sound_special(int unit)
 {
 	sound_remove_unit(&chains[unit % SOUND_STEP], unit);
 }
- 
 EXPORT_SYMBOL(unregister_sound_special);
 
 /**
@@ -524,12 +514,10 @@ EXPORT_SYMBOL(unregister_sound_special);
  *	Release a sound device that was allocated with register_sound_mixer().
  *	The unit passed is the return value from the register function.
  */
-
 void unregister_sound_mixer(int unit)
 {
 	sound_remove_unit(&chains[0], unit);
 }
-
 EXPORT_SYMBOL(unregister_sound_mixer);
 
 /**
@@ -539,12 +527,10 @@ EXPORT_SYMBOL(unregister_sound_mixer);
  *	Release a sound device that was allocated with register_sound_midi().
  *	The unit passed is the return value from the register function.
  */
-
 void unregister_sound_midi(int unit)
 {
 	sound_remove_unit(&chains[2], unit);
 }
-
 EXPORT_SYMBOL(unregister_sound_midi);
 
 /**
@@ -556,25 +542,21 @@ EXPORT_SYMBOL(unregister_sound_midi);
  *
  *	Both of the allocated units are released together automatically.
  */
-
 void unregister_sound_dsp(int unit)
 {
 	sound_remove_unit(&chains[3], unit);
 }
-
-
 EXPORT_SYMBOL(unregister_sound_dsp);
 
 static struct sound_unit *__look_for_unit(int chain, int unit)
 {
 	struct sound_unit *s;
-	
-	s=chains[chain];
-	while(s && s->unit_minor <= unit)
-	{
-		if(s->unit_minor==unit)
+
+	s = chains[chain];
+	while (s && s->unit_minor <= unit) {
+		if (s->unit_minor == unit)
 			return s;
-		s=s->next;
+		s = s->next;
 	}
 	return NULL;
 }
@@ -586,14 +568,13 @@ static int soundcore_open(struct inode *inode, struct file *file)
 	struct sound_unit *s;
 	const struct file_operations *new_fops = NULL;
 
-	chain=unit&0x0F;
-	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
-	{
-		unit&=0xF0;
-		unit|=3;
-		chain=3;
+	chain = unit & 0x0F;
+	if (chain == 4 || chain == 5) {	/* dsp/audio/dsp16 */
+		unit &= 0xF0;
+		unit |= 3;
+		chain = 3;
 	}
-	
+
 	spin_lock(&sound_loader_lock);
 	s = __look_for_unit(chain, unit);
 	if (s)
@@ -636,7 +617,7 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		replace_fops(file, new_fops);
 
 		if (file->f_op->open)
-			err = file->f_op->open(inode,file);
+			err = file->f_op->open(inode, file);
 
 		return err;
 	}
@@ -656,7 +637,7 @@ static int __init init_oss_soundcore(void)
 {
 	if (preclaim_oss &&
 	    register_chrdev(SOUND_MAJOR, "sound", &soundcore_fops) == -1) {
-		printk(KERN_ERR "soundcore: sound device already in use.\n");
+		pr_err("sound device already in use\n");
 		return -EBUSY;
 	}
 


