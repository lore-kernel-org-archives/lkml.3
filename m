Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3DKXVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:21:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DKXVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:21:17 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=2RFXOBAfd_UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mFutn27H_8gA:10 a=sOvEHXT4AAAA:8 a=Y6Avcr6PTx7W5Ejp04YA:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=NvCvpz8KglQA:10 a=-0qkl0XTG-IA:10 a=P87CIiLEdyE-CEUK:21 a=UhewJXphmvbR4SF4:21 a=5E4O5lCVABwNK5DE:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365722472.9609.68.camel@gandalf.local.home>
Subject: Re: [ 0/9 ] 3.6.11.2-stable review (update)
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 11 Apr 2013 19:21:12 -0400
In-Reply-To: <20130411231149.302144972@goodmis.org>
References: <20130411231149.302144972@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index fd753ca..50c3a87 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .1
+EXTRAVERSION = .2
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/arm/boot/dts/kirkwood-goflexnet.dts b/arch/arm/boot/dts/kirkwood-goflexnet.dts
index 7c8238f..a66a8eb 100644
--- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
+++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
@@ -22,6 +22,7 @@
 		};
 
 		nand@3000000 {
+			chip-delay = <40>;
 			status = "okay";
 
 			partition@0 {
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 031805b..7f26faf 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -22,19 +22,9 @@
 
 static struct map_desc cns3xxx_io_desc[] __initdata = {
 	{
-		.virtual	= CNS3XXX_TC11MP_TWD_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_TWD_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
-		.virtual	= CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_GIC_CPU_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
-		.virtual	= CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_GIC_DIST_BASE),
-		.length		= SZ_4K,
+		.virtual	= CNS3XXX_TC11MP_SCU_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_SCU_BASE),
+		.length		= SZ_8K,
 		.type		= MT_DEVICE,
 	}, {
 		.virtual	= CNS3XXX_TIMER1_2_3_BASE_VIRT,
diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
index 191c8e5..b1021aa 100644
--- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
+++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
@@ -94,10 +94,10 @@
 #define RTC_INTR_STS_OFFSET			0x34
 
 #define CNS3XXX_MISC_BASE			0x76000000	/* Misc Control */
-#define CNS3XXX_MISC_BASE_VIRT			0xFFF07000	/* Misc Control */
+#define CNS3XXX_MISC_BASE_VIRT			0xFB000000	/* Misc Control */
 
 #define CNS3XXX_PM_BASE				0x77000000	/* Power Management Control */
-#define CNS3XXX_PM_BASE_VIRT			0xFFF08000
+#define CNS3XXX_PM_BASE_VIRT			0xFB001000
 
 #define PM_CLK_GATE_OFFSET			0x00
 #define PM_SOFT_RST_OFFSET			0x04
@@ -109,7 +109,7 @@
 #define PM_PLL_HM_PD_OFFSET			0x1C
 
 #define CNS3XXX_UART0_BASE			0x78000000	/* UART 0 */
-#define CNS3XXX_UART0_BASE_VIRT			0xFFF09000
+#define CNS3XXX_UART0_BASE_VIRT			0xFB002000
 
 #define CNS3XXX_UART1_BASE			0x78400000	/* UART 1 */
 #define CNS3XXX_UART1_BASE_VIRT			0xFFF0A000
@@ -130,7 +130,7 @@
 #define CNS3XXX_I2S_BASE_VIRT			0xFFF10000
 
 #define CNS3XXX_TIMER1_2_3_BASE			0x7C800000	/* Timer */
-#define CNS3XXX_TIMER1_2_3_BASE_VIRT		0xFFF10800
+#define CNS3XXX_TIMER1_2_3_BASE_VIRT		0xFB003000
 
 #define TIMER1_COUNTER_OFFSET			0x00
 #define TIMER1_AUTO_RELOAD_OFFSET		0x04
@@ -227,16 +227,16 @@
  * Testchip peripheral and fpga gic regions
  */
 #define CNS3XXX_TC11MP_SCU_BASE			0x90000000	/* IRQ, Test chip */
-#define CNS3XXX_TC11MP_SCU_BASE_VIRT		0xFF000000
+#define CNS3XXX_TC11MP_SCU_BASE_VIRT		0xFB004000
 
 #define CNS3XXX_TC11MP_GIC_CPU_BASE		0x90000100	/* Test chip interrupt controller CPU interface */
-#define CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT	0xFF000100
+#define CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT	(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x100)
 
 #define CNS3XXX_TC11MP_TWD_BASE			0x90000600
-#define CNS3XXX_TC11MP_TWD_BASE_VIRT		0xFF000600
+#define CNS3XXX_TC11MP_TWD_BASE_VIRT		(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x600)
 
 #define CNS3XXX_TC11MP_GIC_DIST_BASE		0x90001000	/* Test chip interrupt controller distributor */
-#define CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT	0xFF001000
+#define CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT	(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x1000)
 
 #define CNS3XXX_TC11MP_L220_BASE		0x92002000	/* L220 registers */
 #define CNS3XXX_TC11MP_L220_BASE_VIRT		0xFF002000
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 13f555d..a3658d6 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -311,6 +311,7 @@ static int __init atomic_pool_init(void)
 {
 	struct dma_pool *pool = &atomic_pool;
 	pgprot_t prot = pgprot_dmacoherent(pgprot_kernel);
+	gfp_t gfp = GFP_KERNEL | GFP_DMA;
 	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
 	unsigned long *bitmap;
 	struct page *page;
@@ -329,8 +330,8 @@ static int __init atomic_pool_init(void)
 	if (IS_ENABLED(CONFIG_CMA))
 		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page);
 	else
-		ptr = __alloc_remap_buffer(NULL, pool->size, GFP_KERNEL, prot,
-					   &page, NULL);
+		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
+					   NULL);
 	if (ptr) {
 		int i;
 
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6a649a4..86b1ae4 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -999,15 +999,8 @@ void __cpuinit setup_cpu(int boot)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-/*
- * Note that the kernel can potentially support other compression
- * techniques than gz, though we don't do so by default.  If we ever
- * decide to do so we can either look for other filename extensions,
- * or just allow a file with this name to be compressed with an
- * arbitrary compressor (somewhat counterintuitively).
- */
 static int __initdata set_initramfs_file;
-static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
+static char __initdata initramfs_file[128] = "initramfs";
 
 static int __init setup_initramfs_file(char *str)
 {
@@ -1021,9 +1014,9 @@ static int __init setup_initramfs_file(char *str)
 early_param("initramfs_file", setup_initramfs_file);
 
 /*
- * We look for an "initramfs.cpio.gz" file in the hvfs.
- * If there is one, we allocate some memory for it and it will be
- * unpacked to the initramfs.
+ * We look for a file called "initramfs" in the hvfs.  If there is one, we
+ * allocate some memory for it and it will be unpacked to the initramfs.
+ * If it's compressed, the initd code will uncompress it first.
  */
 static void __init load_hv_initrd(void)
 {
@@ -1033,10 +1026,16 @@ static void __init load_hv_initrd(void)
 
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
-		if (set_initramfs_file)
+		if (set_initramfs_file) {
 			pr_warning("No such hvfs initramfs file '%s'\n",
 				   initramfs_file);
-		return;
+			return;
+		} else {
+			/* Try old backwards-compatible name. */
+			fd = hv_fs_findfile((HV_VirtAddr)"initramfs.cpio.gz");
+			if (fd == HV_ENOENT)
+				return;
+		}
 	}
 	BUG_ON(fd < 0);
 	stat = hv_fs_fstat(fd);
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index e5b130b..cc9de31 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -72,10 +72,10 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	char c;
 	unsigned zero_len;
 
-	for (; len; --len) {
+	for (; len; --len, to++) {
 		if (__get_user_nocheck(c, from++, sizeof(char)))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, to, sizeof(char)))
 			break;
 	}
 
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 243ee85..6eff12f 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -88,40 +88,31 @@ static int acpi_find_bridge_device(struct device *dev, acpi_handle * handle)
 	return ret;
 }
 
-/* Get device's handler per its address under its parent */
-struct acpi_find_child {
-	acpi_handle handle;
-	u64 address;
-};
-
-static acpi_status
-do_acpi_find_child(acpi_handle handle, u32 lvl, void *context, void **rv)
+static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
+				      void *addr_p, void **ret_p)
 {
+	unsigned long long addr;
 	acpi_status status;
-	struct acpi_device_info *info;
-	struct acpi_find_child *find = context;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_SUCCESS(status)) {
-		if ((info->address == find->address)
-			&& (info->valid & ACPI_VALID_ADR))
-			find->handle = handle;
-		kfree(info);
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
+	if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
+		*ret_p = handle;
+		return AE_CTRL_TERMINATE;
 	}
 	return AE_OK;
 }
 
 acpi_handle acpi_get_child(acpi_handle parent, u64 address)
 {
-	struct acpi_find_child find = { NULL, address };
+	void *ret = NULL;
 
 	if (!parent)
 		return NULL;
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent,
-			    1, do_acpi_find_child, NULL, &find, NULL);
-	return find.handle;
-}
 
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, NULL,
+			    do_acpi_find_child, &address, &ret);
+	return (acpi_handle)ret;
+}
 EXPORT_SYMBOL(acpi_get_child);
 
 /* Link ACPI devices with physical devices */
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 887f68f..db30542 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -30,8 +30,9 @@ new_skb(ulong len)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(len, GFP_ATOMIC);
+	skb = alloc_skb(len + MAX_HEADER, GFP_ATOMIC);
 	if (skb) {
+		skb_reserve(skb, MAX_HEADER);
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3bba655..1d6b89d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -908,6 +908,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
+
+	/* Grab the block_device to prevent its destruction after we
+	 * put /dev/loopXX inode. Later in loop_clr_fd() we bdput(bdev).
+	 */
+	bdgrab(bdev);
 	return 0;
 
 out_clr:
@@ -1004,8 +1009,10 @@ static int loop_clr_fd(struct loop_device *lo)
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	if (bdev)
+	if (bdev) {
+		bdput(bdev);
 		invalidate_bdev(bdev);
+	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
 	if (bdev) {
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c6decb9..4fd1dea 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -422,6 +422,16 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	return err;
 }
 
+static int dispatch_other_io(struct xen_blkif *blkif,
+			     struct blkif_request *req,
+			     struct pending_req *pending_req)
+{
+	free_req(pending_req);
+	make_response(blkif, req->u.other.id, req->operation,
+		      BLKIF_RSP_EOPNOTSUPP);
+	return -EIO;
+}
+
 static void xen_blk_drain_io(struct xen_blkif *blkif)
 {
 	atomic_set(&blkif->drain, 1);
@@ -543,17 +553,30 @@ __do_block_io_op(struct xen_blkif *blkif)
 
 		/* Apply all sanity checks to /private copy/ of request. */
 		barrier();
-		if (unlikely(req.operation == BLKIF_OP_DISCARD)) {
+
+		switch (req.operation) {
+		case BLKIF_OP_READ:
+		case BLKIF_OP_WRITE:
+		case BLKIF_OP_WRITE_BARRIER:
+		case BLKIF_OP_FLUSH_DISKCACHE:
+			if (dispatch_rw_block_io(blkif, &req, pending_req))
+				goto done;
+			break;
+		case BLKIF_OP_DISCARD:
 			free_req(pending_req);
 			if (dispatch_discard_io(blkif, &req))
-				break;
-		} else if (dispatch_rw_block_io(blkif, &req, pending_req))
+				goto done;
 			break;
+		default:
+			if (dispatch_other_io(blkif, &req, pending_req))
+				goto done;
+			break;
+		}
 
 		/* Yield point for this unbounded loop. */
 		cond_resched();
 	}
-
+done:
 	return more_to_do;
 }
 
@@ -720,13 +743,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		bio->bi_end_io  = end_block_io_op;
 	}
 
-	/*
-	 * We set it one so that the last submit_bio does not have to call
-	 * atomic_inc.
-	 */
 	atomic_set(&pending_req->pendcnt, nbio);
-
-	/* Get a reference count for the disk queue and start sending I/O */
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
@@ -754,6 +771,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
  fail_put_bio:
 	for (i = 0; i < nbio; i++)
 		bio_put(biolist[i]);
+	atomic_set(&pending_req->pendcnt, 1);
 	__end_block_io_op(pending_req, -EINVAL);
 	msleep(1); /* back off a bit */
 	return -EIO;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9ad3b5e..fc2a486 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -76,11 +76,18 @@ struct blkif_x86_32_request_discard {
 	uint64_t       nr_sectors;
 } __attribute__((__packed__));
 
+struct blkif_x86_32_request_other {
+	uint8_t        _pad1;
+	blkif_vdev_t   _pad2;
+	uint64_t       id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_x86_32_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_32_request_rw rw;
 		struct blkif_x86_32_request_discard discard;
+		struct blkif_x86_32_request_other other;
 	} u;
 } __attribute__((__packed__));
 
@@ -112,11 +119,19 @@ struct blkif_x86_64_request_discard {
 	uint64_t       nr_sectors;
 } __attribute__((__packed__));
 
+struct blkif_x86_64_request_other {
+	uint8_t        _pad1;
+	blkif_vdev_t   _pad2;
+	uint32_t       _pad3;        /* offsetof(blkif_..,u.discard.id)==8   */
+	uint64_t       id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_x86_64_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_64_request_rw rw;
 		struct blkif_x86_64_request_discard discard;
+		struct blkif_x86_64_request_other other;
 	} u;
 } __attribute__((__packed__));
 
@@ -262,6 +277,11 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
 	default:
+		/*
+		 * Don't know how to translate this op. Only get the
+		 * ID so failure can be reported to the frontend.
+		 */
+		dst->u.other.id = src->u.other.id;
 		break;
 	}
 }
@@ -293,6 +313,11 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
 	default:
+		/*
+		 * Don't know how to translate this op. Only get the
+		 * ID so failure can be reported to the frontend.
+		 */
+		dst->u.other.id = src->u.other.id;
 		break;
 	}
 }
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index fc2de55..b0395b0 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -72,8 +72,10 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x03F0, 0x311D) },
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0CF3, 0x0036) },
 	{ USB_DEVICE(0x0CF3, 0x3004) },
 	{ USB_DEVICE(0x0CF3, 0x311D) },
+	{ USB_DEVICE(0x0CF3, 0x817a) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
@@ -99,8 +101,10 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
 static struct usb_device_id ath3k_blist_tbl[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0CF3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0CF3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 654e248..30ac56b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -128,8 +128,10 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros 3012 with sflash firmware */
+	{ USB_DEVICE(0x0cf3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..d2f7eb0 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -131,7 +131,8 @@ struct ports_device {
 	spinlock_t ports_lock;
 
 	/* To protect the vq operations for the control channel */
-	spinlock_t cvq_lock;
+	spinlock_t c_ivq_lock;
+	spinlock_t c_ovq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -457,11 +458,14 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
+
+	spin_lock(&portdev->c_ovq_lock);
 	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) >= 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
 	}
+	spin_unlock(&portdev->c_ovq_lock);
 	return 0;
 }
 
@@ -1465,23 +1469,23 @@ static void control_work_handler(struct work_struct *work)
 	portdev = container_of(work, struct ports_device, control_work);
 	vq = portdev->c_ivq;
 
-	spin_lock(&portdev->cvq_lock);
+	spin_lock(&portdev->c_ivq_lock);
 	while ((buf = virtqueue_get_buf(vq, &len))) {
-		spin_unlock(&portdev->cvq_lock);
+		spin_unlock(&portdev->c_ivq_lock);
 
 		buf->len = len;
 		buf->offset = 0;
 
 		handle_control_message(portdev, buf);
 
-		spin_lock(&portdev->cvq_lock);
+		spin_lock(&portdev->c_ivq_lock);
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
 			dev_warn(&portdev->vdev->dev,
 				 "Error adding buffer to queue\n");
 			free_buf(buf);
 		}
 	}
-	spin_unlock(&portdev->cvq_lock);
+	spin_unlock(&portdev->c_ivq_lock);
 }
 
 static void out_intr(struct virtqueue *vq)
@@ -1742,10 +1746,12 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 	if (multiport) {
 		unsigned int nr_added_bufs;
 
-		spin_lock_init(&portdev->cvq_lock);
+		spin_lock_init(&portdev->c_ivq_lock);
+		spin_lock_init(&portdev->c_ovq_lock);
 		INIT_WORK(&portdev->control_work, &control_work_handler);
 
-		nr_added_bufs = fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+		nr_added_bufs = fill_queue(portdev->c_ivq,
+					   &portdev->c_ivq_lock);
 		if (!nr_added_bufs) {
 			dev_err(&vdev->dev,
 				"Error allocating buffers for control queue\n");
@@ -1885,7 +1891,7 @@ static int virtcons_restore(struct virtio_device *vdev)
 		return ret;
 
 	if (use_multiport(portdev))
-		fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+		fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
 
 	list_for_each_entry(port, &portdev->ports, list) {
 		port->in_vq = portdev->in_vqs[port->id];
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b7ee230..24763fa 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -879,7 +879,7 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 	unsigned vblank = (pt->vactive_vblank_hi & 0xf) << 8 | pt->vblank_lo;
 	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) << 2 | pt->hsync_offset_lo;
 	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) << 4 | pt->hsync_pulse_width_lo;
-	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) << 2 | pt->vsync_offset_pulse_width_lo >> 4;
 	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 4 | (pt->vsync_offset_pulse_width_lo & 0xf);
 
 	/* ignore tiny modes */
@@ -960,6 +960,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 359f6e8..956e9b7 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -121,7 +121,7 @@ static const char *cache_level_str(int type)
 static void
 describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 {
-	seq_printf(m, "%p: %s%s %8zdKiB %04x %04x %d %d%s%s%s",
+	seq_printf(m, "%pK: %s%s %8zdKiB %04x %04x %d %d%s%s%s",
 		   &obj->base,
 		   get_pin_flag(obj),
 		   get_tiling_flag(obj),
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index cdf46b5..c26a8f8 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -910,15 +910,20 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		   int count)
 {
 	int i;
+	int relocs_total = 0;
+	int relocs_max = INT_MAX / sizeof(struct drm_i915_gem_relocation_entry);
 
 	for (i = 0; i < count; i++) {
 		char __user *ptr = (char __user *)(uintptr_t)exec[i].relocs_ptr;
 		int length; /* limited by fault_in_pages_readable() */
 
-		/* First check for malicious input causing overflow */
-		if (exec[i].relocation_count >
-		    INT_MAX / sizeof(struct drm_i915_gem_relocation_entry))
+		/* First check for malicious input causing overflow in
+		 * the worst case where we need to allocate the entire
+		 * relocation tree as a single array.
+		 */
+		if (exec[i].relocation_count > relocs_max - relocs_total)
 			return -EINVAL;
+		relocs_total += exec[i].relocation_count;
 
 		length = exec[i].relocation_count *
 			sizeof(struct drm_i915_gem_relocation_entry);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0777c79..379abcb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6459,8 +6459,8 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_framebuffer *intel_fb;
-	struct drm_i915_gem_object *obj;
+	struct drm_framebuffer *old_fb = crtc->fb;
+	struct drm_i915_gem_object *obj = to_intel_framebuffer(fb)->obj;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct intel_unpin_work *work;
 	unsigned long flags;
@@ -6485,8 +6485,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 
 	work->event = event;
 	work->dev = crtc->dev;
-	intel_fb = to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj = intel_fb->obj;
+	work->old_fb_obj = to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
 
 	ret = drm_vblank_get(dev, intel_crtc->pipe);
@@ -6506,9 +6505,6 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	intel_crtc->unpin_work = work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
-	intel_fb = to_intel_framebuffer(fb);
-	obj = intel_fb->obj;
-
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		goto cleanup;
@@ -6542,6 +6538,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb = old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index ace757a..2e2bf3d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -800,6 +800,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	int lane_count = 4;
 	struct intel_dp_m_n m_n;
 	int pipe = intel_crtc->pipe;
+	int target_clock;
 
 	/*
 	 * Find the lane count in the intel_encoder private
@@ -815,13 +816,22 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 		}
 	}
 
+	target_clock = mode->clock;
+	for_each_encoder_on_crtc(dev, crtc, encoder) {
+		if (encoder->type == INTEL_OUTPUT_EDP) {
+			target_clock = intel_edp_target_clock(encoder,
+							      mode);
+			break;
+		}
+	}
+
 	/*
 	 * Compute the GMCH and Link ratios. The '3' here is
 	 * the number of bytes_per_pixel post-LUT, which we always
 	 * set up for 8-bits of R/G/B, or 3 bytes total.
 	 */
 	intel_dp_compute_m_n(intel_crtc->bpp, lane_count,
-			     mode->clock, adjusted_mode->clock, &m_n);
+			     target_clock, adjusted_mode->clock, &m_n);
 
 	if (HAS_PCH_SPLIT(dev)) {
 		I915_WRITE(TRANSDATA_M1(pipe),
@@ -1771,7 +1781,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		for (i = 0; i < intel_dp->lane_count; i++)
 			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) == 0)
 				break;
-		if (i == intel_dp->lane_count && voltage_tries == 5) {
+		if (i == intel_dp->lane_count) {
 			++loop_tries;
 			if (loop_tries == 5) {
 				DRM_DEBUG_KMS("too many full retries, give up\n");
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index b69642d..0a5daaa 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -383,19 +383,19 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 	m = n = p = 0;
 	vcomax = 800000;
 	vcomin = 400000;
-	pllreffreq = 3333;
+	pllreffreq = 33333;
 
 	delta = 0xffffffff;
 	permitteddelta = clock * 5 / 1000;
 
-	for (testp = 16; testp > 0; testp--) {
+	for (testp = 16; testp > 0; testp >>= 1) {
 		if (clock * testp > vcomax)
 			continue;
 		if (clock * testp < vcomin)
 			continue;
 
 		for (testm = 1; testm < 33; testm++) {
-			for (testn = 1; testn < 257; testn++) {
+			for (testn = 17; testn < 257; testn++) {
 				computed = (pllreffreq * testn) /
 					(testm * testp);
 				if (computed > clock)
@@ -405,11 +405,11 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 				if (tmpdelta < delta) {
 					delta = tmpdelta;
 					n = testn - 1;
-					m = (testm - 1) | ((n >> 1) & 0x80);
+					m = (testm - 1);
 					p = testp - 1;
 				}
 				if ((clock * testp) >= 600000)
-					p |= 80;
+					p |= 0x80;
 			}
 		}
 	}
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 853800e..eecf30f 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -466,13 +466,19 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x9907) ||
 		    (rdev->pdev->device == 0x9908) ||
 		    (rdev->pdev->device == 0x9909) ||
+		    (rdev->pdev->device == 0x990B) ||
+		    (rdev->pdev->device == 0x990C) ||
+		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
-		    (rdev->pdev->device == 0x9917)) {
+		    (rdev->pdev->device == 0x9917) ||
+		    (rdev->pdev->device == 0x9999)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
 			   (rdev->pdev->device == 0x9904) ||
 			   (rdev->pdev->device == 0x990A) ||
+			   (rdev->pdev->device == 0x990D) ||
+			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
 			   (rdev->pdev->device == 0x9918)) {
 			rdev->config.cayman.max_simds_per_se = 4;
@@ -481,6 +487,9 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x9990) ||
 			   (rdev->pdev->device == 0x9991) ||
 			   (rdev->pdev->device == 0x9994) ||
+			   (rdev->pdev->device == 0x9995) ||
+			   (rdev->pdev->device == 0x9996) ||
+			   (rdev->pdev->device == 0x999A) ||
 			   (rdev->pdev->device == 0x99A0)) {
 			rdev->config.cayman.max_simds_per_se = 3;
 			rdev->config.cayman.max_backends_per_se = 1;
diff --git a/drivers/gpu/drm/radeon/radeon_benchmark.c b/drivers/gpu/drm/radeon/radeon_benchmark.c
index bedda9c..a2f0c24 100644
--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -135,13 +135,15 @@ static void radeon_benchmark_move(struct radeon_device *rdev, unsigned size,
 						     sdomain, ddomain, "dma");
 	}
 
-	time = radeon_benchmark_do_move(rdev, size, saddr, daddr,
-					RADEON_BENCHMARK_COPY_BLIT, n);
-	if (time < 0)
-		goto out_cleanup;
-	if (time > 0)
-		radeon_benchmark_log_results(n, size, time,
-					     sdomain, ddomain, "blit");
+	if (rdev->asic->copy.blit) {
+		time = radeon_benchmark_do_move(rdev, size, saddr, daddr,
+						RADEON_BENCHMARK_COPY_BLIT, n);
+		if (time < 0)
+			goto out_cleanup;
+		if (time > 0)
+			radeon_benchmark_log_results(n, size, time,
+						     sdomain, ddomain, "blit");
+	}
 
 out_cleanup:
 	if (sobj) {
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ab8ce9f..b4fc436 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -566,6 +566,9 @@
 #define USB_VENDOR_ID_MONTEREY		0x0566
 #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
 
+#define USB_VENDOR_ID_MSI		0x1770
+#define USB_DEVICE_ID_MSI_GX680R_LED_PANEL	0xff00
+
 #define USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR 0x0400
 #define USB_DEVICE_ID_N_S_HARMONY	0xc359
 
@@ -657,6 +660,9 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
 #define USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN	0x3001
 
+#define USB_VENDOR_ID_REALTEK		0x0bda
+#define USB_DEVICE_ID_REALTEK_READER	0x0152
+
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8865fa3..833d417 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -72,12 +72,14 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 24683fd..2ad27ce 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -755,9 +755,13 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
-			if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
-				ipoib_warn(priv, "request notify on send CQ failed\n");
 			netif_stop_queue(dev);
+			rc = ib_req_notify_cq(priv->send_cq,
+				IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+			if (rc < 0)
+				ipoib_warn(priv, "request notify on send CQ failed\n");
+			else if (rc)
+				ipoib_send_comp_handler(priv->send_cq, dev);
 		}
 	}
 }
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e89daf1..c698cf6 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2337,18 +2337,16 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
-
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-		dev_data = get_dev_data(dev);
+		if (!dma_domain) {
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
+
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
 		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cc06a1e..c0fc827 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1029,6 +1029,8 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 {
 	struct blk_plug plug;
 
+	BUG_ON(dm_bufio_in_request());
+
 	blk_start_plug(&plug);
 	dm_bufio_lock(c);
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 892ae27..dd5ba3b 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -95,6 +95,13 @@ struct dm_verity_io {
 	 */
 };
 
+struct dm_verity_prefetch_work {
+	struct work_struct work;
+	struct dm_verity *v;
+	sector_t block;
+	unsigned n_blocks;
+};
+
 static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
 {
 	return (struct shash_desc *)(io + 1);
@@ -428,15 +435,18 @@ static void verity_end_io(struct bio *bio, int error)
  * The root buffer is not prefetched, it is assumed that it will be cached
  * all the time.
  */
-static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
+static void verity_prefetch_io(struct work_struct *work)
 {
+	struct dm_verity_prefetch_work *pw =
+		container_of(work, struct dm_verity_prefetch_work, work);
+	struct dm_verity *v = pw->v;
 	int i;
 
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
 		sector_t hash_block_end;
-		verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
-		verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
+		verity_hash_at_level(v, pw->block, i, &hash_block_start, NULL);
+		verity_hash_at_level(v, pw->block + pw->n_blocks - 1, i, &hash_block_end, NULL);
 		if (!i) {
 			unsigned cluster = *(volatile unsigned *)&dm_verity_prefetch_cluster;
 
@@ -456,6 +466,25 @@ no_prefetch_cluster:
 		dm_bufio_prefetch(v->bufio, hash_block_start,
 				  hash_block_end - hash_block_start + 1);
 	}
+
+	kfree(pw);
+}
+
+static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
+{
+	struct dm_verity_prefetch_work *pw;
+
+	pw = kmalloc(sizeof(struct dm_verity_prefetch_work),
+		GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+
+	if (!pw)
+		return;
+
+	INIT_WORK(&pw->work, verity_prefetch_io);
+	pw->v = v;
+	pw->block = io->block;
+	pw->n_blocks = io->n_blocks;
+	queue_work(v->verify_wq, &pw->work);
 }
 
 /*
@@ -504,7 +533,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 	memcpy(io->io_vec, bio_iovec(bio),
 	       io->io_vec_size * sizeof(struct bio_vec));
 
-	verity_prefetch_io(v, io);
+	verity_submit_prefetch(v, io);
 
 	generic_make_request(bio);
 
@@ -875,7 +904,7 @@ bad:
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.version	= {1, 0, 0},
+	.version	= {1, 2, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index acc0718..83ae683 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1733,6 +1733,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 
 	bond_compute_features(bond);
 
+	bond_update_speed_duplex(new_slave);
+
 	read_lock(&bond->lock);
 
 	new_slave->last_arp_rx = jiffies -
@@ -1785,8 +1787,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		new_slave->link == BOND_LINK_DOWN ? "DOWN" :
 			(new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
-	bond_update_speed_duplex(new_slave);
-
 	if (USES_PRIMARY(bond->params.mode) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
 		if (strcmp(bond->params.primary, new_slave->dev->name) == 0) {
@@ -1961,12 +1961,11 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 		return -EINVAL;
 	}
 
+	write_unlock_bh(&bond->lock);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
 	netdev_rx_handler_unregister(slave_dev);
-	write_unlock_bh(&bond->lock);
-	synchronize_net();
 	write_lock_bh(&bond->lock);
 
 	if (!bond->params.fail_over_mac) {
@@ -2467,8 +2466,6 @@ static void bond_miimon_commit(struct bonding *bond)
 				bond_set_backup_slave(slave);
 			}
 
-			bond_update_speed_duplex(slave);
-
 			pr_info("%s: link status definitely up for interface %s, %u Mbps %s duplex.\n",
 				bond->dev->name, slave->dev->name,
 				slave->speed, slave->duplex ? "full" : "half");
@@ -3413,6 +3410,28 @@ static int bond_xmit_hash_policy_l2(struct sk_buff *skb, int count)
 
 /*-------------------------- Device entry points ----------------------------*/
 
+static void bond_work_init_all(struct bonding *bond)
+{
+	INIT_DELAYED_WORK(&bond->mcast_work,
+			  bond_resend_igmp_join_requests_delayed);
+	INIT_DELAYED_WORK(&bond->alb_work, bond_alb_monitor);
+	INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
+	if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
+		INIT_DELAYED_WORK(&bond->arp_work, bond_activebackup_arp_mon);
+	else
+		INIT_DELAYED_WORK(&bond->arp_work, bond_loadbalance_arp_mon);
+	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
+}
+
+static void bond_work_cancel_all(struct bonding *bond)
+{
+	cancel_delayed_work_sync(&bond->mii_work);
+	cancel_delayed_work_sync(&bond->arp_work);
+	cancel_delayed_work_sync(&bond->alb_work);
+	cancel_delayed_work_sync(&bond->ad_work);
+	cancel_delayed_work_sync(&bond->mcast_work);
+}
+
 static int bond_open(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
@@ -3435,41 +3454,27 @@ static int bond_open(struct net_device *bond_dev)
 	}
 	read_unlock(&bond->lock);
 
-	INIT_DELAYED_WORK(&bond->mcast_work, bond_resend_igmp_join_requests_delayed);
+	bond_work_init_all(bond);
 
 	if (bond_is_lb(bond)) {
 		/* bond_alb_initialize must be called before the timer
 		 * is started.
 		 */
-		if (bond_alb_initialize(bond, (bond->params.mode == BOND_MODE_ALB))) {
-			/* something went wrong - fail the open operation */
+		if (bond_alb_initialize(bond, (bond->params.mode == BOND_MODE_ALB)))
 			return -ENOMEM;
-		}
-
-		INIT_DELAYED_WORK(&bond->alb_work, bond_alb_monitor);
 		queue_delayed_work(bond->wq, &bond->alb_work, 0);
 	}
 
-	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
-		INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
+	if (bond->params.miimon)  /* link check interval, in milliseconds. */
 		queue_delayed_work(bond->wq, &bond->mii_work, 0);
-	}
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
-		if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
-			INIT_DELAYED_WORK(&bond->arp_work,
-					  bond_activebackup_arp_mon);
-		else
-			INIT_DELAYED_WORK(&bond->arp_work,
-					  bond_loadbalance_arp_mon);
-
 		queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		if (bond->params.arp_validate)
 			bond->recv_probe = bond_arp_rcv;
 	}
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
-		INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
 		queue_delayed_work(bond->wq, &bond->ad_work, 0);
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
@@ -3484,34 +3489,10 @@ static int bond_close(struct net_device *bond_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 
 	write_lock_bh(&bond->lock);
-
 	bond->send_peer_notif = 0;
-
 	write_unlock_bh(&bond->lock);
 
-	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
-		cancel_delayed_work_sync(&bond->mii_work);
-	}
-
-	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
-		cancel_delayed_work_sync(&bond->arp_work);
-	}
-
-	switch (bond->params.mode) {
-	case BOND_MODE_8023AD:
-		cancel_delayed_work_sync(&bond->ad_work);
-		break;
-	case BOND_MODE_TLB:
-	case BOND_MODE_ALB:
-		cancel_delayed_work_sync(&bond->alb_work);
-		break;
-	default:
-		break;
-	}
-
-	if (delayed_work_pending(&bond->mcast_work))
-		cancel_delayed_work_sync(&bond->mcast_work);
-
+	bond_work_cancel_all(bond);
 	if (bond_is_lb(bond)) {
 		/* Must be called only after all
 		 * slaves have been released
@@ -4390,26 +4371,6 @@ static void bond_setup(struct net_device *bond_dev)
 	bond_dev->features |= bond_dev->hw_features;
 }
 
-static void bond_work_cancel_all(struct bonding *bond)
-{
-	if (bond->params.miimon && delayed_work_pending(&bond->mii_work))
-		cancel_delayed_work_sync(&bond->mii_work);
-
-	if (bond->params.arp_interval && delayed_work_pending(&bond->arp_work))
-		cancel_delayed_work_sync(&bond->arp_work);
-
-	if (bond->params.mode == BOND_MODE_ALB &&
-	    delayed_work_pending(&bond->alb_work))
-		cancel_delayed_work_sync(&bond->alb_work);
-
-	if (bond->params.mode == BOND_MODE_8023AD &&
-	    delayed_work_pending(&bond->ad_work))
-		cancel_delayed_work_sync(&bond->ad_work);
-
-	if (delayed_work_pending(&bond->mcast_work))
-		cancel_delayed_work_sync(&bond->mcast_work);
-}
-
 /*
 * Destroy a bonding device.
 * Must be under rtnl_lock when this function is called.
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 21609f9..53eeac2 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -183,6 +183,11 @@ int bond_create_slave_symlinks(struct net_device *master,
 	sprintf(linkname, "slave_%s", slave->name);
 	ret = sysfs_create_link(&(master->dev.kobj), &(slave->dev.kobj),
 				linkname);
+
+	/* free the master link created earlier in case of error */
+	if (ret)
+		sysfs_remove_link(&(slave->dev.kobj), "master");
+
 	return ret;
 
 }
@@ -513,6 +518,8 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (sscanf(buf, "%d", &new_value) != 1) {
 		pr_err("%s: no arp_interval value specified.\n",
 		       bond->dev->name);
@@ -520,7 +527,7 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		goto out;
 	}
 	if (new_value < 0) {
-		pr_err("%s: Invalid arp_interval value %d not in range 1-%d; rejected.\n",
+		pr_err("%s: Invalid arp_interval value %d not in range 0-%d; rejected.\n",
 		       bond->dev->name, new_value, INT_MAX);
 		ret = -EINVAL;
 		goto out;
@@ -535,18 +542,15 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 	pr_info("%s: Setting ARP monitoring interval to %d.\n",
 		bond->dev->name, new_value);
 	bond->params.arp_interval = new_value;
-	if (bond->params.miimon) {
-		pr_info("%s: ARP monitoring cannot be used with MII monitoring. %s Disabling MII monitoring.\n",
-			bond->dev->name, bond->dev->name);
-		bond->params.miimon = 0;
-		if (delayed_work_pending(&bond->mii_work)) {
-			cancel_delayed_work(&bond->mii_work);
-			flush_workqueue(bond->wq);
+	if (new_value) {
+		if (bond->params.miimon) {
+			pr_info("%s: ARP monitoring cannot be used with MII monitoring. %s Disabling MII monitoring.\n",
+				bond->dev->name, bond->dev->name);
+			bond->params.miimon = 0;
 		}
-	}
-	if (!bond->params.arp_targets[0]) {
-		pr_info("%s: ARP monitoring has been set up, but no ARP targets have been specified.\n",
-			bond->dev->name);
+		if (!bond->params.arp_targets[0])
+			pr_info("%s: ARP monitoring has been set up, but no ARP targets have been specified.\n",
+				bond->dev->name);
 	}
 	if (bond->dev->flags & IFF_UP) {
 		/* If the interface is up, we may need to fire off
@@ -554,19 +558,15 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		 * timer will get fired off when the open function
 		 * is called.
 		 */
-		if (!delayed_work_pending(&bond->arp_work)) {
-			if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
-				INIT_DELAYED_WORK(&bond->arp_work,
-						  bond_activebackup_arp_mon);
-			else
-				INIT_DELAYED_WORK(&bond->arp_work,
-						  bond_loadbalance_arp_mon);
-
+		if (!new_value) {
+			cancel_delayed_work_sync(&bond->arp_work);
+		} else {
+			cancel_delayed_work_sync(&bond->mii_work);
 			queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		}
 	}
-
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(arp_interval, S_IRUGO | S_IWUSR,
@@ -706,7 +706,7 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	}
 	if (new_value < 0) {
 		pr_err("%s: Invalid down delay value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
 	} else {
@@ -761,8 +761,8 @@ static ssize_t bonding_store_updelay(struct device *d,
 		goto out;
 	}
 	if (new_value < 0) {
-		pr_err("%s: Invalid down delay value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		pr_err("%s: Invalid up delay value %d not in range %d-%d; rejected.\n",
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
 	} else {
@@ -962,6 +962,8 @@ static ssize_t bonding_store_miimon(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (sscanf(buf, "%d", &new_value) != 1) {
 		pr_err("%s: no miimon value specified.\n",
 		       bond->dev->name);
@@ -970,50 +972,43 @@ static ssize_t bonding_store_miimon(struct device *d,
 	}
 	if (new_value < 0) {
 		pr_err("%s: Invalid miimon value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
-	} else {
-		pr_info("%s: Setting MII monitoring interval to %d.\n",
-			bond->dev->name, new_value);
-		bond->params.miimon = new_value;
-		if (bond->params.updelay)
-			pr_info("%s: Note: Updating updelay (to %d) since it is a multiple of the miimon value.\n",
-				bond->dev->name,
-				bond->params.updelay * bond->params.miimon);
-		if (bond->params.downdelay)
-			pr_info("%s: Note: Updating downdelay (to %d) since it is a multiple of the miimon value.\n",
-				bond->dev->name,
-				bond->params.downdelay * bond->params.miimon);
-		if (bond->params.arp_interval) {
-			pr_info("%s: MII monitoring cannot be used with ARP monitoring. Disabling ARP monitoring...\n",
-				bond->dev->name);
-			bond->params.arp_interval = 0;
-			if (bond->params.arp_validate) {
-				bond->params.arp_validate =
-					BOND_ARP_VALIDATE_NONE;
-			}
-			if (delayed_work_pending(&bond->arp_work)) {
-				cancel_delayed_work(&bond->arp_work);
-				flush_workqueue(bond->wq);
-			}
-		}
-
-		if (bond->dev->flags & IFF_UP) {
-			/* If the interface is up, we may need to fire off
-			 * the MII timer. If the interface is down, the
-			 * timer will get fired off when the open function
-			 * is called.
-			 */
-			if (!delayed_work_pending(&bond->mii_work)) {
-				INIT_DELAYED_WORK(&bond->mii_work,
-						  bond_mii_monitor);
-				queue_delayed_work(bond->wq,
-						   &bond->mii_work, 0);
-			}
+	}
+	pr_info("%s: Setting MII monitoring interval to %d.\n",
+		bond->dev->name, new_value);
+	bond->params.miimon = new_value;
+	if (bond->params.updelay)
+		pr_info("%s: Note: Updating updelay (to %d) since it is a multiple of the miimon value.\n",
+			bond->dev->name,
+			bond->params.updelay * bond->params.miimon);
+	if (bond->params.downdelay)
+		pr_info("%s: Note: Updating downdelay (to %d) since it is a multiple of the miimon value.\n",
+			bond->dev->name,
+			bond->params.downdelay * bond->params.miimon);
+	if (new_value && bond->params.arp_interval) {
+		pr_info("%s: MII monitoring cannot be used with ARP monitoring. Disabling ARP monitoring...\n",
+			bond->dev->name);
+		bond->params.arp_interval = 0;
+		if (bond->params.arp_validate)
+			bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
+	}
+	if (bond->dev->flags & IFF_UP) {
+		/* If the interface is up, we may need to fire off
+		 * the MII timer. If the interface is down, the
+		 * timer will get fired off when the open function
+		 * is called.
+		 */
+		if (!new_value) {
+			cancel_delayed_work_sync(&bond->mii_work);
+		} else {
+			cancel_delayed_work_sync(&bond->arp_work);
+			queue_delayed_work(bond->wq, &bond->mii_work, 0);
 		}
 	}
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(miimon, S_IRUGO | S_IWUSR,
diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/plx_pci.c
index 8bc9598..8099275 100644
--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -329,7 +329,7 @@ static inline int plx_pci_check_sja1000(const struct sja1000_priv *priv)
 	 */
 	if ((priv->read_reg(priv, REG_CR) & REG_CR_BASICCAN_INITIAL_MASK) ==
 	    REG_CR_BASICCAN_INITIAL &&
-	    (priv->read_reg(priv, REG_SR) == REG_SR_BASICCAN_INITIAL) &&
+	    (priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_BASICCAN_INITIAL) &&
 	    (priv->read_reg(priv, REG_IR) == REG_IR_BASICCAN_INITIAL))
 		flag = 1;
 
@@ -341,7 +341,7 @@ static inline int plx_pci_check_sja1000(const struct sja1000_priv *priv)
 	 * See states on p. 23 of the Datasheet.
 	 */
 	if (priv->read_reg(priv, REG_MOD) == REG_MOD_PELICAN_INITIAL &&
-	    priv->read_reg(priv, REG_SR) == REG_SR_PELICAN_INITIAL &&
+	    priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_PELICAN_INITIAL &&
 	    priv->read_reg(priv, REG_IR) == REG_IR_PELICAN_INITIAL)
 		return flag;
 
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 4c4f33d..f0e1789 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -91,7 +91,7 @@ static void sja1000_write_cmdreg(struct sja1000_priv *priv, u8 val)
 	 */
 	spin_lock_irqsave(&priv->cmdreg_lock, flags);
 	priv->write_reg(priv, REG_CMR, val);
-	priv->read_reg(priv, REG_SR);
+	priv->read_reg(priv, SJA1000_REG_SR);
 	spin_unlock_irqrestore(&priv->cmdreg_lock, flags);
 }
 
@@ -496,7 +496,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
 		n++;
-		status = priv->read_reg(priv, REG_SR);
+		status = priv->read_reg(priv, SJA1000_REG_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
 			return IRQ_NONE;
@@ -515,7 +515,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 			/* receive interrupt */
 			while (status & SR_RBS) {
 				sja1000_rx(dev);
-				status = priv->read_reg(priv, REG_SR);
+				status = priv->read_reg(priv, SJA1000_REG_SR);
 				/* check for absent controller */
 				if (status == 0xFF && sja1000_is_absent(priv))
 					return IRQ_NONE;
diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
index 23fff06..2a79543 100644
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -56,7 +56,7 @@
 /* SJA1000 registers - manual section 6.4 (Pelican Mode) */
 #define REG_MOD		0x00
 #define REG_CMR		0x01
-#define REG_SR		0x02
+#define SJA1000_REG_SR		0x02
 #define REG_IR		0x03
 #define REG_IER		0x04
 #define REG_ALC		0x0B
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index 829b5ad..edfdf6b 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -438,7 +438,6 @@ struct atl1e_adapter {
 	struct atl1e_hw        hw;
 	struct atl1e_hw_stats  hw_stats;
 
-	bool have_msi;
 	u32 wol;
 	u16 link_speed;
 	u16 link_duplex;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index a98acc8..b986503 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1851,34 +1851,19 @@ static void atl1e_free_irq(struct atl1e_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 
 	free_irq(adapter->pdev->irq, netdev);
-
-	if (adapter->have_msi)
-		pci_disable_msi(adapter->pdev);
 }
 
 static int atl1e_request_irq(struct atl1e_adapter *adapter)
 {
 	struct pci_dev    *pdev   = adapter->pdev;
 	struct net_device *netdev = adapter->netdev;
-	int flags = 0;
 	int err = 0;
 
-	adapter->have_msi = true;
-	err = pci_enable_msi(pdev);
-	if (err) {
-		netdev_dbg(netdev,
-			   "Unable to allocate MSI interrupt Error: %d\n", err);
-		adapter->have_msi = false;
-	}
-
-	if (!adapter->have_msi)
-		flags |= IRQF_SHARED;
-	err = request_irq(pdev->irq, atl1e_intr, flags, netdev->name, netdev);
+	err = request_irq(pdev->irq, atl1e_intr, IRQF_SHARED, netdev->name,
+			  netdev);
 	if (err) {
 		netdev_dbg(adapter->netdev,
 			   "Unable to allocate interrupt Error: %d\n", err);
-		if (adapter->have_msi)
-			pci_disable_msi(pdev);
 		return err;
 	}
 	netdev_dbg(netdev, "atl1e_request_irq OK\n");
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e8e97a7..cb18cf4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2323,6 +2323,7 @@ load_error2:
 	bp->port.pmf = 0;
 load_error1:
 	bnx2x_napi_disable(bp);
+	bnx2x_del_all_napi(bp);
 	/* clear pf_load status, as it was already set */
 	bnx2x_clear_pf_load(bp);
 load_error0:
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index 24b8e50..06bd1c0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -453,8 +453,9 @@ struct bnx2x_fw_port_stats_old {
 
 #define UPDATE_QSTAT(s, t) \
 	do { \
-		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi); \
 		qstats->t##_lo = qstats_old->t##_lo + le32_to_cpu(s.lo); \
+		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi) \
+			+ ((qstats->t##_lo < qstats_old->t##_lo) ? 1 : 0); \
 	} while (0)
 
 #define UPDATE_QSTAT_OLD(f) \
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3756278..440e963 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -4055,6 +4055,14 @@ static void tg3_phy_copper_begin(struct tg3 *tp)
 		tp->link_config.active_speed = tp->link_config.speed;
 		tp->link_config.active_duplex = tp->link_config.duplex;
 
+		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5714) {
+			/* With autoneg disabled, 5715 only links up when the
+			 * advertisement register has the configured speed
+			 * enabled.
+			 */
+			tg3_writephy(tp, MII_ADVERTISE, ADVERTISE_ALL);
+		}
+
 		bmcr = 0;
 		switch (tp->link_config.speed) {
 		default:
@@ -13859,8 +13867,11 @@ static void __devinit tg3_read_vpd(struct tg3 *tp)
 		if (j + len > block_end)
 			goto partno;
 
-		memcpy(tp->fw_ver, &vpd_data[j], len);
-		strncat(tp->fw_ver, " bc ", vpdlen - len - 1);
+		if (len >= sizeof(tp->fw_ver))
+			len = sizeof(tp->fw_ver) - 1;
+		memset(tp->fw_ver, 0, sizeof(tp->fw_ver));
+		snprintf(tp->fw_ver, sizeof(tp->fw_ver), "%.*s bc ", len,
+			 &vpd_data[j]);
 	}
 
 partno:
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 36499d5..a9628b6 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -257,6 +257,107 @@ static void dm9000_dumpblk_32bit(void __iomem *reg, int count)
 		tmp = readl(reg);
 }
 
+/*
+ * Sleep, either by using msleep() or if we are suspending, then
+ * use mdelay() to sleep.
+ */
+static void dm9000_msleep(board_info_t *db, unsigned int ms)
+{
+	if (db->in_suspend)
+		mdelay(ms);
+	else
+		msleep(ms);
+}
+
+/* Read a word from phyxcer */
+static int
+dm9000_phy_read(struct net_device *dev, int phy_reg_unused, int reg)
+{
+	board_info_t *db = netdev_priv(dev);
+	unsigned long flags;
+	unsigned int reg_save;
+	int ret;
+
+	mutex_lock(&db->addr_lock);
+
+	spin_lock_irqsave(&db->lock, flags);
+
+	/* Save previous register address */
+	reg_save = readb(db->io_addr);
+
+	/* Fill the phyxcer register into REG_0C */
+	iow(db, DM9000_EPAR, DM9000_PHY | reg);
+
+	/* Issue phyxcer read command */
+	iow(db, DM9000_EPCR, EPCR_ERPRR | EPCR_EPOS);
+
+	writeb(reg_save, db->io_addr);
+	spin_unlock_irqrestore(&db->lock, flags);
+
+	dm9000_msleep(db, 1);		/* Wait read complete */
+
+	spin_lock_irqsave(&db->lock, flags);
+	reg_save = readb(db->io_addr);
+
+	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer read command */
+
+	/* The read data keeps on REG_0D & REG_0E */
+	ret = (ior(db, DM9000_EPDRH) << 8) | ior(db, DM9000_EPDRL);
+
+	/* restore the previous address */
+	writeb(reg_save, db->io_addr);
+	spin_unlock_irqrestore(&db->lock, flags);
+
+	mutex_unlock(&db->addr_lock);
+
+	dm9000_dbg(db, 5, "phy_read[%02x] -> %04x\n", reg, ret);
+	return ret;
+}
+
+/* Write a word to phyxcer */
+static void
+dm9000_phy_write(struct net_device *dev,
+		 int phyaddr_unused, int reg, int value)
+{
+	board_info_t *db = netdev_priv(dev);
+	unsigned long flags;
+	unsigned long reg_save;
+
+	dm9000_dbg(db, 5, "phy_write[%02x] = %04x\n", reg, value);
+	mutex_lock(&db->addr_lock);
+
+	spin_lock_irqsave(&db->lock, flags);
+
+	/* Save previous register address */
+	reg_save = readb(db->io_addr);
+
+	/* Fill the phyxcer register into REG_0C */
+	iow(db, DM9000_EPAR, DM9000_PHY | reg);
+
+	/* Fill the written data into REG_0D & REG_0E */
+	iow(db, DM9000_EPDRL, value);
+	iow(db, DM9000_EPDRH, value >> 8);
+
+	/* Issue phyxcer write command */
+	iow(db, DM9000_EPCR, EPCR_EPOS | EPCR_ERPRW);
+
+	writeb(reg_save, db->io_addr);
+	spin_unlock_irqrestore(&db->lock, flags);
+
+	dm9000_msleep(db, 1);		/* Wait write complete */
+
+	spin_lock_irqsave(&db->lock, flags);
+	reg_save = readb(db->io_addr);
+
+	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer write command */
+
+	/* restore the previous address */
+	writeb(reg_save, db->io_addr);
+
+	spin_unlock_irqrestore(&db->lock, flags);
+	mutex_unlock(&db->addr_lock);
+}
+
 /* dm9000_set_io
  *
  * select the specified set of io routines to use with the
@@ -794,6 +895,9 @@ dm9000_init_dm9000(struct net_device *dev)
 
 	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
 
+	dm9000_phy_write(dev, 0, MII_BMCR, BMCR_RESET); /* PHY RESET */
+	dm9000_phy_write(dev, 0, MII_DM_DSPCR, DSPCR_INIT_PARAM); /* Init */
+
 	ncr = (db->flags & DM9000_PLATF_EXT_PHY) ? NCR_EXT_PHY : 0;
 
 	/* if wol is needed, then always set NCR_WAKEEN otherwise we end
@@ -1200,109 +1304,6 @@ dm9000_open(struct net_device *dev)
 	return 0;
 }
 
-/*
- * Sleep, either by using msleep() or if we are suspending, then
- * use mdelay() to sleep.
- */
-static void dm9000_msleep(board_info_t *db, unsigned int ms)
-{
-	if (db->in_suspend)
-		mdelay(ms);
-	else
-		msleep(ms);
-}
-
-/*
- *   Read a word from phyxcer
- */
-static int
-dm9000_phy_read(struct net_device *dev, int phy_reg_unused, int reg)
-{
-	board_info_t *db = netdev_priv(dev);
-	unsigned long flags;
-	unsigned int reg_save;
-	int ret;
-
-	mutex_lock(&db->addr_lock);
-
-	spin_lock_irqsave(&db->lock,flags);
-
-	/* Save previous register address */
-	reg_save = readb(db->io_addr);
-
-	/* Fill the phyxcer register into REG_0C */
-	iow(db, DM9000_EPAR, DM9000_PHY | reg);
-
-	iow(db, DM9000_EPCR, EPCR_ERPRR | EPCR_EPOS);	/* Issue phyxcer read command */
-
-	writeb(reg_save, db->io_addr);
-	spin_unlock_irqrestore(&db->lock,flags);
-
-	dm9000_msleep(db, 1);		/* Wait read complete */
-
-	spin_lock_irqsave(&db->lock,flags);
-	reg_save = readb(db->io_addr);
-
-	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer read command */
-
-	/* The read data keeps on REG_0D & REG_0E */
-	ret = (ior(db, DM9000_EPDRH) << 8) | ior(db, DM9000_EPDRL);
-
-	/* restore the previous address */
-	writeb(reg_save, db->io_addr);
-	spin_unlock_irqrestore(&db->lock,flags);
-
-	mutex_unlock(&db->addr_lock);
-
-	dm9000_dbg(db, 5, "phy_read[%02x] -> %04x\n", reg, ret);
-	return ret;
-}
-
-/*
- *   Write a word to phyxcer
- */
-static void
-dm9000_phy_write(struct net_device *dev,
-		 int phyaddr_unused, int reg, int value)
-{
-	board_info_t *db = netdev_priv(dev);
-	unsigned long flags;
-	unsigned long reg_save;
-
-	dm9000_dbg(db, 5, "phy_write[%02x] = %04x\n", reg, value);
-	mutex_lock(&db->addr_lock);
-
-	spin_lock_irqsave(&db->lock,flags);
-
-	/* Save previous register address */
-	reg_save = readb(db->io_addr);
-
-	/* Fill the phyxcer register into REG_0C */
-	iow(db, DM9000_EPAR, DM9000_PHY | reg);
-
-	/* Fill the written data into REG_0D & REG_0E */
-	iow(db, DM9000_EPDRL, value);
-	iow(db, DM9000_EPDRH, value >> 8);
-
-	iow(db, DM9000_EPCR, EPCR_EPOS | EPCR_ERPRW);	/* Issue phyxcer write command */
-
-	writeb(reg_save, db->io_addr);
-	spin_unlock_irqrestore(&db->lock, flags);
-
-	dm9000_msleep(db, 1);		/* Wait write complete */
-
-	spin_lock_irqsave(&db->lock,flags);
-	reg_save = readb(db->io_addr);
-
-	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer write command */
-
-	/* restore the previous address */
-	writeb(reg_save, db->io_addr);
-
-	spin_unlock_irqrestore(&db->lock, flags);
-	mutex_unlock(&db->addr_lock);
-}
-
 static void
 dm9000_shutdown(struct net_device *dev)
 {
@@ -1501,7 +1502,12 @@ dm9000_probe(struct platform_device *pdev)
 	db->flags |= DM9000_PLATF_SIMPLE_PHY;
 #endif
 
-	dm9000_reset(db);
+	/* Fixing bug on dm9000_probe, takeover dm9000_reset(db),
+	 * Need 'NCR_MAC_LBK' bit to indeed stable our DM9000 fifo
+	 * while probe stage.
+	 */
+
+	iow(db, DM9000_NCR, NCR_MAC_LBK | NCR_RST);
 
 	/* try multiple times, DM9000 sometimes gets the read wrong */
 	for (i = 0; i < 8; i++) {
diff --git a/drivers/net/ethernet/davicom/dm9000.h b/drivers/net/ethernet/davicom/dm9000.h
index 55688bd..9ce058a 100644
--- a/drivers/net/ethernet/davicom/dm9000.h
+++ b/drivers/net/ethernet/davicom/dm9000.h
@@ -69,7 +69,9 @@
 #define NCR_WAKEEN          (1<<6)
 #define NCR_FCOL            (1<<4)
 #define NCR_FDX             (1<<3)
-#define NCR_LBK             (3<<1)
+
+#define NCR_RESERVED        (3<<1)
+#define NCR_MAC_LBK         (1<<1)
 #define NCR_RST	            (1<<0)
 
 #define NSR_SPEED           (1<<7)
@@ -167,5 +169,12 @@
 #define ISR_LNKCHNG		(1<<5)
 #define ISR_UNDERRUN		(1<<4)
 
+/* Davicom MII registers.
+ */
+
+#define MII_DM_DSPCR		0x1b    /* DSP Control Register */
+
+#define DSPCR_INIT_PARAM	0xE100	/* DSP init parameter */
+
 #endif /* _DM9000X_H_ */
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 2b0748d..c8d7e5f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1067,7 +1067,7 @@ static void sky2_ramset(struct sky2_hw *hw, u16 q, u32 start, u32 space)
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTHP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTHP), space/2);
 
-		tp = space - 2048/8;
+		tp = space - 8192/8;
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTPP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTPP), space/4);
 	} else {
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index 615ac63..ec6dcd8 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2074,7 +2074,7 @@ enum {
 	GM_IS_RX_FF_OR	= 1<<1,	/* Receive FIFO Overrun */
 	GM_IS_RX_COMPL	= 1<<0,	/* Frame Reception Complete */
 
-#define GMAC_DEF_MSK     GM_IS_TX_FF_UR
+#define GMAC_DEF_MSK     (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
 };
 
 /*	GMAC_LINK_CTRL	16 bit	GMAC Link Control Reg (YUKON only) */
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 1540ebe..a4cd9a0 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -547,7 +547,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xfff;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index feb85d5..bfc2d64 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1777,9 +1777,9 @@ pch_gbe_clean_rx(struct pch_gbe_adapter *adapter,
 
 			skb->protocol = eth_type_trans(skb, netdev);
 			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
-				skb->ip_summed = CHECKSUM_NONE;
-			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			else
+				skb->ip_summed = CHECKSUM_NONE;
 
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;
diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index b26a954..5400a33 100644
--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -120,10 +120,10 @@ typedef union efx_oword {
  * [0,high-low), with garbage in bits [high-low+1,...).
  */
 #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
-	(((low > max) || (high < min)) ? 0 :				\
-	 ((low > min) ?							\
-	  ((native_element) >> (low - min)) :				\
-	  ((native_element) << (min - low))))
+	((low) > (max) || (high) < (min) ? 0 :				\
+	 (low) > (min) ?						\
+	 (native_element) >> ((low) - (min)) :				\
+	 (native_element) << ((min) - (low)))
 
 /*
  * Extract bit field portion [low,high) from the 64-bit little-endian
@@ -142,27 +142,27 @@ typedef union efx_oword {
 #define EFX_EXTRACT_OWORD64(oword, low, high)				\
 	((EFX_EXTRACT64((oword).u64[0], 0, 63, low, high) |		\
 	  EFX_EXTRACT64((oword).u64[1], 64, 127, low, high)) &		\
-	 EFX_MASK64(high + 1 - low))
+	 EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_EXTRACT_QWORD64(qword, low, high)				\
 	(EFX_EXTRACT64((qword).u64[0], 0, 63, low, high) &		\
-	 EFX_MASK64(high + 1 - low))
+	 EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_EXTRACT_OWORD32(oword, low, high)				\
 	((EFX_EXTRACT32((oword).u32[0], 0, 31, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[1], 32, 63, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[2], 64, 95, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[3], 96, 127, low, high)) &		\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_EXTRACT_QWORD32(qword, low, high)				\
 	((EFX_EXTRACT32((qword).u32[0], 0, 31, low, high) |		\
 	  EFX_EXTRACT32((qword).u32[1], 32, 63, low, high)) &		\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_EXTRACT_DWORD(dword, low, high)			\
 	(EFX_EXTRACT32((dword).u32[0], 0, 31, low, high) &	\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_OWORD_FIELD64(oword, field)				\
 	EFX_EXTRACT_OWORD64(oword, EFX_LOW_BIT(field),		\
@@ -442,10 +442,10 @@ typedef union efx_oword {
 	cpu_to_le32(EFX_INSERT_NATIVE(min, max, low, high, value))
 
 #define EFX_INPLACE_MASK64(min, max, low, high)				\
-	EFX_INSERT64(min, max, low, high, EFX_MASK64(high + 1 - low))
+	EFX_INSERT64(min, max, low, high, EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_INPLACE_MASK32(min, max, low, high)				\
-	EFX_INSERT32(min, max, low, high, EFX_MASK32(high + 1 - low))
+	EFX_INSERT32(min, max, low, high, EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_SET_OWORD64(oword, low, high, value) do {			\
 	(oword).u64[0] = (((oword).u64[0]				\
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 65a8d49..2dd7a3f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -754,6 +754,7 @@ efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 						tx_queue->txd.entries);
 	}
 
+	efx_device_detach_sync(efx);
 	efx_stop_all(efx);
 	efx_stop_interrupts(efx, true);
 
@@ -807,6 +808,7 @@ out:
 
 	efx_start_interrupts(efx, true);
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return rc;
 
 rollback:
@@ -1601,8 +1603,12 @@ static void efx_stop_all(struct efx_nic *efx)
 	/* Flush efx_mac_work(), refill_workqueue, monitor_work */
 	efx_flush_all(efx);
 
-	/* Stop the kernel transmit interface late, so the watchdog
-	 * timer isn't ticking over the flush */
+	/* Stop the kernel transmit interface.  This is only valid if
+	 * the device is stopped or detached; otherwise the watchdog
+	 * may fire immediately.
+	 */
+	WARN_ON(netif_running(efx->net_dev) &&
+		netif_device_present(efx->net_dev));
 	netif_tx_disable(efx->net_dev);
 
 	efx_stop_datapath(efx);
@@ -1921,10 +1927,11 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	if (new_mtu > EFX_MAX_MTU)
 		return -EINVAL;
 
-	efx_stop_all(efx);
-
 	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
 
+	efx_device_detach_sync(efx);
+	efx_stop_all(efx);
+
 	mutex_lock(&efx->mac_lock);
 	/* Reconfigure the MAC before enabling the dma queues so that
 	 * the RX buffers don't overflow */
@@ -1933,6 +1940,7 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	mutex_unlock(&efx->mac_lock);
 
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return 0;
 }
 
@@ -2224,7 +2232,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 	efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
@@ -2719,7 +2727,7 @@ static int efx_pm_freeze(struct device *dev)
 
 	efx->state = STATE_FINI;
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	efx_stop_all(efx);
 	efx_stop_interrupts(efx, false);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 70755c9..7db0e5b 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -162,4 +162,17 @@ extern void efx_link_status_changed(struct efx_nic *efx);
 extern void efx_link_set_advertising(struct efx_nic *efx, u32);
 extern void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 
+static inline void efx_device_detach_sync(struct efx_nic *efx)
+{
+	struct net_device *dev = efx->net_dev;
+
+	/* Lock/freeze all TX queues so that we can be sure the
+	 * TX scheduler is stopped when we're done and before
+	 * netif_device_present() becomes false.
+	 */
+	netif_tx_lock_bh(dev);
+	netif_device_detach(dev);
+	netif_tx_unlock_bh(dev);
+}
+
 #endif /* EFX_EFX_H */
diff --git a/drivers/net/ethernet/sfc/falcon.c b/drivers/net/ethernet/sfc/falcon.c
index 12b573a..49bcd19 100644
--- a/drivers/net/ethernet/sfc/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon.c
@@ -1792,6 +1792,7 @@ const struct efx_nic_type falcon_a1_nic_type = {
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
@@ -1834,6 +1835,7 @@ const struct efx_nic_type falcon_b0_nic_type = {
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index fc5e7bb..8407d41 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -22,7 +22,7 @@
  **************************************************************************
  */
 
-#define MCDI_RPC_TIMEOUT       10 /*seconds */
+#define MCDI_RPC_TIMEOUT       (10 * HZ)
 
 #define MCDI_PDU(efx)							\
 	(efx_port_num(efx) ? MC_SMEM_P1_PDU_OFST : MC_SMEM_P0_PDU_OFST)
@@ -120,7 +120,7 @@ static void efx_mcdi_copyout(struct efx_nic *efx, u8 *outbuf, size_t outlen)
 static int efx_mcdi_poll(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-	unsigned int time, finish;
+	unsigned long time, finish;
 	unsigned int respseq, respcmd, error;
 	unsigned int pdu = FR_CZ_MC_TREG_SMEM + MCDI_PDU(efx);
 	unsigned int rc, spins;
@@ -136,7 +136,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 	 * and poll once a jiffy (approximately)
 	 */
 	spins = TICK_USEC;
-	finish = get_seconds() + MCDI_RPC_TIMEOUT;
+	finish = jiffies + MCDI_RPC_TIMEOUT;
 
 	while (1) {
 		if (spins != 0) {
@@ -146,7 +146,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 			schedule_timeout_uninterruptible(1);
 		}
 
-		time = get_seconds();
+		time = jiffies;
 
 		rmb();
 		efx_readd(efx, &reg, pdu);
@@ -158,7 +158,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 		    EFX_DWORD_FIELD(reg, MCDI_HEADER_RESPONSE))
 			break;
 
-		if (time >= finish)
+		if (time_after(time, finish))
 			return -ETIMEDOUT;
 	}
 
@@ -250,7 +250,7 @@ static int efx_mcdi_await_completion(struct efx_nic *efx)
 	if (wait_event_timeout(
 		    mcdi->wq,
 		    atomic_read(&mcdi->state) == MCDI_STATE_COMPLETED,
-		    msecs_to_jiffies(MCDI_RPC_TIMEOUT * 1000)) == 0)
+		    MCDI_RPC_TIMEOUT) == 0)
 		return -ETIMEDOUT;
 
 	/* Check if efx_mcdi_set_mode() switched us back to polled completions.
@@ -641,9 +641,8 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 			   u16 *fw_subtype_list, u32 *capabilities)
 {
 	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMIN];
-	size_t outlen;
+	size_t outlen, offset, i;
 	int port_num = efx_port_num(efx);
-	int offset;
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_BOARD_CFG_IN_LEN != 0);
@@ -663,11 +662,16 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 		: MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT0_OFST;
 	if (mac_address)
 		memcpy(mac_address, outbuf + offset, ETH_ALEN);
-	if (fw_subtype_list)
-		memcpy(fw_subtype_list,
-		       outbuf + MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_OFST,
-		       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM *
-		       sizeof(fw_subtype_list[0]));
+	if (fw_subtype_list) {
+		offset = MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_OFST;
+		for (i = 0;
+		     i < MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM;
+		     i++) {
+			fw_subtype_list[i] =
+				le16_to_cpup((__le16 *)(outbuf + offset));
+			offset += 2;
+		}
+	}
 	if (capabilities) {
 		if (port_num)
 			*capabilities = MCDI_DWORD(outbuf,
@@ -1169,6 +1173,9 @@ int efx_mcdi_flush_rxqs(struct efx_nic *efx)
 	__le32 *qid;
 	int rc, count;
 
+	BUILD_BUG_ON(EFX_MAX_CHANNELS >
+		     MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM);
+
 	qid = kmalloc(EFX_MAX_CHANNELS * sizeof(*qid), GFP_KERNEL);
 	if (qid == NULL)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 0bdf3e3..96f43d2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -107,11 +107,13 @@ extern void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_EVENT_FIELD(_ev, _field)			\
 	EFX_QWORD_FIELD(_ev, MCDI_EVENT_ ## _field)
 #define MCDI_ARRAY_FIELD(_buf, _field1, _type, _index, _field2)		\
-	EFX_DWORD_FIELD(						\
+	EFX_EXTRACT_DWORD(						\
 		*((efx_dword_t *)					\
 		  (MCDI_ARRAY_PTR(_buf, _field1, _type, _index) +	\
 		   (MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _OFST & ~3))), \
-		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2)
+		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _LBN & 0x1f, \
+		(MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _LBN & 0x1f) + \
+		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _WIDTH - 1)
 
 extern void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
 extern int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index cd9c0a9..30d2f4f 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -196,6 +196,7 @@ struct efx_tx_queue {
 	/* Members shared between paths and sometimes updated */
 	unsigned int empty_read_count ____cacheline_aligned_in_smp;
 #define EFX_EMPTY_COUNT_VALID 0x80000000
+	atomic_t flush_outstanding;
 };
 
 /**
@@ -205,6 +206,7 @@ struct efx_tx_queue {
  *	Will be %NULL if the buffer slot is currently free.
  * @page: The associated page buffer. Valif iff @flags & %EFX_RX_BUF_PAGE.
  *	Will be %NULL if the buffer slot is currently free.
+ * @page_offset: Offset within page. Valid iff @flags & %EFX_RX_BUF_PAGE.
  * @len: Buffer length, in bytes.
  * @flags: Flags for buffer and packet state.
  */
@@ -214,7 +216,8 @@ struct efx_rx_buffer {
 		struct sk_buff *skb;
 		struct page *page;
 	} u;
-	unsigned int len;
+	u16 page_offset;
+	u16 len;
 	u16 flags;
 };
 #define EFX_RX_BUF_PAGE		0x0001
@@ -891,6 +894,7 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
  * @remove_port: Free resources allocated by probe_port()
  * @handle_global_event: Handle a "global" event (may be %NULL)
  * @prepare_flush: Prepare the hardware for flushing the DMA queues
+ * @finish_flush: Clean up after flushing the DMA queues
  * @update_stats: Update statistics not provided by event handling
  * @start_stats: Start the regular fetching of statistics
  * @stop_stats: Stop the regular fetching of statistics
@@ -938,6 +942,7 @@ struct efx_nic_type {
 	void (*remove_port)(struct efx_nic *efx);
 	bool (*handle_global_event)(struct efx_channel *channel, efx_qword_t *);
 	void (*prepare_flush)(struct efx_nic *efx);
+	void (*finish_flush)(struct efx_nic *efx);
 	void (*update_stats)(struct efx_nic *efx);
 	void (*start_stats)(struct efx_nic *efx);
 	void (*stop_stats)(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 326d799..d29b4e4 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -73,6 +73,8 @@
 	_EFX_CHANNEL_MAGIC(_EFX_CHANNEL_MAGIC_TX_DRAIN,			\
 			   (_tx_queue)->queue)
 
+static void efx_magic_event(struct efx_channel *channel, u32 magic);
+
 /**************************************************************************
  *
  * Solarstorm hardware access
@@ -377,7 +379,8 @@ efx_may_push_tx_desc(struct efx_tx_queue *tx_queue, unsigned int write_count)
 		return false;
 
 	tx_queue->empty_read_count = 0;
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0
+		&& tx_queue->write_count - write_count == 1;
 }
 
 /* For each entry inserted into the software descriptor ring, create a
@@ -492,6 +495,9 @@ static void efx_flush_tx_queue(struct efx_tx_queue *tx_queue)
 	struct efx_nic *efx = tx_queue->efx;
 	efx_oword_t tx_flush_descq;
 
+	WARN_ON(atomic_read(&tx_queue->flush_outstanding));
+	atomic_set(&tx_queue->flush_outstanding, 1);
+
 	EFX_POPULATE_OWORD_2(tx_flush_descq,
 			     FRF_AZ_TX_FLUSH_DESCQ_CMD, 1,
 			     FRF_AZ_TX_FLUSH_DESCQ, tx_queue->queue);
@@ -667,6 +673,47 @@ static bool efx_flush_wake(struct efx_nic *efx)
 		 && atomic_read(&efx->rxq_flush_pending) > 0));
 }
 
+static bool efx_check_tx_flush_complete(struct efx_nic *efx)
+{
+	bool i = true;
+	efx_oword_t txd_ptr_tbl;
+	struct efx_channel *channel;
+	struct efx_tx_queue *tx_queue;
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
+			efx_reado_table(efx, &txd_ptr_tbl,
+					FR_BZ_TX_DESC_PTR_TBL, tx_queue->queue);
+			if (EFX_OWORD_FIELD(txd_ptr_tbl,
+					    FRF_AZ_TX_DESCQ_FLUSH) ||
+			    EFX_OWORD_FIELD(txd_ptr_tbl,
+					    FRF_AZ_TX_DESCQ_EN)) {
+				netif_dbg(efx, hw, efx->net_dev,
+					  "flush did not complete on TXQ %d\n",
+					  tx_queue->queue);
+				i = false;
+			} else if (atomic_cmpxchg(&tx_queue->flush_outstanding,
+						  1, 0)) {
+				/* The flush is complete, but we didn't
+				 * receive a flush completion event
+				 */
+				netif_dbg(efx, hw, efx->net_dev,
+					  "flush complete on TXQ %d, so drain "
+					  "the queue\n", tx_queue->queue);
+				/* Don't need to increment drain_pending as it
+				 * has already been incremented for the queues
+				 * which did not drain
+				 */
+				efx_magic_event(channel,
+						EFX_CHANNEL_MAGIC_TX_DRAIN(
+							tx_queue));
+			}
+		}
+	}
+
+	return i;
+}
+
 /* Flush all the transmit queues, and continue flushing receive queues until
  * they're all flushed. Wait for the DRAIN events to be recieved so that there
  * are no more RX and TX events left on any channel. */
@@ -678,7 +725,6 @@ int efx_nic_flush_queues(struct efx_nic *efx)
 	struct efx_tx_queue *tx_queue;
 	int rc = 0;
 
-	efx->fc_disable++;
 	efx->type->prepare_flush(efx);
 
 	efx_for_each_channel(channel, efx) {
@@ -728,7 +774,8 @@ int efx_nic_flush_queues(struct efx_nic *efx)
 					     timeout);
 	}
 
-	if (atomic_read(&efx->drain_pending)) {
+	if (atomic_read(&efx->drain_pending) &&
+	    !efx_check_tx_flush_complete(efx)) {
 		netif_err(efx, hw, efx->net_dev, "failed to flush %d queues "
 			  "(rx %d+%d)\n", atomic_read(&efx->drain_pending),
 			  atomic_read(&efx->rxq_flush_outstanding),
@@ -740,7 +787,7 @@ int efx_nic_flush_queues(struct efx_nic *efx)
 		atomic_set(&efx->rxq_flush_outstanding, 0);
 	}
 
-	efx->fc_disable--;
+	efx->type->finish_flush(efx);
 
 	return rc;
 }
@@ -1015,9 +1062,10 @@ efx_handle_tx_flush_done(struct efx_nic *efx, efx_qword_t *event)
 	if (qid < EFX_TXQ_TYPES * efx->n_tx_channels) {
 		tx_queue = efx_get_tx_queue(efx, qid / EFX_TXQ_TYPES,
 					    qid % EFX_TXQ_TYPES);
-
-		efx_magic_event(tx_queue->channel,
-				EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
+		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0)) {
+			efx_magic_event(tx_queue->channel,
+					EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index bab5cd9..a8194b8 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -334,6 +334,8 @@ static inline int efx_nic_irq_test_irq_cpu(struct efx_nic *efx)
 
 /* Global Resources */
 extern int efx_nic_flush_queues(struct efx_nic *efx);
+extern void siena_prepare_flush(struct efx_nic *efx);
+extern void siena_finish_flush(struct efx_nic *efx);
 extern void falcon_start_nic_stats(struct efx_nic *efx);
 extern void falcon_stop_nic_stats(struct efx_nic *efx);
 extern void falcon_setup_xaui(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 719319b..cd3f12f 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -90,11 +90,7 @@ static unsigned int rx_refill_threshold;
 static inline unsigned int efx_rx_buf_offset(struct efx_nic *efx,
 					     struct efx_rx_buffer *buf)
 {
-	/* Offset is always within one page, so we don't need to consider
-	 * the page order.
-	 */
-	return ((unsigned int) buf->dma_addr & (PAGE_SIZE - 1)) +
-		efx->type->rx_buffer_hash_size;
+	return buf->page_offset + efx->type->rx_buffer_hash_size;
 }
 static inline unsigned int efx_rx_buf_size(struct efx_nic *efx)
 {
@@ -187,6 +183,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 	struct efx_nic *efx = rx_queue->efx;
 	struct efx_rx_buffer *rx_buf;
 	struct page *page;
+	unsigned int page_offset;
 	void *page_addr;
 	struct efx_rx_page_state *state;
 	dma_addr_t dma_addr;
@@ -214,12 +211,14 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 
 		page_addr += sizeof(struct efx_rx_page_state);
 		dma_addr += sizeof(struct efx_rx_page_state);
+		page_offset = sizeof(struct efx_rx_page_state);
 
 	split:
 		index = rx_queue->added_count & rx_queue->ptr_mask;
 		rx_buf = efx_rx_buffer(rx_queue, index);
 		rx_buf->dma_addr = dma_addr + EFX_PAGE_IP_ALIGN;
 		rx_buf->u.page = page;
+		rx_buf->page_offset = page_offset + EFX_PAGE_IP_ALIGN;
 		rx_buf->len = efx->rx_buffer_len - EFX_PAGE_IP_ALIGN;
 		rx_buf->flags = EFX_RX_BUF_PAGE;
 		++rx_queue->added_count;
@@ -230,6 +229,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 			/* Use the second half of the page */
 			get_page(page);
 			dma_addr += (PAGE_SIZE >> 1);
+			page_offset += (PAGE_SIZE >> 1);
 			page_addr += (PAGE_SIZE >> 1);
 			++count;
 			goto split;
@@ -240,7 +240,8 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 }
 
 static void efx_unmap_rx_buffer(struct efx_nic *efx,
-				struct efx_rx_buffer *rx_buf)
+				struct efx_rx_buffer *rx_buf,
+				unsigned int used_len)
 {
 	if ((rx_buf->flags & EFX_RX_BUF_PAGE) && rx_buf->u.page) {
 		struct efx_rx_page_state *state;
@@ -251,6 +252,10 @@ static void efx_unmap_rx_buffer(struct efx_nic *efx,
 				       state->dma_addr,
 				       efx_rx_buf_size(efx),
 				       DMA_FROM_DEVICE);
+		} else if (used_len) {
+			dma_sync_single_for_cpu(&efx->pci_dev->dev,
+						rx_buf->dma_addr, used_len,
+						DMA_FROM_DEVICE);
 		}
 	} else if (!(rx_buf->flags & EFX_RX_BUF_PAGE) && rx_buf->u.skb) {
 		dma_unmap_single(&efx->pci_dev->dev, rx_buf->dma_addr,
@@ -273,7 +278,7 @@ static void efx_free_rx_buffer(struct efx_nic *efx,
 static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 			       struct efx_rx_buffer *rx_buf)
 {
-	efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
+	efx_unmap_rx_buffer(rx_queue->efx, rx_buf, 0);
 	efx_free_rx_buffer(rx_queue->efx, rx_buf);
 }
 
@@ -539,10 +544,10 @@ void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 		goto out;
 	}
 
-	/* Release card resources - assumes all RX buffers consumed in-order
-	 * per RX queue
+	/* Release and/or sync DMA mapping - assumes all RX buffers
+	 * consumed in-order per RX queue
 	 */
-	efx_unmap_rx_buffer(efx, rx_buf);
+	efx_unmap_rx_buffer(efx, rx_buf, len);
 
 	/* Prefetch nice and early so data will (hopefully) be in cache by
 	 * the time we look at it.
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 96068d1..57dec37 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -721,7 +721,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	/* Detach the device so the kernel doesn't transmit during the
 	 * loopback test and the watchdog timeout doesn't fire.
 	 */
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	if (efx->type->test_chip) {
 		rc_reset = efx->type->test_chip(efx, tests);
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 6bafd21..7470163 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -127,6 +127,18 @@ static void siena_remove_port(struct efx_nic *efx)
 	efx_nic_free_buffer(efx, &efx->stats_buffer);
 }
 
+void siena_prepare_flush(struct efx_nic *efx)
+{
+	if (efx->fc_disable++ == 0)
+		efx_mcdi_set_mac(efx);
+}
+
+void siena_finish_flush(struct efx_nic *efx)
+{
+	if (--efx->fc_disable == 0)
+		efx_mcdi_set_mac(efx);
+}
+
 static const struct efx_nic_register_test siena_register_tests[] = {
 	{ FR_AZ_ADR_REGION,
 	  EFX_OWORD32(0x0003FFFF, 0x0003FFFF, 0x0003FFFF, 0x0003FFFF) },
@@ -158,7 +170,7 @@ static const struct efx_nic_register_test siena_register_tests[] = {
 
 static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 {
-	enum reset_type reset_method = reset_method;
+	enum reset_type reset_method = RESET_TYPE_ALL;
 	int rc, rc2;
 
 	efx_reset_down(efx, reset_method);
@@ -658,7 +670,8 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.reset = siena_reset_hw,
 	.probe_port = siena_probe_port,
 	.remove_port = siena_remove_port,
-	.prepare_flush = efx_port_dummy_op_void,
+	.prepare_flush = siena_prepare_flush,
+	.finish_flush = siena_finish_flush,
 	.update_stats = siena_update_nic_stats,
 	.start_stats = siena_start_nic_stats,
 	.stop_stats = siena_stop_nic_stats,
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index 9cb3b84..4ad8082 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -21,6 +21,9 @@
 /* Number of longs required to track all the VIs in a VF */
 #define VI_MASK_LENGTH BITS_TO_LONGS(1 << EFX_VI_SCALE_MAX)
 
+/* Maximum number of RX queues supported */
+#define VF_MAX_RX_QUEUES 63
+
 /**
  * enum efx_vf_tx_filter_mode - TX MAC filtering behaviour
  * @VF_TX_FILTER_OFF: Disabled
@@ -578,6 +581,7 @@ static int efx_vfdi_init_rxq(struct efx_vf *vf)
 	efx_oword_t reg;
 
 	if (bad_vf_index(efx, vf_evq) || bad_vf_index(efx, vf_rxq) ||
+	    vf_rxq >= VF_MAX_RX_QUEUES ||
 	    bad_buf_count(buf_count, EFX_MAX_DMAQ_SIZE)) {
 		if (net_ratelimit())
 			netif_err(efx, hw, efx->net_dev,
@@ -683,13 +687,15 @@ static int efx_vfdi_fini_all_queues(struct efx_vf *vf)
 	__le32 *rxqs;
 	int rc;
 
+	BUILD_BUG_ON(VF_MAX_RX_QUEUES >
+		     MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM);
+
 	rxqs = kmalloc(count * sizeof(*rxqs), GFP_KERNEL);
 	if (rxqs == NULL)
 		return VFDI_RC_ENOMEM;
 
 	rtnl_lock();
-	if (efx->fc_disable++ == 0)
-		efx_mcdi_set_mac(efx);
+	siena_prepare_flush(efx);
 	rtnl_unlock();
 
 	/* Flush all the initialized queues */
@@ -726,8 +732,7 @@ static int efx_vfdi_fini_all_queues(struct efx_vf *vf)
 	}
 
 	rtnl_lock();
-	if (--efx->fc_disable == 0)
-		efx_mcdi_set_mac(efx);
+	siena_finish_flush(efx);
 	rtnl_unlock();
 
 	/* Irrespective of success/failure, fini the queues */
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 1e5d85b..0ab0a10 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -250,7 +250,7 @@ void cpsw_tx_handler(void *token, int len, int status)
 	struct cpsw_priv	*priv = netdev_priv(ndev);
 
 	if (unlikely(netif_queue_stopped(ndev)))
-		netif_start_queue(ndev);
+		netif_wake_queue(ndev);
 	priv->stats.tx_packets++;
 	priv->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index fce89a0..93c040d 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1055,7 +1055,7 @@ static void emac_tx_handler(void *token, int len, int status)
 	atomic_dec(&priv->cur_tx);
 
 	if (unlikely(netif_queue_stopped(ndev)))
-		netif_start_queue(ndev);
+		netif_wake_queue(ndev);
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index b332112..2524a69 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -626,6 +626,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
+restart:
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
@@ -638,15 +639,17 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			case NETDEV_UNREGISTER:
 				/*
 				 * rtnl_lock already held
+				 * we might sleep in __netpoll_cleanup()
 				 */
-				if (nt->np.dev) {
-					__netpoll_cleanup(&nt->np);
-					dev_put(nt->np.dev);
-					nt->np.dev = NULL;
-				}
+				spin_unlock_irqrestore(&target_list_lock, flags);
+				__netpoll_cleanup(&nt->np);
+				spin_lock_irqsave(&target_list_lock, flags);
+				dev_put(nt->np.dev);
+				nt->np.dev = NULL;
 				nt->enabled = 0;
 				stopped = true;
-				break;
+				netconsole_target_put(nt);
+				goto restart;
 			}
 		}
 		netconsole_target_put(nt);
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 2603b99..5c05572 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1021,15 +1021,7 @@ ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
-static struct lock_class_key ppp_tx_busylock;
-static int ppp_dev_init(struct net_device *dev)
-{
-	dev->qdisc_tx_busylock = &ppp_tx_busylock;
-	return 0;
-}
-
 static const struct net_device_ops ppp_netdev_ops = {
-	.ndo_init	 = ppp_dev_init,
 	.ndo_start_xmit = ppp_start_xmit,
 	.ndo_do_ioctl   = ppp_net_ioctl,
 };
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 376143e..0d9a895 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -724,8 +724,12 @@ static int smsc75xx_set_rx_max_frame_length(struct usbnet *dev, int size)
 static int smsc75xx_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
+
+	if (new_mtu > MAX_SINGLE_PACKET_SIZE)
+		return -EINVAL;
 
-	int ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu);
+	ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu + ETH_HLEN);
 	check_warn_return(ret, "Failed to set mac rx frame length");
 
 	return usbnet_change_mtu(netdev, new_mtu);
@@ -983,7 +987,7 @@ static int smsc75xx_reset(struct usbnet *dev)
 
 	netif_dbg(dev, ifup, dev->net, "FCT_TX_CTL set to 0x%08x", buf);
 
-	ret = smsc75xx_set_rx_max_frame_length(dev, 1514);
+	ret = smsc75xx_set_rx_max_frame_length(dev, dev->net->mtu + ETH_HLEN);
 	check_warn_return(ret, "Failed to set max rx frame length");
 
 	ret = smsc75xx_read_reg(dev, MAC_RX, &buf);
@@ -1127,8 +1131,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			else if (rx_cmd_a & (RX_CMD_A_LONG | RX_CMD_A_RUNT))
 				dev->net->stats.rx_frame_errors++;
 		} else {
-			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
+			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
 				netif_dbg(dev, rx_err, dev->net,
 					"size err rx_cmd_a=0x%08x", rx_cmd_a);
 				return 0;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7b88b9c..b99514f 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -31,21 +31,21 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 	sc->tx_complete_poll_work_seen++;
 #endif
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-			ath_txq_lock(sc, txq);
-			if (txq->axq_depth) {
-				if (txq->axq_tx_inprogress) {
-					needreset = true;
-					ath_txq_unlock(sc, txq);
-					break;
-				} else {
-					txq->axq_tx_inprogress = true;
-				}
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		txq = sc->tx.txq_map[i];
+
+		ath_txq_lock(sc, txq);
+		if (txq->axq_depth) {
+			if (txq->axq_tx_inprogress) {
+				needreset = true;
+				ath_txq_unlock(sc, txq);
+				break;
+			} else {
+				txq->axq_tx_inprogress = true;
 			}
-			ath_txq_unlock_complete(sc, txq);
 		}
+		ath_txq_unlock_complete(sc, txq);
+	}
 
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
@@ -173,7 +173,8 @@ void ath_rx_poll(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 
-	ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
+		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 }
 
 /*
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 777cd74..92768d304 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1484,8 +1484,12 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_meta *meta;
+	static const struct b43_txstatus fake; /* filled with 0 */
+	const struct b43_txstatus *txstat;
 	int slot, firstused;
 	bool frame_succeed;
+	int skip;
+	static u8 err_out1, err_out2;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
@@ -1498,13 +1502,36 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	firstused = ring->current_slot - ring->used_slots + 1;
 	if (firstused < 0)
 		firstused = ring->nr_slots + firstused;
+
+	skip = 0;
 	if (unlikely(slot != firstused)) {
 		/* This possibly is a firmware bug and will result in
-		 * malfunction, memory leaks and/or stall of DMA functionality. */
-		b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
-		       "Expected %d, but got %d\n",
-		       ring->index, firstused, slot);
-		return;
+		 * malfunction, memory leaks and/or stall of DMA functionality.
+		 */
+		if (slot == next_slot(ring, next_slot(ring, firstused))) {
+			/* If a single header/data pair was missed, skip over
+			 * the first two slots in an attempt to recover.
+			 */
+			slot = firstused;
+			skip = 2;
+			if (!err_out1) {
+				/* Report the error once. */
+				b43dbg(dev->wl,
+				       "Skip on DMA ring %d slot %d.\n",
+				       ring->index, slot);
+				err_out1 = 1;
+			}
+		} else {
+			/* More than a single header/data pair were missed.
+			 * Report this error once.
+			 */
+			if (!err_out2)
+				b43dbg(dev->wl,
+				       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
+				       ring->index, firstused, slot);
+			err_out2 = 1;
+			return;
+		}
 	}
 
 	ops = ring->ops;
@@ -1519,11 +1546,13 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			       slot, firstused, ring->index);
 			break;
 		}
+
 		if (meta->skb) {
 			struct b43_private_tx_info *priv_info =
-				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
+			     b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
 
-			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
+			unmap_descbuffer(ring, meta->dmaaddr,
+					 meta->skb->len, 1);
 			kfree(priv_info->bouncebuffer);
 			priv_info->bouncebuffer = NULL;
 		} else {
@@ -1535,8 +1564,9 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			struct ieee80211_tx_info *info;
 
 			if (unlikely(!meta->skb)) {
-				/* This is a scatter-gather fragment of a frame, so
-				 * the skb pointer must not be NULL. */
+				/* This is a scatter-gather fragment of a frame,
+				 * so the skb pointer must not be NULL.
+				 */
 				b43dbg(dev->wl, "TX status unexpected NULL skb "
 				       "at slot %d (first=%d) on ring %d\n",
 				       slot, firstused, ring->index);
@@ -1547,9 +1577,18 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 
 			/*
 			 * Call back to inform the ieee80211 subsystem about
-			 * the status of the transmission.
+			 * the status of the transmission. When skipping over
+			 * a missed TX status report, use a status structure
+			 * filled with zeros to indicate that the frame was not
+			 * sent (frame_count 0) and not acknowledged
 			 */
-			frame_succeed = b43_fill_txstatus_report(dev, info, status);
+			if (unlikely(skip))
+				txstat = &fake;
+			else
+				txstat = status;
+
+			frame_succeed = b43_fill_txstatus_report(dev, info,
+								 txstat);
 #ifdef CONFIG_B43_DEBUG
 			if (frame_succeed)
 				ring->nr_succeed_tx_packets++;
@@ -1577,12 +1616,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 		/* Everything unmapped and free'd. So it's not used anymore. */
 		ring->used_slots--;
 
-		if (meta->is_last_fragment) {
+		if (meta->is_last_fragment && !skip) {
 			/* This is the last scatter-gather
 			 * fragment of the frame. We are done. */
 			break;
 		}
 		slot = next_slot(ring, slot);
+		if (skip > 0)
+			--skip;
 	}
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b92bb9c..914718a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1320,7 +1320,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
 
 	u8 vcm_final = 0;
-	s8 offset[4];
+	s32 offset[4];
 	s32 results[8][4] = { };
 	s32 results_min[4] = { };
 	s32 poll_results[4] = { };
@@ -1371,7 +1371,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		}
 		for (i = 0; i < 4; i += 2) {
 			s32 curr;
-			s32 mind = 40;
+			s32 mind = 0x100000;
 			s32 minpoll = 249;
 			u8 minvcm = 0;
 			if (2 * core != i)
@@ -1488,7 +1488,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
 
-	s8 offset[4];
+	s32 offset[4];
 	u8 core;
 	u8 rail;
 
@@ -1555,7 +1555,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	}
 
 	for (i = 0; i < 4; i++) {
-		s32 mind = 40;
+		s32 mind = 0x100000;
 		u8 minvcm = 0;
 		s32 minpoll = 249;
 		s32 curr;
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index bef88c1..f18ecd3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -1263,6 +1263,15 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	/*
+	 * This can happen upon FW ASSERT: we clear the STATUS_FW_ERROR flag
+	 * in iwl_down but cancel the workers only later.
+	 */
+	if (!priv->ucode_loaded) {
+		IWL_ERR(priv, "Fw not loaded - dropping CMD: %x\n", cmd->id);
+		return -EIO;
+	}
+
+	/*
 	 * Synchronous commands from this op-mode must hold
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 6d8d6dd..6215b16 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -450,6 +450,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
+	priv->ucode_loaded = true;
+
 	/*
 	 * This step takes a long time (60-80ms!!) and
 	 * WoWLAN image should be loaded quickly, so
@@ -474,8 +476,6 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	priv->ucode_loaded = true;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 82e63ce..fa42578 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1093,10 +1093,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		adhoc_join->bss_descriptor.bssid,
 		adhoc_join->bss_descriptor.ssid);
 
-	for (i = 0; bss_desc->supported_rates[i] &&
-			i < MWIFIEX_SUPPORTED_RATES;
-			i++)
-			;
+	for (i = 0; i < MWIFIEX_SUPPORTED_RATES &&
+		    bss_desc->supported_rates[i]; i++)
+		;
 	rates_size = i;
 
 	/* Copy Data Rates from the Rates recorded in scan response */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 4bbb711..82167ac 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,74 +1377,57 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
-}
-
-/*========================================================================== */
-
-static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
-			      enum nl80211_iftype type)
-{
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u8 filterout_non_associated_bssid = false;
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
-	if (filterout_non_associated_bssid) {
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			switch (rtlphy->current_io_type) {
-			case IO_CMD_RESUME_DM_BY_SCAN:
-				reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* enable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
-				break;
-			case IO_CMD_PAUSE_DM_BY_SCAN:
-				reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* disable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
-				break;
-			}
+			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr |= (RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, 0, (BIT(4)|BIT(5)));
+			reg_rcr |= RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
-	} else if (filterout_non_associated_bssid == false) {
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
+	} else {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr &= (~RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, (BIT(4)|BIT(5)), 0);
+			reg_rcr &= ~RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
+		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, tmp, 0);
 	}
 }
 
+/*========================================================================== */
+
 int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92cu_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92cu_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92cu_set_check_bssid(hw, true);
+	} else {
+		rtl92cu_set_check_bssid(hw, false);
+	}
+
 	return 0;
 }
 
@@ -2058,8 +2041,6 @@ void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 			       (shortgi_rate << 4) | (shortgi_rate);
 	}
 	rtl_write_dword(rtlpriv, REG_ARFR0 + ratr_index * 4, ratr_value);
-	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
-		 rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
 void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index aa970fc..98b0d6d 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -842,6 +842,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!_urb)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't allocate urb. Drop skb!\n");
+		kfree_skb(skb);
 		return;
 	}
 	urb_list = &rtlusb->tx_pending[ep_num];
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 2b03b68..f809ef3 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1509,7 +1509,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	case TRIG_NONE:
 		/*  continous acquisition */
 		devpriv->ai_continous = 1;
-		devpriv->ai_sample_count = 0;
+		devpriv->ai_sample_count = 1;
 		break;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index db0cf7c..a0fc7b9 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -166,6 +166,7 @@ static int chap_server_compute_md5(
 {
 	char *endptr;
 	unsigned long id;
+	unsigned char id_as_uchar;
 	unsigned char digest[MD5_SIGNATURE_SIZE];
 	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
 	unsigned char identifier[10], *challenge = NULL;
@@ -355,7 +356,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	sg_init_one(&sg, &id, 1);
+	/* To handle both endiannesses */
+	id_as_uchar = id;
+	sg_init_one(&sg, &id_as_uchar, 1);
 	ret = crypto_hash_update(&desc, &sg, 1);
 	if (ret < 0) {
 		pr_err("crypto_hash_update() failed for id\n");
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 876ae53..291f66e 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -7,7 +7,7 @@
 #define FD_DEVICE_QUEUE_DEPTH	32
 #define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
-#define FD_MAX_SECTORS		1024
+#define FD_MAX_SECTORS		2048
 
 #define RRF_EMULATE_CDB		0x01
 #define RRF_GOT_LBA		0x02
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3d7e1ee..ed7cd37 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -159,7 +159,7 @@ struct atmel_uart_port {
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
-static unsigned long atmel_ports_in_use;
+static DECLARE_BITMAP(atmel_ports_in_use, ATMEL_MAX_UART);
 
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
@@ -1785,15 +1785,14 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	if (ret < 0)
 		/* port id not found in platform data nor device-tree aliases:
 		 * auto-enumerate it */
-		ret = find_first_zero_bit(&atmel_ports_in_use,
-				sizeof(atmel_ports_in_use));
+		ret = find_first_zero_bit(atmel_ports_in_use, ATMEL_MAX_UART);
 
-	if (ret > ATMEL_MAX_UART) {
+	if (ret >= ATMEL_MAX_UART) {
 		ret = -ENODEV;
 		goto err;
 	}
 
-	if (test_and_set_bit(ret, &atmel_ports_in_use)) {
+	if (test_and_set_bit(ret, atmel_ports_in_use)) {
 		/* port already in use */
 		ret = -EBUSY;
 		goto err;
@@ -1867,7 +1866,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clear_bit(port->line, &atmel_ports_in_use);
+	clear_bit(port->line, atmel_ports_in_use);
 
 	clk_put(atmel_port->clk);
 
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 675303b..76fa1fa 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -968,6 +968,7 @@ static struct uart_ops sunsu_pops = {
 #define UART_NR	4
 
 static struct uart_sunsu_port sunsu_ports[UART_NR];
+static int nr_inst; /* Number of already registered ports */
 
 #ifdef CONFIG_SERIO
 
@@ -1337,13 +1338,8 @@ static int __init sunsu_console_setup(struct console *co, char *options)
 	printk("Console: ttyS%d (SU)\n",
 	       (sunsu_reg.minor - 64) + co->index);
 
-	/*
-	 * Check whether an invalid uart number has been specified, and
-	 * if so, search for the first available port that does have
-	 * console support.
-	 */
-	if (co->index >= UART_NR)
-		co->index = 0;
+	if (co->index > nr_inst)
+		return -ENODEV;
 	port = &sunsu_ports[co->index].port;
 
 	/*
@@ -1408,7 +1404,6 @@ static enum su_type __devinit su_get_type(struct device_node *dp)
 
 static int __devinit su_probe(struct platform_device *op)
 {
-	static int inst;
 	struct device_node *dp = op->dev.of_node;
 	struct uart_sunsu_port *up;
 	struct resource *rp;
@@ -1418,16 +1413,16 @@ static int __devinit su_probe(struct platform_device *op)
 
 	type = su_get_type(dp);
 	if (type == SU_PORT_PORT) {
-		if (inst >= UART_NR)
+		if (nr_inst >= UART_NR)
 			return -EINVAL;
-		up = &sunsu_ports[inst];
+		up = &sunsu_ports[nr_inst];
 	} else {
 		up = kzalloc(sizeof(*up), GFP_KERNEL);
 		if (!up)
 			return -ENOMEM;
 	}
 
-	up->port.line = inst;
+	up->port.line = nr_inst;
 
 	spin_lock_init(&up->port.lock);
 
@@ -1461,6 +1456,8 @@ static int __devinit su_probe(struct platform_device *op)
 		}
 		dev_set_drvdata(&op->dev, up);
 
+		nr_inst++;
+
 		return 0;
 	}
 
@@ -1488,7 +1485,7 @@ static int __devinit su_probe(struct platform_device *op)
 
 	dev_set_drvdata(&op->dev, up);
 
-	inst++;
+	nr_inst++;
 
 	return 0;
 
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index fa7268a..6abb92c 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -93,7 +93,7 @@ vcs_poll_data_free(struct vcs_poll_data *poll)
 static struct vcs_poll_data *
 vcs_poll_data_get(struct file *file)
 {
-	struct vcs_poll_data *poll = file->private_data;
+	struct vcs_poll_data *poll = file->private_data, *kill = NULL;
 
 	if (poll)
 		return poll;
@@ -122,10 +122,12 @@ vcs_poll_data_get(struct file *file)
 		file->private_data = poll;
 	} else {
 		/* someone else raced ahead of us */
-		vcs_poll_data_free(poll);
+		kill = poll;
 		poll = file->private_data;
 	}
 	spin_unlock(&file->f_lock);
+	if (kill)
+		vcs_poll_data_free(kill);
 
 	return poll;
 }
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 89c752a..d0d8f1c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -601,7 +601,6 @@ static void acm_port_destruct(struct tty_port *port)
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
-	tty_unregister_device(acm_tty_driver, acm->minor);
 	acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
@@ -1418,6 +1417,8 @@ static void acm_disconnect(struct usb_interface *intf)
 
 	stop_data_traffic(acm);
 
+	tty_unregister_device(acm_tty_driver, acm->minor);
+
 	usb_free_urb(acm->ctrlurb);
 	for (i = 0; i < ACM_NW; i++)
 		usb_free_urb(acm->wb[i].urb);
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 622b4a4..2b487d4 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -173,6 +173,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct hc_driver	*driver;
 	struct usb_hcd		*hcd;
 	int			retval;
+	int			hcd_irq = 0;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -187,15 +188,19 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	dev->current_state = PCI_D0;
 
-	/* The xHCI driver supports MSI and MSI-X,
-	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
+	/*
+	 * The xHCI driver has its own irq management
+	 * make sure irq setup is not touched for xhci in generic hcd code
 	 */
-	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
-		dev_err(&dev->dev,
-			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
-			pci_name(dev));
-		retval = -ENODEV;
-		goto disable_pci;
+	if ((driver->flags & HCD_MASK) != HCD_USB3) {
+		if (!dev->irq) {
+			dev_err(&dev->dev,
+			"Found HC with no IRQ. Check BIOS/PCI %s setup!\n",
+				pci_name(dev));
+			retval = -ENODEV;
+			goto disable_pci;
+		}
+		hcd_irq = dev->irq;
 	}
 
 	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));
@@ -245,7 +250,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_master(dev);
 
-	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, hcd_irq, IRQF_SHARED);
 	if (retval != 0)
 		goto unmap_registers;
 	set_hs_companion(dev, hcd);
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index d3ace90..919177b 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -358,7 +358,7 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	if (unlikely(ret < 0))
 		goto error;
 
-	for (i = func_num; --i; ) {
+	for (i = func_num; i--; ) {
 		ret = functionfs_bind(ffs_tab[i].ffs_data, cdev);
 		if (unlikely(ret < 0)) {
 			while (++i < func_num)
@@ -413,7 +413,7 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
 		gether_cleanup();
 	gfs_ether_setup = false;
 
-	for (i = func_num; --i; )
+	for (i = func_num; i--; )
 		if (ffs_tab[i].ffs_data)
 			functionfs_unbind(ffs_tab[i].ffs_data);
 
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index e5e44f8..b0af333 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -265,7 +265,7 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 		udc->driver->disconnect(udc->gadget);
 		usb_gadget_disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
+		usb_gadget_udc_stop(udc->gadget, NULL);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 528a540..56a1907 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1237,6 +1237,7 @@ itd_urb_transaction (
 
 		memset (itd, 0, sizeof *itd);
 		itd->itd_dma = itd_dma;
+		itd->frame = 9999;		/* an invalid value */
 		list_add (&itd->itd_list, &sched->td_list);
 	}
 	spin_unlock_irqrestore (&ehci->lock, flags);
@@ -1931,6 +1932,7 @@ sitd_urb_transaction (
 
 		memset (sitd, 0, sizeof *sitd);
 		sitd->sitd_dma = sitd_dma;
+		sitd->frame = 9999;		/* an invalid value */
 		list_add (&sitd->sitd_list, &iso_sched->td_list);
 	}
 
diff --git a/drivers/usb/host/ehci-timer.c b/drivers/usb/host/ehci-timer.c
index 20dbdcb..c3fa130 100644
--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -304,7 +304,7 @@ static void ehci_iaa_watchdog(struct ehci_hcd *ehci)
 	 * (a) SMP races against real IAA firing and retriggering, and
 	 * (b) clean HC shutdown, when IAA watchdog was pending.
 	 */
-	if (ehci->async_iaa) {
+	if (1) {
 		u32 cmd, status;
 
 		/* If we get here, IAA is *REALLY* late.  It's barely
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 4f1e265..b9ade46 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2018,8 +2018,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (event_trb != ep_ring->dequeue &&
 				event_trb != td->last_trb)
 			td->urb->actual_length =
-				td->urb->transfer_buffer_length
-				- TRB_LEN(le32_to_cpu(event->transfer_len));
+				td->urb->transfer_buffer_length -
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 		else
 			td->urb->actual_length = 0;
 
@@ -2051,7 +2051,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		/* Maybe the event was for the data stage? */
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			xhci_dbg(xhci, "Waiting for status "
 					"stage event\n");
 			return 0;
@@ -2087,7 +2087,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
 			frame->status = 0;
 			break;
 		}
@@ -2132,7 +2132,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
 		}
 		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2190,7 +2190,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2218,18 +2218,18 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				"%d bytes untransferred\n",
 				td->urb->ep->desc.bEndpointAddress,
 				td->urb->transfer_buffer_length,
-				TRB_LEN(le32_to_cpu(event->transfer_len)));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 	/* Fast path - was this the last TRB in the TD for this URB? */
 	if (event_trb == td->last_trb) {
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			if (td->urb->transfer_buffer_length <
 					td->urb->actual_length) {
 				xhci_warn(xhci, "HC gave bad length "
 						"of %d bytes left\n",
-					  TRB_LEN(le32_to_cpu(event->transfer_len)));
+					  EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 				td->urb->actual_length = 0;
 				if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 					*status = -EREMOTEIO;
@@ -2271,7 +2271,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
 				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2357,7 +2357,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
 		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
 			trb_comp_code = COMP_SHORT_TX;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a6e910b..fd36acd 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -350,7 +350,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 	 * generate interrupts.  Don't even try to enable MSI.
 	 */
 	if (xhci->quirks & XHCI_BROKEN_MSI)
-		return 0;
+		goto legacy_irq;
 
 	/* unregister the legacy interrupt */
 	if (hcd->irq)
@@ -371,6 +371,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 		return -EINVAL;
 	}
 
+ legacy_irq:
 	/* fall back to legacy interrupt*/
 	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 			hcd->irq_descr, hcd);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 53df4e7..212d408 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -206,8 +206,8 @@ struct xhci_op_regs {
 /* bits 12:31 are reserved (and should be preserved on writes). */
 
 /* IMAN - Interrupt Management Register */
-#define IMAN_IP		(1 << 1)
-#define IMAN_IE		(1 << 0)
+#define IMAN_IE		(1 << 1)
+#define IMAN_IP		(1 << 0)
 
 /* USBSTS - USB status - status bitmasks */
 /* HC not running - set to 1 when run/stop bit is cleared. */
@@ -972,6 +972,10 @@ struct xhci_transfer_event {
 	__le32	flags;
 };
 
+/* Transfer event TRB length bit mask */
+/* bits 0:23 */
+#define	EVENT_TRB_LEN(p)		((p) & 0xffffff)
+
 /** Transfer Event bit fields **/
 #define	TRB_TO_EP_ID(p)	(((p) >> 16) & 0x1f)
 
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index a6758ff..5f9eaaf 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -68,7 +68,6 @@ static int is_irda(struct usb_serial *serial)
 }
 
 struct ark3116_private {
-	wait_queue_head_t       delta_msr_wait;
 	struct async_icount	icount;
 	int			irda;	/* 1 for irda device */
 
@@ -152,7 +151,6 @@ static int ark3116_port_probe(struct usb_serial_port *port)
 	if (!priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&priv->delta_msr_wait);
 	mutex_init(&priv->hw_lock);
 	spin_lock_init(&priv->status_lock);
 
@@ -462,10 +460,14 @@ static int ark3116_ioctl(struct tty_struct *tty,
 	case TIOCMIWAIT:
 		for (;;) {
 			struct async_icount prev = priv->icount;
-			interruptible_sleep_on(&priv->delta_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			if ((prev.rng == priv->icount.rng) &&
 			    (prev.dsr == priv->icount.dsr) &&
 			    (prev.dcd == priv->icount.dcd) &&
@@ -586,7 +588,7 @@ static void ark3116_update_msr(struct usb_serial_port *port, __u8 msr)
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 8391d30..65fb3e0 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -82,7 +82,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct ch341_private {
 	spinlock_t lock; /* access lock */
-	wait_queue_head_t delta_msr_wait; /* wait queue for modem status */
 	unsigned baud_rate; /* set baud rate */
 	u8 line_control; /* set line control value RTS/DTR */
 	u8 line_status; /* active status of modem control inputs */
@@ -251,7 +250,6 @@ static int ch341_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->baud_rate = DEFAULT_BAUD_RATE;
 	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
 
@@ -297,7 +295,7 @@ static void ch341_dtr_rts(struct usb_serial_port *port, int on)
 		priv->line_control &= ~(CH341_BIT_RTS | CH341_BIT_DTR);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ch341_set_handshake(port->serial->dev, priv->line_control);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 }
 
 static void ch341_close(struct usb_serial_port *port)
@@ -490,7 +488,7 @@ static void ch341_read_int_callback(struct urb *urb)
 			tty_kref_put(tty);
 		}
 
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 
 exit:
@@ -516,11 +514,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (!multi_change) {
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		multi_change = priv->multi_status_change;
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 5ad6e7d..61de7e1 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -116,7 +116,6 @@ struct cypress_private {
 	int baud_rate;			   /* stores current baud rate in
 					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
-	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
@@ -452,7 +451,6 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
 		kfree(priv);
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_reset_configuration(serial->dev);
 
@@ -872,12 +870,16 @@ static int cypress_ioctl(struct tty_struct *tty,
 	switch (cmd) {
 	/* This code comes from drivers/char/serial.c and ftdi_sio.c */
 	case TIOCMIWAIT:
-		while (priv != NULL) {
-			interruptible_sleep_on(&priv->delta_msr_wait);
+		for (;;) {
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
-			else {
+
+			if (port->serial->disconnected)
+				return -EIO;
+
+			{
 				char diff = priv->diff_status;
 				if (diff == 0)
 					return -EIO; /* no change => error */
@@ -1193,7 +1195,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	if (priv->current_status != priv->prev_status) {
 		priv->diff_status |= priv->current_status ^
 			priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = priv->current_status;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index be94436..441f09a 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -49,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct f81232_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 };
@@ -114,7 +113,7 @@ static void f81232_process_read_urb(struct urb *urb)
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
@@ -262,11 +261,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -328,7 +330,6 @@ static int f81232_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 360bdeb..caa52dd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -74,9 +74,7 @@ struct ftdi_private {
 	int flags;		/* some ASYNC_xxxx flags are supported */
 	unsigned long last_dtr_rts;	/* saved modem control outputs */
 	struct async_icount	icount;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	char prev_status;        /* Used for TIOCMIWAIT */
-	bool dev_gone;        /* Used to abort TIOCMIWAIT */
 	char transmit_empty;	/* If transmitter is empty or not */
 	struct usb_serial_port *port;
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
@@ -647,6 +645,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
 	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
+	{ USB_DEVICE(MITSUBISHI_VID, MITSUBISHI_FXUSB_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
@@ -1690,10 +1689,8 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	kref_init(&priv->kref);
 	mutex_init(&priv->cfg_lock);
 	memset(&priv->icount, 0x00, sizeof(priv->icount));
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	priv->flags = ASYNC_LOW_LATENCY;
-	priv->dev_gone = false;
 
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
@@ -1840,8 +1837,7 @@ static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 
-	priv->dev_gone = true;
-	wake_up_interruptible_all(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	remove_sysfs_attrs(port);
 
@@ -1992,7 +1988,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 		if (diff_status & FTDI_RS0_RLSD)
 			priv->icount.dcd++;
 
-		wake_up_interruptible_all(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
@@ -2391,11 +2387,15 @@ static int ftdi_ioctl(struct tty_struct *tty,
 	 */
 	case TIOCMIWAIT:
 		cprev = priv->icount;
-		while (!priv->dev_gone) {
-			interruptible_sleep_on(&priv->delta_msr_wait);
+		for (;;) {
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = priv->icount;
 			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
@@ -2405,8 +2405,6 @@ static int ftdi_ioctl(struct tty_struct *tty,
 			}
 			cprev = cnow;
 		}
-		return -EIO;
-		break;
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
 		break;
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 049b6e7..4801983 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -577,6 +577,13 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
 
 /*
+ * Mitsubishi Electric Corp. (http://www.meau.com)
+ * Submitted by Konstantin Holoborodko
+ */
+#define MITSUBISHI_VID		0x06D3
+#define MITSUBISHI_FXUSB_PID	0x0284 /* USB/RS422 converters: FX-USB-AW/-BD */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index de9cfd4..6e6e305 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -959,10 +959,7 @@ static void garmin_close(struct usb_serial_port *port)
 	if (!serial)
 		return;
 
-	mutex_lock(&port->serial->disc_mutex);
-
-	if (!port->serial->disconnected)
-		garmin_clear(garmin_data_p);
+	garmin_clear(garmin_data_p);
 
 	/* shutdown our urbs */
 	usb_kill_urb(port->read_urb);
@@ -971,8 +968,6 @@ static void garmin_close(struct usb_serial_port *port)
 	/* keep reset state so we know that we must start a new session */
 	if (garmin_data_p->state != STATE_RESET)
 		garmin_data_p->state = STATE_DISCONNECTED;
-
-	mutex_unlock(&port->serial->disc_mutex);
 }
 
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 6c22679..3067157 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -114,7 +114,6 @@ struct edgeport_port {
 	wait_queue_head_t	wait_chase;		/* for handling sleeping while waiting for chase to finish */
 	wait_queue_head_t	wait_open;		/* for handling sleeping while waiting for open to finish */
 	wait_queue_head_t	wait_command;		/* for handling sleeping while waiting for command to finish */
-	wait_queue_head_t	delta_msr_wait;		/* for handling sleeping while waiting for msr change to happen */
 
 	struct async_icount	icount;
 	struct usb_serial_port	*port;			/* loop back to the owner of this object */
@@ -886,7 +885,6 @@ static int edge_open(struct tty_struct *tty, struct usb_serial_port *port)
 	/* initialize our wait queues */
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 	init_waitqueue_head(&edge_port->wait_command);
 
 	/* initialize our icount structure */
@@ -1703,13 +1701,17 @@ static int edge_ioctl(struct tty_struct *tty,
 		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
 		cprev = edge_port->icount;
 		while (1) {
-			prepare_to_wait(&edge_port->delta_msr_wait,
+			prepare_to_wait(&port->delta_msr_wait,
 						&wait, TASK_INTERRUPTIBLE);
 			schedule();
-			finish_wait(&edge_port->delta_msr_wait, &wait);
+			finish_wait(&port->delta_msr_wait, &wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = edge_port->icount;
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
@@ -2090,7 +2092,7 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr)
 			icount->dcd++;
 		if (newMsr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index ccf297d..d2b6008 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -91,9 +91,6 @@ struct edgeport_port {
 	int close_pending;
 	int lsr_event;
 	struct async_icount	icount;
-	wait_queue_head_t	delta_msr_wait;	/* for handling sleeping while
-						   waiting for msr change to
-						   happen */
 	struct edgeport_serial	*edge_serial;
 	struct usb_serial_port	*port;
 	__u8 bUartMode;		/* Port type, 0: RS232, etc. */
@@ -1539,7 +1536,7 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 			icount->dcd++;
 		if (msr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
@@ -1857,7 +1854,6 @@ static int edge_open(struct tty_struct *tty, struct usb_serial_port *port)
 	dev = port->serial->dev;
 
 	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 
 	/* turn off loopback */
 	status = ti_do_config(edge_port, UMPC_SET_CLR_LOOPBACK, 0);
@@ -2549,10 +2545,14 @@ static int edge_ioctl(struct tty_struct *tty,
 		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
 		cprev = edge_port->icount;
 		while (1) {
-			interruptible_sleep_on(&edge_port->delta_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = edge_port->icount;
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
@@ -2766,6 +2766,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index c088250..505c954 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -120,8 +120,6 @@ struct mct_u232_private {
 	unsigned char	     last_msr;      /* Modem Status Register */
 	unsigned int	     rx_flags;      /* Throttling flags */
 	struct async_icount  icount;
-	wait_queue_head_t    msr_wait;	/* for handling sleeping while waiting
-						for msr change to happen */
 };
 
 #define THROTTLED		0x01
@@ -417,7 +415,6 @@ static int mct_u232_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -625,7 +622,7 @@ static void mct_u232_read_int_callback(struct urb *urb)
 		tty_kref_put(tty);
 	}
 #endif
-	wake_up_interruptible(&priv->msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -836,13 +833,17 @@ static int  mct_u232_ioctl(struct tty_struct *tty,
 		cprev = mct_u232_port->icount;
 		spin_unlock_irqrestore(&mct_u232_port->lock, flags);
 		for ( ; ; ) {
-			prepare_to_wait(&mct_u232_port->msr_wait,
+			prepare_to_wait(&port->delta_msr_wait,
 					&wait, TASK_INTERRUPTIBLE);
 			schedule();
-			finish_wait(&mct_u232_port->msr_wait, &wait);
+			finish_wait(&port->delta_msr_wait, &wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			spin_lock_irqsave(&mct_u232_port->lock, flags);
 			cnow = mct_u232_port->icount;
 			spin_unlock_irqrestore(&mct_u232_port->lock, flags);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 5311819..8654df0 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -223,7 +223,6 @@ struct moschip_port {
 	char open;
 	char open_ports;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
-	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
 	struct async_icount icount;
 	struct usb_serial_port *port;	/* loop back to the owner of this object */
@@ -441,6 +440,9 @@ static void mos7840_handle_new_msr(struct moschip_port *port, __u8 new_msr)
 			icount->rng++;
 			smp_wmb();
 		}
+
+		mos7840_port->delta_msr_cond = 1;
+		wake_up_interruptible(&port->port->delta_msr_wait);
 	}
 }
 
@@ -1162,7 +1164,6 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* initialize our wait queues */
 	init_waitqueue_head(&mos7840_port->wait_chase);
-	init_waitqueue_head(&mos7840_port->delta_msr_wait);
 
 	/* initialize our icount structure */
 	memset(&(mos7840_port->icount), 0x00, sizeof(mos7840_port->icount));
@@ -2095,8 +2096,6 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	wake_up(&mos7840_port->delta_msr_wait);
-	mos7840_port->delta_msr_cond = 1;
 	dbg("mos7840_change_port_settings mos7840_port->shadowLCR is End %x",
 	    mos7840_port->shadowLCR);
 }
@@ -2305,13 +2304,18 @@ static int mos7840_ioctl(struct tty_struct *tty,
 		while (1) {
 			/* interruptible_sleep_on(&mos7840_port->delta_msr_wait); */
 			mos7840_port->delta_msr_cond = 0;
-			wait_event_interruptible(mos7840_port->delta_msr_wait,
-						 (mos7840_port->
+			wait_event_interruptible(port->delta_msr_wait,
+						 (port->serial->disconnected ||
+						  mos7840_port->
 						  delta_msr_cond == 1));
 
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = mos7840_port->icount;
 			smp_rmb();
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 3aa582e..88e31f8 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -191,7 +191,6 @@ struct oti6858_private {
 	u8 setup_done;
 	struct delayed_work delayed_setup_work;
 
-	wait_queue_head_t intr_wait;
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
@@ -342,7 +341,6 @@ static int oti6858_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->intr_wait);
 	priv->port = port;
 	INIT_DELAYED_WORK(&priv->delayed_setup_work, setup_line);
 	INIT_DELAYED_WORK(&priv->delayed_write_work, send_data);
@@ -669,11 +667,15 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->intr_wait,
+		wait_event_interruptible(port->delta_msr_wait,
+					port->serial->disconnected ||
 					priv->status.pin_state != prev);
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->status.pin_state & PIN_MASK;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -771,7 +773,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 
 		if (!priv->transient) {
 			if (xs->pin_state != priv->status.pin_state)
-				wake_up_interruptible(&priv->intr_wait);
+				wake_up_interruptible(&port->delta_msr_wait);
 			memcpy(&priv->status, xs, OTI6858_CTRL_PKT_SIZE);
 		}
 
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 4d8d210..bf39f1b 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -141,7 +141,6 @@ struct pl2303_serial_private {
 
 struct pl2303_private {
 	spinlock_t lock;
-	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 };
@@ -235,7 +234,6 @@ static int pl2303_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -609,11 +607,14 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -721,7 +722,7 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
@@ -786,7 +787,7 @@ static void pl2303_process_read_urb(struct urb *urb)
 	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index ea69301..e801c54 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -132,7 +132,6 @@ struct qt2_port_private {
 	u8          shadowLSR;
 	u8          shadowMSR;
 
-	wait_queue_head_t   delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 
 	struct usb_serial_port *port;
@@ -510,8 +509,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -519,6 +519,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -845,7 +848,6 @@ static int qt2_port_probe(struct usb_serial_port *port)
 
 	spin_lock_init(&port_priv->lock);
 	spin_lock_init(&port_priv->urb_lock);
-	init_waitqueue_head(&port_priv->delta_msr_wait);
 	port_priv->port = port;
 
 	port_priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -990,7 +992,7 @@ static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
 		if (newMSR & UART_MSR_TERI)
 			port_priv->icount.rng++;
 
-		wake_up_interruptible(&port_priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 2451c08..0822a10 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -154,7 +154,6 @@ enum spcp8x5_type {
 struct spcp8x5_private {
 	spinlock_t 	lock;
 	enum spcp8x5_type	type;
-	wait_queue_head_t	delta_msr_wait;
 	u8 			line_control;
 	u8 			line_status;
 };
@@ -184,7 +183,6 @@ static int spcp8x5_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->type = type;
 
 	usb_set_serial_port_data(port , priv);
@@ -481,7 +479,7 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
 	/* wake up the wait for termios */
-	wake_up_interruptible(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	if (!urb->actual_length)
 		return;
@@ -531,12 +529,15 @@ static int spcp8x5_wait_modem_info(struct usb_serial_port *port,
 
 	while (1) {
 		/* wake up in bulk read */
-		interruptible_sleep_on(&priv->delta_msr_wait);
+		interruptible_sleep_on(&port->delta_msr_wait);
 
 		/* see if a signal did it */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
 		spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index fe3a8a0..fd260de 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -65,7 +65,6 @@ struct ssu100_port_private {
 	spinlock_t status_lock;
 	u8 shadowLSR;
 	u8 shadowMSR;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	struct async_icount icount;
 };
 
@@ -359,8 +358,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->status_lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->delta_msr_wait,
-					 ((priv->icount.rng != prev.rng) ||
+		wait_event_interruptible(port->delta_msr_wait,
+					 (port->serial->disconnected ||
+					  (priv->icount.rng != prev.rng) ||
 					  (priv->icount.dsr != prev.dsr) ||
 					  (priv->icount.dcd != prev.dcd) ||
 					  (priv->icount.cts != prev.cts)));
@@ -368,6 +368,9 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		if (port->serial->disconnected)
+			return -EIO;
+
 		spin_lock_irqsave(&priv->status_lock, flags);
 		cur = priv->icount;
 		spin_unlock_irqrestore(&priv->status_lock, flags);
@@ -449,7 +452,6 @@ static int ssu100_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->status_lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -544,7 +546,7 @@ static void ssu100_update_msr(struct usb_serial_port *port, u8 msr)
 			priv->icount.dcd++;
 		if (msr & UART_MSR_TERI)
 			priv->icount.rng++;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 }
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 33537bb..722069c 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -75,7 +75,6 @@ struct ti_port {
 	int			tp_flags;
 	int			tp_closing_wait;/* in .01 secs */
 	struct async_icount	tp_icount;
-	wait_queue_head_t	tp_msr_wait;	/* wait for msr change */
 	wait_queue_head_t	tp_write_wait;
 	struct ti_device	*tp_tdev;
 	struct usb_serial_port	*tp_port;
@@ -442,7 +441,6 @@ static int ti_port_probe(struct usb_serial_port *port)
 	else
 		tport->tp_uart_base_addr = TI_UART2_BASE_ADDR;
 	tport->tp_closing_wait = closing_wait;
-	init_waitqueue_head(&tport->tp_msr_wait);
 	init_waitqueue_head(&tport->tp_write_wait);
 	if (kfifo_alloc(&tport->write_fifo, TI_WRITE_BUF_SIZE, GFP_KERNEL)) {
 		kfree(tport);
@@ -798,9 +796,13 @@ static int ti_ioctl(struct tty_struct *tty,
 		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
 		cprev = tport->tp_icount;
 		while (1) {
-			interruptible_sleep_on(&tport->tp_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = tport->tp_icount;
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
@@ -1412,7 +1414,7 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 			icount->dcd++;
 		if (msr & TI_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&tport->tp_msr_wait);
+		wake_up_interruptible(&tport->tp_port->delta_msr_wait);
 		spin_unlock_irqrestore(&tport->tp_lock, flags);
 	}
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 667c39c..5f38894 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -157,6 +157,7 @@ static void destroy_serial(struct kref *kref)
 		}
 	}
 
+	usb_put_intf(serial->interface);
 	usb_put_dev(serial->dev);
 	kfree(serial);
 }
@@ -614,7 +615,7 @@ static struct usb_serial *create_serial(struct usb_device *dev,
 	}
 	serial->dev = usb_get_dev(dev);
 	serial->type = driver;
-	serial->interface = interface;
+	serial->interface = usb_get_intf(interface);
 	kref_init(&serial->kref);
 	mutex_init(&serial->disc_mutex);
 	serial->minor = SERIAL_TTY_NO_MINOR;
@@ -888,6 +889,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 8f98c9a..3561322 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -488,6 +488,13 @@ UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
 
+/* Added by Dmitry Artamonow <mad_soft@inbox.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5136, 0x0000, 0x9999,
+		"Samsung",
+		"YP-Z3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7f93f34..156a360 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -235,7 +235,8 @@ static void handle_tx(struct vhost_net *net)
 				msg.msg_controllen = 0;
 				ubufs = NULL;
 			} else {
-				struct ubuf_info *ubuf = &vq->ubuf_info[head];
+				struct ubuf_info *ubuf;
+				ubuf = vq->ubuf_info + vq->upend_idx;
 
 				vq->heads[vq->upend_idx].len = len;
 				ubuf->callback = vhost_zerocopy_callback;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..daaca3d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -604,6 +604,7 @@ struct block_device *bdgrab(struct block_device *bdev)
 	ihold(bdev->bd_inode);
 	return bdev;
 }
+EXPORT_SYMBOL(bdgrab);
 
 long nr_blockdev_pages(void)
 {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..6d7b589 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4301,7 +4301,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +
@@ -4582,14 +4582,49 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 * If the inodes csum_bytes is the same as the original
 		 * csum_bytes then we know we haven't raced with any free()ers
 		 * so we can just reduce our inodes csum bytes and carry on.
-		 * Otherwise we have to do the normal free thing to account for
-		 * the case that the free side didn't free up its reserve
-		 * because of this outstanding reservation.
 		 */
-		if (BTRFS_I(inode)->csum_bytes == csum_bytes)
+		if (BTRFS_I(inode)->csum_bytes == csum_bytes) {
 			calc_csum_metadata_size(inode, num_bytes, 0);
-		else
-			to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+		} else {
+			u64 orig_csum_bytes = BTRFS_I(inode)->csum_bytes;
+			u64 bytes;
+
+			/*
+			 * This is tricky, but first we need to figure out how much we
+			 * free'd from any free-ers that occured during this
+			 * reservation, so we reset ->csum_bytes to the csum_bytes
+			 * before we dropped our lock, and then call the free for the
+			 * number of bytes that were freed while we were trying our
+			 * reservation.
+			 */
+			bytes = csum_bytes - BTRFS_I(inode)->csum_bytes;
+			BTRFS_I(inode)->csum_bytes = csum_bytes;
+			to_free = calc_csum_metadata_size(inode, bytes, 0);
+
+
+			/*
+			 * Now we need to see how much we would have freed had we not
+			 * been making this reservation and our ->csum_bytes were not
+			 * artificially inflated.
+			 */
+			BTRFS_I(inode)->csum_bytes = csum_bytes - num_bytes;
+			bytes = csum_bytes - orig_csum_bytes;
+			bytes = calc_csum_metadata_size(inode, bytes, 0);
+
+			/*
+			 * Now reset ->csum_bytes to what it should be.  If bytes is
+			 * more than to_free then we would have free'd more space had we
+			 * not had an artificially high ->csum_bytes, so we need to free
+			 * the remainder.  If bytes is the same or less then we don't
+			 * need to do anything, the other free-ers did the correct
+			 * thing.
+			 */
+			BTRFS_I(inode)->csum_bytes = orig_csum_bytes - num_bytes;
+			if (bytes > to_free)
+				to_free = bytes - to_free;
+			else
+				to_free = 0;
+		}
 		spin_unlock(&BTRFS_I(inode)->lock);
 		if (dropped)
 			to_free += btrfs_calc_trans_metadata_size(root, dropped);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..d1e1b7c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1230,6 +1230,39 @@ int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 				GFP_NOFS);
 }
 
+int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end)
+{
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
+	struct page *page;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		BUG_ON(!page); /* Pages should be in the extent_io_tree */
+		clear_page_dirty_for_io(page);
+		page_cache_release(page);
+		index++;
+	}
+	return 0;
+}
+
+int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
+{
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
+	struct page *page;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		BUG_ON(!page); /* Pages should be in the extent_io_tree */
+		account_page_redirty(page);
+		__set_page_dirty_nobuffers(page);
+		page_cache_release(page);
+		index++;
+	}
+	return 0;
+}
+
 /*
  * helper function to set both pages and extents in the tree writeback
  */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..c5003db 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -314,6 +314,8 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long *map_len);
 int extent_range_uptodate(struct extent_io_tree *tree,
 			  u64 start, u64 end);
+int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
+int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode,
 				struct extent_io_tree *tree,
 				u64 start, u64 end, struct page *locked_page,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ec154f9..cb6f206 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -350,6 +350,7 @@ static noinline int compress_file_range(struct inode *inode,
 	int i;
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
+	int redirty = 0;
 
 	/* if this is a small write inside eof, kick off a defrag */
 	if ((end - start + 1) < 16 * 1024 &&
@@ -412,6 +413,17 @@ again:
 		if (BTRFS_I(inode)->force_compress)
 			compress_type = BTRFS_I(inode)->force_compress;
 
+		/*
+		 * we need to call clear_page_dirty_for_io on each
+		 * page in the range.  Otherwise applications with the file
+		 * mmap'd can wander in and change the page contents while
+		 * we are compressing them.
+		 *
+		 * If the compression fails for any reason, we set the pages
+		 * dirty again later on.
+		 */
+		extent_range_clear_dirty_for_io(inode, start, end);
+		redirty = 1;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
 					   total_compressed, pages,
@@ -553,6 +565,8 @@ cleanup_and_bail_uncompressed:
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
+		if (redirty)
+			extent_range_redirty_for_io(inode, start, end);
 		add_async_extent(async_cow, start, end - start + 1,
 				 0, NULL, 0, BTRFS_COMPRESS_NONE);
 		*num_added += 1;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b223620..5aeffbe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -385,7 +385,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	eb = path->nodes[0];
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-	btrfs_release_path(path);
 
 	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
@@ -401,7 +400,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 				ret < 0 ? -1 : ref_level,
 				ret < 0 ? -1 : ref_root);
 		} while (ret != 1);
+		btrfs_release_path(path);
 	} else {
+		btrfs_release_path(path);
 		swarn.path = path;
 		iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, 1,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..d814a5d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1132,7 +1132,10 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	if (ret == 0) {
-		btrfs_inc_nlink(inode);
+		if (!inode->i_nlink)
+			set_nlink(inode, 1);
+		else
+			btrfs_inc_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index cfd1ce3..1d36db1 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -614,53 +614,10 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 		}
 	}
 
-	/* mechlistMIC */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		/* Check if we have reached the end of the blob, but with
-		   no mechListMic (e.g. NTLMSSP instead of KRB5) */
-		if (ctx.error == ASN1_ERR_DEC_EMPTY)
-			goto decode_negtoken_exit;
-		cFYI(1, "Error decoding last part negTokenInit exit3");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		/* tag = 3 indicating mechListMIC */
-		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-
-	/* sequence */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit5");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
-		   || (tag != ASN1_SEQ)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-	}
-
-	/* sequence of */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit 7");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-
-	/* general string */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit9");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
-		   || (tag != ASN1_GENSTR)) {
-		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-	cFYI(1, "Need to call asn1_octets_decode() function for %s",
-		ctx.pointer);	/* is this UTF-8 or ASCII? */
-decode_negtoken_exit:
+	/*
+	 * We currently ignore anything at the end of the SPNEGO blob after
+	 * the mechTypes have been parsed, since none of that info is
+	 * used at the moment.
+	 */
 	return 1;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 693f95b..2488c47 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2583,7 +2583,6 @@ static int prepend_path(const struct path *path,
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2613,8 +2612,6 @@ static int prepend_path(const struct path *path,
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-out:
-	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
@@ -2631,7 +2628,7 @@ global_root:
 		error = prepend(buffer, buflen, "/", 1);
 	if (!error)
 		error = is_mounted(vfsmnt) ? 1 : 2;
-	goto out;
+	return error;
 }
 
 /**
@@ -2658,9 +2655,11 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2677,9 +2676,11 @@ char *d_absolute_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -2743,11 +2744,13 @@ char *d_path(const struct path *path, char *buf, int buflen)
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
+	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
-	write_sequnlock(&rename_lock);
 	path_put(&root);
 	return res;
 }
@@ -2902,6 +2905,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2911,6 +2915,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
 			goto out;
@@ -2931,6 +2936,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		}
 	} else {
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 
 out:
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b686b43..1b3df8f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -329,9 +329,9 @@ struct ext4_group_desc
  */
 
 struct flex_groups {
-	atomic_t free_inodes;
-	atomic_t free_clusters;
-	atomic_t used_dirs;
+	atomic64_t	free_clusters;
+	atomic_t	free_inodes;
+	atomic_t	used_dirs;
 };
 
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 741bb94..4f7d479 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3011,6 +3011,7 @@ static int ext4_split_extent(handle_t *handle,
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3030,6 +3031,8 @@ static int ext4_split_extent(handle_t *handle,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 
 	ext4_ext_drop_refs(path);
@@ -3052,7 +3055,7 @@ static int ext4_split_extent(handle_t *handle,
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
@@ -3720,6 +3723,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index cc2d77c..c690ff9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -324,8 +324,8 @@ error_return:
 }
 
 struct orlov_stats {
+	__u64 free_clusters;
 	__u32 free_inodes;
-	__u32 free_clusters;
 	__u32 used_dirs;
 };
 
@@ -342,7 +342,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 
 	if (flex_size > 1) {
 		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic_read(&flex_group[g].free_clusters);
+		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
 		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
 		return;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ce16af..5cf441c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -211,7 +211,8 @@ void ext4_evict_inode(struct inode *inode)
 		 * don't use page cache.
 		 */
 		if (ext4_should_journal_data(inode) &&
-		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+		    inode->i_ino != EXT4_JOURNAL_INO) {
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b26410c..87b5519 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2820,8 +2820,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
-		atomic_sub(ac->ac_b_ex.fe_len,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_sub(ac->ac_b_ex.fe_len,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4670,8 +4670,8 @@ do_more:
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(count_clusters,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(count_clusters,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
@@ -4815,8 +4815,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_B2C(sbi, blocks_freed),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(EXT4_B2C(sbi, blocks_freed),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2b5fb60..f581886 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1945,8 +1945,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		flex_group = ext4_flex_group(sbi, i);
 		atomic_add(ext4_free_inodes_count(sb, gdp),
 			   &sbi->s_flex_groups[flex_group].free_inodes);
-		atomic_add(ext4_free_group_clusters(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(ext4_free_group_clusters(sb, gdp),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(ext4_used_dirs_count(sb, gdp),
 			   &sbi->s_flex_groups[flex_group].used_dirs);
 	}
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fb1ab953..9427cf1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1046,9 +1046,12 @@ out:
 void jbd2_journal_set_triggers(struct buffer_head *bh,
 			       struct jbd2_buffer_trigger_type *type)
 {
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh = jbd2_journal_grab_journal_head(bh);
 
+	if (WARN_ON(!jh))
+		return;
 	jh->b_triggers = type;
+	jbd2_journal_put_journal_head(jh);
 }
 
 void jbd2_buffer_frozen_trigger(struct journal_head *jh, void *mapped_data,
@@ -1100,17 +1103,18 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh;
 	int ret = 0;
 
-	jbd_debug(5, "journal_head %p\n", jh);
-	JBUFFER_TRACE(jh, "entry");
 	if (is_handle_aborted(handle))
 		goto out;
-	if (!buffer_jbd(bh)) {
+	jh = jbd2_journal_grab_journal_head(bh);
+	if (!jh) {
 		ret = -EUCLEAN;
 		goto out;
 	}
+	jbd_debug(5, "journal_head %p\n", jh);
+	JBUFFER_TRACE(jh, "entry");
 
 	jbd_lock_bh_state(bh);
 
@@ -1201,6 +1205,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
+	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
diff --git a/fs/namespace.c b/fs/namespace.c
index 7bdf790..c48b0d3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2681,3 +2681,28 @@ bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(real_mount(mnt));
 }
+
+bool current_chrooted(void)
+{
+	/* Does the current process have a non-standard root */
+	struct path ns_root;
+	struct path fs_root;
+	bool chrooted;
+
+	/* Find the namespace root */
+	ns_root.mnt = &current->nsproxy->mnt_ns->root->mnt;
+	ns_root.dentry = ns_root.mnt->mnt_root;
+	path_get(&ns_root);
+	while (d_mountpoint(ns_root.dentry) && follow_down_one(&ns_root))
+		;
+
+	get_fs_root(current->fs, &fs_root);
+
+	chrooted = !path_equal(&fs_root, &ns_root);
+
+	path_put(&fs_root);
+	path_put(&ns_root);
+
+	return chrooted;
+}
+
diff --git a/fs/nfs/blocklayout/blocklayoutdm.c b/fs/nfs/blocklayout/blocklayoutdm.c
index 737d839..6fc7b5c 100644
--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -55,7 +55,8 @@ static void dev_remove(struct net *net, dev_t dev)
 
 	bl_pipe_msg.bl_wq = &nn->bl_wq;
 	memset(msg, 0, sizeof(*msg));
-	msg->data = kzalloc(1 + sizeof(bl_umount_request), GFP_NOFS);
+	msg->len = sizeof(bl_msg) + bl_msg.totallen;
+	msg->data = kzalloc(msg->len, GFP_NOFS);
 	if (!msg->data)
 		goto out;
 
@@ -66,7 +67,6 @@ static void dev_remove(struct net *net, dev_t dev)
 	memcpy(msg->data, &bl_msg, sizeof(bl_msg));
 	dataptr = (uint8_t *) msg->data;
 	memcpy(&dataptr[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request));
-	msg->len = sizeof(bl_msg) + bl_msg.totallen;
 
 	add_wait_queue(&nn->bl_wq, &wq);
 	if (rpc_queue_upcall(nn->bl_device_pipe, msg) < 0) {
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index a850079..e720df5 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -707,9 +707,9 @@ out1:
 	return ret;
 }
 
-static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *data)
+static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *data, size_t datalen)
 {
-	return key_instantiate_and_link(key, data, strlen(data) + 1,
+	return key_instantiate_and_link(key, data, datalen,
 					id_resolver_cache->thread_keyring,
 					authkey);
 }
@@ -717,15 +717,18 @@ static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *dat
 static int nfs_idmap_read_message(struct idmap_msg *im, struct key *key, struct key *authkey)
 {
 	char id_str[NFS_UINT_MAXLEN];
+	size_t len;
 	int ret = -EINVAL;
 
 	switch (im->im_conv) {
 	case IDMAP_CONV_NAMETOID:
-		sprintf(id_str, "%d", im->im_id);
-		ret = nfs_idmap_instantiate(key, authkey, id_str);
+		/* Note: here we store the NUL terminator too */
+		len = sprintf(id_str, "%d", im->im_id) + 1;
+		ret = nfs_idmap_instantiate(key, authkey, id_str, len);
 		break;
 	case IDMAP_CONV_IDTONAME:
-		ret = nfs_idmap_instantiate(key, authkey, im->im_name);
+		len = strlen(im->im_name);
+		ret = nfs_idmap_instantiate(key, authkey, im->im_name, len);
 		break;
 	}
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7bff871..2c6c214 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6549,22 +6549,8 @@ nfs4_layoutcommit_done(struct rpc_task *task, void *calldata)
 static void nfs4_layoutcommit_release(void *calldata)
 {
 	struct nfs4_layoutcommit_data *data = calldata;
-	struct pnfs_layout_segment *lseg, *tmp;
-	unsigned long *bitlock = &NFS_I(data->args.inode)->flags;
 
 	pnfs_cleanup_layoutcommit(data);
-	/* Matched by references in pnfs_set_layoutcommit */
-	list_for_each_entry_safe(lseg, tmp, &data->lseg_list, pls_lc_list) {
-		list_del_init(&lseg->pls_lc_list);
-		if (test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT,
-				       &lseg->pls_flags))
-			put_lseg(lseg);
-	}
-
-	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
-	smp_mb__after_clear_bit();
-	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
-
 	put_rpccred(data->cred);
 	kfree(data);
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 2e00fea..49dffeb5 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -364,6 +364,16 @@ should_free_lseg(struct pnfs_layout_range *lseg_range,
 	       lo_seg_intersecting(lseg_range, recall_range);
 }
 
+static bool pnfs_lseg_dec_and_remove_zero(struct pnfs_layout_segment *lseg,
+		struct list_head *tmp_list)
+{
+	if (!atomic_dec_and_test(&lseg->pls_refcount))
+		return false;
+	put_lseg_common(lseg);
+	list_add(&lseg->pls_list, tmp_list);
+	return true;
+}
+
 /* Returns 1 if lseg is removed from list, 0 otherwise */
 static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 			     struct list_head *tmp_list)
@@ -377,11 +387,8 @@ static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 		 */
 		dprintk("%s: lseg %p ref %d\n", __func__, lseg,
 			atomic_read(&lseg->pls_refcount));
-		if (atomic_dec_and_test(&lseg->pls_refcount)) {
-			put_lseg_common(lseg);
-			list_add(&lseg->pls_list, tmp_list);
+		if (pnfs_lseg_dec_and_remove_zero(lseg, tmp_list))
 			rv = 1;
-		}
 	}
 	return rv;
 }
@@ -614,6 +621,21 @@ send_layoutget(struct pnfs_layout_hdr *lo,
 	return lseg;
 }
 
+static void pnfs_clear_layoutcommit(struct inode *inode,
+		struct list_head *head)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct pnfs_layout_segment *lseg, *tmp;
+
+	if (!test_and_clear_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags))
+		return;
+	list_for_each_entry_safe(lseg, tmp, &nfsi->layout->plh_segs, pls_list) {
+		if (!test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
+			continue;
+		pnfs_lseg_dec_and_remove_zero(lseg, head);
+	}
+}
+
 /*
  * Initiates a LAYOUTRETURN(FILE), and removes the pnfs_layout_hdr
  * when the layout segment list is empty.
@@ -645,6 +667,7 @@ _pnfs_return_layout(struct inode *ino)
 	/* Reference matched in nfs4_layoutreturn_release */
 	get_layout_hdr(lo);
 	empty = list_empty(&lo->plh_segs);
+	pnfs_clear_layoutcommit(ino, &tmp_list);
 	mark_matching_lsegs_invalid(lo, &tmp_list, NULL);
 	/* Don't send a LAYOUTRETURN if list was initially empty */
 	if (empty) {
@@ -658,8 +681,6 @@ _pnfs_return_layout(struct inode *ino)
 	spin_unlock(&ino->i_lock);
 	pnfs_free_lseg_list(&tmp_list);
 
-	WARN_ON(test_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags));
-
 	lrp = kzalloc(sizeof(*lrp), GFP_KERNEL);
 	if (unlikely(lrp == NULL)) {
 		status = -ENOMEM;
@@ -1283,7 +1304,6 @@ static void pnfs_ld_handle_write_error(struct nfs_write_data *data)
 	dprintk("pnfs write error = %d\n", hdr->pnfs_error);
 	if (NFS_SERVER(hdr->inode)->pnfs_curr_ld->flags &
 	    PNFS_LAYOUTRET_ON_ERROR) {
-		clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(hdr->inode)->flags);
 		pnfs_return_layout(hdr->inode);
 	}
 	if (!test_and_set_bit(NFS_IOHDR_REDO, &hdr->flags))
@@ -1435,7 +1455,6 @@ static void pnfs_ld_handle_read_error(struct nfs_read_data *data)
 	dprintk("pnfs read error = %d\n", hdr->pnfs_error);
 	if (NFS_SERVER(hdr->inode)->pnfs_curr_ld->flags &
 	    PNFS_LAYOUTRET_ON_ERROR) {
-		clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(hdr->inode)->flags);
 		pnfs_return_layout(hdr->inode);
 	}
 	if (!test_and_set_bit(NFS_IOHDR_REDO, &hdr->flags))
@@ -1567,11 +1586,27 @@ static void pnfs_list_write_lseg(struct inode *inode, struct list_head *listp)
 
 	list_for_each_entry(lseg, &NFS_I(inode)->layout->plh_segs, pls_list) {
 		if (lseg->pls_range.iomode == IOMODE_RW &&
-		    test_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
+		    test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
 			list_add(&lseg->pls_lc_list, listp);
 	}
 }
 
+static void pnfs_list_write_lseg_done(struct inode *inode, struct list_head *listp)
+{
+	struct pnfs_layout_segment *lseg, *tmp;
+	unsigned long *bitlock = &NFS_I(inode)->flags;
+
+	/* Matched by references in pnfs_set_layoutcommit */
+	list_for_each_entry_safe(lseg, tmp, listp, pls_lc_list) {
+		list_del_init(&lseg->pls_lc_list);
+		put_lseg(lseg);
+	}
+
+	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
+	smp_mb__after_clear_bit();
+	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
+}
+
 void pnfs_set_lo_fail(struct pnfs_layout_segment *lseg)
 {
 	if (lseg->pls_range.iomode == IOMODE_RW) {
@@ -1622,6 +1657,7 @@ void pnfs_cleanup_layoutcommit(struct nfs4_layoutcommit_data *data)
 
 	if (nfss->pnfs_curr_ld->cleanup_layoutcommit)
 		nfss->pnfs_curr_ld->cleanup_layoutcommit(data);
+	pnfs_list_write_lseg_done(data->args.inode, &data->lseg_list);
 }
 
 /*
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6322df3..551b061 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -263,7 +263,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		int nace;
+		u32 nace;
 		struct nfs4_ace *ace;
 
 		READ_BUF(4); len += 4;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b3647fe..dcd2b05 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -417,8 +417,7 @@ static const struct dentry_operations proc_dentry_operations =
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		struct dentry *dentry)
 {
-	struct inode *inode = NULL;
-	int error = -ENOENT;
+	struct inode *inode;
 
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
@@ -427,22 +426,16 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
-			error = -EINVAL;
 			inode = proc_get_inode(dir->i_sb, de);
-			goto out_unlock;
+			if (!inode)
+				return ERR_PTR(-ENOMEM);
+			d_set_d_op(dentry, &proc_dentry_operations);
+			d_add(dentry, inode);
+			return NULL;
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
-out_unlock:
-
-	if (inode) {
-		d_set_d_op(dentry, &proc_dentry_operations);
-		d_add(dentry, inode);
-		return NULL;
-	}
-	if (de)
-		pde_put(de);
-	return ERR_PTR(error);
+	return ERR_PTR(-ENOENT);
 }
 
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..e5b57da 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -443,12 +443,10 @@ static const struct file_operations proc_reg_file_ops_no_compat = {
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode * inode;
+	struct inode *inode = new_inode_pseudo(sb);
 
-	inode = iget_locked(sb, de->low_ino);
-	if (!inode)
-		return NULL;
-	if (inode->i_state & I_NEW) {
+	if (inode) {
+		inode->i_ino = de->low_ino;
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
@@ -477,11 +475,10 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
 	} else
 	       pde_put(de);
 	return inode;
-}			
+}
 
 int proc_fill_super(struct super_block *s)
 {
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..4b93159 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1020,6 +1020,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	if (filp->f_pos == 1) {
 		if (parent_sd->s_parent)
@@ -1028,6 +1030,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			ino = parent_sd->s_ino;
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
@@ -1058,10 +1062,21 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	return 0;
 }
 
+static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode =  file->f_path.dentry->d_inode;
+	loff_t ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = generic_file_llseek(file, offset, whence);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
 
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 	.release	= sysfs_dir_release,
-	.llseek		= generic_file_llseek,
+	.llseek		= sysfs_dir_llseek,
 };
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 42ad69a..9e8e08e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -82,7 +82,7 @@ struct udf_virtual_data {
 struct udf_bitmap {
 	__u32			s_extLength;
 	__u32			s_extPosition;
-	__u16			s_nr_groups;
+	int			s_nr_groups;
 	struct buffer_head 	**s_block_bitmap;
 };
 
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index c5c35e6..1cdbfe9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -568,7 +568,11 @@
 	{0x1002, 0x9908, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9909, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x990A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
-	{0x1002, 0x990F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x990B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x990C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x990D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x990E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x990F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9910, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9913, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9917, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
@@ -579,6 +583,13 @@
 	{0x1002, 0x9992, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9993, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9994, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9996, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9998, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9999, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 003dc0f..961cdaa 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -51,4 +51,6 @@ static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
 	spin_unlock(&fs->lock);
 }
 
+extern bool current_chrooted(void);
+
 #endif /* _LINUX_FS_STRUCT_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59dc05f3..b91c93b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1322,6 +1322,8 @@ struct net_device {
 	/* phy device may attach itself for hardware timestamping */
 	struct phy_device *phydev;
 
+	struct lock_class_key *qdisc_tx_busylock;
+
 	/* group the device belongs to */
 	int group;
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f3165d2..adab092 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -481,7 +481,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
-		__u32		avail_size;
+		__u32		reserved_tailroom;
 	};
 
 	sk_buff_data_t		transport_header;
@@ -1253,11 +1253,13 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * do not lose pfmemalloc information as the pages would not be
 	 * allocated using __GFP_MEMALLOC.
 	 */
-	if (page->pfmemalloc && !page->mapping)
-		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
+
+	page = compound_head(page);
+	if (page->pfmemalloc && !page->mapping)
+		skb->pfmemalloc	= true;
 }
 
 /**
@@ -1412,7 +1414,10 @@ static inline int skb_tailroom(const struct sk_buff *skb)
  */
 static inline int skb_availroom(const struct sk_buff *skb)
 {
-	return skb_is_nonlinear(skb) ? 0 : skb->avail_size - skb->len;
+	if (skb_is_nonlinear(skb))
+		return 0;
+
+	return skb->end - skb->tail - skb->reserved_tailroom;
 }
 
 /**
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 4b94a61..30c223b 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -122,7 +122,7 @@ struct thermal_zone_device {
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
 #define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_group"
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
 
 enum events {
 	THERMAL_AUX0,
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 86c0b45..0b61f01 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -66,6 +66,7 @@
  *	port.
  * @flags: usb serial port flags
  * @write_wait: a wait_queue_head_t used by the port.
+ * @delta_msr_wait: modem-status-change wait queue
  * @work: work queue entry for the line discipline waking up.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
@@ -112,6 +113,7 @@ struct usb_serial_port {
 
 	unsigned long		flags;
 	wait_queue_head_t	write_wait;
+	wait_queue_head_t	delta_msr_wait;
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 2431cf8..92e211e 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -33,6 +33,13 @@ struct inet_frag_queue {
 
 #define INETFRAGS_HASHSZ		64
 
+/* averaged:
+ * max_depth = default ipfrag_high_thresh / INETFRAGS_HASHSZ /
+ *	       rounded up (SKB_TRUELEN(0) + sizeof(struct ipq or
+ *	       struct frag_queue))
+ */
+#define INETFRAGS_MAXDEPTH		128
+
 struct inet_frags {
 	struct hlist_head	hash[INETFRAGS_HASHSZ];
 	rwlock_t		lock;
@@ -63,6 +70,8 @@ int inet_frag_evictor(struct netns_frags *nf, struct inet_frags *f);
 struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 		struct inet_frags *f, void *key, unsigned int hash)
 	__releases(&f->lock);
+void inet_frag_maybe_warn_overflow(struct inet_frag_queue *q,
+				   const char *prefix);
 
 static inline void inet_frag_put(struct inet_frag_queue *q, struct inet_frags *f)
 {
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 9497be1..e49db91 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -152,18 +152,16 @@ struct fib_result_nl {
 };
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-
 #define FIB_RES_NH(res)		((res).fi->fib_nh[(res).nh_sel])
-
-#define FIB_TABLE_HASHSZ 2
-
 #else /* CONFIG_IP_ROUTE_MULTIPATH */
-
 #define FIB_RES_NH(res)		((res).fi->fib_nh[0])
+#endif /* CONFIG_IP_ROUTE_MULTIPATH */
 
+#ifdef CONFIG_IP_MULTIPLE_TABLES
 #define FIB_TABLE_HASHSZ 256
-
-#endif /* CONFIG_IP_ROUTE_MULTIPATH */
+#else
+#define FIB_TABLE_HASHSZ 2
+#endif
 
 extern __be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh);
 
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ee338bf..2af8fdb 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -138,11 +138,21 @@ struct blkif_request_discard {
 	uint8_t        _pad3;
 } __attribute__((__packed__));
 
+struct blkif_request_other {
+	uint8_t      _pad1;
+	blkif_vdev_t _pad2;        /* only for read/write requests         */
+#ifdef CONFIG_X86_64
+	uint32_t     _pad3;        /* offsetof(blkif_req..,u.other.id)==8*/
+#endif
+	uint64_t     id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_request_rw rw;
 		struct blkif_request_discard discard;
+		struct blkif_request_other other;
 	} u;
 } __attribute__((__packed__));
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9a08acc..9e4cf7f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -841,7 +841,8 @@ out_putfd:
 		fd = error;
 	}
 	mutex_unlock(&root->d_inode->i_mutex);
-	mnt_drop_write(mnt);
+	if (!ro)
+		mnt_drop_write(mnt);
 out_putname:
 	putname(name);
 	return fd;
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..a13987a 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,7 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if ((tick_broadcast_device.evtdev &&
+	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 781ecc2..c27095d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3002,8 +3002,8 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..bf2c50b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -693,7 +693,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -705,6 +705,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	}
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
@@ -2776,11 +2777,25 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 	return -EINVAL;
 }
 
-static void set_tracer_flags(unsigned int mask, int enabled)
+/* Some tracers require overwrite to stay enabled */
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
+{
+	if (tracer->enabled && (mask & TRACE_ITER_OVERWRITE) && !set)
+		return -1;
+
+	return 0;
+}
+
+int set_tracer_flag(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
-		return;
+		return 0;
+
+	/* Give the tracer a chance to approve the change */
+	if (current_trace->flag_changed)
+		if (current_trace->flag_changed(current_trace, mask, !!enabled))
+			return -EINVAL;
 
 	if (enabled)
 		trace_flags |= mask;
@@ -2790,8 +2805,14 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 	if (mask == TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
 
-	if (mask == TRACE_ITER_OVERWRITE)
+	if (mask == TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
+		ring_buffer_change_overwrite(max_tr.buffer, enabled);
+#endif
+	}
+
+	return 0;
 }
 
 static ssize_t
@@ -2818,21 +2839,23 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
-			set_tracer_flags(1 << i, !neg);
+			ret = set_tracer_flag(1 << i, !neg);
 			break;
 		}
 	}
 
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i]) {
-		mutex_lock(&trace_types_lock);
+	if (!trace_options[i])
 		ret = set_tracer_option(current_trace, cmp, neg);
-		mutex_unlock(&trace_types_lock);
-		if (ret)
-			return ret;
-	}
+
+	mutex_unlock(&trace_types_lock);
+
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
@@ -3174,8 +3197,11 @@ static int tracing_set_tracer(const char *buf)
 		goto out;
 
 	trace_branch_disable();
-	if (current_trace && current_trace->reset)
-		current_trace->reset(tr);
+	if (current_trace) {
+		current_trace->enabled = false;
+		if (current_trace->reset)
+			current_trace->reset(tr);
+	}
 	if (current_trace && current_trace->use_max_tr) {
 		/*
 		 * We don't free the ring buffer. instead, resize it because
@@ -3211,6 +3237,7 @@ static int tracing_set_tracer(const char *buf)
 	}
 
 	current_trace = t;
+	current_trace->enabled = true;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -4612,7 +4639,13 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
-	set_tracer_flags(1 << index, val);
+
+	mutex_lock(&trace_types_lock);
+	ret = set_tracer_flag(1 << index, val);
+	mutex_unlock(&trace_types_lock);
+
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f..1dd9fe7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -283,10 +283,14 @@ struct tracer {
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	/* Return 0 if OK with change, else return non-zero */
+	int			(*flag_changed)(struct tracer *tracer,
+						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	int			print_max;
 	int			use_max_tr;
+	bool			enabled;
 };
 
 
@@ -840,6 +844,8 @@ extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
 void trace_printk_init_buffers(void);
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
+int set_tracer_flag(unsigned int mask, int enabled);
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 99d20e9..8dd139a 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -32,7 +32,7 @@ enum {
 
 static int trace_type __read_mostly;
 
-static int save_lat_flag;
+static int save_flags;
 
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -557,8 +557,11 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	irqsoff_trace = tr;
@@ -572,10 +575,13 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_irqsoff_tracer(tr, is_graph());
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -608,6 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
@@ -641,6 +648,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
@@ -676,6 +684,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index ff791ea..9eadedc 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -36,7 +36,7 @@ static void __wakeup_reset(struct trace_array *tr);
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
-static int save_lat_flag;
+static int save_flags;
 
 #define TRACE_DISPLAY_GRAPH     1
 
@@ -539,8 +539,11 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
@@ -562,12 +565,15 @@ static int wakeup_rt_tracer_init(struct trace_array *tr)
 
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_wakeup_tracer(tr);
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -593,6 +599,7 @@ static struct tracer wakeup_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
@@ -614,6 +621,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 8660231..a74dc5b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -39,6 +39,15 @@ int create_user_ns(struct cred *new)
 	kuid_t owner = new->euid;
 	kgid_t group = new->egid;
 
+	/*
+	 * Verify that we can not violate the policy of which files
+	 * may be accessed that is specified by the root directory,
+	 * by verifing that the root directory is at the root of the
+	 * mount namespace which allows all files to be accessed.
+	 */
+	if (current_chrooted())
+		return -EPERM;
+
 	/* The creator needs a mapping in the parent user namespace
 	 * or else we won't be able to reasonably tell userspace who
 	 * created a user_namespace.
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3adceaf..651d1ab 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2131,8 +2131,12 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	struct hstate *h = &default_hstate;
-	return h->nr_huge_pages * pages_per_huge_page(h);
+	struct hstate *h;
+	unsigned long nr_total_pages = 0;
+
+	for_each_hstate(h)
+		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
+	return nr_total_pages;
 }
 
 static int hugetlb_acct_memory(struct hstate *h, long delta)
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 9096bcb..8bdc56d 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -86,13 +86,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 
 	grp = &vlan_info->grp;
 
-	/* Take it out of our own structures, but be sure to interlock with
-	 * HW accelerating devices or SW vlan input packet processing if
-	 * VLAN is not 0 (leave it there for 802.1p).
-	 */
-	if (vlan_id)
-		vlan_vid_del(real_dev, vlan_id);
-
 	grp->nr_vlan_devs--;
 
 	if (vlan->flags & VLAN_FLAG_GVRP)
@@ -108,6 +101,13 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	if (grp->nr_vlan_devs == 0)
 		vlan_gvrp_uninit_applicant(real_dev);
 
+	/* Take it out of our own structures, but be sure to interlock with
+	 * HW accelerating devices or SW vlan input packet processing if
+	 * VLAN is not 0 (leave it there for 802.1p).
+	 */
+	if (vlan_id)
+		vlan_vid_del(real_dev, vlan_id);
+
 	/* Get rid of the vlan's reference to real_dev */
 	dev_put(real_dev);
 }
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 1476f26..aca451e 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1273,7 +1273,8 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 	batadv_ogm_packet = (struct batadv_ogm_packet *)packet_buff;
 
 	/* unpack the aggregated packets and process them one by one */
-	do {
+	while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
+					 batadv_ogm_packet->tt_num_changes)) {
 		tt_buff = packet_buff + buff_pos + BATADV_OGM_HLEN;
 
 		batadv_iv_ogm_process(ethhdr, batadv_ogm_packet, tt_buff,
@@ -1284,8 +1285,7 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 
 		batadv_ogm_packet = (struct batadv_ogm_packet *)
 						(packet_buff + buff_pos);
-	} while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
-					   batadv_ogm_packet->tt_num_changes));
+	}
 
 	kfree_skb(skb);
 	return NET_RX_SUCCESS;
diff --git a/net/core/dev.c b/net/core/dev.c
index c41efb7..9509394 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1481,7 +1481,6 @@ void net_enable_timestamp(void)
 		return;
 	}
 #endif
-	WARN_ON(in_interrupt());
 	static_key_slow_inc(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_enable_timestamp);
@@ -3154,6 +3153,7 @@ int netdev_rx_handler_register(struct net_device *dev,
 	if (dev->rx_handler)
 		return -EBUSY;
 
+	/* Note: rx_handler_data must be set before rx_handler */
 	rcu_assign_pointer(dev->rx_handler_data, rx_handler_data);
 	rcu_assign_pointer(dev->rx_handler, rx_handler);
 
@@ -3174,6 +3174,11 @@ void netdev_rx_handler_unregister(struct net_device *dev)
 
 	ASSERT_RTNL();
 	RCU_INIT_POINTER(dev->rx_handler, NULL);
+	/* a reader seeing a non NULL rx_handler in a rcu_read_lock()
+	 * section has a guarantee to see a non NULL rx_handler_data
+	 * as well.
+	 */
+	synchronize_net();
 	RCU_INIT_POINTER(dev->rx_handler_data, NULL);
 }
 EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4908588..1c854d4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2319,7 +2319,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct rtattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
 
 		while (RTA_OK(attr, attrlen)) {
-			unsigned int flavor = attr->rta_type;
+			unsigned int flavor = attr->rta_type & NLA_TYPE_MASK;
 			if (flavor) {
 				if (flavor > rta_max[sz_idx])
 					return -EINVAL;
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 85190e6..7112e6c 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -21,6 +21,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 
+#include <net/sock.h>
 #include <net/inet_frag.h>
 
 static void inet_frag_secret_rebuild(unsigned long dummy)
@@ -271,6 +272,7 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 {
 	struct inet_frag_queue *q;
 	struct hlist_node *n;
+	int depth = 0;
 
 	hlist_for_each_entry(q, n, &f->hash[hash], list) {
 		if (q->net == nf && f->match(q, key)) {
@@ -278,9 +280,25 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 			read_unlock(&f->lock);
 			return q;
 		}
+		depth++;
 	}
 	read_unlock(&f->lock);
 
-	return inet_frag_create(nf, f, key);
+	if (depth <= INETFRAGS_MAXDEPTH)
+		return inet_frag_create(nf, f, key);
+	else
+		return ERR_PTR(-ENOBUFS);
 }
 EXPORT_SYMBOL(inet_frag_find);
+
+void inet_frag_maybe_warn_overflow(struct inet_frag_queue *q,
+				   const char *prefix)
+{
+	static const char msg[] = "inet_frag_find: Fragment hash bucket"
+		" list length grew over limit " __stringify(INETFRAGS_MAXDEPTH)
+		". Dropping fragment.\n";
+
+	if (PTR_ERR(q) == -ENOBUFS)
+		LIMIT_NETDEBUG(KERN_WARNING "%s%s", prefix, msg);
+}
+EXPORT_SYMBOL(inet_frag_maybe_warn_overflow);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cea1859..578e536 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -299,14 +299,11 @@ static inline struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
 	hash = ipqhashfn(iph->id, iph->saddr, iph->daddr, iph->protocol);
 
 	q = inet_frag_find(&net->ipv4.frags, &ip4_frags, &arg, hash);
-	if (q == NULL)
-		goto out_nomem;
-
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
+		return NULL;
+	}
 	return container_of(q, struct ipq, q);
-
-out_nomem:
-	LIMIT_NETDEBUG(KERN_ERR pr_fmt("ip_frag_create: no memory left !\n"));
-	return NULL;
 }
 
 /* Is the fragment too far ahead to be part of ipq? */
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 3ee08ce..b062a98 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -946,12 +946,8 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 			ptr--;
 		}
 		if (tunnel->parms.o_flags&GRE_CSUM) {
-			int offset = skb_transport_offset(skb);
-
 			*ptr = 0;
-			*(__sum16 *)ptr = csum_fold(skb_checksum(skb, offset,
-								 skb->len - offset,
-								 0));
+			*(__sum16 *)ptr = ip_compute_csum((void *)(iph+1), skb->len - sizeof(struct iphdr));
 		}
 	}
 
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 1dc01f9..98e6916 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -370,7 +370,6 @@ int ip_options_compile(struct net *net,
 				}
 				switch (optptr[3]&0xF) {
 				      case IPOPT_TS_TSONLY:
-					opt->ts = optptr - iph;
 					if (skb)
 						timeptr = &optptr[optptr[2]-1];
 					opt->ts_needtime = 1;
@@ -381,7 +380,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					if (rt)  {
 						spec_dst_fill(&spec_dst, skb);
 						memcpy(&optptr[optptr[2]-1], &spec_dst, 4);
@@ -396,7 +394,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					{
 						__be32 addr;
 						memcpy(&addr, &optptr[optptr[2]-1], 4);
@@ -429,12 +426,12 @@ int ip_options_compile(struct net *net,
 					pp_ptr = optptr + 3;
 					goto error;
 				}
-				opt->ts = optptr - iph;
 				if (skb) {
 					optptr[3] = (optptr[3]&0xF)|((overflow+1)<<4);
 					opt->is_changed = 1;
 				}
 			}
+			opt->ts = optptr - iph;
 			break;
 		      case IPOPT_RA:
 			if (optlen < 4) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a07e91c..094a01f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -771,7 +771,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp)
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb->avail_size = size;
+			skb->reserved_tailroom = skb->end - skb->tail - size;
 			return skb;
 		}
 		__kfree_skb(skb);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 396c6ae..db1b172 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2083,11 +2083,8 @@ void tcp_enter_loss(struct sock *sk, int how)
 	if (tcp_is_reno(tp))
 		tcp_reset_reno_sack(tp);
 
-	if (!how) {
-		/* Push undo marker, if it was plain RTO and nothing
-		 * was retransmitted. */
-		tp->undo_marker = tp->snd_una;
-	} else {
+	tp->undo_marker = tp->snd_una;
+	if (how) {
 		tp->sacked_out = 0;
 		tp->fackets_out = 0;
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c883f4f..e6ed4ae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -285,13 +285,6 @@ static void tcp_v4_mtu_reduced(struct sock *sk)
 	struct inet_sock *inet = inet_sk(sk);
 	u32 mtu = tcp_sk(sk)->mtu_info;
 
-	/* We are not interested in TCP_LISTEN and open_requests (SYN-ACKs
-	 * send out by Linux are always <576bytes so they should go through
-	 * unfragmented).
-	 */
-	if (sk->sk_state == TCP_LISTEN)
-		return;
-
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -415,6 +408,13 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 			goto out;
 
 		if (code == ICMP_FRAG_NEEDED) { /* PMTU discovery (RFC1191) */
+			/* We are not interested in TCP_LISTEN and open_requests
+			 * (SYN-ACKs send out by Linux are always <576bytes so
+			 * they should go through unfragmented).
+			 */
+			if (sk->sk_state == TCP_LISTEN)
+				goto out;
+
 			tp->mtu_info = info;
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6a1cdc8..fb79daa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1289,7 +1289,6 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
-		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;
@@ -1801,8 +1800,11 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb)
 			goto send_now;
 	}
 
-	/* Ok, it looks like it is advisable to defer.  */
-	tp->tso_deferred = 1 | (jiffies << 1);
+	/* Ok, it looks like it is advisable to defer.
+	 * Do not rearm the timer if already set to not break TCP ACK clocking.
+	 */
+	if (!tp->tso_deferred)
+		tp->tso_deferred = 1 | (jiffies << 1);
 
 	return true;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index fd82a30..ec627b5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4653,26 +4653,20 @@ static void addrconf_sysctl_unregister(struct inet6_dev *idev)
 
 static int __net_init addrconf_init_net(struct net *net)
 {
-	int err;
+	int err = -ENOMEM;
 	struct ipv6_devconf *all, *dflt;
 
-	err = -ENOMEM;
-	all = &ipv6_devconf;
-	dflt = &ipv6_devconf_dflt;
+	all = kmemdup(&ipv6_devconf, sizeof(ipv6_devconf), GFP_KERNEL);
+	if (all == NULL)
+		goto err_alloc_all;
 
-	if (!net_eq(net, &init_net)) {
-		all = kmemdup(all, sizeof(ipv6_devconf), GFP_KERNEL);
-		if (all == NULL)
-			goto err_alloc_all;
+	dflt = kmemdup(&ipv6_devconf_dflt, sizeof(ipv6_devconf_dflt), GFP_KERNEL);
+	if (dflt == NULL)
+		goto err_alloc_dflt;
 
-		dflt = kmemdup(dflt, sizeof(ipv6_devconf_dflt), GFP_KERNEL);
-		if (dflt == NULL)
-			goto err_alloc_dflt;
-	} else {
-		/* these will be inherited by all namespaces */
-		dflt->autoconf = ipv6_defaults.autoconf;
-		dflt->disable_ipv6 = ipv6_defaults.disable_ipv6;
-	}
+	/* these will be inherited by all namespaces */
+	dflt->autoconf = ipv6_defaults.autoconf;
+	dflt->disable_ipv6 = ipv6_defaults.disable_ipv6;
 
 	net->ipv6.devconf_all = all;
 	net->ipv6.devconf_dflt = dflt;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index b196852..dee9964 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -118,6 +118,27 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 	    ipv6_addr_loopback(&hdr->daddr))
 		goto err;
 
+	/* RFC4291 Errata ID: 3480
+	 * Interface-Local scope spans only a single interface on a
+	 * node and is useful only for loopback transmission of
+	 * multicast.  Packets with interface-local scope received
+	 * from another node must be discarded.
+	 */
+	if (!(skb->pkt_type == PACKET_LOOPBACK ||
+	      dev->flags & IFF_LOOPBACK) &&
+	    ipv6_addr_is_multicast(&hdr->daddr) &&
+	    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 1)
+		goto err;
+
+	/* RFC4291 2.7
+	 * Nodes must not originate a packet to a multicast address whose scope
+	 * field contains the reserved value 0; if such a packet is received, it
+	 * must be silently dropped.
+	 */
+	if (ipv6_addr_is_multicast(&hdr->daddr) &&
+	    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 0)
+		goto err;
+
 	/*
 	 * RFC4291 2.7
 	 * Multicast addresses must not be used as source addresses in IPv6
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c9c78c2..f5ea02f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -14,6 +14,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) "IPv6-nf: " fmt
+
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -176,13 +178,11 @@ fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 
 	q = inet_frag_find(&nf_init_frags, &nf_frags, &arg, hash);
 	local_bh_enable();
-	if (q == NULL)
-		goto oom;
-
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
+		return NULL;
+	}
 	return container_of(q, struct nf_ct_frag6_queue, q);
-
-oom:
-	return NULL;
 }
 
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 4ff9af6..66d2096 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -26,6 +26,9 @@
  *	YOSHIFUJI,H. @USAGI	Always remove fragment header to
  *				calculate ICV correctly.
  */
+
+#define pr_fmt(fmt) "IPv6: " fmt
+
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -241,9 +244,10 @@ fq_find(struct net *net, __be32 id, const struct in6_addr *src, const struct in6
 	hash = inet6_hash_frag(id, src, dst, ip6_frags.rnd);
 
 	q = inet_frag_find(&net->ipv6.frags, &ip6_frags, &arg, hash);
-	if (q == NULL)
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
 		return NULL;
-
+	}
 	return container_of(q, struct frag_queue, q);
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8b45fb4..fe48fc9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -400,6 +400,13 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
+		/* We are not interested in TCP_LISTEN and open_requests
+		 * (SYN-ACKs send out by Linux are always <576bytes so
+		 * they should go through unfragmented).
+		 */
+		if (sk->sk_state == TCP_LISTEN)
+			goto out;
+
 		tp->mtu_info = ntohl(info);
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index bb738c9..73dfe2c 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2584,8 +2584,10 @@ bed:
 				    NULL, NULL, NULL);
 
 		/* Check if the we got some results */
-		if (!self->cachedaddr)
-			return -EAGAIN;		/* Didn't find any devices */
+		if (!self->cachedaddr) {
+			err = -EAGAIN;		/* Didn't find any devices */
+			goto out;
+		}
 		daddr = self->cachedaddr;
 		/* Cleanup */
 		self->cachedaddr = 0;
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 69bf48d..76125c5 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -67,6 +67,7 @@ static inline struct l2tp_eth_net *l2tp_eth_pernet(struct net *net)
 	return net_generic(net, l2tp_eth_net_id);
 }
 
+static struct lock_class_key l2tp_eth_tx_busylock;
 static int l2tp_eth_dev_init(struct net_device *dev)
 {
 	struct l2tp_eth *priv = netdev_priv(dev);
@@ -74,7 +75,7 @@ static int l2tp_eth_dev_init(struct net_device *dev)
 	priv->dev = dev;
 	eth_hw_addr_random(dev);
 	memset(&dev->broadcast[0], 0xff, 6);
-
+	dev->qdisc_tx_busylock = &l2tp_eth_tx_busylock;
 	return 0;
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 31aa8b8..d82dec3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -656,6 +656,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata;
 	int ret, i, ac;
 	struct tid_ampdu_tx *tid_tx;
+	bool have_key = false;
 
 	might_sleep();
 
@@ -683,12 +684,19 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
-	if (sta->ptk)
+		have_key = true;
+	}
+	if (sta->ptk) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
+		have_key = true;
+	}
 	mutex_unlock(&local->key_mtx);
 
+	if (!have_key)
+		synchronize_net();
+
 	sta->dead = true;
 
 	local->num_sta--;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index fda4974..42556ce 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -142,6 +142,7 @@ int genl_register_mc_group(struct genl_family *family,
 	int err = 0;
 
 	BUG_ON(grp->name[0] == '\0');
+	BUG_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL);
 
 	genl_lock();
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 4e606fc..5578628 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -195,7 +195,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 		flow->deficit = q->quantum;
 		flow->dropped = 0;
 	}
-	if (++sch->q.qlen < sch->limit)
+	if (++sch->q.qlen <= sch->limit)
 		return NET_XMIT_SUCCESS;
 
 	q->drop_overlimit++;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 511323e..b62b33d 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -545,6 +545,8 @@ struct Qdisc_ops pfifo_fast_ops __read_mostly = {
 };
 EXPORT_SYMBOL(pfifo_fast_ops);
 
+static struct lock_class_key qdisc_tx_busylock;
+
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  struct Qdisc_ops *ops)
 {
@@ -552,6 +554,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	struct Qdisc *sch;
 	unsigned int size = QDISC_ALIGN(sizeof(*sch)) + ops->priv_size;
 	int err = -ENOBUFS;
+	struct net_device *dev = dev_queue->dev;
 
 	p = kzalloc_node(size, GFP_KERNEL,
 			 netdev_queue_numa_node_read(dev_queue));
@@ -571,12 +574,16 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	}
 	INIT_LIST_HEAD(&sch->list);
 	skb_queue_head_init(&sch->q);
+
 	spin_lock_init(&sch->busylock);
+	lockdep_set_class(&sch->busylock,
+			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
+
 	sch->ops = ops;
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
-	dev_hold(qdisc_dev(sch));
+	dev_hold(dev);
 	atomic_set(&sch->refcnt, 1);
 
 	return sch;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index ebaef3e..247abb9 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1074,7 +1074,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
 			transports) {
 
 		if (transport == active)
-			break;
+			continue;
 		list_for_each_entry(chunk, &transport->transmitted,
 				transmitted_list) {
 			if (key == chunk->subh.data_hdr->tsn) {
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 9fca103..469ef67 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2042,7 +2042,7 @@ sctp_disposition_t sctp_sf_do_5_2_4_dupcook(const struct sctp_endpoint *ep,
 	}
 
 	/* Delete the tempory new association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
+	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 
 	/* Restore association pointer to provide SCTP command interpeter
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 128494e..cd09810 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -143,6 +143,8 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 		list_add_tail(&task->u.tk_wait.list, &queue->tasks[0]);
 	task->tk_waitqueue = queue;
 	queue->qlen++;
+	/* barrier matches the read in rpc_wake_up_task_queue_locked() */
+	smp_wmb();
 	rpc_set_queued(task);
 
 	dprintk("RPC: %5u added to queue %p \"%s\"\n",
@@ -400,8 +402,11 @@ static void __rpc_do_wake_up_task(struct rpc_wait_queue *queue, struct rpc_task
  */
 static void rpc_wake_up_task_queue_locked(struct rpc_wait_queue *queue, struct rpc_task *task)
 {
-	if (RPC_IS_QUEUED(task) && task->tk_waitqueue == queue)
-		__rpc_do_wake_up_task(queue, task);
+	if (RPC_IS_QUEUED(task)) {
+		smp_rmb();
+		if (task->tk_waitqueue == queue)
+			__rpc_do_wake_up_task(queue, task);
+	}
 }
 
 /*
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c5ee4ff..1b3abc8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -384,7 +384,7 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
-static int unix_release_sock(struct sock *sk, int embrion)
+static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct path path;
@@ -453,8 +453,6 @@ static int unix_release_sock(struct sock *sk, int embrion)
 
 	if (unix_tot_inflight)
 		unix_gc();		/* Garbage collect fds */
-
-	return 0;
 }
 
 static void init_peercred(struct sock *sk)
@@ -704,9 +702,10 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-	return unix_release_sock(sk, 0);
+	return 0;
 }
 
 static int unix_autobind(struct socket *sock)
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 38fdefc..f60254d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2970,7 +2970,7 @@ static unsigned int convert_to_spdif_status(unsigned short val)
 	if (val & AC_DIG1_PROFESSIONAL)
 		sbits |= IEC958_AES0_PROFESSIONAL;
 	if (sbits & IEC958_AES0_PROFESSIONAL) {
-		if (sbits & AC_DIG1_EMPHASIS)
+		if (val & AC_DIG1_EMPHASIS)
 			sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
 	} else {
 		if (val & AC_DIG1_EMPHASIS)
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 784017e..ee23081 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1182,7 +1182,7 @@ static int patch_cxt5045(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -1961,7 +1961,7 @@ static int patch_cxt5051(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -3143,7 +3143,7 @@ static int patch_cxt5066(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -4538,7 +4538,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	spec->capture_stream = &cx_auto_pcm_analog_capture;
 	codec->patch_ops = cx_auto_patch_ops;
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	/* Some laptops with Conexant chips show stalls in S3 resume,
 	 * which falls into the single-cmd mode.
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 298070e..900bf42 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -711,8 +711,9 @@ static int check_input_term(struct mixer_build *state, int id, struct usb_audio_
 		case UAC2_CLOCK_SELECTOR: {
 			struct uac_selector_unit_descriptor *d = p1;
 			/* call recursively to retrieve the channel info */
-			if (check_input_term(state, d->baSourceID[0], term) < 0)
-				return -ENODEV;
+			err = check_input_term(state, d->baSourceID[0], term);
+			if (err < 0)
+				return err;
 			term->type = d->bDescriptorSubtype << 16; /* virtual type */
 			term->id = id;
 			term->name = uac_selector_unit_iSelector(d);
@@ -1276,8 +1277,9 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid, void
 		return err;
 
 	/* determine the input source type and name */
-	if (check_input_term(state, hdr->bSourceID, &iterm) < 0)
-		return -EINVAL;
+	err = check_input_term(state, hdr->bSourceID, &iterm);
+	if (err < 0)
+		return err;
 
 	master_bits = snd_usb_combine_bytes(bmaControls, csize);
 	/* master configuration quirks */
@@ -2038,7 +2040,7 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		} else { /* UAC_VERSION_2 */
 			struct uac2_output_terminal_descriptor *desc = p;
@@ -2050,12 +2052,12 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 
 			/* for UAC2, use the same approach to also add the clock selectors */
 			err = parse_audio_unit(&state, desc->bCSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		}
 	}


