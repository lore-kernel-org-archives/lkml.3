Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaC1SEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:04:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47811 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaC1SEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:04:46 -0400
Message-ID: <5335B9BA.3070408@gmail.com>
Date: Fri, 28 Mar 2014 18:04:42 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] Subject: ata: libata  Fixed Coding style & tabs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 718d05b6aae57da1a990e38b99a4e3d880717d77 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Fri, 28 Mar 2014 17:58:02 +0000
Subject: [PATCH] Subject: ata: libata  Fixed Coding style & tabs

Made files below checkpatch.pl clean.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/ata/acard-ahci.c       |  3 +--
 drivers/ata/ahci.c             |  2 +-
 drivers/ata/ahci.h             |  6 ++---
 drivers/ata/ata_generic.c      | 10 ++++----
 drivers/ata/ata_piix.c         | 53 ++++++++++++++----------------------------
 drivers/ata/libata-core.c      |  2 +-
 drivers/ata/libata-eh.c        | 15 +++++++-----
 drivers/ata/libata-pmp.c       |  3 +--
 drivers/ata/libata-scsi.c      | 14 +++++------
 drivers/ata/libata-sff.c       |  4 ++--
 drivers/ata/libata-transport.c | 16 ++++++-------
 drivers/ata/libata.h           |  2 +-
 drivers/ata/pata_ali.c         | 16 ++++++-------
 13 files changed, 65 insertions(+), 81 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index fd665d9..9a1f919 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -97,8 +97,7 @@ static struct ata_port_operations acard_ops = {
 #define AHCI_HFLAGS(flags)    .private_data    = (void *)(flags)
 
 static const struct ata_port_info acard_ahci_port_info[] = {
-    [board_acard_ahci] =
-    {
+    [board_acard_ahci] = {
         AHCI_HFLAGS    (AHCI_HFLAG_NO_NCQ),
         .flags        = AHCI_FLAG_COMMON,
         .pio_mask    = ATA_PIO4,
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c81d809..49191c1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1233,7 +1233,7 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
         return rc;
 
     for (i = 0; i < host->n_ports; i++) {
-        const char* desc;
+        const char *desc;
         struct ahci_port_priv *pp = host->ports[i]->private_data;
 
         /* pp is NULL for dummy ports */
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2289efd..2b59473 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -229,8 +229,8 @@ enum {
     AHCI_HFLAG_NO_FPDMA_AA        = (1 << 13), /* no FPDMA AA */
     AHCI_HFLAG_YES_FBS        = (1 << 14), /* force FBS cap on */
     AHCI_HFLAG_DELAY_ENGINE        = (1 << 15), /* do not start engine on
-                                port start (wait until
-                                error-handling stage) */
+                            port start (wait until
+                            error-handling stage) */
     AHCI_HFLAG_MULTI_MSI        = (1 << 16), /* multiple PCI MSIs */
 
     /* ap->flags bits */
@@ -310,7 +310,7 @@ struct ahci_port_priv {
 };
 
 struct ahci_host_priv {
-    void __iomem *        mmio;        /* bus-independent mem map */
+    void __iomem          *mmio;        /* bus-independent mem map */
     unsigned int        flags;        /* AHCI_HFLAG_* */
     u32            cap;        /* cap to use */
     u32            cap2;        /* cap2 to use */
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 7d19665..48c0114 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -219,13 +219,13 @@ static struct pci_device_id ata_generic[] = {
     { PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
     { PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
     { PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
-    { PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE),
+    { PCI_DEVICE(PCI_VENDOR_ID_CENATEK, PCI_DEVICE_ID_CENATEK_IDE),
       .driver_data = ATA_GEN_FORCE_DMA },
 #if !defined(CONFIG_PATA_TOSHIBA) && !defined(CONFIG_PATA_TOSHIBA_MODULE)
-    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
-    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
-    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
-    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
+    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
+    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
+    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
+    { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
 #endif
     /* Intel, IDE class device */
     { PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6334c8d..f6563fa 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -560,7 +560,7 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
     struct pci_dev *dev    = to_pci_dev(ap->host->dev);
     unsigned long flags;
     unsigned int is_slave    = (adev->devno != 0);
-    unsigned int master_port= ap->port_no ? 0x42 : 0x40;
+    unsigned int master_port = ap->port_no ? 0x42 : 0x40;
     unsigned int slave_port    = 0x44;
     u16 master_data;
     u8 slave_data;
@@ -1114,16 +1114,14 @@ static struct ata_port_operations piix_sidpr_sata_ops = {
 };
 
 static struct ata_port_info piix_port_info[] = {
-    [piix_pata_mwdma] =    /* PIIX3 MWDMA only */
-    {
+    [piix_pata_mwdma] = {    /* PIIX3 MWDMA only */
         .flags        = PIIX_PATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
         .port_ops    = &piix_pata_ops,
     },
 
-    [piix_pata_33] =    /* PIIX4 at 33MHz */
-    {
+    [piix_pata_33] = {    /* PIIX4 at 33MHz */
         .flags        = PIIX_PATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
@@ -1131,8 +1129,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_pata_ops,
     },
 
-    [ich_pata_33] =        /* ICH0 - ICH at 33Mhz*/
-    {
+    [ich_pata_33] =    {    /* ICH0 - ICH at 33Mhz*/
         .flags        = PIIX_PATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
@@ -1140,8 +1137,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &ich_pata_ops,
     },
 
-    [ich_pata_66] =        /* ICH controllers up to 66MHz */
-    {
+    [ich_pata_66] =    {    /* ICH controllers up to 66MHz */
         .flags        = PIIX_PATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
@@ -1149,8 +1145,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &ich_pata_ops,
     },
 
-    [ich_pata_100] =
-    {
+    [ich_pata_100] = {
         .flags        = PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY,
@@ -1158,8 +1153,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &ich_pata_ops,
     },
 
-    [ich_pata_100_nomwdma1] =
-    {
+    [ich_pata_100_nomwdma1] = {
         .flags        = PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2_ONLY,
@@ -1167,8 +1161,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &ich_pata_ops,
     },
 
-    [ich5_sata] =
-    {
+    [ich5_sata] = {
         .flags        = PIIX_SATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1176,8 +1169,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich6_sata] =
-    {
+    [ich6_sata] = {
         .flags        = PIIX_SATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1185,8 +1177,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich6m_sata] =
-    {
+    [ich6m_sata] = {
         .flags        = PIIX_SATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1194,8 +1185,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich8_sata] =
-    {
+    [ich8_sata] = {
         .flags        = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1203,8 +1193,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich8_2port_sata] =
-    {
+    [ich8_2port_sata] = {
         .flags        = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1212,8 +1201,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [tolapai_sata] =
-    {
+    [tolapai_sata] = {
         .flags        = PIIX_SATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1221,8 +1209,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich8m_apple_sata] =
-    {
+    [ich8m_apple_sata] = {
         .flags        = PIIX_SATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1230,8 +1217,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [piix_pata_vmw] =
-    {
+    [piix_pata_vmw] = {
         .flags        = PIIX_PATA_FLAGS,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
@@ -1243,8 +1229,7 @@ static struct ata_port_info piix_port_info[] = {
      * some Sandybridge chipsets have broken 32 mode up to now,
      * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
      */
-    [ich8_sata_snb] =
-    {
+    [ich8_sata_snb] = {
         .flags        = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
         .pio_mask    = ATA_PIO4,
         .mwdma_mask    = ATA_MWDMA2,
@@ -1252,8 +1237,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich8_2port_sata_snb] =
-    {
+    [ich8_2port_sata_snb] = {
         .flags        = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
                     | PIIX_FLAG_PIO16,
         .pio_mask    = ATA_PIO4,
@@ -1262,8 +1246,7 @@ static struct ata_port_info piix_port_info[] = {
         .port_ops    = &piix_sata_ops,
     },
 
-    [ich8_2port_sata_byt] =
-    {
+    [ich8_2port_sata_byt] = {
         .flags          = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
         .pio_mask       = ATA_PIO4,
         .mwdma_mask     = ATA_MWDMA2,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8cb2522..3f840e8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5843,7 +5843,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
  *    Inherited from calling layer (may sleep).
  */
 struct ata_host *ata_host_alloc_pinfo(struct device *dev,
-                      const struct ata_port_info * const * ppi,
+                      const struct ata_port_info * const *ppi,
                       int n_ports)
 {
     const struct ata_port_info *pi;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6d87570..35eb92c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1627,8 +1627,9 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 unsigned int atapi_eh_request_sense(struct ata_device *dev,
                        u8 *sense_buf, u8 dfl_sense_key)
 {
-    u8 cdb[ATAPI_CDB_LEN] =
-        { REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };
+    u8 cdb[ATAPI_CDB_LEN] = {
+        REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0
+     };
     struct ata_port *ap = dev->link->ap;
     struct ata_taskfile tf;
 
@@ -2042,10 +2043,12 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 
         /* lower transfer mode */
         if (dev->spdn_cnt < 2) {
-            static const int dma_dnxfer_sel[] =
-                { ATA_DNXFER_DMA, ATA_DNXFER_40C };
-            static const int pio_dnxfer_sel[] =
-                { ATA_DNXFER_PIO, ATA_DNXFER_FORCE_PIO0 };
+            static const int dma_dnxfer_sel[] = {
+                ATA_DNXFER_DMA, ATA_DNXFER_40C
+            };
+            static const int pio_dnxfer_sel[] = {
+                ATA_DNXFER_PIO, ATA_DNXFER_FORCE_PIO0
+            };
             int sel;
 
             if (dev->xfer_shift != ATA_SHIFT_PIO)
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 7ccc084..7981b20 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -352,9 +352,8 @@ static int sata_pmp_init_links (struct ata_port *ap, int nr_ports)
 
         for (i = 0; i < SATA_PMP_MAX_PORTS; i++) {
             err = ata_tlink_add(&pmp_link[i]);
-            if (err) {
+            if (err)
                 goto err_tlink;
-            }
         }
     }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef8567d..6c2bf19 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -948,7 +948,7 @@ static void ata_to_sense_error(unsigned id, u8 drv_stat, u8 drv_err, u8 *sk,
  *    passthrough command, so we use the following sense data:
  *    sk = RECOVERED ERROR
  *    asc,ascq = ATA PASS-THROUGH INFORMATION AVAILABLE
- *      
+ *
  *
  *    LOCKING:
  *    None.
@@ -2390,7 +2390,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
     if (spg && (spg != ALL_SUB_MPAGES))
         goto invalid_fld;
 
-    switch(pg) {
+    switch (pg) {
     case RW_RECOVERY_MPAGE:
         p += ata_msense_rw_recovery(p, page_control == 1);
         break;
@@ -2500,8 +2500,8 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
         rbuf[7] = last_lba;
 
         /* sector size */
-        rbuf[ 8] = sector_size >> (8 * 3);
-        rbuf[ 9] = sector_size >> (8 * 2);
+        rbuf[8] = sector_size >> (8 * 3);
+        rbuf[9] = sector_size >> (8 * 2);
         rbuf[10] = sector_size >> (8 * 1);
         rbuf[11] = sector_size;
 
@@ -2557,7 +2557,7 @@ static void atapi_sense_complete(struct ata_queued_cmd *qc)
 /* is it pointless to prefer PIO for "safety reasons"? */
 static inline int ata_pio_use_silly(struct ata_port *ap)
 {
-    return (ap->flags & ATA_FLAG_PIO_DMA);
+    return ap->flags & ATA_FLAG_PIO_DMA;
 }
 
 static void atapi_request_sense(struct ata_queued_cmd *qc)
@@ -2858,7 +2858,7 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 static u8
 ata_scsi_map_proto(u8 byte1)
 {
-    switch((byte1 & 0x1e) >> 1) {
+    switch ((byte1 & 0x1e) >> 1) {
     case 3:        /* Non-data */
         return ATA_PROT_NODATA;
 
@@ -3518,7 +3518,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
     args.cmd = cmd;
     args.done = cmd->scsi_done;
 
-    switch(scsicmd[0]) {
+    switch (scsicmd[0]) {
     /* TODO: worth improving? */
     case FORMAT_UNIT:
         ata_scsi_invalid_field(cmd);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b603720..20eada3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3271,7 +3271,7 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
  *    0 on success, -errno otherwise.
  */
 int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
-                   const struct ata_port_info * const * ppi,
+                   const struct ata_port_info * const *ppi,
                    struct ata_host **r_host)
 {
     int rc;
@@ -3303,7 +3303,7 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
  *    Zero on success, negative on errno-based value on error.
  */
 int ata_pci_bmdma_init_one(struct pci_dev *pdev,
-               const struct ata_port_info * const * ppi,
+               const struct ata_port_info * const *ppi,
                struct scsi_host_template *sht, void *host_priv,
                int hflags)
 {
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index e37413228..0454e8e 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -487,16 +487,16 @@ static DEVICE_ATTR(field, S_IRUGO,             \
 ata_dev_simple_attr(spdn_cnt, "%d\n", int);
 
 struct ata_show_ering_arg {
-    char* buf;
+    char *buf;
     int written;
 };
 
 static int ata_show_ering(struct ata_ering_entry *ent, void *void_arg)
 {
-    struct ata_show_ering_arg* arg = void_arg;
+    struct ata_show_ering_arg *arg = void_arg;
     struct timespec time;
 
-    jiffies_to_timespec(ent->timestamp,&time);
+    jiffies_to_timespec(ent->timestamp, &time);
     arg->written += sprintf(arg->buf + arg->written,
                    "[%5lu.%06lu]",
                    time.tv_sec, time.tv_nsec);
@@ -528,7 +528,7 @@ show_ata_dev_id(struct device *dev,
 
     if (ata_dev->class == ATA_DEV_PMP)
         return 0;
-    for(i=0;i<ATA_ID_WORDS;i++)  {
+    for (i = 0; i < ATA_ID_WORDS; i++) {
         written += snprintf(buf+written, 20, "%04x%c",
                     ata_dev->id[i],
                     ((i+1) & 7) ? ' ' : '\n');
@@ -547,7 +547,7 @@ show_ata_dev_gscr(struct device *dev,
 
     if (ata_dev->class != ATA_DEV_PMP)
         return 0;
-    for(i=0;i<SATA_PMP_GSCR_DWORDS;i++)  {
+    for (i = 0; i < SATA_PMP_GSCR_DWORDS; i++) {
         written += snprintf(buf+written, 20, "%08x%c",
                     ata_dev->gscr[i],
                     ((i+1) & 3) ? ' ' : '\n');
@@ -582,7 +582,7 @@ static int ata_is_ata_dev(const struct device *dev)
 static int ata_tdev_match(struct attribute_container *cont,
               struct device *dev)
 {
-    struct ata_internal* i = to_ata_internal(ata_scsi_transport_template);
+    struct ata_internal *i = to_ata_internal(ata_scsi_transport_template);
     if (!ata_is_ata_dev(dev))
         return 0;
     return &i->dev_attr_cont.ac == cont;
@@ -640,8 +640,8 @@ static int ata_tdev_add(struct ata_device *ata_dev)
     dev->parent = get_device(&link->tdev);
     dev->release = ata_tdev_release;
     if (ata_is_host_link(link))
-        dev_set_name(dev, "dev%d.%d", ap->print_id,ata_dev->devno);
-        else
+        dev_set_name(dev, "dev%d.%d", ap->print_id, ata_dev->devno);
+    else
         dev_set_name(dev, "dev%d.%d.0", ap->print_id, link->pmp);
 
     transport_setup_device(dev);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 45b5ab3..4190712 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -178,7 +178,7 @@ extern int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 extern void ata_eh_finish(struct ata_port *ap);
 extern int ata_ering_map(struct ata_ering *ering,
              int (*map_fn)(struct ata_ering_entry *, void *),
-               void *arg);
+            void *arg);
 extern unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
 extern unsigned int atapi_eh_request_sense(struct ata_device *dev,
                        u8 *sense_buf, u8 dfl_sense_key);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 1b7b2cc..6505b85 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -69,7 +69,7 @@ static int ali_cable_override(struct pci_dev *pdev)
 {
     /* Fujitsu P2000 */
     if (pdev->subsystem_vendor == 0x10CF && pdev->subsystem_device == 0x10AF)
-           return 1;
+        return 1;
     /* Mitac 8317 (Winbook-A) and relatives */
     if (pdev->subsystem_vendor == 0x1071 && pdev->subsystem_device == 0x8317)
         return 1;
@@ -466,7 +466,7 @@ static void ali_init_chipset(struct pci_dev *pdev)
             tmp |= 0x01;    /* CD_ROM enable for DMA */
         pci_write_config_byte(pdev, 0x53, tmp);
     }
-    north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+    north = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
     if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
         /* Configure the ALi bridge logic. For non ALi rely on BIOS.
            Set the south bridge enable bit */
@@ -564,15 +564,15 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
     if (pdev->revision < 0x20) {
         ppi[0] = &info_early;
     } else if (pdev->revision < 0xC2) {
-            ppi[0] = &info_20;
+        ppi[0] = &info_20;
     } else if (pdev->revision == 0xC2) {
-            ppi[0] = &info_c2;
+        ppi[0] = &info_c2;
     } else if (pdev->revision == 0xC3) {
-            ppi[0] = &info_c3;
+        ppi[0] = &info_c3;
     } else if (pdev->revision == 0xC4) {
-            ppi[0] = &info_c4;
+        ppi[0] = &info_c4;
     } else
-            ppi[0] = &info_c5;
+        ppi[0] = &info_c5;
 
     ali_init_chipset(pdev);
 
@@ -580,7 +580,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
         /* Are we paired with a UDMA capable chip */
         pci_read_config_byte(ali_isa_bridge, 0x5E, &tmp);
         if ((tmp & 0x1E) == 0x12)
-                ppi[0] = &info_20_udma;
+            ppi[0] = &info_20_udma;
     }
 
     if (!ppi[0]->mwdma_mask && !ppi[0]->udma_mask)
-- 
1.8.3.2

