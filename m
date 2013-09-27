Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3I0Quz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:50:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:61345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3I0Quv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="300200208"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 3/5] misc: mic: cleanups for "--strict" checkpatch.
Date: Fri, 27 Sep 2013 09:49:53 -0700
Message-Id: <6ec5d933e58aa0eea2858b6036bfa26e8d07e8e9.1380289102.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380289102.git.sudeep.dutt@intel.com>
References: <cover.1380289102.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

These changes were mostly authored by Joe Perches <joe@perches.com>
@ https://lkml.org/lkml/2013/9/5/602

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 Documentation/mic/mpssd/mpssd.c     | 65 ++++++++++++++-------------
 Documentation/mic/mpssd/sysfs.c     |  4 +-
 drivers/misc/mic/card/mic_device.c  |  1 -
 drivers/misc/mic/card/mic_virtio.c  | 17 ++++---
 drivers/misc/mic/card/mic_x100.c    |  4 +-
 drivers/misc/mic/host/mic_debugfs.c | 90 ++++++++++++++++++-------------------
 drivers/misc/mic/host/mic_fops.c    |  6 +--
 drivers/misc/mic/host/mic_intr.c    | 34 +++++++-------
 drivers/misc/mic/host/mic_smpt.c    | 14 +++---
 drivers/misc/mic/host/mic_sysfs.c   | 20 ++++-----
 drivers/misc/mic/host/mic_virtio.c  | 37 +++++++--------
 drivers/misc/mic/host/mic_x100.c    | 33 +++++++-------
 12 files changed, 158 insertions(+), 167 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 8064804..f9327a2 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -246,7 +246,7 @@ static int tun_alloc(struct mic_info *mic, char *dev)
 	if (*dev)
 		strncpy(ifr.ifr_name, dev, IFNAMSIZ);
 
-	err = ioctl(fd, TUNSETIFF, (void *) &ifr);
+	err = ioctl(fd, TUNSETIFF, (void *)&ifr);
 	if (err < 0) {
 		mpsslog("%s %s %d TUNSETIFF failed %s\n",
 			mic->name, __func__, __LINE__, strerror(errno));
@@ -363,7 +363,7 @@ static inline void verify_out_len(struct mic_info *mic,
 {
 	if (copy->out_len != sum_iovec_len(copy)) {
 		mpsslog("%s %s %d BUG copy->out_len 0x%x len 0x%x\n",
-				mic->name, __func__, __LINE__,
+			mic->name, __func__, __LINE__,
 				copy->out_len, sum_iovec_len(copy));
 		assert(copy->out_len == sum_iovec_len(copy));
 	}
@@ -372,7 +372,7 @@ static inline void verify_out_len(struct mic_info *mic,
 /* Display an iovec */
 static void
 disp_iovec(struct mic_info *mic, struct mic_copy_desc *copy,
-	const char *s, int line)
+	   const char *s, int line)
 {
 	int i;
 
@@ -401,7 +401,7 @@ static inline void txrx_prepare(int type, bool tx, struct mic_vring *vr,
 /* Central API which triggers the copies */
 static int
 mic_virtio_copy(struct mic_info *mic, int fd,
-	struct mic_vring *vr, struct mic_copy_desc *copy)
+		struct mic_vring *vr, struct mic_copy_desc *copy)
 {
 	int ret;
 
@@ -440,7 +440,7 @@ init_vr(struct mic_info *mic, int fd, int type,
 	vr0->info = vr0->va +
 		vring_size(MIC_VRING_ENTRIES, MIC_VIRTIO_RING_ALIGN);
 	vring_init(&vr0->vr,
-		MIC_VRING_ENTRIES, vr0->va, MIC_VIRTIO_RING_ALIGN);
+		   MIC_VRING_ENTRIES, vr0->va, MIC_VIRTIO_RING_ALIGN);
 	mpsslog("%s %s vr0 %p vr0->info %p vr_size 0x%x vring 0x%x ",
 		__func__, mic->name, vr0->va, vr0->info, vr_size,
 		vring_size(MIC_VRING_ENTRIES, MIC_VIRTIO_RING_ALIGN));
@@ -453,7 +453,7 @@ init_vr(struct mic_info *mic, int fd, int type,
 		vr1->info = vr1->va + vring_size(MIC_VRING_ENTRIES,
 			MIC_VIRTIO_RING_ALIGN);
 		vring_init(&vr1->vr,
-			MIC_VRING_ENTRIES, vr1->va, MIC_VIRTIO_RING_ALIGN);
+			   MIC_VRING_ENTRIES, vr1->va, MIC_VIRTIO_RING_ALIGN);
 		mpsslog("%s %s vr1 %p vr1->info %p vr_size 0x%x vring 0x%x ",
 			__func__, mic->name, vr1->va, vr1->info, vr_size,
 			vring_size(MIC_VRING_ENTRIES, MIC_VIRTIO_RING_ALIGN));
@@ -551,7 +551,7 @@ virtio_net(void *arg)
 	net_poll[NET_FD_TUN].events = POLLIN;
 
 	if (MAP_FAILED == init_vr(mic, mic->mic_net.virtio_net_fd,
-		VIRTIO_ID_NET, &tx_vr, &rx_vr,
+				  VIRTIO_ID_NET, &tx_vr, &rx_vr,
 		virtnet_dev_page.dd.num_vq)) {
 		mpsslog("%s init_vr failed %s\n",
 			mic->name, strerror(errno));
@@ -576,7 +576,7 @@ virtio_net(void *arg)
 		}
 		if (!(desc->status & VIRTIO_CONFIG_S_DRIVER_OK))
 			wait_for_card_driver(mic, mic->mic_net.virtio_net_fd,
-					VIRTIO_ID_NET);
+					     VIRTIO_ID_NET);
 		/*
 		 * Check if there is data to be read from TUN and write to
 		 * virtio net fd if there is.
@@ -587,7 +587,7 @@ virtio_net(void *arg)
 				copy.iov, copy.iovcnt);
 			if (len > 0) {
 				struct virtio_net_hdr *hdr
-					= (struct virtio_net_hdr *) vnet_hdr[0];
+					= (struct virtio_net_hdr *)vnet_hdr[0];
 
 				/* Disable checksums on the card since we are on
 				   a reliable PCIe link */
@@ -606,7 +606,7 @@ virtio_net(void *arg)
 #endif
 				spin_for_descriptors(mic, &tx_vr);
 				txrx_prepare(VIRTIO_ID_NET, 1, &tx_vr, &copy,
-					len);
+					     len);
 
 				err = mic_virtio_copy(mic,
 					mic->mic_net.virtio_net_fd, &tx_vr,
@@ -644,7 +644,7 @@ virtio_net(void *arg)
 				le16toh(rx_vr.vr.avail->idx)) {
 				copy.iov = iov1;
 				txrx_prepare(VIRTIO_ID_NET, 0, &rx_vr, &copy,
-					MAX_NET_PKT_SIZE
+					     MAX_NET_PKT_SIZE
 					+ sizeof(struct virtio_net_hdr));
 
 				err = mic_virtio_copy(mic,
@@ -669,7 +669,7 @@ virtio_net(void *arg)
 					verify_out_len(mic, &copy);
 #ifdef DEBUG
 					disp_iovec(mic, copy, __func__,
-						__LINE__);
+						   __LINE__);
 					mpsslog("%s %s %d ",
 						mic->name, __func__, __LINE__);
 					mpsslog("read from net 0x%lx\n",
@@ -686,7 +686,7 @@ virtio_net(void *arg)
 					} else {
 #ifdef DEBUG
 						disp_iovec(mic, &copy, __func__,
-							__LINE__);
+							   __LINE__);
 						mpsslog("%s %s %d ",
 							mic->name, __func__,
 							__LINE__);
@@ -750,13 +750,13 @@ virtio_console(void *arg)
 	err = grantpt(pty_fd);
 	if (err < 0) {
 		mpsslog("can't grant access: %s %s\n",
-				pts_name, strerror(errno));
+			pts_name, strerror(errno));
 		goto _close_pty;
 	}
 	err = unlockpt(pty_fd);
 	if (err < 0) {
 		mpsslog("can't unlock a pseudoterminal: %s %s\n",
-				pts_name, strerror(errno));
+			pts_name, strerror(errno));
 		goto _close_pty;
 	}
 	console_poll[MONITOR_FD].fd = pty_fd;
@@ -766,7 +766,7 @@ virtio_console(void *arg)
 	console_poll[VIRTIO_CONSOLE_FD].events = POLLIN;
 
 	if (MAP_FAILED == init_vr(mic, mic->mic_console.virtio_console_fd,
-		VIRTIO_ID_CONSOLE, &tx_vr, &rx_vr,
+				  VIRTIO_ID_CONSOLE, &tx_vr, &rx_vr,
 		virtcons_dev_page.dd.num_vq)) {
 		mpsslog("%s init_vr failed %s\n",
 			mic->name, strerror(errno));
@@ -787,7 +787,7 @@ virtio_console(void *arg)
 		}
 		if (!(desc->status & VIRTIO_CONFIG_S_DRIVER_OK))
 			wait_for_card_driver(mic,
-				mic->mic_console.virtio_console_fd,
+					     mic->mic_console.virtio_console_fd,
 				VIRTIO_ID_CONSOLE);
 
 		if (console_poll[MONITOR_FD].revents & POLLIN) {
@@ -802,7 +802,7 @@ virtio_console(void *arg)
 #endif
 				spin_for_descriptors(mic, &tx_vr);
 				txrx_prepare(VIRTIO_ID_CONSOLE, 1, &tx_vr,
-					&copy, len);
+					     &copy, len);
 
 				err = mic_virtio_copy(mic,
 					mic->mic_console.virtio_console_fd,
@@ -837,7 +837,7 @@ virtio_console(void *arg)
 				le16toh(rx_vr.vr.avail->idx)) {
 				copy.iov = iov1;
 				txrx_prepare(VIRTIO_ID_CONSOLE, 0, &rx_vr,
-					&copy, PAGE_SIZE);
+					     &copy, PAGE_SIZE);
 
 				err = mic_virtio_copy(mic,
 					mic->mic_console.virtio_console_fd,
@@ -848,7 +848,7 @@ virtio_console(void *arg)
 					verify_out_len(mic, &copy);
 #ifdef DEBUG
 					disp_iovec(mic, copy, __func__,
-						__LINE__);
+						   __LINE__);
 					mpsslog("%s %s %d ",
 						mic->name, __func__, __LINE__);
 					mpsslog("read from net 0x%lx\n",
@@ -865,7 +865,7 @@ virtio_console(void *arg)
 					} else {
 #ifdef DEBUG
 						disp_iovec(mic, copy, __func__,
-							__LINE__);
+							   __LINE__);
 						mpsslog("%s %s %d ",
 							mic->name, __func__,
 							__LINE__);
@@ -1033,7 +1033,8 @@ start_virtblk(struct mic_info *mic, struct mic_vring *vring)
 	}
 	add_virtio_device(mic, &virtblk_dev_page.dd);
 	if (MAP_FAILED == init_vr(mic, mic->mic_virtblk.virtio_block_fd,
-		VIRTIO_ID_BLOCK, vring, NULL, virtblk_dev_page.dd.num_vq)) {
+				  VIRTIO_ID_BLOCK, vring, NULL,
+				  virtblk_dev_page.dd.num_vq)) {
 		mpsslog("%s init_vr failed %s\n",
 			mic->name, strerror(errno));
 		return false;
@@ -1060,7 +1061,7 @@ header_error_check(struct vring_desc *desc)
 {
 	if (le32toh(desc->len) != sizeof(struct virtio_blk_outhdr)) {
 		mpsslog("%s() %d: length is not sizeof(virtio_blk_outhd)\n",
-				__func__, __LINE__);
+			__func__, __LINE__);
 		return -EIO;
 	}
 	if (!(le16toh(desc->flags) & VRING_DESC_F_NEXT)) {
@@ -1132,7 +1133,7 @@ write_status(int fd, __u8 *status)
 static void *
 virtio_block(void *arg)
 {
-	struct mic_info *mic = (struct mic_info *) arg;
+	struct mic_info *mic = (struct mic_info *)arg;
 	int ret;
 	struct pollfd block_poll;
 	struct mic_vring vring;
@@ -1219,8 +1220,8 @@ virtio_block(void *arg)
 				status = 0;
 				fos = mic->mic_virtblk.backend_addr +
 					(hdr.sector * SECTOR_SIZE);
-				buffer_desc_idx = desc_idx =
-					next_desc(desc);
+				buffer_desc_idx = next_desc(desc);
+				desc_idx = buffer_desc_idx;
 				for (desc = &vring.vr.desc[buffer_desc_idx];
 				     desc->flags & VRING_DESC_F_NEXT;
 				     desc_idx = next_desc(desc),
@@ -1255,7 +1256,7 @@ virtio_block(void *arg)
 						iovec,
 						piov - iovec);
 					if (ret < 0 &&
-						status != 0)
+					    status != 0)
 						status = ret;
 				}
 				/* write status and update used pointer */
@@ -1391,7 +1392,7 @@ mic_config(void *arg)
 	char value[4096];
 
 	snprintf(pathname, PATH_MAX - 1, "%s/%s/%s",
-		MICSYSFSDIR, mic->name, "state");
+		 MICSYSFSDIR, mic->name, "state");
 
 	fd = open(pathname, O_RDONLY);
 	if (fd < 0) {
@@ -1560,22 +1561,22 @@ init_mic(struct mic_info *mic)
 			virtio_console, mic);
 		if (err)
 			mpsslog("%s virtcons pthread_create failed %s\n",
-			mic->name, strerror(err));
+				mic->name, strerror(err));
 		err = pthread_create(&mic->mic_net.net_thread, NULL,
 			virtio_net, mic);
 		if (err)
 			mpsslog("%s virtnet pthread_create failed %s\n",
-			mic->name, strerror(err));
+				mic->name, strerror(err));
 		err = pthread_create(&mic->mic_virtblk.block_thread, NULL,
 			virtio_block, mic);
 		if (err)
 			mpsslog("%s virtblk pthread_create failed %s\n",
-			mic->name, strerror(err));
+				mic->name, strerror(err));
 		sigemptyset(&act.sa_mask);
 		err = sigaction(SIGUSR1, &act, NULL);
 		if (err)
 			mpsslog("%s sigaction SIGUSR1 failed %s\n",
-			mic->name, strerror(errno));
+				mic->name, strerror(errno));
 		while (1)
 			sleep(60);
 	case -1:
diff --git a/Documentation/mic/mpssd/sysfs.c b/Documentation/mic/mpssd/sysfs.c
index 11de72b..8dd3269 100644
--- a/Documentation/mic/mpssd/sysfs.c
+++ b/Documentation/mic/mpssd/sysfs.c
@@ -35,7 +35,7 @@ readsysfs(char *dir, char *entry)
 		snprintf(filename, PATH_MAX, "%s/%s", MICSYSFSDIR, entry);
 	else
 		snprintf(filename, PATH_MAX,
-			"%s/%s/%s", MICSYSFSDIR, dir, entry);
+			 "%s/%s/%s", MICSYSFSDIR, dir, entry);
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
@@ -75,7 +75,7 @@ setsysfs(char *dir, char *entry, char *value)
 		snprintf(filename, PATH_MAX, "%s/%s", MICSYSFSDIR, entry);
 	else
 		snprintf(filename, PATH_MAX, "%s/%s/%s",
-			MICSYSFSDIR, dir, entry);
+			 MICSYSFSDIR, dir, entry);
 
 	oldvalue = readsysfs(dir, entry);
 
diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
index 175d114..d0980ff 100644
--- a/drivers/misc/mic/card/mic_device.c
+++ b/drivers/misc/mic/card/mic_device.c
@@ -167,7 +167,6 @@ struct mic_irq *mic_request_card_irq(irqreturn_t (*func)(int irq, void *data),
 	return (struct mic_irq *)cookie;
 err:
 	return ERR_PTR(rc);
-
 }
 
 /**
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 7420c33..914cc9b 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -103,7 +103,7 @@ static void mic_finalize_features(struct virtio_device *vdev)
 	for (i = 0; i < bits; i++) {
 		if (test_bit(i, vdev->features))
 			iowrite8(ioread8(&out_features[i / 8]) | (1 << (i % 8)),
-				&out_features[i / 8]);
+				 &out_features[i / 8]);
 	}
 }
 
@@ -197,10 +197,9 @@ static void mic_notify(struct virtqueue *vq)
 static void mic_del_vq(struct virtqueue *vq, int n)
 {
 	struct mic_vdev *mvdev = to_micvdev(vq->vdev);
-	struct vring *vr = (struct vring *) (vq + 1);
+	struct vring *vr = (struct vring *)(vq + 1);
 
-	free_pages((unsigned long) vr->used,
-		get_order(mvdev->used_size[n]));
+	free_pages((unsigned long) vr->used, get_order(mvdev->used_size[n]));
 	vring_del_virtqueue(vq);
 	mic_card_unmap(mvdev->mdev, mvdev->vr[n]);
 	mvdev->vr[n] = NULL;
@@ -274,8 +273,8 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
 	/* Allocate and reassign used ring now */
 	mvdev->used_size[index] = PAGE_ALIGN(sizeof(__u16) * 3 +
 			sizeof(struct vring_used_elem) * config.num);
-	used = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(mvdev->used_size[index]));
+	used = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					get_order(mvdev->used_size[index]));
 	if (!used) {
 		err = -ENOMEM;
 		dev_err(mic_dev(mvdev), "%s %d err %d\n",
@@ -291,7 +290,7 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
 	 * vring_new_virtqueue() would ensure that
 	 *  (&vq->vring == (struct vring *) (&vq->vq + 1));
 	 */
-	vr = (struct vring *) (vq + 1);
+	vr = (struct vring *)(vq + 1);
 	vr->used = used;
 
 	vq->priv = mvdev;
@@ -544,7 +543,7 @@ static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
 		if (dev) {
 			if (remove)
 				iowrite8(MIC_VIRTIO_PARAM_DEV_REMOVE,
-					&dc->config_change);
+					 &dc->config_change);
 			put_device(dev);
 			mic_handle_config_change(d, i, mdrv);
 			ret = mic_remove_device(d, i, mdrv);
@@ -559,7 +558,7 @@ static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
 
 		/* new device */
 		dev_dbg(mdrv->dev, "%s %d Adding new virtio device %p\n",
-				__func__, __LINE__, d);
+			__func__, __LINE__, d);
 		if (!remove)
 			mic_add_device(d, i, mdrv);
 	}
diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index f491c91..2868945 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -66,8 +66,8 @@ void mic_send_intr(struct mic_device *mdev, int doorbell)
 	/* Ensure that the interrupt is ordered w.r.t previous stores. */
 	wmb();
 	mic_mmio_write(mw, MIC_X100_SBOX_SDBIC0_DBREQ_BIT,
-		MIC_X100_SBOX_BASE_ADDRESS +
-		(MIC_X100_SBOX_SDBIC0 + (4 * doorbell)));
+		       MIC_X100_SBOX_BASE_ADDRESS +
+		       (MIC_X100_SBOX_SDBIC0 + (4 * doorbell)));
 }
 
 /**
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
index 98a61b4..028ba5d6 100644
--- a/drivers/misc/mic/host/mic_debugfs.c
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -103,7 +103,7 @@ static int mic_smpt_show(struct seq_file *s, void *pos)
 	unsigned long flags;
 
 	seq_printf(s, "MIC %-2d |%-10s| %-14s %-10s\n",
-		mdev->id, "SMPT entry", "SW DMA addr", "RefCount");
+		   mdev->id, "SMPT entry", "SW DMA addr", "RefCount");
 	seq_puts(s, "====================================================\n");
 
 	if (mdev->smpt) {
@@ -111,8 +111,8 @@ static int mic_smpt_show(struct seq_file *s, void *pos)
 		spin_lock_irqsave(&smpt_info->smpt_lock, flags);
 		for (i = 0; i < smpt_info->info.num_reg; i++) {
 			seq_printf(s, "%9s|%-10d| %-#14llx %-10lld\n",
-				" ",  i, smpt_info->entry[i].dma_addr,
-				smpt_info->entry[i].ref_count);
+				   " ",  i, smpt_info->entry[i].dma_addr,
+				   smpt_info->entry[i].ref_count);
 		}
 		spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
 	}
@@ -203,17 +203,17 @@ static int mic_dp_show(struct seq_file *s, void *pos)
 	int i, j;
 
 	seq_printf(s, "Bootparam: magic 0x%x\n",
-		bootparam->magic);
+		   bootparam->magic);
 	seq_printf(s, "Bootparam: h2c_shutdown_db %d\n",
-		bootparam->h2c_shutdown_db);
+		   bootparam->h2c_shutdown_db);
 	seq_printf(s, "Bootparam: h2c_config_db %d\n",
-		bootparam->h2c_config_db);
+		   bootparam->h2c_config_db);
 	seq_printf(s, "Bootparam: c2h_shutdown_db %d\n",
-		bootparam->c2h_shutdown_db);
+		   bootparam->c2h_shutdown_db);
 	seq_printf(s, "Bootparam: shutdown_status %d\n",
-		bootparam->shutdown_status);
+		   bootparam->shutdown_status);
 	seq_printf(s, "Bootparam: shutdown_card %d\n",
-		bootparam->shutdown_card);
+		   bootparam->shutdown_card);
 
 	for (i = sizeof(*bootparam); i < MIC_DP_SIZE;
 	     i += mic_total_desc_size(d)) {
@@ -239,10 +239,10 @@ static int mic_dp_show(struct seq_file *s, void *pos)
 			seq_printf(s, "address 0x%llx ", vqconfig->address);
 			seq_printf(s, "num %d ", vqconfig->num);
 			seq_printf(s, "used address 0x%llx\n",
-				vqconfig->used_address);
+				   vqconfig->used_address);
 		}
 
-		features = (__u32 *) mic_vq_features(d);
+		features = (__u32 *)mic_vq_features(d);
 		seq_printf(s, "Features: Host 0x%x ", features[0]);
 		seq_printf(s, "Guest 0x%x\n", features[1]);
 
@@ -256,7 +256,7 @@ static int mic_dp_show(struct seq_file *s, void *pos)
 		seq_printf(s, "Guest Ack %d ", dc->guest_ack);
 		seq_printf(s, "Host ack %d\n", dc->host_ack);
 		seq_printf(s, "Used address updated %d ",
-			dc->used_address_updated);
+			   dc->used_address_updated);
 		seq_printf(s, "Vdev 0x%llx\n", dc->vdev);
 		seq_printf(s, "c2h doorbell %d ", dc->c2h_vdev_db);
 		seq_printf(s, "h2c doorbell %d\n", dc->h2c_vdev_db);
@@ -294,10 +294,10 @@ static int mic_vdev_info_show(struct seq_file *s, void *unused)
 	list_for_each_safe(pos, tmp, &mdev->vdev_list) {
 		mvdev = list_entry(pos, struct mic_vdev, list);
 		seq_printf(s, "VDEV type %d state %s in %ld out %ld\n",
-			mvdev->virtio_id,
-			mic_vdevup(mvdev) ? "UP" : "DOWN",
-			mvdev->in_bytes,
-			mvdev->out_bytes);
+			   mvdev->virtio_id,
+			   mic_vdevup(mvdev) ? "UP" : "DOWN",
+			   mvdev->in_bytes,
+			   mvdev->out_bytes);
 		for (i = 0; i < MIC_MAX_VRINGS; i++) {
 			struct vring_desc *desc;
 			struct vring_avail *avail;
@@ -309,38 +309,38 @@ static int mic_vdev_info_show(struct seq_file *s, void *unused)
 				continue;
 			desc = vrh->vring.desc;
 			seq_printf(s, "vring i %d avail_idx %d",
-				i, mvr->vring.info->avail_idx & (num - 1));
+				   i, mvr->vring.info->avail_idx & (num - 1));
 			seq_printf(s, " vring i %d avail_idx %d\n",
-				i, mvr->vring.info->avail_idx);
+				   i, mvr->vring.info->avail_idx);
 			seq_printf(s, "vrh i %d weak_barriers %d",
-				i, vrh->weak_barriers);
+				   i, vrh->weak_barriers);
 			seq_printf(s, " last_avail_idx %d last_used_idx %d",
-				vrh->last_avail_idx, vrh->last_used_idx);
+				   vrh->last_avail_idx, vrh->last_used_idx);
 			seq_printf(s, " completed %d\n", vrh->completed);
 			for (j = 0; j < num; j++) {
 				seq_printf(s, "desc[%d] addr 0x%llx len %d",
-					j, desc->addr, desc->len);
+					   j, desc->addr, desc->len);
 				seq_printf(s, " flags 0x%x next %d\n",
-					desc->flags,
-					desc->next);
+					   desc->flags, desc->next);
 				desc++;
 			}
 			avail = vrh->vring.avail;
 			seq_printf(s, "avail flags 0x%x idx %d\n",
-				avail->flags, avail->idx & (num - 1));
+				   avail->flags, avail->idx & (num - 1));
 			seq_printf(s, "avail flags 0x%x idx %d\n",
-				avail->flags, avail->idx);
+				   avail->flags, avail->idx);
 			for (j = 0; j < num; j++)
 				seq_printf(s, "avail ring[%d] %d\n",
-					j, avail->ring[j]);
+					   j, avail->ring[j]);
 			used = vrh->vring.used;
 			seq_printf(s, "used flags 0x%x idx %d\n",
-				used->flags, used->idx & (num - 1));
+				   used->flags, used->idx & (num - 1));
 			seq_printf(s, "used flags 0x%x idx %d\n",
-				used->flags, used->idx);
+				   used->flags, used->idx);
 			for (j = 0; j < num; j++)
 				seq_printf(s, "used ring[%d] id %d len %d\n",
-					j, used->ring[j].id, used->ring[j].len);
+					   j, used->ring[j].id,
+					   used->ring[j].len);
 		}
 	}
 	mutex_unlock(&mdev->mic_mutex);
@@ -389,7 +389,7 @@ static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
 			reg = mdev->intr_ops->read_msi_to_src_map(mdev, entry);
 
 			seq_printf(s, "%s %-10d %s %-10d MXAR[%d]: %08X\n",
-				"IRQ:", vector, "Entry:", entry, i, reg);
+				   "IRQ:", vector, "Entry:", entry, i, reg);
 
 			seq_printf(s, "%-10s", "offset:");
 			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
@@ -400,8 +400,8 @@ static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
 			seq_printf(s, "%-10s", "count:");
 			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
 				seq_printf(s, "%4d ",
-				(mdev->irq_info.mic_msi_map[i] & BIT(j)) ?
-					1 : 0);
+					   (mdev->irq_info.mic_msi_map[i] &
+					   BIT(j)) ? 1 : 0);
 			seq_puts(s, "\n\n");
 		}
 	} else {
@@ -409,7 +409,6 @@ static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
 	}
 
 	return 0;
-
 }
 
 static int mic_msi_irq_info_debug_open(struct inode *inode, struct file *file)
@@ -443,26 +442,23 @@ void mic_create_debug_dir(struct mic_device *mdev)
 	if (!mdev->dbg_dir)
 		return;
 
-	debugfs_create_file("log_buf", 0444, mdev->dbg_dir,
-		mdev, &log_buf_ops);
+	debugfs_create_file("log_buf", 0444, mdev->dbg_dir, mdev, &log_buf_ops);
 
-	debugfs_create_file("smpt", 0444, mdev->dbg_dir,
-		mdev, &smpt_file_ops);
+	debugfs_create_file("smpt", 0444, mdev->dbg_dir, mdev, &smpt_file_ops);
 
-	debugfs_create_file("soft_reset", 0444, mdev->dbg_dir,
-		mdev, &soft_reset_ops);
+	debugfs_create_file("soft_reset", 0444, mdev->dbg_dir, mdev,
+			    &soft_reset_ops);
 
-	debugfs_create_file("post_code", 0444, mdev->dbg_dir,
-		mdev, &post_code_ops);
+	debugfs_create_file("post_code", 0444, mdev->dbg_dir, mdev,
+			    &post_code_ops);
 
-	debugfs_create_file("dp", 0444, mdev->dbg_dir,
-		mdev, &dp_ops);
+	debugfs_create_file("dp", 0444, mdev->dbg_dir, mdev, &dp_ops);
 
-	debugfs_create_file("vdev_info", 0444, mdev->dbg_dir,
-		mdev, &vdev_info_ops);
+	debugfs_create_file("vdev_info", 0444, mdev->dbg_dir, mdev,
+			    &vdev_info_ops);
 
-	debugfs_create_file("msi_irq_info", 0444, mdev->dbg_dir,
-		mdev, &msi_irq_info_ops);
+	debugfs_create_file("msi_irq_info", 0444, mdev->dbg_dir, mdev,
+			    &msi_irq_info_ops);
 }
 
 /**
diff --git a/drivers/misc/mic/host/mic_fops.c b/drivers/misc/mic/host/mic_fops.c
index e699c80..8dc6ff1 100644
--- a/drivers/misc/mic/host/mic_fops.c
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -140,9 +140,9 @@ unsigned int mic_poll(struct file *f, poll_table *wait)
 
 	poll_wait(f, &mvdev->waitq, wait);
 
-	if (mic_vdev_inited(mvdev))
+	if (mic_vdev_inited(mvdev)) {
 		mask = POLLERR;
-	else if (mvdev->poll_wake) {
+	} else if (mvdev->poll_wake) {
 		mvdev->poll_wake = 0;
 		mask = POLLIN | POLLOUT;
 	}
@@ -152,7 +152,7 @@ unsigned int mic_poll(struct file *f, poll_table *wait)
 
 static inline int
 mic_query_offset(struct mic_vdev *mvdev, unsigned long offset,
-	unsigned long *size, unsigned long *pa)
+		 unsigned long *size, unsigned long *pa)
 {
 	struct mic_device *mdev = mvdev->mdev;
 	unsigned long start = MIC_DP_SIZE;
diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index 71a7521..f9c29bc 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -71,8 +71,8 @@ static irqreturn_t mic_interrupt(int irq, void *dev)
 
 /* Return the interrupt offset from the index. Index is 0 based. */
 static u16 mic_map_src_to_offset(struct mic_device *mdev,
-		int intr_src, enum mic_intr_type type) {
-
+		int intr_src, enum mic_intr_type type)
+{
 	if (type >= MIC_NUM_INTR_TYPES)
 		return MIC_NUM_OFFSETS;
 	if (intr_src >= mdev->intr_info->intr_len[type])
@@ -112,7 +112,7 @@ static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
 	struct mic_intr_cb *intr_cb;
 	unsigned long flags;
 	int rc;
-	intr_cb = kmalloc(sizeof(struct mic_intr_cb), GFP_KERNEL);
+	intr_cb = kmalloc(sizeof(*intr_cb), GFP_KERNEL);
 
 	if (!intr_cb)
 		return ERR_PTR(-ENOMEM);
@@ -159,7 +159,7 @@ static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
 			if (intr_cb->cb_id == idx) {
 				list_del(pos);
 				ida_simple_remove(&mdev->irq_info.cb_ida,
-					intr_cb->cb_id);
+						  intr_cb->cb_id);
 				kfree(intr_cb);
 				spin_unlock_irqrestore(
 					&mdev->irq_info.mic_intr_lock, flags);
@@ -182,9 +182,10 @@ static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
 static int mic_setup_msix(struct mic_device *mdev, struct pci_dev *pdev)
 {
 	int rc, i;
+	int entry_size = sizeof(*mdev->irq_info.msix_entries);
 
-	mdev->irq_info.msix_entries = kmalloc(sizeof(struct msix_entry) *
-			MIC_MIN_MSIX, GFP_KERNEL);
+	mdev->irq_info.msix_entries = kmalloc_array(MIC_MIN_MSIX,
+						    entry_size, GFP_KERNEL);
 	if (!mdev->irq_info.msix_entries) {
 		rc = -ENOMEM;
 		goto err_nomem1;
@@ -231,8 +232,9 @@ static int mic_setup_callbacks(struct mic_device *mdev)
 {
 	int i;
 
-	mdev->irq_info.cb_list = kmalloc(sizeof(struct list_head) *
-		MIC_NUM_OFFSETS, GFP_KERNEL);
+	mdev->irq_info.cb_list = kmalloc_array(MIC_NUM_OFFSETS,
+					       sizeof(*mdev->irq_info.cb_list),
+					       GFP_KERNEL);
 	if (!mdev->irq_info.cb_list)
 		return -ENOMEM;
 
@@ -261,7 +263,7 @@ static void mic_release_callbacks(struct mic_device *mdev)
 
 		if (list_empty(&mdev->irq_info.cb_list[i])) {
 			spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock,
-				flags);
+					       flags);
 			break;
 		}
 
@@ -269,7 +271,7 @@ static void mic_release_callbacks(struct mic_device *mdev)
 			intr_cb = list_entry(pos, struct mic_intr_cb, list);
 			list_del(pos);
 			ida_simple_remove(&mdev->irq_info.cb_ida,
-				intr_cb->cb_id);
+					  intr_cb->cb_id);
 			kfree(intr_cb);
 		}
 		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
@@ -427,8 +429,8 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 	offset = mic_map_src_to_offset(mdev, intr_src, type);
 	if (offset >= MIC_NUM_OFFSETS) {
 		dev_err(mdev->sdev->parent,
-				"Error mapping index %d to a valid source id.\n",
-				intr_src);
+			"Error mapping index %d to a valid source id.\n",
+			intr_src);
 		rc = -EINVAL;
 		goto err;
 	}
@@ -437,7 +439,7 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 		msix = mic_get_available_vector(mdev);
 		if (!msix) {
 			dev_err(mdev->sdev->parent,
-			"No MSIx vectors available for use.\n");
+				"No MSIx vectors available for use.\n");
 			rc = -ENOSPC;
 			goto err;
 		}
@@ -460,7 +462,7 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 				offset, func, data);
 		if (IS_ERR(intr_cb)) {
 			dev_err(mdev->sdev->parent,
-			"No available callback entries for use\n");
+				"No available callback entries for use\n");
 			rc = PTR_ERR(intr_cb);
 			goto err;
 		}
@@ -506,7 +508,7 @@ void mic_free_irq(struct mic_device *mdev,
 	if (mdev->irq_info.num_vectors > 1) {
 		if (entry >= mdev->irq_info.num_vectors) {
 			dev_warn(mdev->sdev->parent,
-				"entry %d should be < num_irq %d\n",
+				 "entry %d should be < num_irq %d\n",
 				entry, mdev->irq_info.num_vectors);
 			return;
 		}
@@ -581,7 +583,7 @@ void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev)
 		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
 			if (mdev->irq_info.mic_msi_map[i])
 				dev_warn(&pdev->dev, "irq %d may still be in use.\n",
-					mdev->irq_info.msix_entries[i].vector);
+					 mdev->irq_info.msix_entries[i].vector);
 		}
 		kfree(mdev->irq_info.mic_msi_map);
 		kfree(mdev->irq_info.msix_entries);
diff --git a/drivers/misc/mic/host/mic_smpt.c b/drivers/misc/mic/host/mic_smpt.c
index 003d02b..fae474c 100644
--- a/drivers/misc/mic/host/mic_smpt.c
+++ b/drivers/misc/mic/host/mic_smpt.c
@@ -84,7 +84,7 @@ static void mic_add_smpt_entry(int spt, s64 *ref, u64 addr,
 	for (i = spt; i < spt + entries; i++,
 		addr += smpt_info->info.page_size) {
 		if (!smpt_info->entry[i].ref_count &&
-			(smpt_info->entry[i].dma_addr != addr)) {
+		    (smpt_info->entry[i].dma_addr != addr)) {
 			mdev->smpt_ops->set(mdev, addr, i);
 			smpt_info->entry[i].dma_addr = addr;
 		}
@@ -183,7 +183,7 @@ mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr)
 
 	if (!mic_is_system_addr(mdev, mic_addr)) {
 		dev_err(mdev->sdev->parent,
-		"mic_addr is invalid. mic_addr = 0x%llx\n", mic_addr);
+			"mic_addr is invalid. mic_addr = 0x%llx\n", mic_addr);
 		return -EINVAL;
 	}
 	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
@@ -286,7 +286,7 @@ void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
 		smpt_info->entry[i].ref_count -= ref[i - spt];
 		if (smpt_info->entry[i].ref_count < 0)
 			dev_warn(mdev->sdev->parent,
-				"ref count for entry %d is negative\n", i);
+				 "ref count for entry %d is negative\n", i);
 	}
 	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
 	kfree(ref);
@@ -320,7 +320,7 @@ dma_addr_t mic_map_single(struct mic_device *mdev, void *va, size_t size)
 				"mic_map failed dma_addr 0x%llx size 0x%lx\n",
 				dma_addr, size);
 			pci_unmap_single(pdev, dma_addr,
-				size, PCI_DMA_BIDIRECTIONAL);
+					 size, PCI_DMA_BIDIRECTIONAL);
 		}
 	}
 	return mic_addr;
@@ -366,8 +366,8 @@ int mic_smpt_init(struct mic_device *mdev)
 
 	smpt_info = mdev->smpt;
 	mdev->smpt_ops->init(mdev);
-	smpt_info->entry = kmalloc(sizeof(struct mic_smpt)
-			* smpt_info->info.num_reg, GFP_KERNEL);
+	smpt_info->entry = kmalloc_array(smpt_info->info.num_reg,
+					 sizeof(*smpt_info->entry), GFP_KERNEL);
 	if (!smpt_info->entry) {
 		err = -ENOMEM;
 		goto free_smpt;
@@ -412,7 +412,7 @@ void mic_smpt_uninit(struct mic_device *mdev)
 			smpt_info->entry[i].ref_count);
 		if (smpt_info->entry[i].ref_count)
 			dev_warn(mdev->sdev->parent,
-			"ref count for entry %d is not zero\n", i);
+				 "ref count for entry %d is not zero\n", i);
 	}
 	kfree(smpt_info->entry);
 	kfree(smpt_info);
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
index 029a4f3..75746ad 100644
--- a/drivers/misc/mic/host/mic_sysfs.c
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -130,7 +130,7 @@ state_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 static ssize_t
 state_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+	    const char *buf, size_t count)
 {
 	int rc = 0;
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -163,7 +163,7 @@ done:
 static DEVICE_ATTR_RW(state);
 
 static ssize_t shutdown_status_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -193,7 +193,7 @@ cmdline_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 static ssize_t
 cmdline_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+	      const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -239,7 +239,7 @@ firmware_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 static ssize_t
 firmware_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+	       const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -284,7 +284,7 @@ ramdisk_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 static ssize_t
 ramdisk_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+	      const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -330,7 +330,7 @@ bootmode_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 static ssize_t
 bootmode_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+	       const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -363,7 +363,7 @@ static DEVICE_ATTR_RW(bootmode);
 
 static ssize_t
 log_buf_addr_show(struct device *dev, struct device_attribute *attr,
-	char *buf)
+		  char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -375,7 +375,7 @@ log_buf_addr_show(struct device *dev, struct device_attribute *attr,
 
 static ssize_t
 log_buf_addr_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+		   const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	int ret;
@@ -397,7 +397,7 @@ static DEVICE_ATTR_RW(log_buf_addr);
 
 static ssize_t
 log_buf_len_show(struct device *dev, struct device_attribute *attr,
-	char *buf)
+		 char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -409,7 +409,7 @@ log_buf_len_show(struct device *dev, struct device_attribute *attr,
 
 static ssize_t
 log_buf_len_store(struct device *dev, struct device_attribute *attr,
-	const char *buf, size_t count)
+		  const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	int ret;
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 9e0456f..0c883cd 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -195,7 +195,7 @@ static int _mic_virtio_copy(struct mic_vdev *mvdev,
 			MIC_VRINGH_READ, &out_len);
 		if (ret) {
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
-					__func__, __LINE__, ret);
+				__func__, __LINE__, ret);
 			break;
 		}
 		len -= out_len;
@@ -206,7 +206,7 @@ static int _mic_virtio_copy(struct mic_vdev *mvdev,
 			!MIC_VRINGH_READ, &out_len);
 		if (ret) {
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
-					__func__, __LINE__, ret);
+				__func__, __LINE__, ret);
 			break;
 		}
 		len -= out_len;
@@ -225,8 +225,7 @@ static int _mic_virtio_copy(struct mic_vdev *mvdev,
 	 * Update the used ring if a descriptor was available and some data was
 	 * copied in/out and the user asked for a used ring update.
 	 */
-	if (*head != USHRT_MAX && copy->out_len &&
-		copy->update_used) {
+	if (*head != USHRT_MAX && copy->out_len && copy->update_used) {
 		u32 total = 0;
 
 		/* Determine the total data consumed */
@@ -367,7 +366,6 @@ void mic_bh_handler(struct work_struct *work)
 
 static irqreturn_t mic_virtio_intr_handler(int irq, void *data)
 {
-
 	struct mic_vdev *mvdev = data;
 	struct mic_device *mdev = mvdev->mdev;
 
@@ -394,7 +392,7 @@ int mic_virtio_config_change(struct mic_vdev *mvdev,
 	}
 
 	if (copy_from_user(mic_vq_configspace(mvdev->dd),
-				argp, mvdev->dd->config_len)) {
+			   argp, mvdev->dd->config_len)) {
 		dev_err(mic_dev(mvdev), "%s %d err %d\n",
 			__func__, __LINE__, -EFAULT);
 		ret = -EFAULT;
@@ -438,8 +436,8 @@ static int mic_copy_dp_entry(struct mic_vdev *mvdev,
 		return -EFAULT;
 	}
 
-	if (mic_aligned_desc_size(&dd) > MIC_MAX_DESC_BLK_SIZE
-		|| dd.num_vq > MIC_MAX_VRINGS) {
+	if (mic_aligned_desc_size(&dd) > MIC_MAX_DESC_BLK_SIZE ||
+	    dd.num_vq > MIC_MAX_VRINGS) {
 		dev_err(mic_dev(mvdev), "%s %d err %d\n",
 			__func__, __LINE__, -EINVAL);
 		return -EINVAL;
@@ -503,7 +501,7 @@ static void mic_init_device_ctrl(struct mic_vdev *mvdev,
 {
 	struct mic_device_ctrl *dc;
 
-	dc = mvdev->dc = (void *)devpage + mic_aligned_desc_size(devpage);
+	dc = (void *)devpage + mic_aligned_desc_size(devpage);
 
 	dc->config_change = 0;
 	dc->guest_ack = 0;
@@ -512,6 +510,7 @@ static void mic_init_device_ctrl(struct mic_vdev *mvdev,
 	dc->used_address_updated = 0;
 	dc->c2h_vdev_db = -1;
 	dc->h2c_vdev_db = -1;
+	mvdev->dc = dc;
 }
 
 int mic_virtio_add_device(struct mic_vdev *mvdev,
@@ -551,7 +550,7 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 			sizeof(struct _mic_vring_info));
 		vr->va = (void *)
 			__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-			get_order(vr_size));
+					 get_order(vr_size));
 		if (!vr->va) {
 			ret = -ENOMEM;
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
@@ -564,8 +563,7 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 		vqconfig[i].address = mic_map_single(mdev,
 			vr->va, vr_size);
 		if (mic_map_error(vqconfig[i].address)) {
-			free_pages((unsigned long)vr->va,
-				get_order(vr_size));
+			free_pages((unsigned long)vr->va, get_order(vr_size));
 			ret = -ENOMEM;
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
 				__func__, __LINE__, ret);
@@ -573,8 +571,7 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 		}
 		vqconfig[i].address = cpu_to_le64(vqconfig[i].address);
 
-		vring_init(&vr->vr, num,
-			vr->va, MIC_VIRTIO_RING_ALIGN);
+		vring_init(&vr->vr, num, vr->va, MIC_VIRTIO_RING_ALIGN);
 		ret = vringh_init_kern(&mvr->vrh,
 			*(u32 *)mic_vq_features(mvdev->dd), num, false,
 			vr->vr.desc, vr->vr.avail, vr->vr.used);
@@ -593,8 +590,8 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 			__func__, __LINE__, i, vr->va, vr->info, vr_size);
 	}
 
-	snprintf(irqname, sizeof(irqname),
-		"mic%dvirtio%d", mdev->id, mvdev->virtio_id);
+	snprintf(irqname, sizeof(irqname), "mic%dvirtio%d", mdev->id,
+		 mvdev->virtio_id);
 	mvdev->virtio_db = mic_next_db(mdev);
 	mvdev->virtio_cookie = mic_request_irq(mdev, mic_virtio_intr_handler,
 			irqname, mvdev, mvdev->virtio_db, MIC_INTR_DB);
@@ -628,9 +625,9 @@ err:
 	for (j = 0; j < i; j++) {
 		struct mic_vringh *mvr = &mvdev->mvr[j];
 		mic_unmap_single(mdev, le64_to_cpu(vqconfig[j].address),
-				mvr->vring.len);
+				 mvr->vring.len);
 		free_pages((unsigned long)mvr->vring.va,
-			get_order(mvr->vring.len));
+			   get_order(mvr->vring.len));
 	}
 	mutex_unlock(&mdev->mic_mutex);
 	return ret;
@@ -676,9 +673,9 @@ skip_hot_remove:
 		vringh_kiov_cleanup(&mvr->riov);
 		vringh_kiov_cleanup(&mvr->wiov);
 		mic_unmap_single(mdev, le64_to_cpu(vqconfig[i].address),
-				mvr->vring.len);
+				 mvr->vring.len);
 		free_pages((unsigned long)mvr->vring.va,
-			get_order(mvr->vring.len));
+			   get_order(mvr->vring.len));
 	}
 
 	list_for_each_safe(pos, tmp, &mdev->vdev_list) {
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index 3a0d660..81e9541 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -46,8 +46,8 @@ mic_x100_write_spad(struct mic_device *mdev, unsigned int idx, u32 val)
 	dev_dbg(mdev->sdev->parent, "Writing 0x%x to scratch pad index %d\n",
 		val, idx);
 	mic_mmio_write(&mdev->mmio, val,
-		MIC_X100_SBOX_BASE_ADDRESS +
-		MIC_X100_SBOX_SPAD0 + idx * 4);
+		       MIC_X100_SBOX_BASE_ADDRESS +
+		       MIC_X100_SBOX_SPAD0 + idx * 4);
 }
 
 /**
@@ -130,8 +130,8 @@ static void mic_x100_send_sbox_intr(struct mic_device *mdev,
 {
 	struct mic_mw *mw = &mdev->mmio;
 	u64 apic_icr_offset = MIC_X100_SBOX_APICICR0 + doorbell * 8;
-	u32 apicicr_low = mic_mmio_read(mw,
-			MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+	u32 apicicr_low = mic_mmio_read(mw, MIC_X100_SBOX_BASE_ADDRESS +
+					apic_icr_offset);
 
 	/* for MIC we need to make sure we "hit" the send_icr bit (13) */
 	apicicr_low = (apicicr_low | (1 << 13));
@@ -139,7 +139,7 @@ static void mic_x100_send_sbox_intr(struct mic_device *mdev,
 	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
 	wmb();
 	mic_mmio_write(mw, apicicr_low,
-		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+		       MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
 }
 
 /**
@@ -153,7 +153,7 @@ static void mic_x100_send_rdmasr_intr(struct mic_device *mdev,
 	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
 	wmb();
 	mic_mmio_write(&mdev->mmio, 0,
-		MIC_X100_SBOX_BASE_ADDRESS + rdmasr_offset);
+		       MIC_X100_SBOX_BASE_ADDRESS + rdmasr_offset);
 }
 
 /**
@@ -212,7 +212,7 @@ done:
  */
 static void mic_x100_hw_intr_init(struct mic_device *mdev)
 {
-	mdev->intr_info = (struct mic_intr_info *) mic_x100_intr_init;
+	mdev->intr_info = (struct mic_intr_info *)mic_x100_intr_init;
 }
 
 /**
@@ -244,7 +244,7 @@ mic_x100_read_msi_to_src_map(struct mic_device *mdev, int idx)
  */
 static void
 mic_x100_program_msi_to_src_map(struct mic_device *mdev,
-			int idx, int offset, bool set)
+				int idx, int offset, bool set)
 {
 	unsigned long reg;
 	struct mic_mw *mw = &mdev->mmio;
@@ -308,12 +308,12 @@ static void mic_x100_send_firmware_intr(struct mic_device *mdev)
 	apicicr_low = (vector | (1 << 13));
 
 	mic_mmio_write(mw, mic_x100_get_apic_id(mdev),
-		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset + 4);
+		       MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset + 4);
 
 	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
 	wmb();
 	mic_mmio_write(mw, apicicr_low,
-		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+		       MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
 }
 
 /**
@@ -365,8 +365,7 @@ mic_x100_load_command_line(struct mic_device *mdev, const struct firmware *fw)
 	len += snprintf(buf, CMDLINE_SIZE - len,
 		" mem=%dM", boot_mem);
 	if (mdev->cmdline)
-		snprintf(buf + len, CMDLINE_SIZE - len,
-				" %s", mdev->cmdline);
+		snprintf(buf + len, CMDLINE_SIZE - len, " %s", mdev->cmdline);
 	memcpy_toio(cmd_line_va, buf, strlen(buf) + 1);
 	kfree(buf);
 	return 0;
@@ -397,8 +396,7 @@ mic_x100_load_ramdisk(struct mic_device *mdev)
 	 * Typically the bootaddr for card OS is 64M
 	 * so copy over the ramdisk @ 128M.
 	 */
-	memcpy_toio(mdev->aper.va + (mdev->bootaddr << 1),
-		fw->data, fw->size);
+	memcpy_toio(mdev->aper.va + (mdev->bootaddr << 1), fw->data, fw->size);
 	iowrite32(cpu_to_le32(mdev->bootaddr << 1), &bp->hdr.ramdisk_image);
 	iowrite32(cpu_to_le32(fw->size), &bp->hdr.ramdisk_size);
 	release_firmware(fw);
@@ -484,8 +482,7 @@ mic_x100_load_firmware(struct mic_device *mdev, const char *buf)
 	if (mdev->ramdisk)
 		rc = mic_x100_load_ramdisk(mdev);
 error:
-	dev_dbg(mdev->sdev->parent, "%s %d rc %d\n",
-			__func__, __LINE__, rc);
+	dev_dbg(mdev->sdev->parent, "%s %d rc %d\n", __func__, __LINE__, rc);
 done:
 	return rc;
 }
@@ -524,8 +521,8 @@ mic_x100_smpt_set(struct mic_device *mdev, dma_addr_t dma_addr, u8 index)
 	uint32_t smpt_reg_val = BUILD_SMPT(SNOOP_ON,
 			dma_addr >> mdev->smpt->info.page_shift);
 	mic_mmio_write(&mdev->mmio, smpt_reg_val,
-		MIC_X100_SBOX_BASE_ADDRESS +
-		MIC_X100_SBOX_SMPT00 + (4 * index));
+		       MIC_X100_SBOX_BASE_ADDRESS +
+		       MIC_X100_SBOX_SMPT00 + (4 * index));
 }
 
 /**
-- 
1.8.2.1

