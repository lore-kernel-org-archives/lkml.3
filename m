Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbaGWPLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:11:10 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:41372 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932427AbaGWPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:11:08 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: drx39xyj - fix to return actual error codes instead of -EIO
Date: Wed, 23 Jul 2014 09:11:03 -0600
Message-Id: <1406128263-5587-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several functions ignore the return values in error legs and always
return -EIO. This makes it hard to debug and take proper action in
calling routines.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c |  112 +++++++++++++--------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 54855a9..c3931cc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2159,7 +2159,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	return 0;
 
 rw_error:
-	return -EIO;
+	return rc;
 
 }
 
@@ -2252,7 +2252,7 @@ static int hi_cfg_command(const struct drx_demod_instance *demod)
 	return 0;
 
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -2363,7 +2363,7 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 	/* if ( powerdown_cmd == true ) */
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -2434,7 +2434,7 @@ static int init_hi(const struct drx_demod_instance *demod)
 	return 0;
 
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -2650,7 +2650,7 @@ static int get_device_capabilities(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -3338,7 +3338,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3421,7 +3421,7 @@ static int set_mpegtei_handling(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3464,7 +3464,7 @@ static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3508,7 +3508,7 @@ static int set_mpeg_start_width(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3652,7 +3652,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -3854,7 +3854,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*---------------------------------------------------------------------------*/
@@ -3969,7 +3969,7 @@ static int smart_ant_init(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd)
@@ -4109,7 +4109,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 	return 0;
 
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -4178,7 +4178,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 	return 0;
 
 rw_error:
-	return -EIO;
+	return rc;
 
 }
 
@@ -4290,7 +4290,7 @@ static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -4349,7 +4349,7 @@ static int adc_synchronization(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -4734,7 +4734,7 @@ static int init_agc(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -4831,7 +4831,7 @@ set_frequency(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -4879,7 +4879,7 @@ static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 #endif
 
@@ -5097,7 +5097,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -5326,7 +5326,7 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -5362,7 +5362,7 @@ static int set_iqm_af(struct drx_demod_instance *demod, bool active)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -5470,7 +5470,7 @@ static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -5686,7 +5686,7 @@ static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -6192,7 +6192,7 @@ static int set_vsb(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -6231,7 +6231,7 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -6276,7 +6276,7 @@ static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -6321,7 +6321,7 @@ static int get_vsbmer(struct i2c_device_addr *dev_addr, u16 *mer)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 
@@ -6434,7 +6434,7 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -6646,7 +6646,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -6881,7 +6881,7 @@ static int set_qam16(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -7116,7 +7116,7 @@ static int set_qam32(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -7351,7 +7351,7 @@ static int set_qam64(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -7586,7 +7586,7 @@ static int set_qam128(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -7821,7 +7821,7 @@ static int set_qam256(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -8650,7 +8650,7 @@ set_qam(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -8831,7 +8831,7 @@ static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *c
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 
 }
 
@@ -8984,7 +8984,7 @@ qam64auto(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -9068,7 +9068,7 @@ qam256auto(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -9273,7 +9273,7 @@ rw_error:
 	/* restore starting value */
 	if (auto_flag)
 		channel->constellation = DRX_CONSTELLATION_AUTO;
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -9344,7 +9344,7 @@ get_qamrs_err_count(struct i2c_device_addr *dev_addr,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -9425,8 +9425,8 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 		*sig_strength = 0;
 
 	return 0;
-	rw_error:
-	return -EIO;
+rw_error:
+	return rc;
 }
 
 /**
@@ -9643,7 +9643,7 @@ rw_error:
 	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
-	return -EIO;
+	return rc;
 }
 
 #endif /* #ifndef DRXJ_VSB_ONLY */
@@ -9810,7 +9810,7 @@ power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, boo
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -9840,7 +9840,7 @@ static int power_down_aud(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -9874,7 +9874,7 @@ static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /**
@@ -10398,7 +10398,7 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -10638,7 +10638,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*=============================================================================
@@ -10756,7 +10756,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -10844,7 +10844,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -10941,7 +10941,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 rw_error:
 	/* Don't know what the standard is now ... try again */
 	ext_attr->standard = DRX_STANDARD_UNKNOWN;
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -11222,7 +11222,7 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -11303,7 +11303,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -11530,7 +11530,7 @@ static int drxj_open(struct drx_demod_instance *demod)
 	return 0;
 rw_error:
 	common_attr->is_opened = false;
-	return -EIO;
+	return rc;
 }
 
 /*============================================================================*/
@@ -11578,7 +11578,7 @@ static int drxj_close(struct drx_demod_instance *demod)
 rw_error:
 	DRX_ATTR_ISOPENED(demod) = false;
 
-	return -EIO;
+	return rc;
 }
 
 /*
-- 
1.7.10.4

