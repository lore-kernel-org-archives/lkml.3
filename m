Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaHTG2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:28:32 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48614 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaHTG2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:28:31 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <jic23@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <devel@driverdev.osuosl.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:iio: moved platform_data into include/linux/iio
Date: Wed, 20 Aug 2014 12:11:09 +0530
Message-ID: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 20 Aug 2014 06:28:29.0769 (UTC) FILETIME=[F5137B90:01CFBC3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the iio which will move all platform_data
into include/linux/iio.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/iio/adc/ad7192.c                |   3 +-
 drivers/staging/iio/adc/ad7192.h                |  47 ---------
 drivers/staging/iio/adc/ad7280a.c               |   3 +-
 drivers/staging/iio/adc/ad7280a.h               |  38 -------
 drivers/staging/iio/adc/ad7606.h                | 104 -------------------
 drivers/staging/iio/adc/ad7606_core.c           |   3 +-
 drivers/staging/iio/adc/ad7606_par.c            |   2 +-
 drivers/staging/iio/adc/ad7606_ring.c           |   3 +-
 drivers/staging/iio/adc/ad7606_spi.c            |   2 +-
 drivers/staging/iio/adc/ad7780.c                |   3 +-
 drivers/staging/iio/adc/ad7780.h                |  30 ------
 drivers/staging/iio/cdc/ad7746.c                |   3 +-
 drivers/staging/iio/cdc/ad7746.h                |  29 ------
 drivers/staging/iio/frequency/ad9832.c          |   3 +-
 drivers/staging/iio/frequency/ad9832.h          | 126 ------------------------
 drivers/staging/iio/frequency/ad9834.c          |   3 +-
 drivers/staging/iio/frequency/ad9834.h          | 112 ---------------------
 drivers/staging/iio/impedance-analyzer/ad5933.c |   3 +-
 drivers/staging/iio/impedance-analyzer/ad5933.h |  28 ------
 include/linux/iio/adc/ad7192.h                  |  43 ++++++++
 include/linux/iio/adc/ad7280a.h                 |  34 +++++++
 include/linux/iio/adc/ad7606.h                  | 100 +++++++++++++++++++
 include/linux/iio/adc/ad7780.h                  |  26 +++++
 include/linux/iio/cdc/ad7746.h                  |  25 +++++
 include/linux/iio/frequency/ad9832.h            | 122 +++++++++++++++++++++++
 include/linux/iio/frequency/ad9834.h            | 107 ++++++++++++++++++++
 include/linux/iio/impedance-analyzer/ad5933.h   |  28 ++++++
 27 files changed, 496 insertions(+), 534 deletions(-)
 delete mode 100644 drivers/staging/iio/adc/ad7192.h
 delete mode 100644 drivers/staging/iio/adc/ad7280a.h
 delete mode 100644 drivers/staging/iio/adc/ad7606.h
 delete mode 100644 drivers/staging/iio/adc/ad7780.h
 delete mode 100644 drivers/staging/iio/cdc/ad7746.h
 delete mode 100644 drivers/staging/iio/frequency/ad9832.h
 delete mode 100644 drivers/staging/iio/frequency/ad9834.h
 delete mode 100644 drivers/staging/iio/impedance-analyzer/ad5933.h
 create mode 100644 include/linux/iio/adc/ad7192.h
 create mode 100644 include/linux/iio/adc/ad7280a.h
 create mode 100644 include/linux/iio/adc/ad7606.h
 create mode 100644 include/linux/iio/adc/ad7780.h
 create mode 100644 include/linux/iio/cdc/ad7746.h
 create mode 100644 include/linux/iio/frequency/ad9832.h
 create mode 100644 include/linux/iio/frequency/ad9834.h
 create mode 100644 include/linux/iio/impedance-analyzer/ad5933.h

diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
index 83bb44b..44216ce 100644
--- a/drivers/staging/iio/adc/ad7192.c
+++ b/drivers/staging/iio/adc/ad7192.c
@@ -24,8 +24,7 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 #include <linux/iio/adc/ad_sigma_delta.h>
-
-#include "ad7192.h"
+#include <linux/iio/adc/ad7192.h>
 
 /* Registers */
 #define AD7192_REG_COMM		0 /* Communications Register (WO, 8-bit) */
diff --git a/drivers/staging/iio/adc/ad7192.h b/drivers/staging/iio/adc/ad7192.h
deleted file mode 100644
index a0a5b61..0000000
--- a/drivers/staging/iio/adc/ad7192.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * AD7190 AD7192 AD7195 SPI ADC driver
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-#ifndef IIO_ADC_AD7192_H_
-#define IIO_ADC_AD7192_H_
-
-/*
- * TODO: struct ad7192_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad7192_platform_data - platform/board specific information
- * @vref_mv:		the external reference voltage in millivolt
- * @clock_source_sel:	[0..3]
- *			0 External 4.92 MHz clock connected from MCLK1 to MCLK2
- *			1 External Clock applied to MCLK2
- *			2 Internal 4.92 MHz Clock not available at the MCLK2 pin
- *			3 Internal 4.92 MHz Clock available at the MCLK2 pin
- * @ext_clk_Hz:		the external clock frequency in Hz, if not set
- *			the driver uses the internal clock (16.776 MHz)
- * @refin2_en:		REFIN1/REFIN2 Reference Select (AD7190/2 only)
- * @rej60_en:		50/60Hz notch filter enable
- * @sinc3_en:		SINC3 filter enable (default SINC4)
- * @chop_en:		CHOP mode enable
- * @buf_en:		buffered input mode enable
- * @unipolar_en:	unipolar mode enable
- * @burnout_curr_en:	constant current generators on AIN(+|-) enable
- */
-
-struct ad7192_platform_data {
-	u16		vref_mv;
-	u8		clock_source_sel;
-	u32		ext_clk_Hz;
-	bool		refin2_en;
-	bool		rej60_en;
-	bool		sinc3_en;
-	bool		chop_en;
-	bool		buf_en;
-	bool		unipolar_en;
-	bool		burnout_curr_en;
-};
-
-#endif /* IIO_ADC_AD7192_H_ */
diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index d215edf..0e0e4c3 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -19,8 +19,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 #include <linux/iio/events.h>
-
-#include "ad7280a.h"
+#include <linux/iio/adc/ad7280a.h>
 
 /* Registers */
 #define AD7280A_CELL_VOLTAGE_1		0x0  /* D11 to D0, Read only */
diff --git a/drivers/staging/iio/adc/ad7280a.h b/drivers/staging/iio/adc/ad7280a.h
deleted file mode 100644
index 20400b0..0000000
--- a/drivers/staging/iio/adc/ad7280a.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * AD7280A Lithium Ion Battery Monitoring System
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-
-#ifndef IIO_ADC_AD7280_H_
-#define IIO_ADC_AD7280_H_
-
-/*
- * TODO: struct ad7280_platform_data needs to go into include/linux/iio
- */
-
-#define AD7280A_ACQ_TIME_400ns			0
-#define AD7280A_ACQ_TIME_800ns			1
-#define AD7280A_ACQ_TIME_1200ns			2
-#define AD7280A_ACQ_TIME_1600ns			3
-
-#define AD7280A_CONV_AVG_DIS			0
-#define AD7280A_CONV_AVG_2			1
-#define AD7280A_CONV_AVG_4			2
-#define AD7280A_CONV_AVG_8			3
-
-#define AD7280A_ALERT_REMOVE_VIN5		(1 << 2)
-#define AD7280A_ALERT_REMOVE_VIN4_VIN5		(2 << 2)
-#define AD7280A_ALERT_REMOVE_AUX5		(1 << 0)
-#define AD7280A_ALERT_REMOVE_AUX4_AUX5		(2 << 0)
-
-struct ad7280_platform_data {
-	unsigned acquisition_time;
-	unsigned conversion_averaging;
-	unsigned chain_last_alert_ignore;
-	bool thermistor_term_en;
-};
-
-#endif /* IIO_ADC_AD7280_H_ */
diff --git a/drivers/staging/iio/adc/ad7606.h b/drivers/staging/iio/adc/ad7606.h
deleted file mode 100644
index ec89d05..0000000
--- a/drivers/staging/iio/adc/ad7606.h
+++ /dev/null
@@ -1,104 +0,0 @@
-/*
- * AD7606 ADC driver
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-
-#ifndef IIO_ADC_AD7606_H_
-#define IIO_ADC_AD7606_H_
-
-/*
- * TODO: struct ad7606_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad7606_platform_data - platform/board specific information
- * @default_os:		default oversampling value {0, 2, 4, 8, 16, 32, 64}
- * @default_range:	default range +/-{5000, 10000} mVolt
- * @gpio_convst:	number of gpio connected to the CONVST pin
- * @gpio_reset:		gpio connected to the RESET pin, if not used set to -1
- * @gpio_range:		gpio connected to the RANGE pin, if not used set to -1
- * @gpio_os0:		gpio connected to the OS0 pin, if not used set to -1
- * @gpio_os1:		gpio connected to the OS1 pin, if not used set to -1
- * @gpio_os2:		gpio connected to the OS2 pin, if not used set to -1
- * @gpio_frstdata:	gpio connected to the FRSTDAT pin, if not used set to -1
- * @gpio_stby:		gpio connected to the STBY pin, if not used set to -1
- */
-
-struct ad7606_platform_data {
-	unsigned			default_os;
-	unsigned			default_range;
-	unsigned			gpio_convst;
-	unsigned			gpio_reset;
-	unsigned			gpio_range;
-	unsigned			gpio_os0;
-	unsigned			gpio_os1;
-	unsigned			gpio_os2;
-	unsigned			gpio_frstdata;
-	unsigned			gpio_stby;
-};
-
-/**
- * struct ad7606_chip_info - chip specific information
- * @name:		identification string for chip
- * @int_vref_mv:	the internal reference voltage
- * @channels:		channel specification
- * @num_channels:	number of channels
- */
-
-struct ad7606_chip_info {
-	const char			*name;
-	u16				int_vref_mv;
-	const struct iio_chan_spec	*channels;
-	unsigned			num_channels;
-};
-
-/**
- * struct ad7606_state - driver instance specific data
- */
-
-struct ad7606_state {
-	struct device			*dev;
-	const struct ad7606_chip_info	*chip_info;
-	struct ad7606_platform_data	*pdata;
-	struct regulator		*reg;
-	struct work_struct		poll_work;
-	wait_queue_head_t		wq_data_avail;
-	const struct ad7606_bus_ops	*bops;
-	unsigned			range;
-	unsigned			oversampling;
-	bool				done;
-	void __iomem			*base_address;
-
-	/*
-	 * DMA (thus cache coherency maintenance) requires the
-	 * transfer buffers to live in their own cache lines.
-	 */
-
-	unsigned short			data[8] ____cacheline_aligned;
-};
-
-struct ad7606_bus_ops {
-	/* more methods added in future? */
-	int (*read_block)(struct device *, int, void *);
-};
-
-void ad7606_suspend(struct iio_dev *indio_dev);
-void ad7606_resume(struct iio_dev *indio_dev);
-struct iio_dev *ad7606_probe(struct device *dev, int irq,
-			      void __iomem *base_address, unsigned id,
-			      const struct ad7606_bus_ops *bops);
-int ad7606_remove(struct iio_dev *indio_dev, int irq);
-int ad7606_reset(struct ad7606_state *st);
-
-enum ad7606_supported_device_ids {
-	ID_AD7606_8,
-	ID_AD7606_6,
-	ID_AD7606_4
-};
-
-int ad7606_register_ring_funcs_and_init(struct iio_dev *indio_dev);
-void ad7606_ring_cleanup(struct iio_dev *indio_dev);
-#endif /* IIO_ADC_AD7606_H_ */
diff --git a/drivers/staging/iio/adc/ad7606_core.c b/drivers/staging/iio/adc/ad7606_core.c
index f0f05f1..554381b 100644
--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -21,8 +21,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 #include <linux/iio/buffer.h>
-
-#include "ad7606.h"
+#include <linux/iio/adc/ad7606.h>
 
 int ad7606_reset(struct ad7606_state *st)
 {
diff --git a/drivers/staging/iio/adc/ad7606_par.c b/drivers/staging/iio/adc/ad7606_par.c
index 7511839..ce76e85 100644
--- a/drivers/staging/iio/adc/ad7606_par.c
+++ b/drivers/staging/iio/adc/ad7606_par.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 
 #include <linux/iio/iio.h>
-#include "ad7606.h"
+#include <linux/iio/adc/ad7606.h>
 
 static int ad7606_par16_read_block(struct device *dev,
 				 int count, void *buf)
diff --git a/drivers/staging/iio/adc/ad7606_ring.c b/drivers/staging/iio/adc/ad7606_ring.c
index 3bf174c..c058d2e 100644
--- a/drivers/staging/iio/adc/ad7606_ring.c
+++ b/drivers/staging/iio/adc/ad7606_ring.c
@@ -15,8 +15,7 @@
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
-
-#include "ad7606.h"
+#include <linux/iio/adc/ad7606.h>
 
 /**
  * ad7606_trigger_handler_th() th/bh of trigger launched polling to ring buffer
diff --git a/drivers/staging/iio/adc/ad7606_spi.c b/drivers/staging/iio/adc/ad7606_spi.c
index 6a8ecd7..229794f 100644
--- a/drivers/staging/iio/adc/ad7606_spi.c
+++ b/drivers/staging/iio/adc/ad7606_spi.c
@@ -12,7 +12,7 @@
 #include <linux/err.h>
 
 #include <linux/iio/iio.h>
-#include "ad7606.h"
+#include <linux/iio/adc/ad7606.h>
 
 #define MAX_SPI_FREQ_HZ		23500000	/* VDRIVE above 4.75 V */
 
diff --git a/drivers/staging/iio/adc/ad7780.c b/drivers/staging/iio/adc/ad7780.c
index 273add3..e6fbb44 100644
--- a/drivers/staging/iio/adc/ad7780.c
+++ b/drivers/staging/iio/adc/ad7780.c
@@ -21,8 +21,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 #include <linux/iio/adc/ad_sigma_delta.h>
-
-#include "ad7780.h"
+#include <linux/iio/adc/ad7780.h>
 
 #define AD7780_RDY	(1 << 7)
 #define AD7780_FILTER	(1 << 6)
diff --git a/drivers/staging/iio/adc/ad7780.h b/drivers/staging/iio/adc/ad7780.h
deleted file mode 100644
index 67e511c..0000000
--- a/drivers/staging/iio/adc/ad7780.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * AD7780/AD7781 SPI ADC driver
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-#ifndef IIO_ADC_AD7780_H_
-#define IIO_ADC_AD7780_H_
-
-/*
- * TODO: struct ad7780_platform_data needs to go into include/linux/iio
- */
-
-/* NOTE:
- * The AD7780 doesn't feature a dedicated SPI chip select, in addition it
- * features a dual use data out ready DOUT/RDY output.
- * In order to avoid contentions on the SPI bus, it's therefore necessary
- * to use spi bus locking combined with a dedicated GPIO to control the
- * power down reset signal of the AD7780.
- *
- * The DOUT/RDY output must also be wired to an interrupt capable GPIO.
- */
-
-struct ad7780_platform_data {
-	u16				vref_mv;
-	int				gpio_pdrst;
-};
-
-#endif /* IIO_ADC_AD7780_H_ */
diff --git a/drivers/staging/iio/cdc/ad7746.c b/drivers/staging/iio/cdc/ad7746.c
index e6e9eaa..d1f6e65 100644
--- a/drivers/staging/iio/cdc/ad7746.c
+++ b/drivers/staging/iio/cdc/ad7746.c
@@ -18,8 +18,7 @@
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
-
-#include "ad7746.h"
+#include <linux/iio/cdc/ad7746.h>
 
 /*
  * AD7746 Register Definition
diff --git a/drivers/staging/iio/cdc/ad7746.h b/drivers/staging/iio/cdc/ad7746.h
deleted file mode 100644
index ea8572d..0000000
--- a/drivers/staging/iio/cdc/ad7746.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * AD7746 capacitive sensor driver supporting AD7745, AD7746 and AD7747
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-
-#ifndef IIO_CDC_AD7746_H_
-#define IIO_CDC_AD7746_H_
-
-/*
- * TODO: struct ad7746_platform_data needs to go into include/linux/iio
- */
-
-#define AD7466_EXCLVL_0		0 /* +-VDD/8 */
-#define AD7466_EXCLVL_1		1 /* +-VDD/4 */
-#define AD7466_EXCLVL_2		2 /* +-VDD * 3/8 */
-#define AD7466_EXCLVL_3		3 /* +-VDD/2 */
-
-struct ad7746_platform_data {
-	unsigned char exclvl;	/*Excitation Voltage Level */
-	bool exca_en;		/* enables EXCA pin as the excitation output */
-	bool exca_inv_en;	/* enables /EXCA pin as the excitation output */
-	bool excb_en;		/* enables EXCB pin as the excitation output */
-	bool excb_inv_en;	/* enables /EXCB pin as the excitation output */
-};
-
-#endif /* IIO_CDC_AD7746_H_ */
diff --git a/drivers/staging/iio/frequency/ad9832.c b/drivers/staging/iio/frequency/ad9832.c
index cf68159..7b23749 100644
--- a/drivers/staging/iio/frequency/ad9832.c
+++ b/drivers/staging/iio/frequency/ad9832.c
@@ -19,8 +19,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 #include "dds.h"
-
-#include "ad9832.h"
+#include <linux/iio/frequency/ad9832.h>
 
 static unsigned long ad9832_calc_freqreg(unsigned long mclk, unsigned long fout)
 {
diff --git a/drivers/staging/iio/frequency/ad9832.h b/drivers/staging/iio/frequency/ad9832.h
deleted file mode 100644
index 386f4dc..0000000
--- a/drivers/staging/iio/frequency/ad9832.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * AD9832 SPI DDS driver
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
- */
-#ifndef IIO_DDS_AD9832_H_
-#define IIO_DDS_AD9832_H_
-
-/* Registers */
-
-#define AD9832_FREQ0LL		0x0
-#define AD9832_FREQ0HL		0x1
-#define AD9832_FREQ0LM		0x2
-#define AD9832_FREQ0HM		0x3
-#define AD9832_FREQ1LL		0x4
-#define AD9832_FREQ1HL		0x5
-#define AD9832_FREQ1LM		0x6
-#define AD9832_FREQ1HM		0x7
-#define AD9832_PHASE0L		0x8
-#define AD9832_PHASE0H		0x9
-#define AD9832_PHASE1L		0xA
-#define AD9832_PHASE1H		0xB
-#define AD9832_PHASE2L		0xC
-#define AD9832_PHASE2H		0xD
-#define AD9832_PHASE3L		0xE
-#define AD9832_PHASE3H		0xF
-
-#define AD9832_PHASE_SYM	0x10
-#define AD9832_FREQ_SYM		0x11
-#define AD9832_PINCTRL_EN	0x12
-#define AD9832_OUTPUT_EN	0x13
-
-/* Command Control Bits */
-
-#define AD9832_CMD_PHA8BITSW	0x1
-#define AD9832_CMD_PHA16BITSW	0x0
-#define AD9832_CMD_FRE8BITSW	0x3
-#define AD9832_CMD_FRE16BITSW	0x2
-#define AD9832_CMD_FPSELECT	0x6
-#define AD9832_CMD_SYNCSELSRC	0x8
-#define AD9832_CMD_SLEEPRESCLR	0xC
-
-#define AD9832_FREQ		(1 << 11)
-#define AD9832_PHASE(x)		(((x) & 3) << 9)
-#define AD9832_SYNC		(1 << 13)
-#define AD9832_SELSRC		(1 << 12)
-#define AD9832_SLEEP		(1 << 13)
-#define AD9832_RESET		(1 << 12)
-#define AD9832_CLR		(1 << 11)
-#define CMD_SHIFT		12
-#define ADD_SHIFT		8
-#define AD9832_FREQ_BITS	32
-#define AD9832_PHASE_BITS	12
-#define RES_MASK(bits)		((1 << (bits)) - 1)
-
-/**
- * struct ad9832_state - driver instance specific data
- * @spi:		spi_device
- * @reg:		supply regulator
- * @mclk:		external master clock
- * @ctrl_fp:		cached frequency/phase control word
- * @ctrl_ss:		cached sync/selsrc control word
- * @ctrl_src:		cached sleep/reset/clr word
- * @xfer:		default spi transfer
- * @msg:		default spi message
- * @freq_xfer:		tuning word spi transfer
- * @freq_msg:		tuning word spi message
- * @phase_xfer:		tuning word spi transfer
- * @phase_msg:		tuning word spi message
- * @data:		spi transmit buffer
- * @phase_data:		tuning word spi transmit buffer
- * @freq_data:		tuning word spi transmit buffer
- */
-
-struct ad9832_state {
-	struct spi_device		*spi;
-	struct regulator		*reg;
-	unsigned long			mclk;
-	unsigned short			ctrl_fp;
-	unsigned short			ctrl_ss;
-	unsigned short			ctrl_src;
-	struct spi_transfer		xfer;
-	struct spi_message		msg;
-	struct spi_transfer		freq_xfer[4];
-	struct spi_message		freq_msg;
-	struct spi_transfer		phase_xfer[2];
-	struct spi_message		phase_msg;
-	/*
-	 * DMA (thus cache coherency maintenance) requires the
-	 * transfer buffers to live in their own cache lines.
-	 */
-	union {
-		__be16			freq_data[4]____cacheline_aligned;
-		__be16			phase_data[2];
-		__be16			data;
-	};
-};
-
-/*
- * TODO: struct ad9832_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad9832_platform_data - platform specific information
- * @mclk:		master clock in Hz
- * @freq0:		power up freq0 tuning word in Hz
- * @freq1:		power up freq1 tuning word in Hz
- * @phase0:		power up phase0 value [0..4095] correlates with 0..2PI
- * @phase1:		power up phase1 value [0..4095] correlates with 0..2PI
- * @phase2:		power up phase2 value [0..4095] correlates with 0..2PI
- * @phase3:		power up phase3 value [0..4095] correlates with 0..2PI
- */
-
-struct ad9832_platform_data {
-	unsigned long		mclk;
-	unsigned long		freq0;
-	unsigned long		freq1;
-	unsigned short		phase0;
-	unsigned short		phase1;
-	unsigned short		phase2;
-	unsigned short		phase3;
-};
-
-#endif /* IIO_DDS_AD9832_H_ */
diff --git a/drivers/staging/iio/frequency/ad9834.c b/drivers/staging/iio/frequency/ad9834.c
index 86cda61..151e093 100644
--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -22,8 +22,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 #include "dds.h"
-
-#include "ad9834.h"
+#include <linux/iio/frequency/ad9834.h>
 
 static unsigned int ad9834_calc_freqreg(unsigned long mclk, unsigned long fout)
 {
diff --git a/drivers/staging/iio/frequency/ad9834.h b/drivers/staging/iio/frequency/ad9834.h
deleted file mode 100644
index 8ca6e52..0000000
--- a/drivers/staging/iio/frequency/ad9834.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * AD9833/AD9834/AD9837/AD9838 SPI DDS driver
- *
- * Copyright 2010-2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-#ifndef IIO_DDS_AD9834_H_
-#define IIO_DDS_AD9834_H_
-
-/* Registers */
-
-#define AD9834_REG_CMD		(0 << 14)
-#define AD9834_REG_FREQ0	(1 << 14)
-#define AD9834_REG_FREQ1	(2 << 14)
-#define AD9834_REG_PHASE0	(6 << 13)
-#define AD9834_REG_PHASE1	(7 << 13)
-
-/* Command Control Bits */
-
-#define AD9834_B28		(1 << 13)
-#define AD9834_HLB		(1 << 12)
-#define AD9834_FSEL		(1 << 11)
-#define AD9834_PSEL		(1 << 10)
-#define AD9834_PIN_SW		(1 << 9)
-#define AD9834_RESET		(1 << 8)
-#define AD9834_SLEEP1		(1 << 7)
-#define AD9834_SLEEP12		(1 << 6)
-#define AD9834_OPBITEN		(1 << 5)
-#define AD9834_SIGN_PIB		(1 << 4)
-#define AD9834_DIV2		(1 << 3)
-#define AD9834_MODE		(1 << 1)
-
-#define AD9834_FREQ_BITS	28
-#define AD9834_PHASE_BITS	12
-
-#define RES_MASK(bits)	((1 << (bits)) - 1)
-
-/**
- * struct ad9834_state - driver instance specific data
- * @spi:		spi_device
- * @reg:		supply regulator
- * @mclk:		external master clock
- * @control:		cached control word
- * @xfer:		default spi transfer
- * @msg:		default spi message
- * @freq_xfer:		tuning word spi transfer
- * @freq_msg:		tuning word spi message
- * @data:		spi transmit buffer
- * @freq_data:		tuning word spi transmit buffer
- */
-
-struct ad9834_state {
-	struct spi_device		*spi;
-	struct regulator		*reg;
-	unsigned int			mclk;
-	unsigned short			control;
-	unsigned short			devid;
-	struct spi_transfer		xfer;
-	struct spi_message		msg;
-	struct spi_transfer		freq_xfer[2];
-	struct spi_message		freq_msg;
-
-	/*
-	 * DMA (thus cache coherency maintenance) requires the
-	 * transfer buffers to live in their own cache lines.
-	 */
-	__be16				data ____cacheline_aligned;
-	__be16				freq_data[2];
-};
-
-
-/*
- * TODO: struct ad7887_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad9834_platform_data - platform specific information
- * @mclk:		master clock in Hz
- * @freq0:		power up freq0 tuning word in Hz
- * @freq1:		power up freq1 tuning word in Hz
- * @phase0:		power up phase0 value [0..4095] correlates with 0..2PI
- * @phase1:		power up phase1 value [0..4095] correlates with 0..2PI
- * @en_div2:		digital output/2 is passed to the SIGN BIT OUT pin
- * @en_signbit_msb_out:	the MSB (or MSB/2) of the DAC data is connected to the
- *			SIGN BIT OUT pin. en_div2 controls whether it is the MSB
- *			or MSB/2 that is output. if en_signbit_msb_out=false,
- *			the on-board comparator is connected to SIGN BIT OUT
- */
-
-struct ad9834_platform_data {
-	unsigned int		mclk;
-	unsigned int		freq0;
-	unsigned int		freq1;
-	unsigned short		phase0;
-	unsigned short		phase1;
-	bool			en_div2;
-	bool			en_signbit_msb_out;
-};
-
-/**
- * ad9834_supported_device_ids:
- */
-
-enum ad9834_supported_device_ids {
-	ID_AD9833,
-	ID_AD9834,
-	ID_AD9837,
-	ID_AD9838,
-};
-
-#endif /* IIO_DDS_AD9834_H_ */
diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index 2b96665..b88e0e5 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -23,8 +23,7 @@
 #include <linux/iio/sysfs.h>
 #include <linux/iio/buffer.h>
 #include <linux/iio/kfifo_buf.h>
-
-#include "ad5933.h"
+#include <linux/iio/impedance-analyzer/ad5933.h>
 
 /* AD5933/AD5934 Registers */
 #define AD5933_REG_CONTROL_HB		0x80	/* R/W, 2 bytes */
diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.h b/drivers/staging/iio/impedance-analyzer/ad5933.h
deleted file mode 100644
index b140e42..0000000
--- a/drivers/staging/iio/impedance-analyzer/ad5933.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * AD5933 AD5934 Impedance Converter, Network Analyzer
- *
- * Copyright 2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2.
- */
-
-#ifndef IIO_ADC_AD5933_H_
-#define IIO_ADC_AD5933_H_
-
-/*
- * TODO: struct ad5933_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad5933_platform_data - platform specific data
- * @ext_clk_Hz:		the external clock frequency in Hz, if not set
- *			the driver uses the internal clock (16.776 MHz)
- * @vref_mv:		the external reference voltage in millivolt
- */
-
-struct ad5933_platform_data {
-	unsigned long			ext_clk_Hz;
-	unsigned short			vref_mv;
-};
-
-#endif /* IIO_ADC_AD5933_H_ */
diff --git a/include/linux/iio/adc/ad7192.h b/include/linux/iio/adc/ad7192.h
new file mode 100644
index 0000000..4ca7b9d
--- /dev/null
+++ b/include/linux/iio/adc/ad7192.h
@@ -0,0 +1,43 @@
+/*
+ * AD7190 AD7192 AD7195 SPI ADC driver
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+#ifndef IIO_ADC_AD7192_H_
+#define IIO_ADC_AD7192_H_
+
+/**
+ * struct ad7192_platform_data - platform/board specific information
+ * @vref_mv:		the external reference voltage in millivolt
+ * @clock_source_sel:	[0..3]
+ *			0 External 4.92 MHz clock connected from MCLK1 to MCLK2
+ *			1 External Clock applied to MCLK2
+ *			2 Internal 4.92 MHz Clock not available at the MCLK2 pin
+ *			3 Internal 4.92 MHz Clock available at the MCLK2 pin
+ * @ext_clk_Hz:		the external clock frequency in Hz, if not set
+ *			the driver uses the internal clock (16.776 MHz)
+ * @refin2_en:		REFIN1/REFIN2 Reference Select (AD7190/2 only)
+ * @rej60_en:		50/60Hz notch filter enable
+ * @sinc3_en:		SINC3 filter enable (default SINC4)
+ * @chop_en:		CHOP mode enable
+ * @buf_en:		buffered input mode enable
+ * @unipolar_en:	unipolar mode enable
+ * @burnout_curr_en:	constant current generators on AIN(+|-) enable
+ */
+
+struct ad7192_platform_data {
+	u16		vref_mv;
+	u8		clock_source_sel;
+	u32		ext_clk_Hz;
+	bool		refin2_en;
+	bool		rej60_en;
+	bool		sinc3_en;
+	bool		chop_en;
+	bool		buf_en;
+	bool		unipolar_en;
+	bool		burnout_curr_en;
+};
+
+#endif /* IIO_ADC_AD7192_H_ */
diff --git a/include/linux/iio/adc/ad7280a.h b/include/linux/iio/adc/ad7280a.h
new file mode 100644
index 0000000..1d0bcbc
--- /dev/null
+++ b/include/linux/iio/adc/ad7280a.h
@@ -0,0 +1,34 @@
+/*
+ * AD7280A Lithium Ion Battery Monitoring System
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+
+#ifndef IIO_ADC_AD7280_H_
+#define IIO_ADC_AD7280_H_
+
+#define AD7280A_ACQ_TIME_400ns			0
+#define AD7280A_ACQ_TIME_800ns			1
+#define AD7280A_ACQ_TIME_1200ns			2
+#define AD7280A_ACQ_TIME_1600ns			3
+
+#define AD7280A_CONV_AVG_DIS			0
+#define AD7280A_CONV_AVG_2			1
+#define AD7280A_CONV_AVG_4			2
+#define AD7280A_CONV_AVG_8			3
+
+#define AD7280A_ALERT_REMOVE_VIN5		(1 << 2)
+#define AD7280A_ALERT_REMOVE_VIN4_VIN5		(2 << 2)
+#define AD7280A_ALERT_REMOVE_AUX5		(1 << 0)
+#define AD7280A_ALERT_REMOVE_AUX4_AUX5		(2 << 0)
+
+struct ad7280_platform_data {
+	unsigned acquisition_time;
+	unsigned conversion_averaging;
+	unsigned chain_last_alert_ignore;
+	bool thermistor_term_en;
+};
+
+#endif /* IIO_ADC_AD7280_H_ */
diff --git a/include/linux/iio/adc/ad7606.h b/include/linux/iio/adc/ad7606.h
new file mode 100644
index 0000000..c38ff54
--- /dev/null
+++ b/include/linux/iio/adc/ad7606.h
@@ -0,0 +1,100 @@
+/*
+ * AD7606 ADC driver
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+
+#ifndef IIO_ADC_AD7606_H_
+#define IIO_ADC_AD7606_H_
+
+/**
+ * struct ad7606_platform_data - platform/board specific information
+ * @default_os:		default oversampling value {0, 2, 4, 8, 16, 32, 64}
+ * @default_range:	default range +/-{5000, 10000} mVolt
+ * @gpio_convst:	number of gpio connected to the CONVST pin
+ * @gpio_reset:		gpio connected to the RESET pin, if not used set to -1
+ * @gpio_range:		gpio connected to the RANGE pin, if not used set to -1
+ * @gpio_os0:		gpio connected to the OS0 pin, if not used set to -1
+ * @gpio_os1:		gpio connected to the OS1 pin, if not used set to -1
+ * @gpio_os2:		gpio connected to the OS2 pin, if not used set to -1
+ * @gpio_frstdata:	gpio connected to the FRSTDAT pin, if not used set to -1
+ * @gpio_stby:		gpio connected to the STBY pin, if not used set to -1
+ */
+
+struct ad7606_platform_data {
+	unsigned			default_os;
+	unsigned			default_range;
+	unsigned			gpio_convst;
+	unsigned			gpio_reset;
+	unsigned			gpio_range;
+	unsigned			gpio_os0;
+	unsigned			gpio_os1;
+	unsigned			gpio_os2;
+	unsigned			gpio_frstdata;
+	unsigned			gpio_stby;
+};
+
+/**
+ * struct ad7606_chip_info - chip specific information
+ * @name:		identification string for chip
+ * @int_vref_mv:	the internal reference voltage
+ * @channels:		channel specification
+ * @num_channels:	number of channels
+ */
+
+struct ad7606_chip_info {
+	const char			*name;
+	u16				int_vref_mv;
+	const struct iio_chan_spec	*channels;
+	unsigned			num_channels;
+};
+
+/**
+ * struct ad7606_state - driver instance specific data
+ */
+
+struct ad7606_state {
+	struct device			*dev;
+	const struct ad7606_chip_info	*chip_info;
+	struct ad7606_platform_data	*pdata;
+	struct regulator		*reg;
+	struct work_struct		poll_work;
+	wait_queue_head_t		wq_data_avail;
+	const struct ad7606_bus_ops	*bops;
+	unsigned			range;
+	unsigned			oversampling;
+	bool				done;
+	void __iomem			*base_address;
+
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 */
+
+	unsigned short			data[8] ____cacheline_aligned;
+};
+
+struct ad7606_bus_ops {
+	/* more methods added in future? */
+	int (*read_block)(struct device *, int, void *);
+};
+
+void ad7606_suspend(struct iio_dev *indio_dev);
+void ad7606_resume(struct iio_dev *indio_dev);
+struct iio_dev *ad7606_probe(struct device *dev, int irq,
+			      void __iomem *base_address, unsigned id,
+			      const struct ad7606_bus_ops *bops);
+int ad7606_remove(struct iio_dev *indio_dev, int irq);
+int ad7606_reset(struct ad7606_state *st);
+
+enum ad7606_supported_device_ids {
+	ID_AD7606_8,
+	ID_AD7606_6,
+	ID_AD7606_4
+};
+
+int ad7606_register_ring_funcs_and_init(struct iio_dev *indio_dev);
+void ad7606_ring_cleanup(struct iio_dev *indio_dev);
+#endif /* IIO_ADC_AD7606_H_ */
diff --git a/include/linux/iio/adc/ad7780.h b/include/linux/iio/adc/ad7780.h
new file mode 100644
index 0000000..eb23730
--- /dev/null
+++ b/include/linux/iio/adc/ad7780.h
@@ -0,0 +1,26 @@
+/*
+ * AD7780/AD7781 SPI ADC driver
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+#ifndef IIO_ADC_AD7780_H_
+#define IIO_ADC_AD7780_H_
+
+/* NOTE:
+ * The AD7780 doesn't feature a dedicated SPI chip select, in addition it
+ * features a dual use data out ready DOUT/RDY output.
+ * In order to avoid contentions on the SPI bus, it's therefore necessary
+ * to use spi bus locking combined with a dedicated GPIO to control the
+ * power down reset signal of the AD7780.
+ *
+ * The DOUT/RDY output must also be wired to an interrupt capable GPIO.
+ */
+
+struct ad7780_platform_data {
+	u16				vref_mv;
+	int				gpio_pdrst;
+};
+
+#endif /* IIO_ADC_AD7780_H_ */
diff --git a/include/linux/iio/cdc/ad7746.h b/include/linux/iio/cdc/ad7746.h
new file mode 100644
index 0000000..4560885
--- /dev/null
+++ b/include/linux/iio/cdc/ad7746.h
@@ -0,0 +1,25 @@
+/*
+ * AD7746 capacitive sensor driver supporting AD7745, AD7746 and AD7747
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+
+#ifndef IIO_CDC_AD7746_H_
+#define IIO_CDC_AD7746_H_
+
+#define AD7466_EXCLVL_0		0 /* +-VDD/8 */
+#define AD7466_EXCLVL_1		1 /* +-VDD/4 */
+#define AD7466_EXCLVL_2		2 /* +-VDD * 3/8 */
+#define AD7466_EXCLVL_3		3 /* +-VDD/2 */
+
+struct ad7746_platform_data {
+	unsigned char exclvl;	/*Excitation Voltage Level */
+	bool exca_en;		/* enables EXCA pin as the excitation output */
+	bool exca_inv_en;	/* enables /EXCA pin as the excitation output */
+	bool excb_en;		/* enables EXCB pin as the excitation output */
+	bool excb_inv_en;	/* enables /EXCB pin as the excitation output */
+};
+
+#endif /* IIO_CDC_AD7746_H_ */
diff --git a/include/linux/iio/frequency/ad9832.h b/include/linux/iio/frequency/ad9832.h
new file mode 100644
index 0000000..a1dbb65
--- /dev/null
+++ b/include/linux/iio/frequency/ad9832.h
@@ -0,0 +1,122 @@
+/*
+ * AD9832 SPI DDS driver
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+#ifndef IIO_DDS_AD9832_H_
+#define IIO_DDS_AD9832_H_
+
+/* Registers */
+
+#define AD9832_FREQ0LL		0x0
+#define AD9832_FREQ0HL		0x1
+#define AD9832_FREQ0LM		0x2
+#define AD9832_FREQ0HM		0x3
+#define AD9832_FREQ1LL		0x4
+#define AD9832_FREQ1HL		0x5
+#define AD9832_FREQ1LM		0x6
+#define AD9832_FREQ1HM		0x7
+#define AD9832_PHASE0L		0x8
+#define AD9832_PHASE0H		0x9
+#define AD9832_PHASE1L		0xA
+#define AD9832_PHASE1H		0xB
+#define AD9832_PHASE2L		0xC
+#define AD9832_PHASE2H		0xD
+#define AD9832_PHASE3L		0xE
+#define AD9832_PHASE3H		0xF
+
+#define AD9832_PHASE_SYM	0x10
+#define AD9832_FREQ_SYM		0x11
+#define AD9832_PINCTRL_EN	0x12
+#define AD9832_OUTPUT_EN	0x13
+
+/* Command Control Bits */
+
+#define AD9832_CMD_PHA8BITSW	0x1
+#define AD9832_CMD_PHA16BITSW	0x0
+#define AD9832_CMD_FRE8BITSW	0x3
+#define AD9832_CMD_FRE16BITSW	0x2
+#define AD9832_CMD_FPSELECT	0x6
+#define AD9832_CMD_SYNCSELSRC	0x8
+#define AD9832_CMD_SLEEPRESCLR	0xC
+
+#define AD9832_FREQ		(1 << 11)
+#define AD9832_PHASE(x)		(((x) & 3) << 9)
+#define AD9832_SYNC		(1 << 13)
+#define AD9832_SELSRC		(1 << 12)
+#define AD9832_SLEEP		(1 << 13)
+#define AD9832_RESET		(1 << 12)
+#define AD9832_CLR		(1 << 11)
+#define CMD_SHIFT		12
+#define ADD_SHIFT		8
+#define AD9832_FREQ_BITS	32
+#define AD9832_PHASE_BITS	12
+#define RES_MASK(bits)		((1 << (bits)) - 1)
+
+/**
+ * struct ad9832_state - driver instance specific data
+ * @spi:		spi_device
+ * @reg:		supply regulator
+ * @mclk:		external master clock
+ * @ctrl_fp:		cached frequency/phase control word
+ * @ctrl_ss:		cached sync/selsrc control word
+ * @ctrl_src:		cached sleep/reset/clr word
+ * @xfer:		default spi transfer
+ * @msg:		default spi message
+ * @freq_xfer:		tuning word spi transfer
+ * @freq_msg:		tuning word spi message
+ * @phase_xfer:		tuning word spi transfer
+ * @phase_msg:		tuning word spi message
+ * @data:		spi transmit buffer
+ * @phase_data:		tuning word spi transmit buffer
+ * @freq_data:		tuning word spi transmit buffer
+ */
+
+struct ad9832_state {
+	struct spi_device		*spi;
+	struct regulator		*reg;
+	unsigned long			mclk;
+	unsigned short			ctrl_fp;
+	unsigned short			ctrl_ss;
+	unsigned short			ctrl_src;
+	struct spi_transfer		xfer;
+	struct spi_message		msg;
+	struct spi_transfer		freq_xfer[4];
+	struct spi_message		freq_msg;
+	struct spi_transfer		phase_xfer[2];
+	struct spi_message		phase_msg;
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 */
+	union {
+		__be16			freq_data[4]____cacheline_aligned;
+		__be16			phase_data[2];
+		__be16			data;
+	};
+};
+
+/**
+ * struct ad9832_platform_data - platform specific information
+ * @mclk:		master clock in Hz
+ * @freq0:		power up freq0 tuning word in Hz
+ * @freq1:		power up freq1 tuning word in Hz
+ * @phase0:		power up phase0 value [0..4095] correlates with 0..2PI
+ * @phase1:		power up phase1 value [0..4095] correlates with 0..2PI
+ * @phase2:		power up phase2 value [0..4095] correlates with 0..2PI
+ * @phase3:		power up phase3 value [0..4095] correlates with 0..2PI
+ */
+
+struct ad9832_platform_data {
+	unsigned long		mclk;
+	unsigned long		freq0;
+	unsigned long		freq1;
+	unsigned short		phase0;
+	unsigned short		phase1;
+	unsigned short		phase2;
+	unsigned short		phase3;
+};
+
+#endif /* IIO_DDS_AD9832_H_ */
diff --git a/include/linux/iio/frequency/ad9834.h b/include/linux/iio/frequency/ad9834.h
new file mode 100644
index 0000000..eea59f2
--- /dev/null
+++ b/include/linux/iio/frequency/ad9834.h
@@ -0,0 +1,107 @@
+/*
+ * AD9833/AD9834/AD9837/AD9838 SPI DDS driver
+ *
+ * Copyright 2010-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+#ifndef IIO_DDS_AD9834_H_
+#define IIO_DDS_AD9834_H_
+
+/* Registers */
+
+#define AD9834_REG_CMD		(0 << 14)
+#define AD9834_REG_FREQ0	(1 << 14)
+#define AD9834_REG_FREQ1	(2 << 14)
+#define AD9834_REG_PHASE0	(6 << 13)
+#define AD9834_REG_PHASE1	(7 << 13)
+
+/* Command Control Bits */
+
+#define AD9834_B28		(1 << 13)
+#define AD9834_HLB		(1 << 12)
+#define AD9834_FSEL		(1 << 11)
+#define AD9834_PSEL		(1 << 10)
+#define AD9834_PIN_SW		(1 << 9)
+#define AD9834_RESET		(1 << 8)
+#define AD9834_SLEEP1		(1 << 7)
+#define AD9834_SLEEP12		(1 << 6)
+#define AD9834_OPBITEN		(1 << 5)
+#define AD9834_SIGN_PIB		(1 << 4)
+#define AD9834_DIV2		(1 << 3)
+#define AD9834_MODE		(1 << 1)
+
+#define AD9834_FREQ_BITS	28
+#define AD9834_PHASE_BITS	12
+
+#define RES_MASK(bits)	((1 << (bits)) - 1)
+
+/**
+ * struct ad9834_state - driver instance specific data
+ * @spi:		spi_device
+ * @reg:		supply regulator
+ * @mclk:		external master clock
+ * @control:		cached control word
+ * @xfer:		default spi transfer
+ * @msg:		default spi message
+ * @freq_xfer:		tuning word spi transfer
+ * @freq_msg:		tuning word spi message
+ * @data:		spi transmit buffer
+ * @freq_data:		tuning word spi transmit buffer
+ */
+
+struct ad9834_state {
+	struct spi_device		*spi;
+	struct regulator		*reg;
+	unsigned int			mclk;
+	unsigned short			control;
+	unsigned short			devid;
+	struct spi_transfer		xfer;
+	struct spi_message		msg;
+	struct spi_transfer		freq_xfer[2];
+	struct spi_message		freq_msg;
+
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 */
+	__be16				data ____cacheline_aligned;
+	__be16				freq_data[2];
+};
+
+/**
+ * struct ad9834_platform_data - platform specific information
+ * @mclk:		master clock in Hz
+ * @freq0:		power up freq0 tuning word in Hz
+ * @freq1:		power up freq1 tuning word in Hz
+ * @phase0:		power up phase0 value [0..4095] correlates with 0..2PI
+ * @phase1:		power up phase1 value [0..4095] correlates with 0..2PI
+ * @en_div2:		digital output/2 is passed to the SIGN BIT OUT pin
+ * @en_signbit_msb_out:	the MSB (or MSB/2) of the DAC data is connected to the
+ *			SIGN BIT OUT pin. en_div2 controls whether it is the MSB
+ *			or MSB/2 that is output. if en_signbit_msb_out=false,
+ *			the on-board comparator is connected to SIGN BIT OUT
+ */
+
+struct ad9834_platform_data {
+	unsigned int		mclk;
+	unsigned int		freq0;
+	unsigned int		freq1;
+	unsigned short		phase0;
+	unsigned short		phase1;
+	bool			en_div2;
+	bool			en_signbit_msb_out;
+};
+
+/**
+ * ad9834_supported_device_ids:
+ */
+
+enum ad9834_supported_device_ids {
+	ID_AD9833,
+	ID_AD9834,
+	ID_AD9837,
+	ID_AD9838,
+};
+
+#endif /* IIO_DDS_AD9834_H_ */
diff --git a/include/linux/iio/impedance-analyzer/ad5933.h b/include/linux/iio/impedance-analyzer/ad5933.h
new file mode 100644
index 0000000..b140e42
--- /dev/null
+++ b/include/linux/iio/impedance-analyzer/ad5933.h
@@ -0,0 +1,28 @@
+/*
+ * AD5933 AD5934 Impedance Converter, Network Analyzer
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2.
+ */
+
+#ifndef IIO_ADC_AD5933_H_
+#define IIO_ADC_AD5933_H_
+
+/*
+ * TODO: struct ad5933_platform_data needs to go into include/linux/iio
+ */
+
+/**
+ * struct ad5933_platform_data - platform specific data
+ * @ext_clk_Hz:		the external clock frequency in Hz, if not set
+ *			the driver uses the internal clock (16.776 MHz)
+ * @vref_mv:		the external reference voltage in millivolt
+ */
+
+struct ad5933_platform_data {
+	unsigned long			ext_clk_Hz;
+	unsigned short			vref_mv;
+};
+
+#endif /* IIO_ADC_AD5933_H_ */
-- 
1.7.11.7

