Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbbAUP0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:26:36 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36072 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbAUPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:25:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com
Subject: [PATCH v4 08/10] mtd: st_spi_fsm: General tidy-up
Date: Wed, 21 Jan 2015 15:24:26 +0000
Message-Id: <1421853868-8262-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
References: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the nature of the port (lots of copy/paste) much of the white-space
is taken up by spaces instead of tab separators. This patch aims to change
that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 280 +++++++++++++++++++--------------------
 1 file changed, 140 insertions(+), 140 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 5e365ef..5733022 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -97,9 +97,9 @@
 #define SPI_CFG_CS_SETUPHOLD(x)		(((x) & 0xff) << 16)
 #define SPI_CFG_DATA_HOLD(x)		(((x) & 0xff) << 24)
 
-#define SPI_CFG_DEFAULT_MIN_CS_HIGH    SPI_CFG_MIN_CS_HIGH(0x0AA)
-#define SPI_CFG_DEFAULT_CS_SETUPHOLD   SPI_CFG_CS_SETUPHOLD(0xA0)
-#define SPI_CFG_DEFAULT_DATA_HOLD      SPI_CFG_DATA_HOLD(0x00)
+#define SPI_CFG_DEFAULT_MIN_CS_HIGH	SPI_CFG_MIN_CS_HIGH(0x0AA)
+#define SPI_CFG_DEFAULT_CS_SETUPHOLD	SPI_CFG_CS_SETUPHOLD(0xA0)
+#define SPI_CFG_DEFAULT_DATA_HOLD	SPI_CFG_DATA_HOLD(0x00)
 
 /*
  * Register: SPI_FAST_SEQ_TRANSFER_SIZE
@@ -179,7 +179,7 @@
 #define STFSM_OPC_ADD			0x2
 #define STFSM_OPC_STA			0x3
 #define STFSM_OPC_MODE			0x4
-#define STFSM_OPC_DUMMY		0x5
+#define STFSM_OPC_DUMMY			0x5
 #define STFSM_OPC_DATA			0x6
 #define STFSM_OPC_WAIT			0x7
 #define STFSM_OPC_JUMP			0x8
@@ -212,88 +212,87 @@
 #define STFSM_INST_WAIT			STFSM_INSTR(STFSM_OPC_WAIT,	0)
 #define STFSM_INST_STOP			STFSM_INSTR(STFSM_OPC_STOP,	0)
 
-#define STFSM_DEFAULT_EMI_FREQ 100000000UL                        /* 100 MHz */
-#define STFSM_DEFAULT_WR_TIME  (STFSM_DEFAULT_EMI_FREQ * (15/1000)) /* 15ms */
+#define STFSM_DEFAULT_EMI_FREQ		100000000UL	/* 100 MHz */
+#define STFSM_DEFAULT_WR_TIME	(STFSM_DEFAULT_EMI_FREQ * (15/1000)) /* 15ms */
 
-#define STFSM_FLASH_SAFE_FREQ  10000000UL                         /* 10 MHz */
+#define STFSM_FLASH_SAFE_FREQ		10000000UL	/* 10 MHz */
 
-#define STFSM_MAX_WAIT_SEQ_MS  1000     /* FSM execution time */
+#define STFSM_MAX_WAIT_SEQ_MS		1000		/* FSM execution time */
 
 /* S25FLxxxS commands */
-#define S25FL_CMD_WRITE4_1_1_4 0x34
-#define S25FL_CMD_SE4          0xdc
-#define S25FL_CMD_CLSR         0x30
-#define S25FL_CMD_DYBWR                0xe1
-#define S25FL_CMD_DYBRD                0xe0
-#define S25FL_CMD_WRITE4       0x12    /* Note, opcode clashes with
+#define S25FL_CMD_WRITE4_1_1_4		0x34
+#define S25FL_CMD_SE4			0xdc
+#define S25FL_CMD_CLSR			0x30
+#define S25FL_CMD_DYBWR			0xe1
+#define S25FL_CMD_DYBRD			0xe0
+#define S25FL_CMD_WRITE4		0x12    /* Note, opcode clashes with
 					* 'SPINOR_OP_WRITE_1_4_4'
 					* as found on N25Qxxx devices! */
-
 /* Status register */
-#define FLASH_STATUS_BUSY      0x01
-#define FLASH_STATUS_WEL       0x02
-#define FLASH_STATUS_BP0       0x04
-#define FLASH_STATUS_BP1       0x08
-#define FLASH_STATUS_BP2       0x10
-#define FLASH_STATUS_SRWP0     0x80
-#define FLASH_STATUS_TIMEOUT   0xff
+#define FLASH_STATUS_BUSY		0x01
+#define FLASH_STATUS_WEL		0x02
+#define FLASH_STATUS_BP0		0x04
+#define FLASH_STATUS_BP1		0x08
+#define FLASH_STATUS_BP2		0x10
+#define FLASH_STATUS_SRWP0		0x80
+#define FLASH_STATUS_TIMEOUT		0xff
 
 /* Maximum READID length */
-#define MAX_READID_LEN         6
-#define MAX_READID_LEN_ALIGNED ALIGN(MAX_READID_LEN, 4)
+#define MAX_READID_LEN			6
+#define MAX_READID_LEN_ALIGNED		ALIGN(MAX_READID_LEN, 4)
 
 /* S25FL Error Flags */
-#define S25FL_STATUS_E_ERR     0x20
-#define S25FL_STATUS_P_ERR     0x40
+#define S25FL_STATUS_E_ERR		0x20
+#define S25FL_STATUS_P_ERR		0x40
 
 /* N25Q - READ/WRITE/CLEAR NON/VOLATILE STATUS/CONFIG Registers */
-#define N25Q_CMD_RFSR          0x70
-#define N25Q_CMD_CLFSR         0x50
-#define N25Q_CMD_WRVCR         0x81
-#define N25Q_CMD_RDVCR         0x85
-#define N25Q_CMD_RDVECR        0x65
-#define N25Q_CMD_RDNVCR        0xb5
-#define N25Q_CMD_WRNVCR        0xb1
+#define N25Q_CMD_RFSR			0x70
+#define N25Q_CMD_CLFSR			0x50
+#define N25Q_CMD_WRVCR			0x81
+#define N25Q_CMD_RDVCR			0x85
+#define N25Q_CMD_RDVECR			0x65
+#define N25Q_CMD_RDNVCR			0xb5
+#define N25Q_CMD_WRNVCR			0xb1
 
 /* N25Q Flags Status Register: Error Flags */
-#define N25Q_FLAGS_ERR_ERASE   BIT(5)
-#define N25Q_FLAGS_ERR_PROG    BIT(4)
-#define N25Q_FLAGS_ERR_VPP     BIT(3)
-#define N25Q_FLAGS_ERR_PROT    BIT(1)
-#define N25Q_FLAGS_ERROR	(N25Q_FLAGS_ERR_ERASE   | \
-				N25Q_FLAGS_ERR_PROG    | \
-				N25Q_FLAGS_ERR_VPP     | \
-				N25Q_FLAGS_ERR_PROT)
-
-#define FLASH_PAGESIZE         256			/* In Bytes    */
-#define FLASH_PAGESIZE_32      (FLASH_PAGESIZE / 4)	/* In uint32_t */
+#define N25Q_FLAGS_ERR_ERASE		BIT(5)
+#define N25Q_FLAGS_ERR_PROG		BIT(4)
+#define N25Q_FLAGS_ERR_VPP		BIT(3)
+#define N25Q_FLAGS_ERR_PROT		BIT(1)
+#define N25Q_FLAGS_ERROR		(N25Q_FLAGS_ERR_ERASE	| \
+					 N25Q_FLAGS_ERR_PROG	| \
+					 N25Q_FLAGS_ERR_VPP	| \
+					 N25Q_FLAGS_ERR_PROT)
+
+#define FLASH_PAGESIZE			256		     /* In Bytes    */
+#define FLASH_PAGESIZE_32		(FLASH_PAGESIZE / 4) /* In uint32_t */
 /* Maximum operation times (in ms) */
-#define FLASH_MAX_CHIP_ERASE_MS 500000          /* Chip Erase time */
-#define FLASH_MAX_SEC_ERASE_MS  30000           /* Sector Erase time */
-#define FLASH_MAX_PAGE_WRITE_MS 100             /* Write Page time */
-#define FLASH_MAX_STA_WRITE_MS  4000            /* Write status reg time */
-#define FSM_MAX_WAIT_SEQ_MS     1000            /* FSM execution time */
+#define FLASH_MAX_CHIP_ERASE_MS		500000	/* Chip Erase time */
+#define FLASH_MAX_SEC_ERASE_MS		30000	/* Sector Erase time */
+#define FLASH_MAX_PAGE_WRITE_MS		100	/* Write Page time */
+#define FLASH_MAX_STA_WRITE_MS		4000	/* Write status reg time */
+#define FSM_MAX_WAIT_SEQ_MS		1000	/* FSM execution time */
 
 /*
  * Flags to tweak operation of default read/write/erase routines
  */
-#define CFG_READ_TOGGLE_32BIT_ADDR     0x00000001
-#define CFG_WRITE_TOGGLE_32BIT_ADDR    0x00000002
-#define CFG_ERASESEC_TOGGLE_32BIT_ADDR 0x00000008
-#define CFG_S25FL_CHECK_ERROR_FLAGS    0x00000010
-#define CFG_N25Q_CHECK_ERROR_FLAGS     0x00000020
+#define CFG_READ_TOGGLE_32BIT_ADDR		0x00000001
+#define CFG_WRITE_TOGGLE_32BIT_ADDR		0x00000002
+#define CFG_ERASESEC_TOGGLE_32BIT_ADDR		0x00000008
+#define CFG_S25FL_CHECK_ERROR_FLAGS		0x00000010
+#define CFG_N25Q_CHECK_ERROR_FLAGS		0x00000020
 
 struct stfsm_seq {
-	uint32_t data_size;
-	uint32_t addr1;
-	uint32_t addr2;
-	uint32_t addr_cfg;
-	uint32_t seq_opc[5];
-	uint32_t mode;
-	uint32_t dummy;
-	uint32_t status;
-	uint8_t  seq[16];
-	uint32_t seq_cfg;
+	uint32_t		data_size;
+	uint32_t		addr1;
+	uint32_t		addr2;
+	uint32_t		addr_cfg;
+	uint32_t		seq_opc[5];
+	uint32_t		mode;
+	uint32_t		dummy;
+	uint32_t		status;
+	uint8_t			seq[16];
+	uint32_t		seq_cfg;
 } __packed __aligned(4);
 
 struct stfsm {
@@ -302,30 +301,31 @@ struct stfsm {
 	struct resource		*region;
 	struct mtd_info		mtd;
 	struct mutex		lock;
-	struct flash_info       *info;
-	struct clk              *clk;
-
-	uint32_t                configuration;
-	uint32_t                fifo_dir_delay;
-	bool                    booted_from_spi;
-	bool                    reset_signal;
-	bool                    reset_por;
-
-	struct stfsm_seq stfsm_seq_read;
-	struct stfsm_seq stfsm_seq_write;
-	struct stfsm_seq stfsm_seq_en_32bit_addr;
+	struct flash_info	*info;
+	struct clk		*clk;
+
+	uint32_t		configuration;
+	uint32_t		fifo_dir_delay;
+	bool			booted_from_spi;
+	bool			reset_signal;
+	bool			reset_por;
+
+	struct stfsm_seq	stfsm_seq_read;
+	struct stfsm_seq	stfsm_seq_write;
+	struct stfsm_seq	stfsm_seq_en_32bit_addr;
 };
 
 /* Parameters to configure a READ or WRITE FSM sequence */
 struct seq_rw_config {
-	uint32_t        flags;          /* flags to support config */
-	uint8_t         cmd;            /* FLASH command */
-	int             write;          /* Write Sequence */
-	uint8_t         addr_pads;      /* No. of addr pads (MODE & DUMMY) */
-	uint8_t         data_pads;      /* No. of data pads */
-	uint8_t         mode_data;      /* MODE data */
-	uint8_t         mode_cycles;    /* No. of MODE cycles */
-	uint8_t         dummy_cycles;   /* No. of DUMMY cycles */
+	uint32_t		flags;		/* flags to support config */
+	uint8_t			cmd;		/* FLASH command */
+	int			write;		/* Write Sequence */
+	uint8_t			addr_pads;	/* No. of addr pads */
+						/* (MODE & DUMMY) */
+	uint8_t			data_pads;	/* No. of data pads */
+	uint8_t			mode_data;	/* MODE data */
+	uint8_t			mode_cycles;	/* No. of MODE cycles */
+	uint8_t			dummy_cycles;	/* No. of DUMMY cycles */
 };
 
 struct stfsm_boot_dev {
@@ -336,23 +336,23 @@ struct stfsm_boot_dev {
 
 /* SPI Flash Device Table */
 struct flash_info {
-	char            *name;
-	/* READID data, as returned by 'SPINOR_OP_RDID' (0x9f). */
-	u8              readid[MAX_READID_LEN];
-	int             readid_len;
+	char			*name;
+	/* READID data, as returned by 'FLASH_CMD_RDID' (0x9f). */
+	u8			readid[MAX_READID_LEN];
+	int			readid_len;
 	/*
 	 * The size listed here is what works with SPINOR_OP_SE, which isn't
 	 * necessarily called a "sector" by the vendor.
 	 */
-	unsigned        sector_size;
-	u16             n_sectors;
-	u32             flags;
+	unsigned		sector_size;
+	u16			n_sectors;
+	u32			flags;
 	/*
 	 * Note, where FAST_READ is supported, freq_max specifies the
 	 * FAST_READ frequency, not the READ frequency.
 	 */
-	u32             max_freq;
-	int             (*config)(struct stfsm *);
+	u32			max_freq;
+	int			(*config)(struct stfsm *);
 };
 
 static struct stfsm_boot_dev stfsm_stid127_data = {
@@ -423,9 +423,9 @@ static struct flash_info flash_types[] = {
 	JEDEC_INFO("m25p64",  0x202017,  64 * 1024, 128, M25P_FLAG, 50, NULL),
 	JEDEC_INFO("m25p128", 0x202018, 256 * 1024,  64, M25P_FLAG, 50, NULL),
 
-#define M25PX_FLAG (FLASH_FLAG_READ_WRITE      |	\
-		    FLASH_FLAG_READ_FAST        |	\
-		    FLASH_FLAG_READ_1_1_2       |	\
+#define M25PX_FLAG (FLASH_FLAG_READ_WRITE	|	\
+		    FLASH_FLAG_READ_FAST	|	\
+		    FLASH_FLAG_READ_1_1_2	|	\
 		    FLASH_FLAG_WRITE_1_1_2)
 	JEDEC_INFO("m25px32", 0x207116,  64 * 1024,  64, M25PX_FLAG, 75, NULL),
 	JEDEC_INFO("m25px64", 0x207117,  64 * 1024, 128, M25PX_FLAG, 75, NULL),
@@ -434,12 +434,12 @@ static struct flash_info flash_types[] = {
 	 *     - Support for 'FLASH_FLAG_WRITE_1_4_4' is omitted for devices
 	 *       where operating frequency must be reduced.
 	 */
-#define MX25_FLAG (FLASH_FLAG_READ_WRITE       |	\
-		   FLASH_FLAG_READ_FAST         |	\
-		   FLASH_FLAG_READ_1_1_2        |	\
-		   FLASH_FLAG_READ_1_2_2        |	\
-		   FLASH_FLAG_READ_1_1_4        |	\
-		   FLASH_FLAG_SE_4K             |	\
+#define MX25_FLAG (FLASH_FLAG_READ_WRITE	|	\
+		   FLASH_FLAG_READ_FAST		|	\
+		   FLASH_FLAG_READ_1_1_2	|	\
+		   FLASH_FLAG_READ_1_2_2	|	\
+		   FLASH_FLAG_READ_1_1_4	|	\
+		   FLASH_FLAG_SE_4K		|	\
 		   FLASH_FLAG_SE_32K)
 	JEDEC_INFO("mx25l3255e",  0xc29e16, 64 * 1024, 64,
 		   (MX25_FLAG | FLASH_FLAG_WRITE_1_4_4), 86, stfsm_mx25_config),
@@ -449,20 +449,20 @@ static struct flash_info flash_types[] = {
 		   (MX25_FLAG | FLASH_FLAG_RESET), 70, stfsm_mx25_config),
 
 	/* Micron N25Qxxx */
-#define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
-		   FLASH_FLAG_READ_FAST         |	\
-		   FLASH_FLAG_READ_1_1_2        |	\
-		   FLASH_FLAG_READ_1_2_2        |	\
-		   FLASH_FLAG_READ_1_1_4        |	\
-		   FLASH_FLAG_READ_1_4_4        |	\
-		   FLASH_FLAG_WRITE_1_1_2       |	\
-		   FLASH_FLAG_WRITE_1_2_2       |	\
-		   FLASH_FLAG_WRITE_1_1_4       |	\
+#define N25Q_FLAG (FLASH_FLAG_READ_WRITE	|	\
+		   FLASH_FLAG_READ_FAST		|	\
+		   FLASH_FLAG_READ_1_1_2	|	\
+		   FLASH_FLAG_READ_1_2_2	|	\
+		   FLASH_FLAG_READ_1_1_4	|	\
+		   FLASH_FLAG_READ_1_4_4	|	\
+		   FLASH_FLAG_WRITE_1_1_2	|	\
+		   FLASH_FLAG_WRITE_1_2_2	|	\
+		   FLASH_FLAG_WRITE_1_1_4	|	\
 		   FLASH_FLAG_WRITE_1_4_4)
 	JEDEC_INFO("n25q128", 0x20ba18, 64 * 1024,  256,
 		   N25Q_FLAG, 108, stfsm_n25q_config),
 
-	/* Micron N25Q256/N25Q512/N25Q00A (32-bit ADDR devices)
+       /* Micron N25Q256/N25Q512/N25Q00A (32-bit ADDR devices)
 	*
 	* Versions are available with or without a dedicated RESET# pin
 	* (e.g. N25Q512A83GSF40G vs. N25Q512A13GSF40G).  To complicate matters,
@@ -474,9 +474,9 @@ static struct flash_info flash_types[] = {
 	* defer overall support for RESET# to the board-level platform/Device
 	* Tree property "reset-signal".
 	*/
-#define N25Q_32BIT_ADDR_FLAG  ((N25Q_FLAG              |	\
-				FLASH_FLAG_32BIT_ADDR  |	\
-				FLASH_FLAG_RESET)      &	\
+#define N25Q_32BIT_ADDR_FLAG  ((N25Q_FLAG		|	\
+				FLASH_FLAG_32BIT_ADDR	|	\
+				FLASH_FLAG_RESET)	&	\
 			       ~FLASH_FLAG_WRITE_1_4_4)
 	JEDEC_INFO("n25q256", 0x20ba19, 64 * 1024,   512,
 		   N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config),
@@ -490,12 +490,12 @@ static struct flash_info flash_types[] = {
 	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
 	 *     - S25FL128Px devices do not support DUAL or QUAD I/O
 	 */
-#define S25FLXXXP_FLAG (FLASH_FLAG_READ_WRITE  |	\
-			FLASH_FLAG_READ_1_1_2   |	\
-			FLASH_FLAG_READ_1_2_2   |	\
-			FLASH_FLAG_READ_1_1_4   |	\
-			FLASH_FLAG_READ_1_4_4   |	\
-			FLASH_FLAG_WRITE_1_1_4  |	\
+#define S25FLXXXP_FLAG (FLASH_FLAG_READ_WRITE	|	\
+			FLASH_FLAG_READ_1_1_2	|	\
+			FLASH_FLAG_READ_1_2_2	|	\
+			FLASH_FLAG_READ_1_1_4	|	\
+			FLASH_FLAG_READ_1_4_4	|	\
+			FLASH_FLAG_WRITE_1_1_4	|	\
 			FLASH_FLAG_READ_FAST)
 	RDID_INFO("s25fl032p", RDID({0x01, 0x02, 0x15, 0x4d, 0x00}), 5,
 		  64 * 1024,  64, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
@@ -520,8 +520,8 @@ static struct flash_info flash_types[] = {
 	 *       may default to locked state on power-on.
 	 *     - S25FL127Sx handled as S25FL128Sx
 	 */
-#define S25FLXXXS_FLAG (S25FLXXXP_FLAG         |	\
-			FLASH_FLAG_RESET        |	\
+#define S25FLXXXS_FLAG (S25FLXXXP_FLAG		|	\
+			FLASH_FLAG_RESET	|	\
 			FLASH_FLAG_DYB_LOCKING)
 	RDID_INFO("s25fl128s0", RDID({0x01, 0x20, 0x18, 0x4d, 0x00, 0x80}), 6,
 		  256 * 1024, 64, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
@@ -532,9 +532,9 @@ static struct flash_info flash_types[] = {
 	RDID_INFO("s25fl256s1", RDID({0x01, 0x02, 0x19, 0x4d, 0x01, 0x80}), 6,
 		  64 * 1024, 512, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
 
-#define W25X_FLAG (FLASH_FLAG_READ_WRITE       |	\
-		   FLASH_FLAG_READ_FAST         |	\
-		   FLASH_FLAG_READ_1_1_2        |	\
+#define W25X_FLAG (FLASH_FLAG_READ_WRITE	|	\
+		   FLASH_FLAG_READ_FAST		|	\
+		   FLASH_FLAG_READ_1_1_2	|	\
 		   FLASH_FLAG_WRITE_1_1_2)
 	JEDEC_INFO("w25x40", 0xef3013, 64 * 1024,   8, W25X_FLAG, 75, NULL),
 	JEDEC_INFO("w25x80", 0xef3014, 64 * 1024,  16, W25X_FLAG, 75, NULL),
@@ -543,12 +543,12 @@ static struct flash_info flash_types[] = {
 	JEDEC_INFO("w25x64", 0xef3017, 64 * 1024, 128, W25X_FLAG, 75, NULL),
 
 	/* Winbond -- w25q "blocks" are 64K, "sectors" are 4KiB */
-#define W25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
-		   FLASH_FLAG_READ_FAST         |	\
-		   FLASH_FLAG_READ_1_1_2        |	\
-		   FLASH_FLAG_READ_1_2_2        |	\
-		   FLASH_FLAG_READ_1_1_4        |	\
-		   FLASH_FLAG_READ_1_4_4        |	\
+#define W25Q_FLAG (FLASH_FLAG_READ_WRITE	|	\
+		   FLASH_FLAG_READ_FAST		|	\
+		   FLASH_FLAG_READ_1_1_2	|	\
+		   FLASH_FLAG_READ_1_2_2	|	\
+		   FLASH_FLAG_READ_1_1_4	|	\
+		   FLASH_FLAG_READ_1_4_4	|	\
 		   FLASH_FLAG_WRITE_1_1_4)
 	JEDEC_INFO("w25q80", 0xef4014, 64 * 1024,  16,
 		   W25Q_FLAG, 80, stfsm_w25q_config),
@@ -619,7 +619,7 @@ static struct seq_rw_config n25q_read3_configs[] = {
 
 /* N25Q 4-byte Address READ configurations
  *	- use special 4-byte address READ commands (reduces overheads, and
- *        reduces risk of hitting watchdog reset issues).
+ *	reduces risk of hitting watchdog reset issues).
  *	- 'FAST' variants configured for 8 dummy cycles (see note above.)
  */
 static struct seq_rw_config n25q_read4_configs[] = {
@@ -681,7 +681,7 @@ static struct seq_rw_config stfsm_s25fl_read4_configs[] = {
 static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
 	{FLASH_FLAG_WRITE_1_1_4, S25FL_CMD_WRITE4_1_1_4, 1, 1, 4, 0x00, 0, 0},
 	{FLASH_FLAG_READ_WRITE,  S25FL_CMD_WRITE4,       1, 1, 1, 0x00, 0, 0},
-	{0x00,                   0,                      0, 0, 0, 0x00, 0, 0},
+	{0x00,		   0,		      0, 0, 0, 0x00, 0, 0},
 };
 
 /*
@@ -906,12 +906,12 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf, uint32_t size)
  * With this in mind, a two stage process is used to the clear the FIFO:
  *
  *     1. Read any complete 32-bit words from the FIFO, as reported by the
- *        SPI_FAST_SEQ_STA register.
+ *	SPI_FAST_SEQ_STA register.
  *
  *     2. Mop up any remaining bytes.  At this point, it is not known if there
- *        are 0, 1, 2, or 3 bytes in the FIFO.  To handle all cases, a dummy FSM
- *        sequence is used to load one byte at a time, until a complete 32-bit
- *        word is formed; at most, 4 bytes will need to be loaded.
+ *	are 0, 1, 2, or 3 bytes in the FIFO.  To handle all cases, a dummy FSM
+ *	sequence is used to load one byte at a time, until a complete 32-bit
+ *	word is formed; at most, 4 bytes will need to be loaded.
  *
  * [1] It is theoretically possible for the FIFO to contain an arbitrary number
  *     of bits.  However, since there are no known use-cases that leave
@@ -2129,7 +2129,7 @@ static int stfsm_init(struct stfsm *fsm)
 		return ret;
 
 	/* Set timing parameters */
-	writel(SPI_CFG_DEVICE_ST            |
+	writel(SPI_CFG_DEVICE_ST	    |
 	       SPI_CFG_DEFAULT_MIN_CS_HIGH  |
 	       SPI_CFG_DEFAULT_CS_SETUPHOLD |
 	       SPI_CFG_DEFAULT_DATA_HOLD,
@@ -2339,7 +2339,7 @@ static struct platform_driver stfsm_driver = {
 	.driver		= {
 		.name	= "st-spi-fsm",
 		.of_match_table = stfsm_match,
-		.pm     = &stfsm_pm_ops,
+		.pm	= &stfsm_pm_ops,
 	},
 };
 module_platform_driver(stfsm_driver);
-- 
1.9.1

