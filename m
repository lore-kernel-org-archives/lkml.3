Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbaGPEON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:14:13 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:47980 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaGPEOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:14:10 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] alpha: Converse all space errors into tabs in mkbb.c
Date: Wed, 16 Jul 2014 00:13:59 -0400
Message-Id: <1405484042-6879-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all the checkpatch errors I get when running it
on mkbb.c for spaces at beginning of lines. I converted then all
to tabs to fix these checkpatch warnings.
---
 arch/alpha/boot/tools/mkbb.c | 124 +++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/arch/alpha/boot/tools/mkbb.c b/arch/alpha/boot/tools/mkbb.c
index 1185778..6f1b957 100644
--- a/arch/alpha/boot/tools/mkbb.c
+++ b/arch/alpha/boot/tools/mkbb.c
@@ -34,49 +34,49 @@
 #endif
 
 struct disklabel {
-    u32	d_magic;				/* must be DISKLABELMAGIC */
-    u16	d_type, d_subtype;
-    u8	d_typename[16];
-    u8	d_packname[16];
-    u32	d_secsize;
-    u32	d_nsectors;
-    u32	d_ntracks;
-    u32	d_ncylinders;
-    u32	d_secpercyl;
-    u32	d_secprtunit;
-    u16	d_sparespertrack;
-    u16	d_sparespercyl;
-    u32	d_acylinders;
-    u16	d_rpm, d_interleave, d_trackskew, d_cylskew;
-    u32	d_headswitch, d_trkseek, d_flags;
-    u32	d_drivedata[5];
-    u32	d_spare[5];
-    u32	d_magic2;				/* must be DISKLABELMAGIC */
-    u16	d_checksum;
-    u16	d_npartitions;
-    u32	d_bbsize, d_sbsize;
-    struct d_partition {
+	u32	d_magic;	/* must be DISKLABELMAGIC */
+	u16	d_type, d_subtype;
+	u8	d_typename[16];
+	u8	d_packname[16];
+	u32	d_secsize;
+	u32	d_nsectors;
+	u32	d_ntracks;
+	u32	d_ncylinders;
+	u32	d_secpercyl;
+	u32	d_secprtunit;
+	u16	d_sparespertrack;
+	u16	d_sparespercyl;
+	u32	d_acylinders;
+	u16	d_rpm, d_interleave, d_trackskew, d_cylskew;
+	u32	d_headswitch, d_trkseek, d_flags;
+	u32	d_drivedata[5];
+	u32	d_spare[5];
+	u32	d_magic2;				/* must be DISKLABELMAGIC */
+	u16	d_checksum;
+	u16	d_npartitions;
+	u32	d_bbsize, d_sbsize;
+	struct d_partition {
 	u32	p_size;
 	u32	p_offset;
 	u32	p_fsize;
 	u8	p_fstype;
 	u8	p_frag;
 	u16	p_cpg;
-    } d_partitions[MAXPARTITIONS];
+	} d_partitions[MAXPARTITIONS];
 };
 
 
 typedef union __bootblock {
-    struct {
-        char			__pad1[64];
-        struct disklabel	__label;
-    } __u1;
-    struct {
+	struct {
+	char			__pad1[64];
+	struct disklabel	__label;
+	} __u1;
+	struct {
 	unsigned long		__pad2[63];
 	unsigned long		__checksum;
-    } __u2;
-    char		bootblock_bytes[512];
-    unsigned long	bootblock_quadwords[64];
+	} __u2;
+	char		bootblock_bytes[512];
+	unsigned long	bootblock_quadwords[64];
 } bootblock;
 
 #define	bootblock_label		__u1.__label
@@ -84,69 +84,67 @@ typedef union __bootblock {
 
 int main(int argc, char ** argv)
 {
-    bootblock		bootblock_from_disk;
-    bootblock		bootloader_image;
-    int			dev, fd;
-    int			i;
-    int			nread;
+	bootblock		bootblock_from_disk;
+	bootblock		bootloader_image;
+	int			dev, fd;
+	int			i;
+	int			nread;
 
     /* Make sure of the arg count */
-    if(argc != 3) {
+	if(argc != 3) {
 	fprintf(stderr, "Usage: %s device lxboot\n", argv[0]);
 	exit(0);
-    }
+	}
 
     /* First, open the device and make sure it's accessible */
-    dev = open(argv[1], O_RDWR);
-    if(dev < 0) {
+	dev = open(argv[1], O_RDWR);
+	if(dev < 0) {
 	perror(argv[1]);
 	exit(0);
-    }
+	}
 
     /* Now open the lxboot and make sure it's reasonable */
-    fd = open(argv[2], O_RDONLY);
-    if(fd < 0) {
+	fd = open(argv[2], O_RDONLY);
+	if(fd < 0) {
 	perror(argv[2]);
 	close(dev);
 	exit(0);
-    }
+	}
 
     /* Read in the lxboot */
-    nread = read(fd, &bootloader_image, sizeof(bootblock));
-    if(nread != sizeof(bootblock)) {
+	nread = read(fd, &bootloader_image, sizeof(bootblock));
+	if(nread != sizeof(bootblock)) {
 	perror("lxboot read");
 	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
-    }
+	}
 
     /* Read in the bootblock from disk. */
-    nread = read(dev, &bootblock_from_disk, sizeof(bootblock));
-    if(nread != sizeof(bootblock)) {
+	nread = read(dev, &bootblock_from_disk, sizeof(bootblock));
+	if(nread != sizeof(bootblock)) {
 	perror("bootblock read");
 	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
-    }
+	}
 
     /* Swap the bootblock's disklabel into the bootloader */
-    bootloader_image.bootblock_label = bootblock_from_disk.bootblock_label;
+	bootloader_image.bootblock_label = bootblock_from_disk.bootblock_label;
 
     /* Calculate the bootblock checksum */
-    bootloader_image.bootblock_checksum = 0;
-    for(i = 0; i < 63; i++) {
-	bootloader_image.bootblock_checksum += 
+	bootloader_image.bootblock_checksum = 0;
+	for(i = 0; i < 63; i++) {
+	bootloader_image.bootblock_checksum +=
 			bootloader_image.bootblock_quadwords[i];
-    }
+	}
 
     /* Write the whole thing out! */
-    lseek(dev, 0L, SEEK_SET);
-    if(write(dev, &bootloader_image, sizeof(bootblock)) != sizeof(bootblock)) {
+	lseek(dev, 0L, SEEK_SET);
+	if(write(dev, &bootloader_image, sizeof(bootblock)) != sizeof(bootblock)) {
 	perror("bootblock write");
 	exit(0);
-    }
+	}
 
-    close(fd);
-    close(dev);
-    exit(0);
+	close(fd);
+	close(dev);
+	exit(0);
 }
-
-
-- 
1.9.1

