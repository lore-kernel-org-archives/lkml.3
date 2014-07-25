Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbaGYKH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:07:57 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41199 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969AbaGYKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:07:55 -0400
From: Arjun AK <arjunak234@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, benjamin.romer@unisys.com,
        david.kershner@unisys.com, gregkh@linuxfoundation.org
Subject: [PATCH] Staging: unisys: Fix code style
Date: Fri, 25 Jul 2014 15:37:41 +0530
Message-ID: <2159111.NPHfj36gbu@thinkpad>
User-Agent: KMail/4.13.3 (Linux/3.16.0-rc6+; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8e7748dd81cf63c62dbef8f102e97da1d4d5d90a Mon Sep 17 00:00:00 2001
From: Arjun AK <arjunak234@gmail.com>
Date: Fri, 25 Jul 2014 15:09:11 +0530
Subject: [PATCH] Staging: unisys: Fix code style

Fixes code style in multiple files

Signed-off-by: Arjun AK <arjunak234@gmail.com>
---
 drivers/staging/unisys/channels/chanstub.c           |  2 ++
 .../unisys/common-spar/include/channels/channel.h    |  2 ++
 .../unisys/common-spar/include/iovmcall_gnuc.h       | 14 ++++++++------
 .../unisys/common-spar/include/vbusdeviceinfo.h      |  1 +
 drivers/staging/unisys/include/timskmod.h            |  1 +
 drivers/staging/unisys/uislib/uislib.c               | 10 +++++++++-
 drivers/staging/unisys/uislib/uisthread.c            |  1 +
 drivers/staging/unisys/uislib/uisutils.c             |  5 +++++
 drivers/staging/unisys/virthba/virthba.c             |  5 ++---
 drivers/staging/unisys/virtpci/virtpci.c             |  8 ++++++++
 .../staging/unisys/visorchannel/visorchannel_funcs.c |  3 +++
 drivers/staging/unisys/visorchipset/file.c           |  1 +
 drivers/staging/unisys/visorchipset/parser.c         |  2 ++
 .../staging/unisys/visorchipset/visorchipset_main.c  | 20 ++++++++++++++++++++
 14 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/unisys/channels/chanstub.c b/drivers/staging/unisys/channels/chanstub.c
index 1e7d6a7..34b6ffe 100644
--- a/drivers/staging/unisys/channels/chanstub.c
+++ b/drivers/staging/unisys/channels/chanstub.c
@@ -47,6 +47,7 @@ SignalInsert_withLock(CHANNEL_HEADER __iomem *pChannel, U32 Queue,
 {
 	unsigned char result;
 	unsigned long flags;
+
 	spin_lock_irqsave(lock, flags);
 	result = visor_signal_insert(pChannel, Queue, pSignal);
 	spin_unlock_irqrestore(lock, flags);
@@ -58,6 +59,7 @@ SignalRemove_withLock(CHANNEL_HEADER __iomem *pChannel, U32 Queue,
 		      void *pSignal, spinlock_t *lock)
 {
 	unsigned char result;
+
 	spin_lock(lock);
 	result = visor_signal_remove(pChannel, Queue, pSignal);
 	spin_unlock(lock);
diff --git a/drivers/staging/unisys/common-spar/include/channels/channel.h b/drivers/staging/unisys/common-spar/include/channels/channel.h
index d19711d..6fcce3d 100644
--- a/drivers/staging/unisys/common-spar/include/channels/channel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/channel.h
@@ -399,6 +399,7 @@ PathName_Last_N_Nodes(U8 *s, unsigned int n)
 {
 	U8 *p = s;
 	unsigned int node_count = 0;
+
 	while (*p != '\0') {
 		if ((*p == '/') || (*p == '\\'))
 			node_count++;
@@ -542,6 +543,7 @@ ULTRA_channel_client_release_os(void __iomem *pChannel, U8 *chanId,
 				void *logCtx, char *file, int line, char *func)
 {
 	CHANNEL_HEADER __iomem *pChan = pChannel;
+
 	if (readb(&pChan->CliErrorOS) != 0) {
 		/* we are in an error msg throttling state; come out of it */
 		UltraLogEvent(logCtx, CHANNELSTATE_DIAG_EVENTID_TRANSITOK,
diff --git a/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h b/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
index fe9598c..413796b 100644
--- a/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
+++ b/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
@@ -21,11 +21,12 @@ __unisys_vmcall_gnuc(unsigned long tuple, unsigned long reg_ebx,
 	unsigned long result = 0;
 
 	unsigned int cpuid_eax, cpuid_ebx, cpuid_ecx, cpuid_edx;
+
 	cpuid(0x00000001, &cpuid_eax, &cpuid_ebx, &cpuid_ecx, &cpuid_edx);
 	if (cpuid_ecx & 0x80000000) {
-	      __asm__ __volatile__(".byte 0x00f, 0x001, 0x0c1" : "=a"(result) :
-				   "a"(tuple), "b"(reg_ebx), "c"(reg_ecx)
-				      );
+		__asm__ __volatile__(".byte 0x00f, 0x001, 0x0c1" :
+				     "=a"(result) : "a"(tuple), "b"(reg_ebx),
+				     "c"(reg_ecx));
 	} else {
 		result = -1;
 	}
@@ -41,11 +42,12 @@ __unisys_extended_vmcall_gnuc(unsigned long long tuple,
 	unsigned long result = 0;
 
 	unsigned int cpuid_eax, cpuid_ebx, cpuid_ecx, cpuid_edx;
+
 	cpuid(0x00000001, &cpuid_eax, &cpuid_ebx, &cpuid_ecx, &cpuid_edx);
 	if (cpuid_ecx & 0x80000000) {
-	      __asm__ __volatile__(".byte 0x00f, 0x001, 0x0c1" : "=a"(result) :
-				   "a"(tuple), "b"(reg_ebx), "c"(reg_ecx),
-				   "d"(reg_edx));
+		__asm__ __volatile__(".byte 0x00f, 0x001, 0x0c1" :
+				     "=a"(result) : "a"(tuple), "b"(reg_ebx),
+				     "c"(reg_ecx), "d"(reg_edx));
 	} else {
 		result = -1;
 	}
diff --git a/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h b/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
index 8c0259a..a9d2a7b 100644
--- a/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
+++ b/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
@@ -54,6 +54,7 @@ VBUSCHANNEL_sanitize_buffer(char *p, int remain, char __iomem *src, int srcmax)
 {
 	int chars = 0;
 	int nonprintable_streak = 0;
+
 	while (srcmax > 0) {
 		if ((readb(src) >= ' ') && (readb(src) < 0x7f)) {
 			if (nonprintable_streak) {
diff --git a/drivers/staging/unisys/include/timskmod.h b/drivers/staging/unisys/include/timskmod.h
index ecf1a6f..14e95bc 100644
--- a/drivers/staging/unisys/include/timskmod.h
+++ b/drivers/staging/unisys/include/timskmod.h
@@ -304,6 +304,7 @@ static inline struct cdev *cdev_alloc_init(struct module *owner,
 					   const struct file_operations *fops)
 {
 	struct cdev *cdev = NULL;
+
 	cdev = cdev_alloc();
 	if (!cdev)
 		return NULL;
diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index d4a7ef8..327af30 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -133,6 +133,7 @@ init_vbus_channel(U64 channelAddr, U32 channelBytes, int isServer)
 {
 	void __iomem *rc = NULL;
 	void __iomem *pChan = uislib_ioremap_cache(channelAddr, channelBytes);
+
 	if (!pChan) {
 		LOGERR("CONTROLVM_BUS_CREATE error: ioremap_cache of channelAddr:%Lx for channelBytes:%llu failed",
 		     (unsigned long long) channelAddr,
@@ -241,6 +242,7 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
 	/* the msg is bound for virtpci; send guest_msgs struct to callback */
 	if (!msg->hdr.Flags.server) {
 		struct guest_msgs cmd;
+
 		cmd.msgtype = GUEST_ADD_VBUS;
 		cmd.add_vbus.busNo = busNo;
 		cmd.add_vbus.chanptr = bus->pBusChannel;
@@ -310,6 +312,7 @@ destroy_bus(CONTROLVM_MESSAGE *msg, char *buf)
 			 */
 			if (!msg->hdr.Flags.server) {
 				struct guest_msgs cmd;
+
 				cmd.msgtype = GUEST_DEL_VBUS;
 				cmd.del_vbus.busNo = busNo;
 				if (!VirtControlChanFunc) {
@@ -445,6 +448,7 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
 			 */
 			if (!msg->hdr.Flags.server) {
 				struct guest_msgs cmd;
+
 				if (!uuid_le_cmp(dev->channelTypeGuid,
 				     UltraVhbaChannelProtocolGuid)) {
 					wait_for_valid_guid(&((CHANNEL_HEADER
@@ -1176,6 +1180,7 @@ uislib_cache_alloc(struct kmem_cache *cur_pool, char *fn, int ln)
 	* invoke oom killer), which will probably cripple the system.
 	*/
 	void *p = kmem_cache_alloc(cur_pool, GFP_ATOMIC | __GFP_NORETRY);
+
 	if (p == NULL) {
 		LOGERR("uislib_malloc failed to alloc uiscmdrsp @%s:%d",
 		       fn, ln);
@@ -1351,6 +1356,7 @@ Process_Incoming(void *v)
 	unsigned long long cur_cycles, old_cycles, idle_cycles, delta_cycles;
 	struct list_head *new_tail = NULL;
 	int i;
+
 	UIS_DAEMONIZE("dev_incoming");
 	for (i = 0; i < 16; i++) {
 		old_cycles = get_cycles();
@@ -1377,6 +1383,7 @@ Process_Incoming(void *v)
 		new_tail = NULL;
 		list_for_each_safe(lelt, tmp, &List_Polling_Device_Channels) {
 			int rc = 0;
+
 			dev = list_entry(lelt, struct device_info,
 					 list_polling_device_channels);
 			LOCKSEM_UNINTERRUPTIBLE(&dev->interrupt_callback_lock);
@@ -1475,6 +1482,7 @@ uislib_enable_channel_interrupts(U32 busNo, U32 devNo,
 				 void *interrupt_context)
 {
 	struct device_info *dev;
+
 	dev = find_dev(busNo, devNo);
 	if (!dev) {
 		LOGERR("%s busNo=%d, devNo=%d", __func__, (int) (busNo),
@@ -1499,6 +1507,7 @@ void
 uislib_disable_channel_interrupts(U32 busNo, U32 devNo)
 {
 	struct device_info *dev;
+
 	dev = find_dev(busNo, devNo);
 	if (!dev) {
 		LOGERR("%s busNo=%d, devNo=%d", __func__, (int) (busNo),
@@ -1624,7 +1633,6 @@ uislib_mod_exit(void)
 	debugfs_remove(dir_debugfs);
 
 	DBGINF("goodbye.\n");
-	return;
 }
 
 module_init(uislib_mod_init);
diff --git a/drivers/staging/unisys/uislib/uisthread.c b/drivers/staging/unisys/uislib/uisthread.c
index c93ab04..c0fc812 100644
--- a/drivers/staging/unisys/uislib/uisthread.c
+++ b/drivers/staging/unisys/uislib/uisthread.c
@@ -62,6 +62,7 @@ uisthread_stop(struct uisthread_info *thrinfo)
 {
 	int ret;
 	int stopped = 0;
+
 	if (thrinfo->id == 0)
 		return;		/* thread not running */
 
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 0f1bb73..2890619 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -118,6 +118,7 @@ uisctrl_register_req_handler_ex(uuid_le switchTypeGuid,
 {
 	ReqHandlerInfo_t *pReqHandlerInfo;
 	int rc = 0;		/* assume failure */
+
 	LOGINF("type=%pUL, controlfunc=0x%p.\n",
 	       &switchTypeGuid, controlfunc);
 	if (!controlfunc) {
@@ -164,6 +165,7 @@ int
 uisctrl_unregister_req_handler_ex(uuid_le switchTypeGuid)
 {
 	int rc = 0;		/* assume failure */
+
 	LOGINF("type=%pUL.\n", &switchTypeGuid);
 	if (ReqHandlerDel(switchTypeGuid) < 0) {
 		LOGERR("failed to remove %pUL from server list\n",
@@ -252,6 +254,7 @@ uisutil_copy_fragsinfo_from_skb(unsigned char *calling_ctx, void *skb_in,
 	if (skb_shinfo(skb)->frag_list) {
 		struct sk_buff *skbinlist;
 		int c;
+
 		for (skbinlist = skb_shinfo(skb)->frag_list; skbinlist;
 		     skbinlist = skbinlist->next) {
 
@@ -309,6 +312,7 @@ ReqHandlerFind(uuid_le switchTypeGuid)
 {
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
+
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
@@ -327,6 +331,7 @@ ReqHandlerDel(uuid_le switchTypeGuid)
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
 	int rc = -1;
+
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index 5c5aa70..e0c93c2 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -1117,7 +1117,6 @@ virthba_slave_destroy(struct scsi_device *scsidev)
 			return;
 		}
 	}
-	return;
 }
 
 /*****************************************************/
@@ -1467,7 +1466,7 @@ enable_ints_write(struct file *file, const char __user *buffer,
 		return -EFAULT;
 	}
 
-	i = sscanf(buf, "%d", &new_value);
+	i = strtoint(buf, 0, &new_value);
 
 	if (i < 1) {
 		LOGERR("Failed to scan value for enable_ints, buf<<%.*s>>",
@@ -1517,7 +1516,7 @@ rqwu_proc_write(struct file *file, const char __user *buffer,
 		return -EFAULT;
 	}
 
-	i = sscanf(buf, "%d", &usecs);
+	i = strtoint(buf, 0, &usecs);
 
 	if (i < 1) {
 		LOGERR("Failed to scan value for rqwait_usecs buf<<%.*s>>",
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 71246fe..acaee60 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -178,6 +178,7 @@ static inline
 int WAIT_FOR_IO_CHANNEL(ULTRA_IO_CHANNEL_PROTOCOL __iomem  *chanptr)
 {
 	int count = 120;
+
 	while (count > 0) {
 
 		if (ULTRA_CHANNEL_SERVER_READY(&chanptr->ChannelHeader))
@@ -193,6 +194,7 @@ static int write_vbus_chpInfo(ULTRA_VBUS_CHANNEL_PROTOCOL *chan,
 			      ULTRA_VBUS_DEVICEINFO *info)
 {
 	int off;
+
 	if (!chan) {
 		LOGERR("vbus channel not present");
 		return -1;
@@ -211,6 +213,7 @@ static int write_vbus_busInfo(ULTRA_VBUS_CHANNEL_PROTOCOL *chan,
 			      ULTRA_VBUS_DEVICEINFO *info)
 {
 	int off;
+
 	if (!chan) {
 		LOGERR("vbus channel not present");
 		return -1;
@@ -232,6 +235,7 @@ write_vbus_devInfo(ULTRA_VBUS_CHANNEL_PROTOCOL *chan,
 		   ULTRA_VBUS_DEVICEINFO *info, int devix)
 {
 	int off;
+
 	if (!chan) {
 		LOGERR("vbus channel not present");
 		return -1;
@@ -255,6 +259,7 @@ static int add_vbus(struct add_vbus_guestpart *addparams)
 {
 	int ret;
 	struct device *vbus;
+
 	vbus = kzalloc(sizeof(struct device), GFP_ATOMIC);
 
 	POSTCODE_LINUX_2(VPCI_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
@@ -861,6 +866,7 @@ static int virtpci_device_remove(struct device *dev_)
 	*/
 	struct virtpci_dev *virtpcidev = device_to_virtpci_dev(dev_);
 	struct virtpci_driver *virtpcidrv = virtpcidev->mydriver;
+
 	LOGINF("In virtpci_device_remove bus_id:%s dev_:%p virtpcidev:%p dev->driver:%p drivername:%s\n",
 	       BUS_ID(dev_), dev_, virtpcidev, dev_->driver,
 	       dev_->driver->name);	/* VERBOSE/DEBUG */
@@ -1313,6 +1319,7 @@ static ssize_t virtpci_driver_attr_show(struct kobject *kobj,
 
 	struct driver_private *dprivate = to_driver(kobj);
 	struct device_driver *driver;
+
 	if (dprivate != NULL)
 		driver = dprivate->driver;
 	else
@@ -1335,6 +1342,7 @@ static ssize_t virtpci_driver_attr_store(struct kobject *kobj,
 
 	struct driver_private *dprivate = to_driver(kobj);
 	struct device_driver *driver;
+
 	if (dprivate != NULL)
 		driver = dprivate->driver;
 	else
diff --git a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
index a44da7c..d2127ec 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
@@ -257,6 +257,7 @@ visorchannel_clear(VISORCHANNEL *channel, ulong offset, U8 ch, ulong nbytes)
 	while (nbytes > 0) {
 		ulong thisbytes = bufsize;
 		int x = -1;
+
 		if (nbytes < thisbytes)
 			thisbytes = nbytes;
 		x = visor_memregion_write(channel->memregion, offset + written,
@@ -520,6 +521,7 @@ int
 visorchannel_signalqueue_max_slots(VISORCHANNEL *channel, U32 queue)
 {
 	SIGNAL_QUEUE_HEADER sig_hdr;
+
 	if (!sig_read_header(channel, queue, &sig_hdr))
 		return 0;
 	return (int) sig_hdr.MaxSignals;
@@ -612,6 +614,7 @@ visorchannel_debug(VISORCHANNEL *channel, int nQueues,
 	else
 		for (i = 0; i < nQueues; i++) {
 			SIGNAL_QUEUE_HEADER q;
+
 			errcode = visorchannel_read(channel,
 						    off + phdr->oChannelSpace +
 						    (i * sizeof(q)),
diff --git a/drivers/staging/unisys/visorchipset/file.c b/drivers/staging/unisys/visorchipset/file.c
index fccc4f0..da4fcdf 100644
--- a/drivers/staging/unisys/visorchipset/file.c
+++ b/drivers/staging/unisys/visorchipset/file.c
@@ -192,6 +192,7 @@ visorchipset_ioctl(struct inode *inode, struct file *file,
 	int rc = SUCCESS;
 	S64 adjustment;
 	S64 vrtc_offset;
+
 	DBGINF("entered visorchipset_ioctl, cmd=%d", cmd);
 	switch (cmd) {
 	case VMCALL_QUERY_GUEST_VIRTUAL_TIME_OFFSET:
diff --git a/drivers/staging/unisys/visorchipset/parser.c b/drivers/staging/unisys/visorchipset/parser.c
index 4274dd2..28aa395 100644
--- a/drivers/staging/unisys/visorchipset/parser.c
+++ b/drivers/staging/unisys/visorchipset/parser.c
@@ -84,6 +84,7 @@ parser_init_guts(U64 addr, U32 bytes, BOOL isLocal,
 	ctx->byte_stream = FALSE;
 	if (isLocal) {
 		void *p;
+
 		if (addr > virt_to_phys(high_memory - 1)) {
 			ERRDRV("%s - bad local address (0x%-16.16Lx for %lu)",
 			       __func__,
@@ -257,6 +258,7 @@ static int
 string_length_no_trail(char *s, int len)
 {
 	int i = len - 1;
+
 	while (i >= 0) {
 		if (!isspace(s[i]))
 			return i + 1;
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 0a602b9..bcd3d30 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -117,6 +117,7 @@ static void
 InitPartitionProperties(void)
 {
 	char **p = PartitionPropertyNames;
+
 	p[PARTPROP_invalid] = "";
 	p[PARTPROP_name] = "name";
 	p[PARTPROP_description] = "description";
@@ -147,6 +148,7 @@ static void
 InitControlVmProperties(void)
 {
 	char **p = ControlVmPropertyNames;
+
 	p[CTLVMPROP_invalid] = "";
 	p[CTLVMPROP_physAddr] = "physAddr";
 	p[CTLVMPROP_controlChannelAddr] = "controlChannelAddr";
@@ -414,6 +416,7 @@ show_controlvm_property(struct seq_file *f, void *ctx, int property)
 			seq_puts(f, "0x0\n");
 		else {
 			GUEST_PHYSICAL_ADDRESS addr = 0;
+
 			visorchannel_read(ControlVm_channel,
 					  offsetof
 					  (ULTRA_CONTROLVM_CHANNEL_PROTOCOL,
@@ -427,6 +430,7 @@ show_controlvm_property(struct seq_file *f, void *ctx, int property)
 			seq_puts(f, "0x0\n");
 		else {
 			U32 bytes = 0;
+
 			visorchannel_read(ControlVm_channel,
 					  offsetof
 					  (ULTRA_CONTROLVM_CHANNEL_PROTOCOL,
@@ -527,6 +531,7 @@ static void
 devInfo_clear(void *v)
 {
 	VISORCHIPSET_DEVICE_INFO *p = (VISORCHIPSET_DEVICE_INFO *) (v);
+
 	p->state.created = 0;
 	memset(p, 0, sizeof(VISORCHIPSET_DEVICE_INFO));
 }
@@ -669,6 +674,7 @@ static void
 controlvm_respond(CONTROLVM_MESSAGE_HEADER *msgHdr, int response)
 {
 	CONTROLVM_MESSAGE outmsg;
+
 	if (!ControlVm_channel)
 		return;
 	controlvm_init_response(&outmsg, msgHdr, response);
@@ -697,6 +703,7 @@ controlvm_respond_chipset_init(CONTROLVM_MESSAGE_HEADER *msgHdr, int response,
 			       ULTRA_CHIPSET_FEATURE features)
 {
 	CONTROLVM_MESSAGE outmsg;
+
 	if (!ControlVm_channel)
 		return;
 	controlvm_init_response(&outmsg, msgHdr, response);
@@ -713,6 +720,7 @@ controlvm_respond_physdev_changestate(CONTROLVM_MESSAGE_HEADER *msgHdr,
 				      int response, ULTRA_SEGMENT_STATE state)
 {
 	CONTROLVM_MESSAGE outmsg;
+
 	if (!ControlVm_channel)
 		return;
 	controlvm_init_response(&outmsg, msgHdr, response);
@@ -1410,6 +1418,7 @@ initialize_controlvm_payload(void)
 	HOSTADDRESS phys_addr = visorchannel_get_physaddr(ControlVm_channel);
 	U64 payloadOffset = 0;
 	U32 payloadBytes = 0;
+
 	if (visorchannel_read(ControlVm_channel,
 			      offsetof(ULTRA_CONTROLVM_CHANNEL_PROTOCOL,
 				       RequestPayloadOffset),
@@ -1449,6 +1458,7 @@ visorchipset_chipset_selftest(void)
 {
 	char env_selftest[20];
 	char *envp[] = { env_selftest, NULL };
+
 	sprintf(env_selftest, "SPARSP_SELFTEST=%d", 1);
 	kobject_uevent_env(&Visorchipset_platform_device.dev.kobj, KOBJ_CHANGE,
 			   envp);
@@ -1471,6 +1481,7 @@ static void
 chipset_ready(CONTROLVM_MESSAGE_HEADER *msgHdr)
 {
 	int rc = visorchipset_chipset_ready();
+
 	if (rc != CONTROLVM_RESP_SUCCESS)
 		rc = -rc;
 	if (msgHdr->Flags.responseExpected && !visorchipset_holdchipsetready)
@@ -1488,6 +1499,7 @@ static void
 chipset_selftest(CONTROLVM_MESSAGE_HEADER *msgHdr)
 {
 	int rc = visorchipset_chipset_selftest();
+
 	if (rc != CONTROLVM_RESP_SUCCESS)
 		rc = -rc;
 	if (msgHdr->Flags.responseExpected)
@@ -1498,6 +1510,7 @@ static void
 chipset_notready(CONTROLVM_MESSAGE_HEADER *msgHdr)
 {
 	int rc = visorchipset_chipset_notready();
+
 	if (rc != CONTROLVM_RESP_SUCCESS)
 		rc = -rc;
 	if (msgHdr->Flags.responseExpected)
@@ -1545,6 +1558,7 @@ static int
 parahotplug_next_id(void)
 {
 	static atomic_t id = ATOMIC_INIT(0);
+
 	return atomic_inc_return(&id);
 }
 
@@ -1816,6 +1830,7 @@ handle_command(CONTROLVM_MESSAGE inmsg, HOSTADDRESS channel_addr)
 	 */
 	if (parametersAddr != 0 && parametersBytes != 0) {
 		BOOL retry = FALSE;
+
 		parser_ctx =
 		    parser_init_byteStream(parametersAddr, parametersBytes,
 					   isLocalAddr, &retry);
@@ -1951,6 +1966,7 @@ controlvm_periodic_work(struct work_struct *work)
 	memset(&chanInfo, 0, sizeof(VISORCHIPSET_CHANNEL_INFO));
 	if (!ControlVm_channel) {
 		HOSTADDRESS addr = controlvm_get_channel_address();
+
 		if (addr != 0) {
 			ControlVm_channel =
 			    visorchannel_create_with_lock
@@ -2251,6 +2267,7 @@ BOOL
 visorchipset_get_bus_info(ulong busNo, VISORCHIPSET_BUS_INFO *busInfo)
 {
 	void *p = findbus(&BusInfoList, busNo);
+
 	if (!p) {
 		LOGERR("(%lu) failed", busNo);
 		return FALSE;
@@ -2264,6 +2281,7 @@ BOOL
 visorchipset_set_bus_context(ulong busNo, void *context)
 {
 	VISORCHIPSET_BUS_INFO *p = findbus(&BusInfoList, busNo);
+
 	if (!p) {
 		LOGERR("(%lu) failed", busNo);
 		return FALSE;
@@ -2278,6 +2296,7 @@ visorchipset_get_device_info(ulong busNo, ulong devNo,
 			     VISORCHIPSET_DEVICE_INFO *devInfo)
 {
 	void *p = finddevice(&DevInfoList, busNo, devNo);
+
 	if (!p) {
 		LOGERR("(%lu,%lu) failed", busNo, devNo);
 		return FALSE;
@@ -2291,6 +2310,7 @@ BOOL
 visorchipset_set_device_context(ulong busNo, ulong devNo, void *context)
 {
 	VISORCHIPSET_DEVICE_INFO *p = finddevice(&DevInfoList, busNo, devNo);
+
 	if (!p) {
 		LOGERR("(%lu,%lu) failed", busNo, devNo);
 		return FALSE;
-- 
1.9.3


