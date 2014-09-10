Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaIJNwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:52:04 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46475 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaIJNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:51:59 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: aoa: printk replacement
Date: Wed, 10 Sep 2014 19:21:47 +0530
Message-Id: <1410357107-29933-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as pr_* macros are more preffered over printk, so printk replaced
with corresponding pr_* macros.
this patch will generate warning from checkpatch as it only did printk
replacement and didnot fixed the other warning of :
Alignment should match open parenthesis and 
Possible unnecessary 'out of memory' message

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

The replacement was done by a bash script to avoid copy paste error. The script is as follows :

OLD1="printk(KERN_DEBUG \?"
OLD2="printk(KERN_ERR \?"
OLD3="printk(KERN_INFO \?"
OLD4="printk(KERN_WARNING \?"
OLD5="printk(KERN_ALERT \?"
NEW1="pr_debug("
NEW2="pr_err("
NEW3="pr_info("
NEW4="pr_warn("
NEW5="pr_alert("
find . -type d -mindepth 0 -maxdepth 2 | while read DIR
do
for f in "${DIR}"/*.c
do
sed -i -e "s/$OLD1/$NEW1/g" -e "s/$OLD2/$NEW2/g" -e "s/$OLD3/$NEW3/g" -e "s/$OLD4/$NEW4/g" -e "s/$OLD5/$NEW5/g" "$f"
done
done

Takashi : thanks for the -i option.

for the codecs section another future patch can define proper pr_fmt
and eliminate the use of PFX while printing.

this patch is not build tested and i understand that you can reject the patch without even seeing at it.

 sound/aoa/codecs/onyx.c             | 16 ++++++++--------
 sound/aoa/codecs/tas.c              | 10 +++++-----
 sound/aoa/codecs/toonie.c           |  6 +++---
 sound/aoa/core/alsa.c               | 10 +++++-----
 sound/aoa/core/core.c               |  6 +++---
 sound/aoa/core/gpio-pmf.c           |  6 +++---
 sound/aoa/fabrics/layout.c          | 16 ++++++++--------
 sound/aoa/soundbus/core.c           |  2 +-
 sound/aoa/soundbus/i2sbus/control.c |  4 ++--
 sound/aoa/soundbus/i2sbus/core.c    |  8 ++++----
 sound/aoa/soundbus/i2sbus/pcm.c     | 28 ++++++++++++++--------------
 11 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 401107b..55aa69f 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -873,7 +873,7 @@ static int onyx_init_codec(struct aoa_codec *codec)
 	int err;
 
 	if (!onyx->codec.gpio || !onyx->codec.gpio->methods) {
-		printk(KERN_ERR PFX "gpios not assigned!!\n");
+		pr_err(PFX "gpios not assigned!!\n");
 		return -EINVAL;
 	}
 
@@ -885,12 +885,12 @@ static int onyx_init_codec(struct aoa_codec *codec)
 	msleep(1);
 
 	if (onyx_register_init(onyx)) {
-		printk(KERN_ERR PFX "failed to initialise onyx registers\n");
+		pr_err(PFX "failed to initialise onyx registers\n");
 		return -ENODEV;
 	}
 
 	if (aoa_snd_device_new(SNDRV_DEV_CODEC, onyx, &ops)) {
-		printk(KERN_ERR PFX "failed to create onyx snd device!\n");
+		pr_err(PFX "failed to create onyx snd device!\n");
 		return -ENODEV;
 	}
 
@@ -925,7 +925,7 @@ static int onyx_init_codec(struct aoa_codec *codec)
 	if (onyx->codec.soundbus_dev->attach_codec(onyx->codec.soundbus_dev,
 						   aoa_get_card(),
 						   ci, onyx)) {
-		printk(KERN_ERR PFX "error creating onyx pcm\n");
+		pr_err(PFX "error creating onyx pcm\n");
 		return -ENODEV;
 	}
 #define ADDCTL(n)							\
@@ -977,7 +977,7 @@ static int onyx_init_codec(struct aoa_codec *codec)
 		}
 	}
 #undef ADDCTL
-	printk(KERN_INFO PFX "attached to onyx codec via i2c\n");
+	pr_info(PFX "attached to onyx codec via i2c\n");
 
 	return 0;
  error:
@@ -991,7 +991,7 @@ static void onyx_exit_codec(struct aoa_codec *codec)
 	struct onyx *onyx = codec_to_onyx(codec);
 
 	if (!onyx->codec.soundbus_dev) {
-		printk(KERN_ERR PFX "onyx_exit_codec called without soundbus_dev!\n");
+		pr_err(PFX "onyx_exit_codec called without soundbus_dev!\n");
 		return;
 	}
 	onyx->codec.soundbus_dev->detach_codec(onyx->codec.soundbus_dev, onyx);
@@ -1016,7 +1016,7 @@ static int onyx_i2c_probe(struct i2c_client *client,
 	/* we try to read from register ONYX_REG_CONTROL
 	 * to check if the codec is present */
 	if (onyx_read_register(onyx, ONYX_REG_CONTROL, &dummy) != 0) {
-		printk(KERN_ERR PFX "failed to read control register\n");
+		pr_err(PFX "failed to read control register\n");
 		goto fail;
 	}
 
@@ -1029,7 +1029,7 @@ static int onyx_i2c_probe(struct i2c_client *client,
 	if (aoa_codec_register(&onyx->codec)) {
 		goto fail;
 	}
-	printk(KERN_DEBUG PFX "created and attached onyx instance\n");
+	pr_debug(PFX "created and attached onyx instance\n");
 	return 0;
  fail:
 	kfree(onyx);
diff --git a/sound/aoa/codecs/tas.c b/sound/aoa/codecs/tas.c
index cf3c630..abf6e8a 100644
--- a/sound/aoa/codecs/tas.c
+++ b/sound/aoa/codecs/tas.c
@@ -806,13 +806,13 @@ static int tas_init_codec(struct aoa_codec *codec)
 	int err;
 
 	if (!tas->codec.gpio || !tas->codec.gpio->methods) {
-		printk(KERN_ERR PFX "gpios not assigned!!\n");
+		pr_err(PFX "gpios not assigned!!\n");
 		return -EINVAL;
 	}
 
 	mutex_lock(&tas->mtx);
 	if (tas_reset_init(tas)) {
-		printk(KERN_ERR PFX "tas failed to initialise\n");
+		pr_err(PFX "tas failed to initialise\n");
 		mutex_unlock(&tas->mtx);
 		return -ENXIO;
 	}
@@ -822,12 +822,12 @@ static int tas_init_codec(struct aoa_codec *codec)
 	if (tas->codec.soundbus_dev->attach_codec(tas->codec.soundbus_dev,
 						   aoa_get_card(),
 						   &tas_codec_info, tas)) {
-		printk(KERN_ERR PFX "error attaching tas to soundbus\n");
+		pr_err(PFX "error attaching tas to soundbus\n");
 		return -ENODEV;
 	}
 
 	if (aoa_snd_device_new(SNDRV_DEV_CODEC, tas, &ops)) {
-		printk(KERN_ERR PFX "failed to create tas snd device!\n");
+		pr_err(PFX "failed to create tas snd device!\n");
 		return -ENODEV;
 	}
 	err = aoa_snd_ctl_add(snd_ctl_new1(&volume_control, tas));
@@ -910,7 +910,7 @@ static int tas_i2c_probe(struct i2c_client *client,
 	if (aoa_codec_register(&tas->codec)) {
 		goto fail;
 	}
-	printk(KERN_DEBUG
+	pr_debug(
 	       "snd-aoa-codec-tas: tas found, addr 0x%02x on %s\n",
 	       (unsigned int)client->addr, node->full_name);
 	return 0;
diff --git a/sound/aoa/codecs/toonie.c b/sound/aoa/codecs/toonie.c
index 7e8c341..f382d7f 100644
--- a/sound/aoa/codecs/toonie.c
+++ b/sound/aoa/codecs/toonie.c
@@ -93,14 +93,14 @@ static int toonie_init_codec(struct aoa_codec *codec)
 		return -ENOTCONN;
 
 	if (aoa_snd_device_new(SNDRV_DEV_CODEC, toonie, &ops)) {
-		printk(KERN_ERR PFX "failed to create toonie snd device!\n");
+		pr_err(PFX "failed to create toonie snd device!\n");
 		return -ENODEV;
 	}
 
 	if (toonie->codec.soundbus_dev->attach_codec(toonie->codec.soundbus_dev,
 						     aoa_get_card(),
 						     &toonie_codec_info, toonie)) {
-		printk(KERN_ERR PFX "error creating toonie pcm\n");
+		pr_err(PFX "error creating toonie pcm\n");
 		snd_device_free(aoa_get_card(), toonie);
 		return -ENODEV;
 	}
@@ -113,7 +113,7 @@ static void toonie_exit_codec(struct aoa_codec *codec)
 	struct toonie *toonie = codec_to_toonie(codec);
 
 	if (!toonie->codec.soundbus_dev) {
-		printk(KERN_ERR PFX "toonie_exit_codec called without soundbus_dev!\n");
+		pr_err(PFX "toonie_exit_codec called without soundbus_dev!\n");
 		return;
 	}
 	toonie->codec.soundbus_dev->detach_codec(toonie->codec.soundbus_dev, toonie);
diff --git a/sound/aoa/core/alsa.c b/sound/aoa/core/alsa.c
index 4a7e4e6..65367c3 100644
--- a/sound/aoa/core/alsa.c
+++ b/sound/aoa/core/alsa.c
@@ -35,7 +35,7 @@ int aoa_alsa_init(char *name, struct module *mod, struct device *dev)
 	strlcpy(alsa_card->mixername, name, sizeof(alsa_card->mixername));
 	err = snd_card_register(aoa_card->alsa_card);
 	if (err < 0) {
-		printk(KERN_ERR "snd-aoa: couldn't register alsa card\n");
+		pr_err("snd-aoa: couldn't register alsa card\n");
 		snd_card_free(aoa_card->alsa_card);
 		aoa_card = NULL;
 		return err;
@@ -69,14 +69,14 @@ int aoa_snd_device_new(enum snd_device_type type,
 
 	err = snd_device_new(card, type, device_data, ops);
 	if (err) {
-		printk(KERN_ERR "snd-aoa: failed to create snd device (%d)\n", err);
+		pr_err("snd-aoa: failed to create snd device (%d)\n", err);
 		return err;
 	}
 	err = snd_device_register(card, device_data);
 	if (err) {
-		printk(KERN_ERR "snd-aoa: failed to register "
+		pr_err("snd-aoa: failed to register "
 				"snd device (%d)\n", err);
-		printk(KERN_ERR "snd-aoa: have you forgotten the "
+		pr_err("snd-aoa: have you forgotten the "
 				"dev_register callback?\n");
 		snd_device_free(card, device_data);
 	}
@@ -92,7 +92,7 @@ int aoa_snd_ctl_add(struct snd_kcontrol* control)
 
 	err = snd_ctl_add(aoa_card->alsa_card, control);
 	if (err)
-		printk(KERN_ERR "snd-aoa: failed to add alsa control (%d)\n",
+		pr_err("snd-aoa: failed to add alsa control (%d)\n",
 		       err);
 	return err;
 }
diff --git a/sound/aoa/core/core.c b/sound/aoa/core/core.c
index 10bec6c..263ea80 100644
--- a/sound/aoa/core/core.c
+++ b/sound/aoa/core/core.c
@@ -33,7 +33,7 @@ static int attach_codec_to_fabric(struct aoa_codec *c)
 		err = fabric->found_codec(c);
 	if (err) {
 		module_put(c->owner);
-		printk(KERN_ERR "snd-aoa: fabric didn't like codec %s\n",
+		pr_err("snd-aoa: fabric didn't like codec %s\n",
 				c->name);
 		return err;
 	}
@@ -43,7 +43,7 @@ static int attach_codec_to_fabric(struct aoa_codec *c)
 	if (c->init)
 		err = c->init(c);
 	if (err) {
-		printk(KERN_ERR "snd-aoa: codec %s didn't init\n", c->name);
+		pr_err("snd-aoa: codec %s didn't init\n", c->name);
 		c->fabric = NULL;
 		if (fabric->remove_codec)
 			fabric->remove_codec(c);
@@ -134,7 +134,7 @@ EXPORT_SYMBOL_GPL(aoa_fabric_unregister);
 void aoa_fabric_unlink_codec(struct aoa_codec *codec)
 {
 	if (!codec->fabric) {
-		printk(KERN_ERR "snd-aoa: fabric unassigned "
+		pr_err("snd-aoa: fabric unassigned "
 				"in aoa_fabric_unlink_codec\n");
 		dump_stack();
 		return;
diff --git a/sound/aoa/core/gpio-pmf.c b/sound/aoa/core/gpio-pmf.c
index c8d8a1a..4a34f7b6 100644
--- a/sound/aoa/core/gpio-pmf.c
+++ b/sound/aoa/core/gpio-pmf.c
@@ -20,7 +20,7 @@ static void pmf_gpio_set_##name(struct gpio_runtime *rt, int on)\
 	if (unlikely(!rt)) return;				\
 	rc = pmf_call_function(rt->node, #name "-mute", &args);	\
 	if (rc && rc != -ENODEV)				\
-		printk(KERN_WARNING "pmf_gpio_set_" #name	\
+		pr_warn("pmf_gpio_set_" #name	\
 		" failed, rc: %d\n", rc);			\
 	rt->implementation_private &= ~(1<<bit);		\
 	rt->implementation_private |= (!!on << bit);		\
@@ -43,7 +43,7 @@ static void pmf_gpio_set_hw_reset(struct gpio_runtime *rt, int on)
 	if (unlikely(!rt)) return;
 	rc = pmf_call_function(rt->node, "hw-reset", &args);
 	if (rc)
-		printk(KERN_WARNING "pmf_gpio_set_hw_reset"
+		pr_warn("pmf_gpio_set_hw_reset"
 		       " failed, rc: %d\n", rc);
 }
 
@@ -190,7 +190,7 @@ static int pmf_set_notify(struct gpio_runtime *rt,
 					      name,
 					      irq_client);
 		if (err) {
-			printk(KERN_ERR "snd-aoa: gpio layer failed to"
+			pr_err("snd-aoa: gpio layer failed to"
 					" register %s irq (%d)\n", name, err);
 			kfree(irq_client);
 			goto out_unlock;
diff --git a/sound/aoa/fabrics/layout.c b/sound/aoa/fabrics/layout.c
index 9dc5806..c9d1956 100644
--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -773,18 +773,18 @@ static int check_codec(struct aoa_codec *codec,
 			 "platform-%s-codec-ref", codec->name);
 		ref = of_get_property(ldev->sound, propname, NULL);
 		if (!ref) {
-			printk(KERN_INFO "snd-aoa-fabric-layout: "
+			pr_info("snd-aoa-fabric-layout: "
 				"required property %s not present\n", propname);
 			return -ENODEV;
 		}
 		if (*ref != codec->node->phandle) {
-			printk(KERN_INFO "snd-aoa-fabric-layout: "
+			pr_info("snd-aoa-fabric-layout: "
 				"%s doesn't match!\n", propname);
 			return -ENODEV;
 		}
 	} else {
 		if (layouts_list_items != 1) {
-			printk(KERN_INFO "snd-aoa-fabric-layout: "
+			pr_info("snd-aoa-fabric-layout: "
 				"more than one soundbus, but no references.\n");
 			return -ENODEV;
 		}
@@ -796,7 +796,7 @@ static int check_codec(struct aoa_codec *codec,
 	if (!cc)
 		return -EINVAL;
 
-	printk(KERN_INFO "snd-aoa-fabric-layout: can use this codec\n");
+	pr_info("snd-aoa-fabric-layout: can use this codec\n");
 
 	codec->connected = 0;
 	codec->fabric_data = cc;
@@ -1017,7 +1017,7 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 	}
 
 	if (!layout) {
-		printk(KERN_ERR "snd-aoa-fabric-layout: unknown layout\n");
+		pr_err("snd-aoa-fabric-layout: unknown layout\n");
 		goto outnodev;
 	}
 
@@ -1036,12 +1036,12 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 	case 51: /* PowerBook5,4 */
 	case 58: /* Mac Mini */
 		ldev->gpio.methods = ftr_gpio_methods;
-		printk(KERN_DEBUG
+		pr_debug(
 		       "snd-aoa-fabric-layout: Using direct GPIOs\n");
 		break;
 	default:
 		ldev->gpio.methods = pmf_gpio_methods;
-		printk(KERN_DEBUG
+		pr_debug(
 		       "snd-aoa-fabric-layout: Using PMF GPIOs\n");
 	}
 	ldev->selfptr_headphone.ptr = ldev;
@@ -1064,7 +1064,7 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 
 	err = aoa_fabric_register(&layout_fabric, &sdev->ofdev.dev);
 	if (err && err != -EALREADY) {
-		printk(KERN_INFO "snd-aoa-fabric-layout: can't use,"
+		pr_info("snd-aoa-fabric-layout: can't use,"
 				 " another fabric is active!\n");
 		goto outlistdel;
 	}
diff --git a/sound/aoa/soundbus/core.c b/sound/aoa/soundbus/core.c
index 7487eb7..c1438eb 100644
--- a/sound/aoa/soundbus/core.c
+++ b/sound/aoa/soundbus/core.c
@@ -172,7 +172,7 @@ int soundbus_add_one(struct soundbus_dev *dev)
 	    !dev->ofdev.dev.of_node ||
 	    dev->pcmname ||
 	    dev->pcmid != -1) {
-		printk(KERN_ERR "soundbus: adding device failed sanity check!\n");
+		pr_err("soundbus: adding device failed sanity check!\n");
 		return -EINVAL;
 	}
 
diff --git a/sound/aoa/soundbus/i2sbus/control.c b/sound/aoa/soundbus/i2sbus/control.c
index 4dc9b49..2672d1c 100644
--- a/sound/aoa/soundbus/i2sbus/control.c
+++ b/sound/aoa/soundbus/i2sbus/control.c
@@ -124,7 +124,7 @@ int i2sbus_control_cell(struct i2sbus_control *c,
 			return pmf_call_one(i2sdev->cell_enable, &args);
 		break;
 	default:
-		printk(KERN_ERR "i2sbus: INVALID CELL ENABLE VALUE\n");
+		pr_err("i2sbus: INVALID CELL ENABLE VALUE\n");
 		return -ENODEV;
 	}
 
@@ -167,7 +167,7 @@ int i2sbus_control_clock(struct i2sbus_control *c,
 			return pmf_call_one(i2sdev->clock_enable, &args);
 		break;
 	default:
-		printk(KERN_ERR "i2sbus: INVALID CLOCK ENABLE VALUE\n");
+		pr_err("i2sbus: INVALID CLOCK ENABLE VALUE\n");
 		return -ENODEV;
 	}
 
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index a80d5ea..d7bb0de 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -264,7 +264,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 					   resource_size(&dev->resources[i]),
 					   dev->rnames[i]);
 		if (!dev->allocated_resource[i]) {
-			printk(KERN_ERR "i2sbus: failed to claim resource %d!\n", i);
+			pr_err("i2sbus: failed to claim resource %d!\n", i);
 			goto err;
 		}
 	}
@@ -298,12 +298,12 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 		goto err;
 
 	if (i2sbus_control_add_dev(dev->control, dev)) {
-		printk(KERN_ERR "i2sbus: control layer didn't like bus\n");
+		pr_err("i2sbus: control layer didn't like bus\n");
 		goto err;
 	}
 
 	if (soundbus_add_one(&dev->sound)) {
-		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		pr_debug("i2sbus: device registration error!\n");
 		goto err;
 	}
 
@@ -340,7 +340,7 @@ static int i2sbus_probe(struct macio_dev* dev, const struct of_device_id *match)
 	if (err)
 		return err;
 	if (!control) {
-		printk(KERN_ERR "i2sbus_control_init API breakage\n");
+		pr_err("i2sbus_control_init API breakage\n");
 		return -ENODEV;
 	}
 
diff --git a/sound/aoa/soundbus/i2sbus/pcm.c b/sound/aoa/soundbus/i2sbus/pcm.c
index 7b74a4b..f9e272c 100644
--- a/sound/aoa/soundbus/i2sbus/pcm.c
+++ b/sound/aoa/soundbus/i2sbus/pcm.c
@@ -268,7 +268,7 @@ static void i2sbus_wait_for_stop(struct i2sbus_dev *i2sdev,
 		pi->stop_completion = NULL;
 		if (timeout == 0) {
 			/* timeout expired, stop dbdma forcefully */
-			printk(KERN_ERR "i2sbus_wait_for_stop: timed out\n");
+			pr_err("i2sbus_wait_for_stop: timed out\n");
 			/* make sure RUN, PAUSE and S0 bits are cleared */
 			out_le32(&pi->dbdma->control, (RUN | PAUSE | 1) << 16);
 			pi->dbdma_ring.stopping = 0;
@@ -681,7 +681,7 @@ static inline void handle_interrupt(struct i2sbus_dev *i2sdev, int in)
 			if (!(status & ACTIVE) && (!in || (status & 0x80)))
 				break;
 			if (--timeout <= 0) {
-				printk(KERN_ERR "i2sbus: timed out "
+				pr_err("i2sbus: timed out "
 				       "waiting for DMA to stop!\n");
 				break;
 			}
@@ -868,7 +868,7 @@ static void i2sbus_private_free(struct snd_pcm *pcm)
 	i2sdev->out.created = 0;
 	i2sdev->in.created = 0;
 	list_for_each_entry_safe(p, tmp, &i2sdev->sound.codec_list, list) {
-		printk(KERN_ERR "i2sbus: a codec didn't unregister!\n");
+		pr_err("i2sbus: a codec didn't unregister!\n");
 		list_del(&p->list);
 		module_put(p->codec->owner);
 		kfree(p);
@@ -887,7 +887,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 	struct codec_info_item *cii;
 
 	if (!dev->pcmname || dev->pcmid == -1) {
-		printk(KERN_ERR "i2sbus: pcm name and id must be set!\n");
+		pr_err("i2sbus: pcm name and id must be set!\n");
 		return -EINVAL;
 	}
 
@@ -910,12 +910,12 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 	 * sysclock/busclock stuff above to depend on which is usable */
 	list_for_each_entry(cii, &dev->codec_list, list) {
 		if (cii->codec->sysclock_factor != ci->sysclock_factor) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "cannot yet handle multiple different sysclocks!\n");
 			return -EINVAL;
 		}
 		if (cii->codec->bus_factor != ci->bus_factor) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "cannot yet handle multiple different bus clocks!\n");
 			return -EINVAL;
 		}
@@ -932,7 +932,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 
 	cii = kzalloc(sizeof(struct codec_info_item), GFP_KERNEL);
 	if (!cii) {
-		printk(KERN_DEBUG "i2sbus: failed to allocate cii\n");
+		pr_debug("i2sbus: failed to allocate cii\n");
 		return -ENOMEM;
 	}
 
@@ -942,20 +942,20 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 	cii->codec_data = data;
 
 	if (!cii->sdev) {
-		printk(KERN_DEBUG
+		pr_debug(
 		       "i2sbus: failed to get soundbus dev reference\n");
 		err = -ENODEV;
 		goto out_free_cii;
 	}
 
 	if (!try_module_get(THIS_MODULE)) {
-		printk(KERN_DEBUG "i2sbus: failed to get module reference!\n");
+		pr_debug("i2sbus: failed to get module reference!\n");
 		err = -EBUSY;
 		goto out_put_sdev;
 	}
 
 	if (!try_module_get(ci->owner)) {
-		printk(KERN_DEBUG
+		pr_debug(
 		       "i2sbus: failed to get module reference to codec owner!\n");
 		err = -EBUSY;
 		goto out_put_this_module;
@@ -965,7 +965,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 		err = snd_pcm_new(card, dev->pcmname, dev->pcmid, 0, 0,
 				  &dev->pcm);
 		if (err) {
-			printk(KERN_DEBUG "i2sbus: failed to create pcm\n");
+			pr_debug("i2sbus: failed to create pcm\n");
 			goto out_put_ci_module;
 		}
 		dev->pcm->dev = &dev->ofdev.dev;
@@ -978,7 +978,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 	if (!i2sdev->out.created && out) {
 		if (dev->pcm->card != card) {
 			/* eh? */
-			printk(KERN_ERR
+			pr_err(
 			       "Can't attach same bus to different cards!\n");
 			err = -EINVAL;
 			goto out_put_ci_module;
@@ -993,7 +993,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 
 	if (!i2sdev->in.created && in) {
 		if (dev->pcm->card != card) {
-			printk(KERN_ERR
+			pr_err(
 			       "Can't attach same bus to different cards!\n");
 			err = -EINVAL;
 			goto out_put_ci_module;
@@ -1014,7 +1014,7 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 	 */
 	err = snd_device_register(card, dev->pcm);
 	if (err) {
-		printk(KERN_ERR "i2sbus: error registering new pcm\n");
+		pr_err("i2sbus: error registering new pcm\n");
 		goto out_put_ci_module;
 	}
 	/* no errors any more, so let's add this to our list */
-- 
1.8.1.2

