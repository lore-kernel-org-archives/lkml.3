Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3CKVFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:05:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54577 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CKVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:05:41 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Jeffrin Jose <ahiliation@yahoo.co.in>, Al Viro <viro@zeniv.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ian Minett <ian_minett@creativelabs.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Randy Dunlap <rdunlap@xenotime.net>, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCH] sound: add/change some comments describing function return values
Date: Mon, 11 Mar 2013 22:05:14 +0100
Message-Id: <1363035914-2700-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

script/kernel-doc reports the following type of warnings (when run in verbose
mode):

Warning(sound/core/init.c:152): No description found for return value of
'snd_card_create'

To fix that:
- add missing descriptions of function return values
- use "Return:" sections to describe those return values

Along the way:
- complete some descriptions
- fix some typos

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---
 include/sound/control.h            |    5 +++-
 include/sound/core.h               |    2 +-
 include/sound/pcm.h                |   23 +++++++++------
 sound/core/control.c               |   41 +++++++++++++++------------
 sound/core/device.c                |    8 +++---
 sound/core/hwdep.c                 |    2 +-
 sound/core/info.c                  |   16 +++++------
 sound/core/init.c                  |   16 ++++++-----
 sound/core/isadma.c                |    2 +-
 sound/core/jack.c                  |    6 ++--
 sound/core/memalloc.c              |   20 ++++++-------
 sound/core/memory.c                |    4 +--
 sound/core/pcm.c                   |    6 ++--
 sound/core/pcm_lib.c               |   54 ++++++++++++++++++++++++++++--------
 sound/core/pcm_memory.c            |   19 ++++++++-----
 sound/core/pcm_misc.c              |   28 +++++++++----------
 sound/core/pcm_native.c            |   13 +++++++++
 sound/core/rawmidi.c               |   14 +++++-----
 sound/core/sound.c                 |    7 +++--
 sound/core/vmaster.c               |    7 +++--
 sound/drivers/mpu401/mpu401_uart.c |    6 +++-
 sound/pci/ac97/ac97_codec.c        |   16 ++++++-----
 sound/pci/ac97/ac97_pcm.c          |   10 ++++++-
 sound/sound_core.c                 |   22 ++++++++++-----
 24 files changed, 221 insertions(+), 126 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index 8332e86..34bc93d 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -189,7 +189,6 @@ int _snd_ctl_add_slave(struct snd_kcontrol *master, struct snd_kcontrol *slave,
  *
  * Add a virtual slave control to the given master element created via
  * snd_ctl_create_virtual_master() beforehand.
- * Returns zero if successful or a negative error code.
  *
  * All slaves must be the same type (returning the same information
  * via info callback).  The function doesn't check it, so it's your
@@ -199,6 +198,8 @@ int _snd_ctl_add_slave(struct snd_kcontrol *master, struct snd_kcontrol *slave,
  * at most two channels,
  * logarithmic volume control (dB level) thus no linear volume,
  * master can only attenuate the volume without gain
+ *
+ * Return: Zero if successful or a negative error code.
  */
 static inline int
 snd_ctl_add_slave(struct snd_kcontrol *master, struct snd_kcontrol *slave)
@@ -219,6 +220,8 @@ snd_ctl_add_slave(struct snd_kcontrol *master, struct snd_kcontrol *slave)
  * When the control peeks the hardware values directly and the value
  * can be changed by other means than the put callback of the element,
  * this function should be used to keep the value always up-to-date.
+ *
+ * Return: Zero if successful or a negative error code.
  */
 static inline int
 snd_ctl_add_slave_uncached(struct snd_kcontrol *master,
diff --git a/include/sound/core.h b/include/sound/core.h
index 7cede2d..80d5db3 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -229,7 +229,7 @@ int snd_register_device_for_dev(int type, struct snd_card *card,
  * This function uses the card's device pointer to link to the
  * correct &struct device.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 static inline int snd_register_device(int type, struct snd_card *card, int dev,
 				      const struct file_operations *f_ops,
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 45c1981..aa7b0a8 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -659,7 +659,7 @@ static inline snd_pcm_sframes_t snd_pcm_capture_hw_avail(struct snd_pcm_runtime
  *
  * Checks whether enough free space is available on the playback buffer.
  *
- * Returns non-zero if available, or zero if not.
+ * Return: Non-zero if available, or zero if not.
  */
 static inline int snd_pcm_playback_ready(struct snd_pcm_substream *substream)
 {
@@ -673,7 +673,7 @@ static inline int snd_pcm_playback_ready(struct snd_pcm_substream *substream)
  *
  * Checks whether enough capture data is available on the capture buffer.
  *
- * Returns non-zero if available, or zero if not.
+ * Return: Non-zero if available, or zero if not.
  */
 static inline int snd_pcm_capture_ready(struct snd_pcm_substream *substream)
 {
@@ -685,10 +685,10 @@ static inline int snd_pcm_capture_ready(struct snd_pcm_substream *substream)
  * snd_pcm_playback_data - check whether any data exists on the playback buffer
  * @substream: the pcm substream instance
  *
- * Checks whether any data exists on the playback buffer. If stop_threshold
- * is bigger or equal to boundary, then this function returns always non-zero.
+ * Checks whether any data exists on the playback buffer.
  *
- * Returns non-zero if exists, or zero if not.
+ * Return: Non-zero if any data exists, or zero if not. If stop_threshold
+ * is bigger or equal to boundary, then this function returns always non-zero.
  */
 static inline int snd_pcm_playback_data(struct snd_pcm_substream *substream)
 {
@@ -705,7 +705,7 @@ static inline int snd_pcm_playback_data(struct snd_pcm_substream *substream)
  *
  * Checks whether the playback buffer is empty.
  *
- * Returns non-zero if empty, or zero if not.
+ * Return: Non-zero if empty, or zero if not.
  */
 static inline int snd_pcm_playback_empty(struct snd_pcm_substream *substream)
 {
@@ -719,7 +719,7 @@ static inline int snd_pcm_playback_empty(struct snd_pcm_substream *substream)
  *
  * Checks whether the capture buffer is empty.
  *
- * Returns non-zero if empty, or zero if not.
+ * Return: Non-zero if empty, or zero if not.
  */
 static inline int snd_pcm_capture_empty(struct snd_pcm_substream *substream)
 {
@@ -852,7 +852,7 @@ int snd_pcm_format_big_endian(snd_pcm_format_t format);
  * snd_pcm_format_cpu_endian - Check the PCM format is CPU-endian
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is CPU-endian, 0 if
+ * Return: 1 if the given PCM format is CPU-endian, 0 if
  * opposite, or a negative error code if endian not specified.
  */
 int snd_pcm_format_cpu_endian(snd_pcm_format_t format);
@@ -963,7 +963,7 @@ struct page *snd_pcm_lib_get_vmalloc_page(struct snd_pcm_substream *substream,
  * contiguous in kernel virtual space, but not in physical memory.  Use this
  * if the buffer is accessed by kernel code but not by device DMA.
  *
- * Returns 1 if the buffer was changed, 0 if not changed, or a negative error
+ * Return: 1 if the buffer was changed, 0 if not changed, or a negative error
  * code.
  */
 static int snd_pcm_lib_alloc_vmalloc_buffer
@@ -975,6 +975,9 @@ static int snd_pcm_lib_alloc_vmalloc_buffer
  *
  * This function works like snd_pcm_lib_alloc_vmalloc_buffer(), but uses
  * vmalloc_32(), i.e., the pages are allocated from 32-bit-addressable memory.
+ *
+ * Return: 1 if the buffer was changed, 0 if not changed, or a negative error
+ * code.
  */
 static int snd_pcm_lib_alloc_vmalloc_32_buffer
 			(struct snd_pcm_substream *substream, size_t size);
@@ -1070,6 +1073,8 @@ const char *snd_pcm_format_name(snd_pcm_format_t format);
 /**
  * snd_pcm_stream_str - Get a string naming the direction of a stream
  * @substream: the pcm substream instance
+ *
+ * Return: A string naming the direction of the stream.
  */
 static inline const char *snd_pcm_stream_str(struct snd_pcm_substream *substream)
 {
diff --git a/sound/core/control.c b/sound/core/control.c
index 8c7c2c9..d8aa206 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -190,7 +190,7 @@ EXPORT_SYMBOL(snd_ctl_notify);
  * Allocates a new struct snd_kcontrol instance and copies the given template 
  * to the new instance. It does not copy volatile data (access).
  *
- * Returns the pointer of the new instance, or NULL on failure.
+ * Return: The pointer of the new instance, or %NULL on failure.
  */
 static struct snd_kcontrol *snd_ctl_new(struct snd_kcontrol *control,
 					unsigned int access)
@@ -224,7 +224,7 @@ static struct snd_kcontrol *snd_ctl_new(struct snd_kcontrol *control,
  * template.  When the access field of ncontrol is 0, it's assumed as
  * READWRITE access. When the count field is 0, it's assumes as one.
  *
- * Returns the pointer of the newly generated instance, or NULL on failure.
+ * Return: The pointer of the newly generated instance, or %NULL on failure.
  */
 struct snd_kcontrol *snd_ctl_new1(const struct snd_kcontrol_new *ncontrol,
 				  void *private_data)
@@ -322,9 +322,10 @@ static int snd_ctl_find_hole(struct snd_card *card, unsigned int count)
  * snd_ctl_new1() to the given card. Assigns also an unique
  * numid used for fast search.
  *
- * Returns zero if successful, or a negative error code on failure.
- *
  * It frees automatically the control which cannot be added.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
+ *
  */
 int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 {
@@ -380,9 +381,9 @@ EXPORT_SYMBOL(snd_ctl_add);
  * and the add_on_replace flag is set, the control is added.  If the
  * control exists, it is destroyed first.
  *
- * Returns zero if successful, or a negative error code on failure.
- *
  * It frees automatically the control which cannot be added or replaced.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ctl_replace(struct snd_card *card, struct snd_kcontrol *kcontrol,
 		    bool add_on_replace)
@@ -442,8 +443,8 @@ EXPORT_SYMBOL(snd_ctl_replace);
  * Removes the control from the card and then releases the instance.
  * You don't need to call snd_ctl_free_one(). You must be in
  * the write lock - down_write(&card->controls_rwsem).
- * 
- * Returns 0 if successful, or a negative error code on failure.
+ *
+ * Return: 0 if successful, or a negative error code on failure.
  */
 int snd_ctl_remove(struct snd_card *card, struct snd_kcontrol *kcontrol)
 {
@@ -470,8 +471,8 @@ EXPORT_SYMBOL(snd_ctl_remove);
  *
  * Finds the control instance with the given id, removes it from the
  * card list and releases it.
- * 
- * Returns 0 if successful, or a negative error code on failure.
+ *
+ * Return: 0 if successful, or a negative error code on failure.
  */
 int snd_ctl_remove_id(struct snd_card *card, struct snd_ctl_elem_id *id)
 {
@@ -498,8 +499,8 @@ EXPORT_SYMBOL(snd_ctl_remove_id);
  *
  * Finds the control instance with the given id, removes it from the
  * card list and releases it.
- * 
- * Returns 0 if successful, or a negative error code on failure.
+ *
+ * Return: 0 if successful, or a negative error code on failure.
  */
 static int snd_ctl_remove_user_ctl(struct snd_ctl_file * file,
 				   struct snd_ctl_elem_id *id)
@@ -541,7 +542,7 @@ error:
  * Finds the control instance with the given id, and activate or
  * inactivate the control together with notification, if changed.
  *
- * Returns 0 if unchanged, 1 if changed, or a negative error code on failure.
+ * Return: 0 if unchanged, 1 if changed, or a negative error code on failure.
  */
 int snd_ctl_activate_id(struct snd_card *card, struct snd_ctl_elem_id *id,
 			int active)
@@ -587,7 +588,7 @@ EXPORT_SYMBOL_GPL(snd_ctl_activate_id);
  * Finds the control with the old id from the card, and replaces the
  * id with the new one.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ctl_rename_id(struct snd_card *card, struct snd_ctl_elem_id *src_id,
 		      struct snd_ctl_elem_id *dst_id)
@@ -616,10 +617,11 @@ EXPORT_SYMBOL(snd_ctl_rename_id);
  *
  * Finds the control instance with the given number-id from the card.
  *
- * Returns the pointer of the instance if found, or NULL if not.
- *
  * The caller must down card->controls_rwsem before calling this function
  * (if the race condition can happen).
+ *
+ * Return: The pointer of the instance if found, or %NULL if not.
+ *
  */
 struct snd_kcontrol *snd_ctl_find_numid(struct snd_card *card, unsigned int numid)
 {
@@ -643,10 +645,11 @@ EXPORT_SYMBOL(snd_ctl_find_numid);
  *
  * Finds the control instance with the given id from the card.
  *
- * Returns the pointer of the instance if found, or NULL if not.
- *
  * The caller must down card->controls_rwsem before calling this function
  * (if the race condition can happen).
+ *
+ * Return: The pointer of the instance if found, or %NULL if not.
+ *
  */
 struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
 				     struct snd_ctl_elem_id *id)
@@ -1710,6 +1713,8 @@ EXPORT_SYMBOL(snd_ctl_boolean_stereo_info);
  * Sets all required fields in @info to their appropriate values.
  * If the control's accessibility is not the default (readable and writable),
  * the caller has to fill @info->access.
+ *
+ * Return: Zero.
  */
 int snd_ctl_enum_info(struct snd_ctl_elem_info *info, unsigned int channels,
 		      unsigned int items, const char *const names[])
diff --git a/sound/core/device.c b/sound/core/device.c
index f03cb54..df88def 100644
--- a/sound/core/device.c
+++ b/sound/core/device.c
@@ -39,7 +39,7 @@
  * The data pointer plays a role as the identifier, too, so the
  * pointer address must be unique and unchanged.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_device_new(struct snd_card *card, snd_device_type_t type,
 		   void *device_data, struct snd_device_ops *ops)
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(snd_device_new);
  * callbacks, dev_disconnect and dev_free, corresponding to the state.
  * Then release the device.
  *
- * Returns zero if successful, or a negative error code on failure or if the
+ * Return: Zero if successful, or a negative error code on failure or if the
  * device not found.
  */
 int snd_device_free(struct snd_card *card, void *device_data)
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(snd_device_free);
  *
  * Usually called from snd_card_disconnect().
  *
- * Returns zero if successful, or a negative error code on failure or if the
+ * Return: Zero if successful, or a negative error code on failure or if the
  * device not found.
  */
 int snd_device_disconnect(struct snd_card *card, void *device_data)
@@ -151,7 +151,7 @@ int snd_device_disconnect(struct snd_card *card, void *device_data)
  * but it can be called later if any new devices are created after
  * invocation of snd_card_register().
  *
- * Returns zero if successful, or a negative error code on failure or if the
+ * Return: Zero if successful, or a negative error code on failure or if the
  * device not found.
  */
 int snd_device_register(struct snd_card *card, void *device_data)
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 3f7f662..d105073 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -356,7 +356,7 @@ static const struct file_operations snd_hwdep_f_ops =
  * The callbacks (hwdep->ops) must be set on the returned instance
  * after this call manually by the caller.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_hwdep_new(struct snd_card *card, char *id, int device,
 		  struct snd_hwdep **rhwdep)
diff --git a/sound/core/info.c b/sound/core/info.c
index 5bb97e7..db308db 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -105,7 +105,7 @@ static int resize_info_buffer(struct snd_info_buffer *buffer,
  *
  * Outputs the string on the procfs buffer just like printf().
  *
- * Returns the size of output string.
+ * Return: The size of output string, or a negative error code.
  */
 int snd_iprintf(struct snd_info_buffer *buffer, const char *fmt, ...)
 {
@@ -694,7 +694,7 @@ int snd_info_card_free(struct snd_card *card)
  *
  * Reads one line from the buffer and stores the string.
  *
- * Returns zero if successful, or 1 if error or EOF.
+ * Return: Zero if successful, or 1 if error or EOF.
  */
 int snd_info_get_line(struct snd_info_buffer *buffer, char *line, int len)
 {
@@ -735,7 +735,7 @@ EXPORT_SYMBOL(snd_info_get_line);
  * Parses the original string and copy a token to the given
  * string buffer.
  *
- * Returns the updated pointer of the original string so that
+ * Return: The updated pointer of the original string so that
  * it can be used for the next call.
  */
 const char *snd_info_get_str(char *dest, const char *src, int len)
@@ -774,7 +774,7 @@ EXPORT_SYMBOL(snd_info_get_str);
  * Usually called from other functions such as
  * snd_info_create_card_entry().
  *
- * Returns the pointer of the new instance, or NULL on failure.
+ * Return: The pointer of the new instance, or %NULL on failure.
  */
 static struct snd_info_entry *snd_info_create_entry(const char *name)
 {
@@ -803,7 +803,7 @@ static struct snd_info_entry *snd_info_create_entry(const char *name)
  *
  * Creates a new info entry and assigns it to the given module.
  *
- * Returns the pointer of the new instance, or NULL on failure.
+ * Return: The pointer of the new instance, or %NULL on failure.
  */
 struct snd_info_entry *snd_info_create_module_entry(struct module * module,
 					       const char *name,
@@ -827,7 +827,7 @@ EXPORT_SYMBOL(snd_info_create_module_entry);
  *
  * Creates a new info entry and assigns it to the given card.
  *
- * Returns the pointer of the new instance, or NULL on failure.
+ * Return: The pointer of the new instance, or %NULL on failure.
  */
 struct snd_info_entry *snd_info_create_card_entry(struct snd_card *card,
 					     const char *name,
@@ -893,7 +893,7 @@ static int snd_info_dev_register_entry(struct snd_device *device)
  * For releasing this entry, use snd_device_free() instead of
  * snd_info_free_entry(). 
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_card_proc_new(struct snd_card *card, const char *name,
 		      struct snd_info_entry **entryp)
@@ -949,7 +949,7 @@ EXPORT_SYMBOL(snd_info_free_entry);
  *
  * Registers the proc info entry.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_info_register(struct snd_info_entry * entry)
 {
diff --git a/sound/core/init.c b/sound/core/init.c
index 7b012d1..6ef0640 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -144,7 +144,7 @@ static inline int init_info_for_card(struct snd_card *card)
  *  space for the driver to use freely.  The allocated struct is stored
  *  in the given card_ret pointer.
  *
- *  Returns zero if successful or a negative error code.
+ *  Return: Zero if successful or a negative error code.
  */
 int snd_card_create(int idx, const char *xid,
 		    struct module *module, int extra_size,
@@ -337,7 +337,7 @@ static const struct file_operations snd_shutdown_f_ops =
  *
  *  Disconnects all APIs from the file-operations (user space).
  *
- *  Returns zero, otherwise a negative error code.
+ *  Return: Zero, otherwise a negative error code.
  *
  *  Note: The current implementation replaces all active file->f_op with special
  *        dummy file operations (they do nothing except release).
@@ -415,7 +415,7 @@ EXPORT_SYMBOL(snd_card_disconnect);
  *  devices automatically.  That is, you don't have to release the devices
  *  by yourself.
  *
- *  Returns zero. Frees all associated devices and frees the control
+ *  Return: Zero. Frees all associated devices and frees the control
  *  interface associated to given soundcard.
  */
 static int snd_card_do_free(struct snd_card *card)
@@ -677,7 +677,7 @@ static struct device_attribute card_number_attrs =
  *  external accesses.  Thus, you should call this function at the end
  *  of the initialization of the card.
  *
- *  Returns zero otherwise a negative error code if the registration failed.
+ *  Return: Zero otherwise a negative error code if the registration failed.
  */
 int snd_card_register(struct snd_card *card)
 {
@@ -849,7 +849,7 @@ int __exit snd_card_info_done(void)
  *  This function adds the component id string to the supported list.
  *  The component can be referred from the alsa-lib.
  *
- *  Returns zero otherwise a negative error code.
+ *  Return: Zero otherwise a negative error code.
  */
   
 int snd_component_add(struct snd_card *card, const char *component)
@@ -883,7 +883,7 @@ EXPORT_SYMBOL(snd_component_add);
  *  This linked-list is used to keep tracking the connection state,
  *  and to avoid the release of busy resources by hotplug.
  *
- *  Returns zero or a negative error code.
+ *  Return: zero or a negative error code.
  */
 int snd_card_file_add(struct snd_card *card, struct file *file)
 {
@@ -920,7 +920,7 @@ EXPORT_SYMBOL(snd_card_file_add);
  *  called beforehand, it processes the pending release of
  *  resources.
  *
- *  Returns zero or a negative error code.
+ *  Return: Zero or a negative error code.
  */
 int snd_card_file_remove(struct snd_card *card, struct file *file)
 {
@@ -959,6 +959,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
  *
  *  Waits until the power-state is changed.
  *
+ *  Return: Zero if successful, or a negative error code.
+ *
  *  Note: the power lock must be active before call.
  */
 int snd_power_wait(struct snd_card *card, unsigned int power_state)
diff --git a/sound/core/isadma.c b/sound/core/isadma.c
index c0f1208..e2b3861 100644
--- a/sound/core/isadma.c
+++ b/sound/core/isadma.c
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(snd_dma_disable);
  * @dma: the dma number
  * @size: the dma transfer size
  *
- * Returns the current pointer in DMA tranfer buffer in bytes
+ * Return: The current pointer in DMA transfer buffer in bytes.
  */
 unsigned int snd_dma_pointer(unsigned long dma, unsigned int size)
 {
diff --git a/sound/core/jack.c b/sound/core/jack.c
index a06b165..b35fe73 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -98,8 +98,8 @@ static int snd_jack_dev_register(struct snd_device *device)
  *
  * Creates a new jack object.
  *
- * Returns zero if successful, or a negative error code on failure.
- * On success jjack will be initialised.
+ * Return: Zero if successful, or a negative error code on failure.
+ * On success @jjack will be initialised.
  */
 int snd_jack_new(struct snd_card *card, const char *id, int type,
 		 struct snd_jack **jjack)
@@ -189,6 +189,8 @@ EXPORT_SYMBOL(snd_jack_set_parent);
  * using this abstraction.
  *
  * This function may only be called prior to registration of the jack.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_jack_set_key(struct snd_jack *jack, enum snd_jack_types type,
 		     int keytype)
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 6915692..bdf826f 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -81,7 +81,7 @@ static inline void dec_snd_pages(int order)
  *
  * Allocates the physically contiguous pages with the given size.
  *
- * Returns the pointer of the buffer, or NULL if no enoguh memory.
+ * Return: The pointer of the buffer, or %NULL if no enough memory.
  */
 void *snd_malloc_pages(size_t size, gfp_t gfp_flags)
 {
@@ -175,9 +175,9 @@ static void snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
  *
  * Calls the memory-allocator function for the corresponding
  * buffer type.
- * 
- * Returns zero if the buffer with the given size is allocated successfully,
- * other a negative value at error.
+ *
+ * Return: Zero if the buffer with the given size is allocated successfully,
+ * otherwise a negative value on error.
  */
 int snd_dma_alloc_pages(int type, struct device *device, size_t size,
 			struct snd_dma_buffer *dmab)
@@ -229,9 +229,9 @@ int snd_dma_alloc_pages(int type, struct device *device, size_t size,
  * buffer type.  When no space is left, this function reduces the size and
  * tries to allocate again.  The size actually allocated is stored in
  * res_size argument.
- * 
- * Returns zero if the buffer with the given size is allocated successfully,
- * other a negative value at error.
+ *
+ * Return: Zero if the buffer with the given size is allocated successfully,
+ * otherwise a negative value on error.
  */
 int snd_dma_alloc_pages_fallback(int type, struct device *device, size_t size,
 				 struct snd_dma_buffer *dmab)
@@ -292,7 +292,7 @@ void snd_dma_free_pages(struct snd_dma_buffer *dmab)
  * Looks for the reserved-buffer list and re-uses if the same buffer
  * is found in the list.  When the buffer is found, it's removed from the free list.
  *
- * Returns the size of buffer if the buffer is found, or zero if not found.
+ * Return: The size of buffer if the buffer is found, or zero if not found.
  */
 size_t snd_dma_get_reserved_buf(struct snd_dma_buffer *dmab, unsigned int id)
 {
@@ -326,8 +326,8 @@ size_t snd_dma_get_reserved_buf(struct snd_dma_buffer *dmab, unsigned int id)
  * @id: the buffer id
  *
  * Reserves the given buffer as a reserved buffer.
- * 
- * Returns zero if successful, or a negative code at error.
+ *
+ * Return: Zero if successful, or a negative code on error.
  */
 int snd_dma_reserve_buf(struct snd_dma_buffer *dmab, unsigned int id)
 {
diff --git a/sound/core/memory.c b/sound/core/memory.c
index 66a278d..36c0f1a 100644
--- a/sound/core/memory.c
+++ b/sound/core/memory.c
@@ -33,7 +33,7 @@
  *
  * Copies the data from mmio-space to user-space.
  *
- * Returns zero if successful, or non-zero on failure.
+ * Return: Zero if successful, or non-zero on failure.
  */
 int copy_to_user_fromio(void __user *dst, const volatile void __iomem *src, size_t count)
 {
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(copy_to_user_fromio);
  *
  * Copies the data from user-space to mmio-space.
  *
- * Returns zero if successful, or non-zero on failure.
+ * Return: Zero if successful, or non-zero on failure.
  */
 int copy_from_user_toio(volatile void __iomem *dst, const void __user *src, size_t count)
 {
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 61798f8..578327e 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -637,7 +637,7 @@ static inline int snd_pcm_substream_proc_done(struct snd_pcm_substream *substrea
  * calling this, i.e. zero must be given to the argument of
  * snd_pcm_new().
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_new_stream(struct snd_pcm *pcm, int stream, int substream_count)
 {
@@ -759,7 +759,7 @@ static int _snd_pcm_new(struct snd_card *card, const char *id, int device,
  * The pcm operators have to be set afterwards to the new instance
  * via snd_pcm_set_ops().
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_new(struct snd_card *card, const char *id, int device,
 		int playback_count, int capture_count, struct snd_pcm **rpcm)
@@ -787,7 +787,7 @@ EXPORT_SYMBOL(snd_pcm_new);
  * The pcm operators have to be set afterwards to the new instance
  * via snd_pcm_set_ops().
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_new_internal(struct snd_card *card, const char *id, int device,
 	int playback_count, int capture_count,
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index c4840ff..41b3dfe 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -666,7 +666,8 @@ static inline unsigned int muldiv32(unsigned int a, unsigned int b,
  * The interval is changed to the range satisfying both intervals.
  * The interval status (min, max, integer, etc.) are evaluated.
  *
- * Returns non-zero if the value is changed, zero if not changed.
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 int snd_interval_refine(struct snd_interval *i, const struct snd_interval *v)
 {
@@ -865,7 +866,8 @@ void snd_interval_mulkdiv(const struct snd_interval *a, unsigned int k,
  * @nump: pointer to store the resultant numerator
  * @denp: pointer to store the resultant denominator
  *
- * Returns non-zero if the value is changed, zero if not changed.
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 int snd_interval_ratnum(struct snd_interval *i,
 			unsigned int rats_count, struct snd_ratnum *rats,
@@ -983,7 +985,8 @@ EXPORT_SYMBOL(snd_interval_ratnum);
  * @nump: pointer to store the resultant numerator
  * @denp: pointer to store the resultant denominator
  *
- * Returns non-zero if the value is changed, zero if not changed.
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 static int snd_interval_ratden(struct snd_interval *i,
 			       unsigned int rats_count, struct snd_ratden *rats,
@@ -1082,7 +1085,8 @@ static int snd_interval_ratden(struct snd_interval *i,
  * When mask is non-zero, only the elements corresponding to bit 1 are
  * evaluated.
  *
- * Returns non-zero if the value is changed, zero if not changed.
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 int snd_interval_list(struct snd_interval *i, unsigned int count,
 		      const unsigned int *list, unsigned int mask)
@@ -1142,7 +1146,7 @@ static int snd_interval_step(struct snd_interval *i, unsigned int min, unsigned
  * @private: the private data pointer passed to function
  * @dep: the dependent variables
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 			int var,
@@ -1200,6 +1204,8 @@ EXPORT_SYMBOL(snd_pcm_hw_rule_add);
  * @mask: the bitmap mask
  *
  * Apply the constraint of the given bitmap mask to a 32-bit mask parameter.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_mask(struct snd_pcm_runtime *runtime, snd_pcm_hw_param_t var,
 			       u_int32_t mask)
@@ -1220,6 +1226,8 @@ int snd_pcm_hw_constraint_mask(struct snd_pcm_runtime *runtime, snd_pcm_hw_param
  * @mask: the 64bit bitmap mask
  *
  * Apply the constraint of the given bitmap mask to a 64-bit mask parameter.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_mask64(struct snd_pcm_runtime *runtime, snd_pcm_hw_param_t var,
 				 u_int64_t mask)
@@ -1240,6 +1248,9 @@ int snd_pcm_hw_constraint_mask64(struct snd_pcm_runtime *runtime, snd_pcm_hw_par
  * @var: hw_params variable to apply the integer constraint
  *
  * Apply the constraint of integer to an interval parameter.
+ *
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 int snd_pcm_hw_constraint_integer(struct snd_pcm_runtime *runtime, snd_pcm_hw_param_t var)
 {
@@ -1257,6 +1268,9 @@ EXPORT_SYMBOL(snd_pcm_hw_constraint_integer);
  * @max: the maximal value
  * 
  * Apply the min/max range constraint to an interval parameter.
+ *
+ * Return: Positive if the value is changed, zero if it's not changed, or a
+ * negative error code.
  */
 int snd_pcm_hw_constraint_minmax(struct snd_pcm_runtime *runtime, snd_pcm_hw_param_t var,
 				 unsigned int min, unsigned int max)
@@ -1288,6 +1302,8 @@ static int snd_pcm_hw_rule_list(struct snd_pcm_hw_params *params,
  * @l: list
  * 
  * Apply the list of constraints to an interval parameter.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_list(struct snd_pcm_runtime *runtime,
 			       unsigned int cond,
@@ -1322,6 +1338,8 @@ static int snd_pcm_hw_rule_ratnums(struct snd_pcm_hw_params *params,
  * @cond: condition bits
  * @var: hw_params variable to apply the ratnums constraint
  * @r: struct snd_ratnums constriants
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_ratnums(struct snd_pcm_runtime *runtime, 
 				  unsigned int cond,
@@ -1355,6 +1373,8 @@ static int snd_pcm_hw_rule_ratdens(struct snd_pcm_hw_params *params,
  * @cond: condition bits
  * @var: hw_params variable to apply the ratdens constraint
  * @r: struct snd_ratdens constriants
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_ratdens(struct snd_pcm_runtime *runtime, 
 				  unsigned int cond,
@@ -1386,6 +1406,8 @@ static int snd_pcm_hw_rule_msbits(struct snd_pcm_hw_params *params,
  * @cond: condition bits
  * @width: sample bits width
  * @msbits: msbits width
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_msbits(struct snd_pcm_runtime *runtime, 
 				 unsigned int cond,
@@ -1414,6 +1436,8 @@ static int snd_pcm_hw_rule_step(struct snd_pcm_hw_params *params,
  * @cond: condition bits
  * @var: hw_params variable to apply the step constraint
  * @step: step size
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_step(struct snd_pcm_runtime *runtime,
 			       unsigned int cond,
@@ -1444,6 +1468,8 @@ static int snd_pcm_hw_rule_pow2(struct snd_pcm_hw_params *params, struct snd_pcm
  * @runtime: PCM runtime instance
  * @cond: condition bits
  * @var: hw_params variable to apply the power-of-2 constraint
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_constraint_pow2(struct snd_pcm_runtime *runtime,
 			       unsigned int cond,
@@ -1470,6 +1496,8 @@ static int snd_pcm_hw_rule_noresample_func(struct snd_pcm_hw_params *params,
  * snd_pcm_hw_rule_noresample - add a rule to allow disabling hw resampling
  * @runtime: PCM runtime instance
  * @base_rate: the rate at which the hardware does not resample
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_rule_noresample(struct snd_pcm_runtime *runtime,
 			       unsigned int base_rate)
@@ -1519,8 +1547,8 @@ EXPORT_SYMBOL(_snd_pcm_hw_params_any);
  * @var: parameter to retrieve
  * @dir: pointer to the direction (-1,0,1) or %NULL
  *
- * Return the value for field @var if it's fixed in configuration space
- * defined by @params. Return -%EINVAL otherwise.
+ * Return: The value for field @var if it's fixed in configuration space
+ * defined by @params. -%EINVAL otherwise.
  */
 int snd_pcm_hw_param_value(const struct snd_pcm_hw_params *params,
 			   snd_pcm_hw_param_t var, int *dir)
@@ -1591,7 +1619,8 @@ static int _snd_pcm_hw_param_first(struct snd_pcm_hw_params *params,
  *
  * Inside configuration space defined by @params remove from @var all
  * values > minimum. Reduce configuration space accordingly.
- * Return the minimum.
+ *
+ * Return: The minimum, or a negative error code on failure.
  */
 int snd_pcm_hw_param_first(struct snd_pcm_substream *pcm, 
 			   struct snd_pcm_hw_params *params, 
@@ -1637,7 +1666,8 @@ static int _snd_pcm_hw_param_last(struct snd_pcm_hw_params *params,
  *
  * Inside configuration space defined by @params remove from @var all
  * values < maximum. Reduce configuration space accordingly.
- * Return the maximum.
+ *
+ * Return: The maximum, or a negative error code on failure.
  */
 int snd_pcm_hw_param_last(struct snd_pcm_substream *pcm, 
 			  struct snd_pcm_hw_params *params,
@@ -1665,6 +1695,8 @@ EXPORT_SYMBOL(snd_pcm_hw_param_last);
  * The configuration chosen is that obtained fixing in this order:
  * first access, first format, first subformat, min channels,
  * min rate, min period time, max buffer size, min tick time
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 			     struct snd_pcm_hw_params *params)
@@ -1771,7 +1803,7 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_pcm_substream *substream,
  * Processes the generic ioctl commands for PCM.
  * Can be passed as the ioctl callback for PCM ops.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_ioctl(struct snd_pcm_substream *substream,
 		      unsigned int cmd, void *arg)
@@ -2510,7 +2542,7 @@ static void pcm_chmap_ctl_private_free(struct snd_kcontrol *kcontrol)
  * @info_ret: store struct snd_pcm_chmap instance if non-NULL
  *
  * Create channel-mapping control elements assigned to the given PCM stream(s).
- * Returns zero if succeed, or a negative error value.
+ * Return: Zero if successful, or a negative error value.
  */
 int snd_pcm_add_chmap_ctls(struct snd_pcm *pcm, int stream,
 			   const struct snd_pcm_chmap_elem *chmap,
diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index 69e01c4..0af622c 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -95,7 +95,7 @@ static void snd_pcm_lib_preallocate_dma_free(struct snd_pcm_substream *substream
  *
  * Releases the pre-allocated buffer of the given substream.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_preallocate_free(struct snd_pcm_substream *substream)
 {
@@ -115,7 +115,7 @@ int snd_pcm_lib_preallocate_free(struct snd_pcm_substream *substream)
  *
  * Releases all the pre-allocated buffers on the given pcm.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_preallocate_free_for_all(struct snd_pcm *pcm)
 {
@@ -265,7 +265,7 @@ static int snd_pcm_lib_preallocate_pages1(struct snd_pcm_substream *substream,
  * destruction time.  The dma_buf_id must be unique for all systems
  * (in the same DMA buffer type) e.g. using snd_dma_pci_buf_id().
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_preallocate_pages(struct snd_pcm_substream *substream,
 				  int type, struct device *data,
@@ -289,7 +289,7 @@ EXPORT_SYMBOL(snd_pcm_lib_preallocate_pages);
  * Do pre-allocation to all substreams of the given pcm for the
  * specified DMA type.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_preallocate_pages_for_all(struct snd_pcm *pcm,
 					  int type, void *data,
@@ -313,8 +313,9 @@ EXPORT_SYMBOL(snd_pcm_lib_preallocate_pages_for_all);
  * @substream: the pcm substream instance
  * @offset: the buffer offset
  *
- * Returns the page struct at the given buffer offset.
  * Used as the page callback of PCM ops.
+ *
+ * Return: The page struct at the given buffer offset. %NULL on failure.
  */
 struct page *snd_pcm_sgbuf_ops_page(struct snd_pcm_substream *substream, unsigned long offset)
 {
@@ -337,7 +338,7 @@ EXPORT_SYMBOL(snd_pcm_sgbuf_ops_page);
  * Allocates the DMA buffer on the BUS type given earlier to
  * snd_pcm_lib_preallocate_xxx_pages().
  *
- * Returns 1 if the buffer is changed, 0 if not changed, or a negative
+ * Return: 1 if the buffer is changed, 0 if not changed, or a negative
  * code on failure.
  */
 int snd_pcm_lib_malloc_pages(struct snd_pcm_substream *substream, size_t size)
@@ -390,7 +391,7 @@ EXPORT_SYMBOL(snd_pcm_lib_malloc_pages);
  *
  * Releases the DMA buffer allocated via snd_pcm_lib_malloc_pages().
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_free_pages(struct snd_pcm_substream *substream)
 {
@@ -437,6 +438,8 @@ EXPORT_SYMBOL(_snd_pcm_lib_alloc_vmalloc_buffer);
  * snd_pcm_lib_free_vmalloc_buffer - free vmalloc buffer
  * @substream: the substream with a buffer allocated by
  *	snd_pcm_lib_alloc_vmalloc_buffer()
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_lib_free_vmalloc_buffer(struct snd_pcm_substream *substream)
 {
@@ -458,6 +461,8 @@ EXPORT_SYMBOL(snd_pcm_lib_free_vmalloc_buffer);
  * @offset: offset in the buffer
  *
  * This function is to be used as the page callback in the PCM ops.
+ *
+ * Return: The page struct, or %NULL on failure.
  */
 struct page *snd_pcm_lib_get_vmalloc_page(struct snd_pcm_substream *substream,
 					  unsigned long offset)
diff --git a/sound/core/pcm_misc.c b/sound/core/pcm_misc.c
index d4fc1bf..b875b19 100644
--- a/sound/core/pcm_misc.c
+++ b/sound/core/pcm_misc.c
@@ -213,7 +213,7 @@ static struct pcm_format_data pcm_formats[(INT)SNDRV_PCM_FORMAT_LAST+1] = {
  * snd_pcm_format_signed - Check the PCM format is signed linear
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is signed linear, 0 if unsigned
+ * Return: 1 if the given PCM format is signed linear, 0 if unsigned
  * linear, and a negative error code for non-linear formats.
  */
 int snd_pcm_format_signed(snd_pcm_format_t format)
@@ -232,7 +232,7 @@ EXPORT_SYMBOL(snd_pcm_format_signed);
  * snd_pcm_format_unsigned - Check the PCM format is unsigned linear
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is unsigned linear, 0 if signed
+ * Return: 1 if the given PCM format is unsigned linear, 0 if signed
  * linear, and a negative error code for non-linear formats.
  */
 int snd_pcm_format_unsigned(snd_pcm_format_t format)
@@ -251,7 +251,7 @@ EXPORT_SYMBOL(snd_pcm_format_unsigned);
  * snd_pcm_format_linear - Check the PCM format is linear
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is linear, 0 if not.
+ * Return: 1 if the given PCM format is linear, 0 if not.
  */
 int snd_pcm_format_linear(snd_pcm_format_t format)
 {
@@ -264,7 +264,7 @@ EXPORT_SYMBOL(snd_pcm_format_linear);
  * snd_pcm_format_little_endian - Check the PCM format is little-endian
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is little-endian, 0 if
+ * Return: 1 if the given PCM format is little-endian, 0 if
  * big-endian, or a negative error code if endian not specified.
  */
 int snd_pcm_format_little_endian(snd_pcm_format_t format)
@@ -283,7 +283,7 @@ EXPORT_SYMBOL(snd_pcm_format_little_endian);
  * snd_pcm_format_big_endian - Check the PCM format is big-endian
  * @format: the format to check
  *
- * Returns 1 if the given PCM format is big-endian, 0 if
+ * Return: 1 if the given PCM format is big-endian, 0 if
  * little-endian, or a negative error code if endian not specified.
  */
 int snd_pcm_format_big_endian(snd_pcm_format_t format)
@@ -302,7 +302,7 @@ EXPORT_SYMBOL(snd_pcm_format_big_endian);
  * snd_pcm_format_width - return the bit-width of the format
  * @format: the format to check
  *
- * Returns the bit-width of the format, or a negative error code
+ * Return: The bit-width of the format, or a negative error code
  * if unknown format.
  */
 int snd_pcm_format_width(snd_pcm_format_t format)
@@ -321,7 +321,7 @@ EXPORT_SYMBOL(snd_pcm_format_width);
  * snd_pcm_format_physical_width - return the physical bit-width of the format
  * @format: the format to check
  *
- * Returns the physical bit-width of the format, or a negative error code
+ * Return: The physical bit-width of the format, or a negative error code
  * if unknown format.
  */
 int snd_pcm_format_physical_width(snd_pcm_format_t format)
@@ -341,7 +341,7 @@ EXPORT_SYMBOL(snd_pcm_format_physical_width);
  * @format: the format to check
  * @samples: sampling rate
  *
- * Returns the byte size of the given samples for the format, or a
+ * Return: The byte size of the given samples for the format, or a
  * negative error code if unknown format.
  */
 ssize_t snd_pcm_format_size(snd_pcm_format_t format, size_t samples)
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(snd_pcm_format_size);
  * snd_pcm_format_silence_64 - return the silent data in 8 bytes array
  * @format: the format to check
  *
- * Returns the format pattern to fill or NULL if error.
+ * Return: The format pattern to fill or %NULL if error.
  */
 const unsigned char *snd_pcm_format_silence_64(snd_pcm_format_t format)
 {
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(snd_pcm_format_silence_64);
  *
  * Sets the silence data on the buffer for the given samples.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_pcm_format_set_silence(snd_pcm_format_t format, void *data, unsigned int samples)
 {
@@ -449,7 +449,7 @@ EXPORT_SYMBOL(snd_pcm_format_set_silence);
  * Determines the rate_min and rate_max fields from the rates bits of
  * the given runtime->hw.
  *
- * Returns zero if successful.
+ * Return: Zero if successful.
  */
 int snd_pcm_limit_hw_rates(struct snd_pcm_runtime *runtime)
 {
@@ -475,7 +475,7 @@ EXPORT_SYMBOL(snd_pcm_limit_hw_rates);
  * snd_pcm_rate_to_rate_bit - converts sample rate to SNDRV_PCM_RATE_xxx bit
  * @rate: the sample rate to convert
  *
- * Returns the SNDRV_PCM_RATE_xxx flag that corresponds to the given rate, or
+ * Return: The SNDRV_PCM_RATE_xxx flag that corresponds to the given rate, or
  * SNDRV_PCM_RATE_KNOT for an unknown rate.
  */
 unsigned int snd_pcm_rate_to_rate_bit(unsigned int rate)
@@ -493,8 +493,8 @@ EXPORT_SYMBOL(snd_pcm_rate_to_rate_bit);
  * snd_pcm_rate_bit_to_rate - converts SNDRV_PCM_RATE_xxx bit to sample rate
  * @rate_bit: the rate bit to convert
  *
- * Returns the sample rate that corresponds to the given SNDRV_PCM_RATE_xxx flag
- * or 0 for an unknown rate bit
+ * Return: The sample rate that corresponds to the given SNDRV_PCM_RATE_xxx flag
+ * or 0 for an unknown rate bit.
  */
 unsigned int snd_pcm_rate_bit_to_rate(unsigned int rate_bit)
 {
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 71ae86c..5bce915 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -898,6 +898,8 @@ static struct action_ops snd_pcm_action_start = {
 /**
  * snd_pcm_start - start all linked streams
  * @substream: the PCM substream instance
+ *
+ * Return: Zero if successful, or a negative error code.
  */
 int snd_pcm_start(struct snd_pcm_substream *substream)
 {
@@ -951,6 +953,8 @@ static struct action_ops snd_pcm_action_stop = {
  * @state: PCM state after stopping the stream
  *
  * The state of each stream is then changed to the given state unconditionally.
+ *
+ * Return: Zero if succesful, or a negative error code.
  */
 int snd_pcm_stop(struct snd_pcm_substream *substream, snd_pcm_state_t state)
 {
@@ -965,6 +969,8 @@ EXPORT_SYMBOL(snd_pcm_stop);
  *
  * After stopping, the state is changed to SETUP.
  * Unlike snd_pcm_stop(), this affects only the given stream.
+ *
+ * Return: Zero if succesful, or a negative error code.
  */
 int snd_pcm_drain_done(struct snd_pcm_substream *substream)
 {
@@ -1098,6 +1104,9 @@ static struct action_ops snd_pcm_action_suspend = {
  * @substream: the PCM substream
  *
  * After this call, all streams are changed to SUSPENDED state.
+ *
+ * Return: Zero if successful (or @substream is %NULL), or a negative error
+ * code.
  */
 int snd_pcm_suspend(struct snd_pcm_substream *substream)
 {
@@ -1120,6 +1129,8 @@ EXPORT_SYMBOL(snd_pcm_suspend);
  * @pcm: the PCM instance
  *
  * After this call, all streams are changed to SUSPENDED state.
+ *
+ * Return: Zero if successful (or @pcm is %NULL), or a negative error code.
  */
 int snd_pcm_suspend_all(struct snd_pcm *pcm)
 {
@@ -1343,6 +1354,8 @@ static struct action_ops snd_pcm_action_prepare = {
  * snd_pcm_prepare - prepare the PCM substream to be triggerable
  * @substream: the PCM substream instance
  * @file: file to refer f_flags
+ *
+ * Return: Zero if successful, or a negative error code.
  */
 static int snd_pcm_prepare(struct snd_pcm_substream *substream,
 			   struct file *file)
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 1bb95ae..7b596b5 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -863,7 +863,7 @@ static int snd_rawmidi_control_ioctl(struct snd_card *card,
  *
  * Reads the data from the internal buffer.
  *
- * Returns the size of read data, or a negative error code on failure.
+ * Return: The size of read data, or a negative error code on failure.
  */
 int snd_rawmidi_receive(struct snd_rawmidi_substream *substream,
 			const unsigned char *buffer, int count)
@@ -1024,8 +1024,8 @@ static ssize_t snd_rawmidi_read(struct file *file, char __user *buf, size_t coun
 /**
  * snd_rawmidi_transmit_empty - check whether the output buffer is empty
  * @substream: the rawmidi substream
- * 
- * Returns 1 if the internal output buffer is empty, 0 if not.
+ *
+ * Return: 1 if the internal output buffer is empty, 0 if not.
  */
 int snd_rawmidi_transmit_empty(struct snd_rawmidi_substream *substream)
 {
@@ -1055,7 +1055,7 @@ int snd_rawmidi_transmit_empty(struct snd_rawmidi_substream *substream)
  * and call snd_rawmidi_transmit_ack() after the transmission is
  * finished.
  *
- * Returns the size of copied data, or a negative error code on failure.
+ * Return: The size of copied data, or a negative error code on failure.
  */
 int snd_rawmidi_transmit_peek(struct snd_rawmidi_substream *substream,
 			      unsigned char *buffer, int count)
@@ -1107,7 +1107,7 @@ int snd_rawmidi_transmit_peek(struct snd_rawmidi_substream *substream,
  * the given size and updates the condition.
  * Call after the transmission is finished.
  *
- * Returns the advanced size if successful, or a negative error code on failure.
+ * Return: The advanced size if successful, or a negative error code on failure.
  */
 int snd_rawmidi_transmit_ack(struct snd_rawmidi_substream *substream, int count)
 {
@@ -1140,7 +1140,7 @@ int snd_rawmidi_transmit_ack(struct snd_rawmidi_substream *substream, int count)
  * 
  * Copies data from the buffer to the device and advances the pointer.
  *
- * Returns the copied size if successful, or a negative error code on failure.
+ * Return: The copied size if successful, or a negative error code on failure.
  */
 int snd_rawmidi_transmit(struct snd_rawmidi_substream *substream,
 			 unsigned char *buffer, int count)
@@ -1438,7 +1438,7 @@ static int snd_rawmidi_alloc_substreams(struct snd_rawmidi *rmidi,
  * Creates a new rawmidi instance.
  * Use snd_rawmidi_set_ops() to set the operators to the new instance.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_rawmidi_new(struct snd_card *card, char *id, int device,
 		    int output_count, int input_count,
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 70ccdab..f002bd9 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -102,6 +102,9 @@ static void snd_request_other(int minor)
  * This function increments the reference counter of the card instance
  * if an associated instance with the given minor number and type is found.
  * The caller must call snd_card_unref() appropriately later.
+ *
+ * Return: The user data pointer if the specified device is found. %NULL
+ * otherwise.
  */
 void *snd_lookup_minor_data(unsigned int minor, int type)
 {
@@ -261,7 +264,7 @@ static int snd_kernel_minor(int type, struct snd_card *card, int dev)
  * Registers an ALSA device file for the given card.
  * The operators have to be set in reg parameter.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_register_device_for_dev(int type, struct snd_card *card, int dev,
 				const struct file_operations *f_ops,
@@ -339,7 +342,7 @@ static int find_snd_minor(int type, struct snd_card *card, int dev)
  * Unregisters the device file already registered via
  * snd_register_device().
  *
- * Returns zero if sucecessful, or a negative error code on failure
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_unregister_device(int type, struct snd_card *card, int dev)
 {
diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index 0097f36..02f90b4 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -365,8 +365,7 @@ static void master_free(struct snd_kcontrol *kcontrol)
  * @name: name string of the control element to create
  * @tlv: optional TLV int array for dB information
  *
- * Creates a virtual matster control with the given name string.
- * Returns the created control element, or NULL for errors (ENOMEM).
+ * Creates a virtual master control with the given name string.
  *
  * After creating a vmaster element, you can add the slave controls
  * via snd_ctl_add_slave() or snd_ctl_add_slave_uncached().
@@ -375,6 +374,8 @@ static void master_free(struct snd_kcontrol *kcontrol)
  * for dB scale of the master control.  It should be a single element
  * with #SNDRV_CTL_TLVT_DB_SCALE, #SNDRV_CTL_TLV_DB_MINMAX or
  * #SNDRV_CTL_TLVT_DB_MINMAX_MUTE type, and should be the max 0dB.
+ *
+ * Return: The created control element, or %NULL for errors (ENOMEM).
  */
 struct snd_kcontrol *snd_ctl_make_virtual_master(char *name,
 						 const unsigned int *tlv)
@@ -426,6 +427,8 @@ EXPORT_SYMBOL(snd_ctl_make_virtual_master);
  *
  * Adds the given hook to the vmaster control element so that it's called
  * at each time when the value is changed.
+ *
+ * Return: Zero.
  */
 int snd_ctl_add_vmaster_hook(struct snd_kcontrol *kcontrol,
 			     void (*hook)(void *private_data, int),
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 4608c2c..e3a90d0 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -129,6 +129,8 @@ static void _snd_mpu401_uart_interrupt(struct snd_mpu401 *mpu)
  * @dev_id: mpu401 instance
  *
  * Processes the interrupt for MPU401-UART i/o.
+ *
+ * Return: %IRQ_HANDLED if the interrupt was handled. %IRQ_NONE otherwise.
  */
 irqreturn_t snd_mpu401_uart_interrupt(int irq, void *dev_id)
 {
@@ -148,6 +150,8 @@ EXPORT_SYMBOL(snd_mpu401_uart_interrupt);
  * @dev_id: mpu401 instance
  *
  * Processes the interrupt for MPU401-UART output.
+ *
+ * Return: %IRQ_HANDLED if the interrupt was handled. %IRQ_NONE otherwise.
  */
 irqreturn_t snd_mpu401_uart_interrupt_tx(int irq, void *dev_id)
 {
@@ -519,7 +523,7 @@ static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
  * not the mpu401 instance itself.  To access to the mpu401 instance,
  * cast from rawmidi->private_data (with struct snd_mpu401 magic-cast).
  *
- * Returns zero if successful, or a negative error code.
+ * Return: Zero if successful, or a negative error code.
  */
 int snd_mpu401_uart_new(struct snd_card *card, int device,
 			unsigned short hardware,
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 8b0f996..d37c683 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -299,7 +299,7 @@ EXPORT_SYMBOL(snd_ac97_write);
  * Reads a value from the given register.  This will invoke the read
  * callback directly after the register check.
  *
- * Returns the read value.
+ * Return: The read value.
  */
 unsigned short snd_ac97_read(struct snd_ac97 *ac97, unsigned short reg)
 {
@@ -352,7 +352,7 @@ EXPORT_SYMBOL(snd_ac97_write_cache);
  * Compares the value with the register cache and updates the value
  * only when the value is changed.
  *
- * Returns 1 if the value is changed, 0 if no change, or a negative
+ * Return: 1 if the value is changed, 0 if no change, or a negative
  * code on failure.
  */
 int snd_ac97_update(struct snd_ac97 *ac97, unsigned short reg, unsigned short value)
@@ -384,7 +384,7 @@ EXPORT_SYMBOL(snd_ac97_update);
  * Updates the masked-bits on the given register only when the value
  * is changed.
  *
- * Returns 1 if the bits are changed, 0 if no change, or a negative
+ * Return: 1 if the bits are changed, 0 if no change, or a negative
  * code on failure.
  */
 int snd_ac97_update_bits(struct snd_ac97 *ac97, unsigned short reg, unsigned short mask, unsigned short value)
@@ -1836,7 +1836,7 @@ void snd_ac97_get_name(struct snd_ac97 *ac97, unsigned int id, char *name, int m
  * snd_ac97_get_short_name - retrieve codec name
  * @ac97: the codec instance
  *
- * Returns the short identifying name of the codec.
+ * Return: The short identifying name of the codec.
  */
 const char *snd_ac97_get_short_name(struct snd_ac97 *ac97)
 {
@@ -1910,7 +1910,7 @@ static int ac97_reset_wait(struct snd_ac97 *ac97, int timeout, int with_modem)
  * The AC97 bus instance is registered as a low-level device, so you don't
  * have to release it manually.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_bus(struct snd_card *card, int num, struct snd_ac97_bus_ops *ops,
 		 void *private_data, struct snd_ac97_bus **rbus)
@@ -2006,7 +2006,7 @@ static void do_update_power(struct work_struct *work)
  * The ac97 instance is registered as a low-level device, so you don't
  * have to release it manually.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_mixer(struct snd_ac97_bus *bus, struct snd_ac97_template *template, struct snd_ac97 **rac97)
 {
@@ -2373,6 +2373,8 @@ static struct ac97_power_reg power_regs[PWIDX_SIZE] = {
  * @powerup: non-zero when power up the part
  *
  * Update the AC97 powerdown register bits of the given part.
+ *
+ * Return: Zero.
  */
 int snd_ac97_update_power(struct snd_ac97 *ac97, int reg, int powerup)
 {
@@ -2885,7 +2887,7 @@ static int apply_quirk_str(struct snd_ac97 *ac97, const char *typestr)
  * headphone (true line-out) control as "Master".
  * The quirk-list must be terminated with a zero-filled entry.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 
 int snd_ac97_tune_hardware(struct snd_ac97 *ac97, struct ac97_quirk *quirk, const char *override)
diff --git a/sound/pci/ac97/ac97_pcm.c b/sound/pci/ac97/ac97_pcm.c
index f1488fc..eab0fc9 100644
--- a/sound/pci/ac97/ac97_pcm.c
+++ b/sound/pci/ac97/ac97_pcm.c
@@ -253,7 +253,7 @@ static int set_spdif_rate(struct snd_ac97 *ac97, unsigned short rate)
  * AC97_SPDIF is accepted as a pseudo register to modify the SPDIF
  * status bits.
  *
- * Returns zero if successful, or a negative error code on failure.
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_set_rate(struct snd_ac97 *ac97, int reg, unsigned int rate)
 {
@@ -440,6 +440,8 @@ static unsigned int get_rates(struct ac97_pcm *pcm, unsigned int cidx, unsigned
  * It assigns available AC97 slots for given PCMs. If none or only
  * some slots are available, pcm->xxx.slots and pcm->xxx.rslots[] members
  * are reduced and might be zero.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_pcm_assign(struct snd_ac97_bus *bus,
 			unsigned short pcms_count,
@@ -562,6 +564,8 @@ EXPORT_SYMBOL(snd_ac97_pcm_assign);
  * @slots: a subset of allocated slots (snd_ac97_pcm_assign) for this pcm
  *
  * It locks the specified slots and sets the given rate to AC97 registers.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_pcm_open(struct ac97_pcm *pcm, unsigned int rate,
 		      enum ac97_pcm_cfg cfg, unsigned short slots)
@@ -644,6 +648,8 @@ EXPORT_SYMBOL(snd_ac97_pcm_open);
  * @pcm: the ac97 pcm instance
  *
  * It frees the locked AC97 slots.
+ *
+ * Return: Zero.
  */
 int snd_ac97_pcm_close(struct ac97_pcm *pcm)
 {
@@ -718,6 +724,8 @@ static int double_rate_hw_constraint_channels(struct snd_pcm_hw_params *params,
  *
  * Installs the hardware constraint rules to prevent using double rates and
  * more than two channels at the same time.
+ *
+ * Return: Zero if successful, or a negative error code on failure.
  */
 int snd_ac97_pcm_double_rate_rules(struct snd_pcm_runtime *runtime)
 {
diff --git a/sound/sound_core.c b/sound/sound_core.c
index bb23009..359753f 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -352,7 +352,9 @@ static struct sound_unit *chains[SOUND_STEP];
  *      @dev: device pointer
  *
  *	Allocate a special sound device by minor number from the sound
- *	subsystem. The allocated number is returned on success. On failure
+ *	subsystem.
+ *
+ *	Return: The allocated number is returned on success. On failure,
  *	a negative error code is returned.
  */
  
@@ -436,8 +438,10 @@ EXPORT_SYMBOL(register_sound_special);
  *	@dev: Unit number to allocate
  *
  *	Allocate a mixer device. Unit is the number of the mixer requested.
- *	Pass -1 to request the next free mixer unit. On success the allocated
- *	number is returned, on failure a negative error code is returned.
+ *	Pass -1 to request the next free mixer unit.
+ *
+ *	Return: On success, the allocated number is returned. On failure,
+ *	a negative error code is returned.
  */
 
 int register_sound_mixer(const struct file_operations *fops, int dev)
@@ -454,8 +458,10 @@ EXPORT_SYMBOL(register_sound_mixer);
  *	@dev: Unit number to allocate
  *
  *	Allocate a midi device. Unit is the number of the midi device requested.
- *	Pass -1 to request the next free midi unit. On success the allocated
- *	number is returned, on failure a negative error code is returned.
+ *	Pass -1 to request the next free midi unit.
+ *
+ *	Return: On success, the allocated number is returned. On failure,
+ *	a negative error code is returned.
  */
 
 int register_sound_midi(const struct file_operations *fops, int dev)
@@ -477,11 +483,13 @@ EXPORT_SYMBOL(register_sound_midi);
  *	@dev: Unit number to allocate
  *
  *	Allocate a DSP device. Unit is the number of the DSP requested.
- *	Pass -1 to request the next free DSP unit. On success the allocated
- *	number is returned, on failure a negative error code is returned.
+ *	Pass -1 to request the next free DSP unit.
  *
  *	This function allocates both the audio and dsp device entries together
  *	and will always allocate them as a matching pair - eg dsp3/audio3
+ *
+ *	Return: On success, the allocated number is returned. On failure,
+ *	a negative error code is returned.
  */
 
 int register_sound_dsp(const struct file_operations *fops, int dev)
-- 
1.7.10.4

