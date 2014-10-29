Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaJ2GOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:14:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:48633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaJ2GOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:14:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="627433630"
Date: Wed, 29 Oct 2014 11:03:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [alsa-devel] [PATCH 03/11] drivers: char: add AXD Audio
 Processing IP driver
Message-ID: <20141029053353.GU28745@intel.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-4-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-4-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:21AM +0000, Qais Yousef wrote:
> +
> +/* Register I/F */
> +#define AXD_REG_VERSION							0x0000
> +#define AXD_REG_CONFIG0							0x0004
> +#define AXD_REG_CONFIG1							0x0008
> +#define AXD_REG_CONFIG2							0x000C
> +#define AXD_REG_CONFIG3							0x0010
> +#define AXD_REG_BUFFER_BASE						0x0014
> +#define AXD_REG_DEBUG_MASK						0x0018
> +/* 0x1c reserved */
> +#define AXD_REG_INPUT0_CONTROL						0x0020
> +#define AXD_REG_INPUT0_GAIN						0x0024
> +#define AXD_REG_INPUT0_UPMIX						0x0028
> +#define AXD_REG_INPUT1_CONTROL						0x0030
> +#define AXD_REG_INPUT1_GAIN						0x0034
> +#define AXD_REG_INPUT1_UPMIX						0x0038
> +#define AXD_REG_INPUT2_CONTROL						0x0040
> +#define AXD_REG_INPUT2_GAIN						0x0044
> +#define AXD_REG_INPUT2_UPMIX						0x0048
> +#define AXD_REG_INPUT0_MUTE						0x0050
> +#define AXD_REG_INPUT1_MUTE						0x0054
> +#define AXD_REG_INPUT2_MUTE						0x0058
> +#define AXD_REG_MIXER_CONTROL						0x0080
> +#define AXD_REG_EQ_CTRL_GAIN						0x0084
> +#define AXD_REG_EQ_BAND0						0x0088
> +#define AXD_REG_EQ_BAND1						0x008C
> +#define AXD_REG_EQ_BAND2						0x0090
> +#define AXD_REG_EQ_BAND3						0x0094
> +#define AXD_REG_EQ_BAND4						0x0098
> +#define AXD_REG_MUX0							0x00B0
> +#define AXD_REG_MUX1							0x00B4
> +#define AXD_REG_MUX2							0x00B8
> +#define AXD_REG_OUTPUT0_CONTROL						0x00D0
> +#define AXD_REG_OUTPUT0_DOWNMIX						0x00D4
> +#define AXD_REG_OUTPUT0_EQCTRL						0x00D8
> +#define AXD_REG_OUTPUT0_EQBAND0						0x00DC
> +#define AXD_REG_OUTPUT0_EQBAND1						0x00E0
> +#define AXD_REG_OUTPUT0_EQBAND2						0x00E4
> +#define AXD_REG_OUTPUT0_EQBAND3						0x00E8
> +#define AXD_REG_OUTPUT0_EQBAND4						0x00EC
> +#define AXD_REG_OUTPUT1_CONTROL						0x00F0
> +#define AXD_REG_OUTPUT1_DOWNMIX						0x00F4
> +#define AXD_REG_OUTPUT1_EQCTRL						0x00F8
> +#define AXD_REG_OUTPUT1_EQBAND0						0x00FC
> +#define AXD_REG_OUTPUT1_EQBAND1						0x0100
> +#define AXD_REG_OUTPUT1_EQBAND2						0x0104
> +#define AXD_REG_OUTPUT1_EQBAND3						0x0108
> +#define AXD_REG_OUTPUT1_EQBAND4						0x010C
> +#define AXD_REG_OUTPUT2_CONTROL						0x0110
> +#define AXD_REG_OUTPUT2_DOWNMIX						0x0114
> +#define AXD_REG_OUTPUT2_EQCTRL						0x0118
> +#define AXD_REG_OUTPUT2_EQBAND0						0x011C
> +#define AXD_REG_OUTPUT2_EQBAND1						0x0120
> +#define AXD_REG_OUTPUT2_EQBAND2						0x0124
> +#define AXD_REG_OUTPUT2_EQBAND3						0x0128
> +#define AXD_REG_OUTPUT2_EQBAND4						0x012c
> +#define AXD_REG_DEC0_AAC_VERSION					0x0200
> +#define AXD_REG_DEC0_AAC_CHANNELS					0x0204
> +#define AXD_REG_DEC0_AAC_PROFILE					0x0208
> +#define AXD_REG_DEC0_AAC_STREAM_TYPE					0x020C
> +#define AXD_REG_DEC0_AAC_SAMPLERATE					0x0210
> +#define AXD_REG_DEC1_AAC_VERSION					0x0220
> +#define AXD_REG_DEC1_AAC_CHANNELS					0x0224
> +#define AXD_REG_DEC1_AAC_PROFILE					0x0228
> +#define AXD_REG_DEC1_AAC_STREAM_TYPE					0x022C
> +#define AXD_REG_DEC1_AAC_SAMPLERATE					0x0230
> +#define AXD_REG_DEC2_AAC_VERSION					0x0240
> +#define AXD_REG_DEC2_AAC_CHANNELS					0x0244
> +#define AXD_REG_DEC2_AAC_PROFILE					0x0248
> +#define AXD_REG_DEC2_AAC_STREAM_TYPE					0x024C
> +#define AXD_REG_DEC2_AAC_SAMPLERATE					0x0250
> +#define AXD_REG_DEC0_COOK_FLAVOUR					0x0260
> +#define AXD_REG_DEC1_COOK_FLAVOUR					0x0264
> +#define AXD_REG_DEC2_COOK_FLAVOUR					0x0268
> +#define AXD_REG_DEC0_FLAC_CHANNELS					0x0270
> +#define AXD_REG_DEC0_FLAC_SAMPLERATE					0x0274
> +#define AXD_REG_DEC0_FLAC_BITS_PER_SAMPLE				0x0278
> +#define AXD_REG_DEC0_FLAC_MD5_CHECKING					0x027C
> +#define AXD_REG_DEC1_FLAC_CHANNELS					0x0280
> +#define AXD_REG_DEC1_FLAC_SAMPLERATE					0x0284
> +#define AXD_REG_DEC1_FLAC_BITS_PER_SAMPLE				0x0288
> +#define AXD_REG_DEC1_FLAC_MD5_CHECKING					0x028C
> +#define AXD_REG_DEC2_FLAC_CHANNELS					0x0290
> +#define AXD_REG_DEC2_FLAC_SAMPLERATE					0x0294
> +#define AXD_REG_DEC2_FLAC_BITS_PER_SAMPLE				0x0298
> +#define AXD_REG_DEC2_FLAC_MD5_CHECKING					0x029C
> +#define AXD_REG_DEC0_MPEG_CHANNELS					0x02A0
> +#define AXD_REG_DEC0_MPEG_MLCHANNEL					0x02A4
> +#define AXD_REG_DEC1_MPEG_CHANNELS					0x02A8
> +#define AXD_REG_DEC1_MPEG_MLCHANNEL					0x02AC
> +#define AXD_REG_DEC2_MPEG_CHANNELS					0x02B0
> +#define AXD_REG_DEC2_MPEG_MLCHANNEL					0x02B4
> +#define AXD_REG_DEC0_WMA_PLAYER_OPT					0x02D0
> +#define AXD_REG_DEC0_WMA_DRC_SETTING					0x02D4
> +#define AXD_REG_DEC0_WMA_PEAK_AMP_REF					0x02D8
> +#define AXD_REG_DEC0_WMA_RMS_AMP_REF					0x02DC
> +#define AXD_REG_DEC0_WMA_PEAK_AMP_TARGET				0x02E0
> +#define AXD_REG_DEC0_WMA_RMS_AMP_TARGET					0x02E4
> +#define AXD_REG_DEC0_WMA_PCM_VAL_BITS_PER_SAMPLE			0x02F4
> +#define AXD_REG_DEC0_WMA_PCM_CONTAINER_SIZE				0x02F8
> +#define AXD_REG_DEC0_WMA_WMA_FORMAT_TAG					0x02FC
> +#define AXD_REG_DEC0_WMA_WMA_CHANNELS					0x0300
> +#define AXD_REG_DEC0_WMA_WMA_SAMPLES_PER_SEC				0x0304
> +#define AXD_REG_DEC0_WMA_WMA_AVG_BYTES_PER_SEC				0x0308
> +#define AXD_REG_DEC0_WMA_WMA_BLOCK_ALIGN				0x030C
> +#define AXD_REG_DEC0_WMA_WMA_VAL_BITS_PER_SAMPLE			0x0310
> +#define AXD_REG_DEC0_WMA_WMA_CHANNEL_MASK				0x0314
> +#define AXD_REG_DEC0_WMA_WMA_ENCODE_OPTS				0x0318
> +#define AXD_REG_DEC1_WMA_PLAYER_OPT					0x0320
> +#define AXD_REG_DEC1_WMA_DRC_SETTING					0x0324
> +#define AXD_REG_DEC1_WMA_PEAK_AMP_REF					0x0328
> +#define AXD_REG_DEC1_WMA_RMS_AMP_REF					0x032C
> +#define AXD_REG_DEC1_WMA_PEAK_AMP_TARGET				0x0330
> +#define AXD_REG_DEC1_WMA_RMS_AMP_TARGET					0x0334
> +#define AXD_REG_DEC1_WMA_PCM_VAL_BITS_PER_SAMPLE			0x0344
> +#define AXD_REG_DEC1_WMA_PCM_CONTAINER_SIZE				0x0348
> +#define AXD_REG_DEC1_WMA_WMA_FORMAT_TAG					0x034C
> +#define AXD_REG_DEC1_WMA_WMA_CHANNELS					0x0350
> +#define AXD_REG_DEC1_WMA_WMA_SAMPLES_PER_SEC				0x0354
> +#define AXD_REG_DEC1_WMA_WMA_AVG_BYTES_PER_SEC				0x0358
> +#define AXD_REG_DEC1_WMA_WMA_BLOCK_ALIGN				0x035C
> +#define AXD_REG_DEC1_WMA_WMA_VAL_BITS_PER_SAMPLE			0x0360
> +#define AXD_REG_DEC1_WMA_WMA_CHANNEL_MASK				0x0364
> +#define AXD_REG_DEC1_WMA_WMA_ENCODE_OPTS				0x0368
> +#define AXD_REG_DEC2_WMA_PLAYER_OPT					0x0370
> +#define AXD_REG_DEC2_WMA_DRC_SETTING					0x0374
> +#define AXD_REG_DEC2_WMA_PEAK_AMP_REF					0x0378
> +#define AXD_REG_DEC2_WMA_RMS_AMP_REF					0x037C
> +#define AXD_REG_DEC2_WMA_PEAK_AMP_TARGET				0x0380
> +#define AXD_REG_DEC2_WMA_RMS_AMP_TARGET					0x0384
> +#define AXD_REG_DEC2_WMA_PCM_VAL_BITS_PER_SAMPLE			0x0394
> +#define AXD_REG_DEC2_WMA_PCM_CONTAINER_SIZE				0x0398
> +#define AXD_REG_DEC2_WMA_WMA_FORMAT_TAG					0x039C
> +#define AXD_REG_DEC2_WMA_WMA_CHANNELS					0x03A0
> +#define AXD_REG_DEC2_WMA_WMA_SAMPLES_PER_SEC				0x03A4
> +#define AXD_REG_DEC2_WMA_WMA_AVG_BYTES_PER_SEC				0x03A8
> +#define AXD_REG_DEC2_WMA_WMA_BLOCK_ALIGN				0x03AC
> +#define AXD_REG_DEC2_WMA_WMA_VAL_BITS_PER_SAMPLE			0x03B0
> +#define AXD_REG_DEC2_WMA_WMA_CHANNEL_MASK				0x03B4
> +#define AXD_REG_DEC2_WMA_WMA_ENCODE_OPTS				0x03B8
> +#define AXD_REG_PCMIN0_SAMPLE_RATE					0x3C0
> +#define AXD_REG_PCMIN0_CHANNELS						0x3C4
> +#define AXD_REG_PCMIN0_BITS_PER_SAMPLE					0x3C8
> +#define AXD_REG_PCMIN0_JUSTIFICATION					0x3CC
> +#define AXD_REG_PCMIN1_SAMPLE_RATE					0x3D0
> +#define AXD_REG_PCMIN1_CHANNELS						0x3D4
> +#define AXD_REG_PCMIN1_BITS_PER_SAMPLE					0x3D8
> +#define AXD_REG_PCMIN1_JUSTIFICATION					0x3DC
> +#define AXD_REG_PCMIN2_SAMPLE_RATE					0x3E0
> +#define AXD_REG_PCMIN2_CHANNELS						0x3E4
> +#define AXD_REG_PCMIN2_BITS_PER_SAMPLE					0x3E8
> +#define AXD_REG_PCMIN2_JUSTIFICATION					0x3EC
> +#define AXD_REG_PCMOUT0_BITS_PER_SAMPLE					0x3F0
> +#define AXD_REG_PCMOUT0_JUSTIFICATION					0x3F4
> +#define AXD_REG_PCMOUT1_BITS_PER_SAMPLE					0x3F8
> +#define AXD_REG_PCMOUT1_JUSTIFICATION					0x3FC
> +#define AXD_REG_PCMOUT2_BITS_PER_SAMPLE					0x400
> +#define AXD_REG_PCMOUT2_JUSTIFICATION					0x404
> +#define AXD_REG_DEC0_AC3_CHANNELS					0x410
> +#define AXD_REG_DEC0_AC3_CHANNEL_ORDER					0x414
> +#define AXD_REG_DEC0_AC3_MODE						0x418
> +#define AXD_REG_DEC1_AC3_CHANNELS					0x420
> +#define AXD_REG_DEC1_AC3_CHANNEL_ORDER					0x424
> +#define AXD_REG_DEC1_AC3_MODE						0x428
> +#define AXD_REG_DEC2_AC3_CHANNELS					0x430
> +#define AXD_REG_DEC2_AC3_CHANNEL_ORDER					0x434
> +#define AXD_REG_DEC2_AC3_MODE						0x438
> +#define AXD_REG_DEC0_DDPLUS_CONFIG					0x440
> +#define AXD_REG_DEC0_DDPLUS_CHANNEL_ORDER				0x444
> +#define AXD_REG_DEC1_DDPLUS_CONFIG					0x448
> +#define AXD_REG_DEC1_DDPLUS_CHANNEL_ORDER				0x44C
> +#define AXD_REG_DEC2_DDPLUS_CONFIG					0x450
> +#define AXD_REG_DEC2_DDPLUS_CHANNEL_ORDER				0x454
> +#define AXD_REG_EQ_OUT0_POWER_B0_C0_C3					0x460
> +#define AXD_REG_EQ_OUT0_POWER_B0_C4_C7					0x464
> +#define AXD_REG_EQ_OUT0_POWER_B1_C0_C3					0x468
> +#define AXD_REG_EQ_OUT0_POWER_B1_C4_C7					0x46C
> +#define AXD_REG_EQ_OUT0_POWER_B2_C0_C3					0x470
> +#define AXD_REG_EQ_OUT0_POWER_B2_C4_C7					0x474
> +#define AXD_REG_EQ_OUT0_POWER_B3_C0_C3					0x478
> +#define AXD_REG_EQ_OUT0_POWER_B3_C4_C7					0x47C
> +#define AXD_REG_EQ_OUT0_POWER_B4_C0_C3					0x480
> +#define AXD_REG_EQ_OUT0_POWER_B4_C4_C7					0x484
> +#define AXD_REG_EQ_OUT1_POWER_B0_C0_C3					0x488
> +#define AXD_REG_EQ_OUT1_POWER_B0_C4_C7					0x48C
> +#define AXD_REG_EQ_OUT1_POWER_B1_C0_C3					0x490
> +#define AXD_REG_EQ_OUT1_POWER_B1_C4_C7					0x494
> +#define AXD_REG_EQ_OUT1_POWER_B2_C0_C3					0x498
> +#define AXD_REG_EQ_OUT1_POWER_B2_C4_C7					0x49C
> +#define AXD_REG_EQ_OUT1_POWER_B3_C0_C3					0x4A0
> +#define AXD_REG_EQ_OUT1_POWER_B3_C4_C7					0x4A4
> +#define AXD_REG_EQ_OUT1_POWER_B4_C0_C3					0x4A8
> +#define AXD_REG_EQ_OUT1_POWER_B4_C4_C7					0x4AC
> +#define AXD_REG_EQ_OUT2_POWER_B0_C0_C3					0x4B0
> +#define AXD_REG_EQ_OUT2_POWER_B0_C4_C7					0x4B4
> +#define AXD_REG_EQ_OUT2_POWER_B1_C0_C3					0x4B8
> +#define AXD_REG_EQ_OUT2_POWER_B1_C4_C7					0x4BC
> +#define AXD_REG_EQ_OUT2_POWER_B2_C0_C3					0x4C0
> +#define AXD_REG_EQ_OUT2_POWER_B2_C4_C7					0x4C4
> +#define AXD_REG_EQ_OUT2_POWER_B3_C0_C3					0x4C8
> +#define AXD_REG_EQ_OUT2_POWER_B3_C4_C7					0x4CC
> +#define AXD_REG_EQ_OUT2_POWER_B4_C0_C3					0x4D0
> +#define AXD_REG_EQ_OUT2_POWER_B4_C4_C7					0x4D4
> +#define AXD_REG_RESAMPLER0_FIN						0x4E0
> +#define AXD_REG_RESAMPLER0_FOUT						0x4E4
> +#define AXD_REG_RESAMPLER1_FIN						0x4E8
> +#define AXD_REG_RESAMPLER1_FOUT						0x4EC
> +#define AXD_REG_RESAMPLER2_FIN						0x4F0
> +#define AXD_REG_RESAMPLER2_FOUT						0x4f4
> +#define AXD_REG_DEC0_ALAC_CHANNELS					0x500
> +#define AXD_REG_DEC0_ALAC_DEPTH						0x504
> +#define AXD_REG_DEC0_ALAC_SAMPLE_RATE					0x508
> +#define AXD_REG_DEC0_ALAC_FRAME_LENGTH					0x50C
> +#define AXD_REG_DEC0_ALAC_MAX_FRAME_BYTES				0x510
> +#define AXD_REG_DEC0_ALAC_AVG_BIT_RATE					0x514
> +#define AXD_REG_DEC1_ALAC_CHANNELS					0x520
> +#define AXD_REG_DEC1_ALAC_DEPTH						0x524
> +#define AXD_REG_DEC1_ALAC_SAMPLE_RATE					0x528
> +#define AXD_REG_DEC1_ALAC_FRAME_LENGTH					0x52C
> +#define AXD_REG_DEC1_ALAC_MAX_FRAME_BYTES				0x530
> +#define AXD_REG_DEC1_ALAC_AVG_BIT_RATE					0x534
> +#define AXD_REG_DEC2_ALAC_CHANNELS					0x540
> +#define AXD_REG_DEC2_ALAC_DEPTH						0x544
> +#define AXD_REG_DEC2_ALAC_SAMPLE_RATE					0x548
> +#define AXD_REG_DEC2_ALAC_FRAME_LENGTH					0x54C
> +#define AXD_REG_DEC2_ALAC_MAX_FRAME_BYTES				0x550
> +#define AXD_REG_DEC2_ALAC_AVG_BIT_RATE					0x554
> +/* 0x558 to 0x55C reserved */
> +#define AXD_REG_ENC0_FLAC_CHANNELS					0x560
> +#define AXD_REG_ENC0_FLAC_BITS_PER_SAMPLE				0x564
> +#define AXD_REG_ENC0_FLAC_SAMPLE_RATE					0x568
> +#define AXD_REG_ENC0_FLAC_TOTAL_SAMPLES					0x56C
> +#define AXD_REG_ENC0_FLAC_DO_MID_SIDE_STEREO				0x570
> +#define AXD_REG_ENC0_FLAC_LOOSE_MID_SIDE_STEREO				0x574
> +#define AXD_REG_ENC0_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH			0x578
> +#define AXD_REG_ENC0_FLAC_MIN_RESIDUAL_PARTITION_ORDER			0x57C
> +#define AXD_REG_ENC0_FLAC_MAX_RESIDUAL_PARTITION_ORDER			0x580
> +#define AXD_REG_ENC0_FLAC_BLOCK_SIZE					0x584
> +#define AXD_REG_ENC0_FLAC_BYTE_COUNT					0x588
> +#define AXD_REG_ENC0_FLAC_SAMPLE_COUNT					0x58C
> +#define AXD_REG_ENC0_FLAC_FRAME_COUNT					0x590
> +#define AXD_REG_ENC0_FLAC_FRAME_BYTES					0x594
> +/* 0x598 to 0x59C reserved */
> +#define AXD_REG_ENC1_FLAC_CHANNELS					0x5A0
> +#define AXD_REG_ENC1_FLAC_BITS_PER_SAMPLE				0x5A4
> +#define AXD_REG_ENC1_FLAC_SAMPLE_RATE					0x5A8
> +#define AXD_REG_ENC1_FLAC_TOTAL_SAMPLES					0x5AC
> +#define AXD_REG_ENC1_FLAC_DO_MID_SIDE_STEREO				0x5B0
> +#define AXD_REG_ENC1_FLAC_LOOSE_MID_SIDE_STEREO				0x5B4
> +#define AXD_REG_ENC1_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH			0x5B8
> +#define AXD_REG_ENC1_FLAC_MIN_RESIDUAL_PARTITION_ORDER			0x5BC
> +#define AXD_REG_ENC1_FLAC_MAX_RESIDUAL_PARTITION_ORDER			0x5C0
> +#define AXD_REG_ENC1_FLAC_BLOCK_SIZE					0x5C4
> +#define AXD_REG_ENC1_FLAC_BYTE_COUNT					0x5C8
> +#define AXD_REG_ENC1_FLAC_SAMPLE_COUNT					0x5CC
> +#define AXD_REG_ENC1_FLAC_FRAME_COUNT					0x5D0
> +#define AXD_REG_ENC1_FLAC_FRAME_BYTES					0x5D4
> +/* 0x5D8 to 0x5DC reserved */
> +#define AXD_REG_ENC2_FLAC_CHANNELS					0x5E0
> +#define AXD_REG_ENC2_FLAC_BITS_PER_SAMPLE				0x5E4
> +#define AXD_REG_ENC2_FLAC_SAMPLE_RATE					0x5E8
> +#define AXD_REG_ENC2_FLAC_TOTAL_SAMPLES					0x5EC
> +#define AXD_REG_ENC2_FLAC_DO_MID_SIDE_STEREO				0x5F0
> +#define AXD_REG_ENC2_FLAC_LOOSE_MID_SIDE_STEREO				0x5F4
> +#define AXD_REG_ENC2_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH			0x5F8
> +#define AXD_REG_ENC2_FLAC_MIN_RESIDUAL_PARTITION_ORDER			0x5FC
> +#define AXD_REG_ENC2_FLAC_MAX_RESIDUAL_PARTITION_ORDER			0x600
> +#define AXD_REG_ENC2_FLAC_BLOCK_SIZE					0x604
> +#define AXD_REG_ENC2_FLAC_BYTE_COUNT					0x608
> +#define AXD_REG_ENC2_FLAC_SAMPLE_COUNT					0x60C
> +#define AXD_REG_ENC2_FLAC_FRAME_COUNT					0x610
> +#define AXD_REG_ENC2_FLAC_FRAME_BYTES					0x614
> +/* 0x618 to 0x61C reserved */
> +#define AXD_REG_ENC0_ALAC_CHANNELS					0x620
> +#define AXD_REG_ENC0_ALAC_DEPTH						0x624
> +#define AXD_REG_ENC0_ALAC_SAMPLE_RATE					0x628
> +#define AXD_REG_ENC0_ALAC_FRAME_LENGTH					0x62C
> +#define AXD_REG_ENC0_ALAC_MAX_FRAME_BYTES				0x630
> +#define AXD_REG_ENC0_ALAC_AVG_BIT_RATE					0x634
> +#define AXD_REG_ENC0_ALAC_FAST_MODE					0x638
> +/* 0x63C to 0x64C reserved */
> +#define AXD_REG_ENC1_ALAC_CHANNELS					0x650
> +#define AXD_REG_ENC1_ALAC_DEPTH						0x654
> +#define AXD_REG_ENC1_ALAC_SAMPLE_RATE					0x658
> +#define AXD_REG_ENC1_ALAC_FRAME_LENGTH					0x65C
> +#define AXD_REG_ENC1_ALAC_MAX_FRAME_BYTES				0x660
> +#define AXD_REG_ENC1_ALAC_AVG_BIT_RATE					0x664
> +#define AXD_REG_ENC1_ALAC_FAST_MODE					0x668
> +/* 0x66C to 0x67C reserved */
> +#define AXD_REG_ENC2_ALAC_CHANNELS					0x680
> +#define AXD_REG_ENC2_ALAC_DEPTH						0x684
> +#define AXD_REG_ENC2_ALAC_SAMPLE_RATE					0x688
> +#define AXD_REG_ENC2_ALAC_FRAME_LENGTH					0x68C
> +#define AXD_REG_ENC2_ALAC_MAX_FRAME_BYTES				0x690
> +#define AXD_REG_ENC2_ALAC_AVG_BIT_RATE					0x694
> +#define AXD_REG_ENC2_ALAC_FAST_MODE					0x698
> +/* 0x69C to 0x6AC reserved */
> +#define AXD_REG_MS11_MODE						0x6B0
> +#define AXD_REG_MS11_COMMON_CONFIG0					0x6B4
> +#define AXD_REG_MS11_COMMON_CONFIG1					0x6B8
> +#define AXD_REG_MS11_DDT_CONFIG0					0x6Bc
> +#define AXD_REG_MS11_DDC_CONFIG0					0x6C0
> +#define AXD_REG_MS11_EXT_PCM_CONFIG0					0x6C4
> +/* 0x6C8 and 0x6CC reserved */
> +#define AXD_REG_OUTPUT0_DCPP_CONTROL					0x6D0
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_CONTROL				0x6D4
> +#define AXD_REG_OUTPUT0_DCPP_BAND_CONTROL				0x6D8
> +#define AXD_REG_OUTPUT0_DCPP_MAX_DELAY_SAMPLES				0x6DC
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_DELAY_SAMPLES			0x6E0
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_SHIFT			0x6E4
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A0			0x6E8
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A1			0x6EC
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A2			0x6F0
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_B0			0x6F4
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_B1			0x6F8
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_SHIFT			0x6FC
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A0			0x700
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A1			0x704
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A2			0x708
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_B0			0x70C
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_B1			0x710
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_OUTPUT_VOLUME			0x714
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN		0x718
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN	0x71C
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_GAIN			0x720
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A0				0x724
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A1				0x728
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A2				0x72C
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_B0				0x730
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_B1				0x734
> +#define AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_SHIFT			0x738
> +#define AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A0			0x73C
> +#define AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A1			0x740
> +#define AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A2			0x744
> +#define AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_B0			0x748
> +#define AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_B1			0x74C
> +/* 0x750 to 0x764 reserved */
> +#define AXD_REG_OUTPUT1_DCPP_CONTROL					0x768
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_CONTROL				0x76C
> +#define AXD_REG_OUTPUT1_DCPP_BAND_CONTROL				0x770
> +#define AXD_REG_OUTPUT1_DCPP_MAX_DELAY_SAMPLES				0x774
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_DELAY_SAMPLES			0x778
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_SHIFT			0x77C
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A0			0x780
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A1			0x784
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A2			0x788
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_B0			0x78C
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_B1			0x790
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_SHIFT			0x794
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A0			0x798
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A1			0x79C
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A2			0x7A0
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_B0			0x7A4
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_B1			0x7A8
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_OUTPUT_VOLUME			0x7AC
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN		0x7B0
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN	0x7B4
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_GAIN			0x7B8
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A0				0x7BC
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A1				0x7C0
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A2				0x7C4
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_B0				0x7C8
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_B1				0x7CC
> +#define AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_SHIFT			0x7D0
> +#define AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A0			0x7D4
> +#define AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A1			0x7D8
> +#define AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A2			0x7DC
> +#define AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_B0			0x7E0
> +#define AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_B1			0x7E4
> +/* 0x7E8 to 0x7FC reserved */
> +#define AXD_REG_OUTPUT2_DCPP_CONTROL					0x800
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_CONTROL				0x804
> +#define AXD_REG_OUTPUT2_DCPP_BAND_CONTROL				0x808
> +#define AXD_REG_OUTPUT2_DCPP_MAX_DELAY_SAMPLES				0x80C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_DELAY_SAMPLES			0x810
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_SHIFT			0x814
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A0			0x818
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A1			0x81C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A2			0x820
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_B0			0x824
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_B1			0x828
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_SHIFT			0x82C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A0			0x830
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A1			0x834
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A2			0x838
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_B0			0x83C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_B1			0x840
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_OUTPUT_VOLUME			0x844
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN		0x848
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN	0x84C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_GAIN			0x850
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A0				0x854
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A1				0x858
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A2				0x85C
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_B0				0x860
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_B1				0x864
> +#define AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_SHIFT			0x868
> +#define AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A0			0x86C
> +#define AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A1			0x870
> +#define AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A2			0x874
> +#define AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_B0			0x878
> +#define AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_B1			0x87C
> +/* 0x880 to 0x89C reserved */
> +#define AXD_REG_DEC0_SBC_SAMPLE_RATE					0x8A0
> +#define AXD_REG_DEC0_SBC_AUDIO_MODE					0x8A4
> +#define AXD_REG_DEC0_SBC_BLOCKS						0x8A8
> +#define AXD_REG_DEC0_SBC_SUBBANDS					0x8AC
> +#define AXD_REG_DEC0_SBC_BITPOOL					0x8B0
> +#define AXD_REG_DEC0_SBC_ALLOCATION_MODE				0x8B4
> +#define AXD_REG_DEC1_SBC_SAMPLE_RATE					0x8B8
> +#define AXD_REG_DEC1_SBC_AUDIO_MODE					0x8BC
> +#define AXD_REG_DEC1_SBC_BLOCKS						0x8C0
> +#define AXD_REG_DEC1_SBC_SUBBANDS					0x8C4
> +#define AXD_REG_DEC1_SBC_BITPOOL					0x8C8
> +#define AXD_REG_DEC1_SBC_ALLOCATION_MODE				0x8CC
> +#define AXD_REG_DEC2_SBC_SAMPLE_RATE					0x8D0
> +#define AXD_REG_DEC2_SBC_AUDIO_MODE					0x8D4
> +#define AXD_REG_DEC2_SBC_BLOCKS						0x8D8
> +#define AXD_REG_DEC2_SBC_SUBBANDS					0x8DC
> +#define AXD_REG_DEC2_SBC_BITPOOL					0x8E0
> +#define AXD_REG_DEC2_SBC_ALLOCATION_MODE				0x8E4
> +/* 0x8E8 to 0x8EC reserved */
> +#define AXD_REG_SYNC_MODE						0x8F0
> +/* 0x8F4 to 0x8FC reserved */
> +#define AXD_REG_INPUT0_BUFFER_OCCUPANCY					0x900
> +#define AXD_REG_INPUT1_BUFFER_OCCUPANCY					0x904
> +#define AXD_REG_INPUT2_BUFFER_OCCUPANCY					0x908
> +/* 0x90C reserved */
> +
> +/* Register masks */
> +#define AXD_INCTRL_ENABLE_MASK		0x1
> +#define AXD_INCTRL_ENABLE_SHIFT		31
> +#define AXD_INCTRL_ENABLE_BITS		\
> +	(AXD_INCTRL_ENABLE_MASK << AXD_INCTRL_ENABLE_SHIFT)
> +#define AXD_INCTRL_SOURCE_MASK		0x3
> +#define AXD_INCTRL_SOURCE_SHIFT		8
> +#define AXD_INCTRL_SOURCE_BITS		\
> +	(AXD_INCTRL_SOURCE_MASK << AXD_INCTRL_SOURCE_SHIFT)
> +#define AXD_INCTRL_CODEC_MASK		0x7FF
> +#define AXD_INCTRL_CODEC_SHIFT		0
> +#define AXD_INCTRL_CODEC_BITS		\
> +	(AXD_INCTRL_CODEC_MASK << AXD_INCTRL_CODEC_SHIFT)
> +
> +#define AXD_OUTCTRL_ENABLE_MASK		0x1
> +#define AXD_OUTCTRL_ENABLE_SHIFT	31
> +#define AXD_OUTCTRL_ENABLE_BITS		\
> +	(AXD_OUTCTRL_ENABLE_MASK << AXD_OUTCTRL_ENABLE_SHIFT)
> +#define AXD_OUTCTRL_SINK_MASK		0x3
> +#define AXD_OUTCTRL_SINK_SHIFT		0
> +#define AXD_OUTCTRL_SINK_BITS		\
> +	(AXD_OUTCTRL_SINK_MASK << AXD_OUTCTRL_SINK_SHIFT)
> +#define AXD_OUTCTRL_CODEC_MASK		0xFF
> +#define AXD_OUTCTRL_CODEC_SHIFT		2
> +#define AXD_OUTCTRL_CODEC_BITS		\
> +	(AXD_OUTCTRL_CODEC_MASK << AXD_OUTCTRL_CODEC_SHIFT)
> +
> +#define AXD_EQCTRL_ENABLE_MASK		0x1
> +#define AXD_EQCTRL_ENABLE_SHIFT		31
> +#define AXD_EQCTRL_ENABLE_BITS		\
> +	(AXD_EQCTRL_ENABLE_MASK << AXD_EQCTRL_ENABLE_SHIFT)
> +#define AXD_EQCTRL_GAIN_MASK		0x7F
> +#define AXD_EQCTRL_GAIN_SHIFT		0
> +#define AXD_EQCTRL_GAIN_BITS		\
> +	(AXD_EQCTRL_GAIN_MASK << AXD_EQCTRL_GAIN_SHIFT)
> +
> +#define AXD_EQBANDX_GAIN_MASK		0xFF
> +#define AXD_EQBANDX_GAIN_SHIFT		0
> +#define AXD_EQBANDX_GAIN_BITS		\
> +	(AXD_EQBANDX_GAIN_MASK << AXD_EQBANDX_GAIN_SHIFT)
> +
> +#define AXD_DCPP_CTRL_ENABLE_MASK			0x1
> +#define AXD_DCPP_CTRL_ENABLE_SHIFT			31
> +#define AXD_DCPP_CTRL_ENABLE_BITS			\
> +	(AXD_DCPP_CTRL_ENABLE_MASK << AXD_DCPP_CTRL_ENABLE_SHIFT)
> +#define AXD_DCPP_CTRL_CHANNELS_MASK			0xF
> +#define AXD_DCPP_CTRL_CHANNELS_SHIFT			27
> +#define AXD_DCPP_CTRL_CHANNELS_BITS			\
> +	(AXD_DCPP_CTRL_CHANNELS_MASK << AXD_DCPP_CTRL_CHANNELS_SHIFT)
> +#define AXD_DCPP_CTRL_MODE_MASK				0x1
> +#define AXD_DCPP_CTRL_MODE_SHIFT			26
> +#define AXD_DCPP_CTRL_MODE_BITS				\
> +	(AXD_DCPP_CTRL_MODE_MASK << AXD_DCPP_CTRL_MODE_SHIFT)
> +#define AXD_DCPP_CTRL_EQ_MODE_MASK			0x1
> +#define AXD_DCPP_CTRL_EQ_MODE_SHIFT			25
> +#define AXD_DCPP_CTRL_EQ_MODE_BITS			\
> +	(AXD_DCPP_CTRL_EQ_MODE_MASK << AXD_DCPP_CTRL_EQ_MODE_SHIFT)
> +#define AXD_DCPP_CTRL_EQ_BANDS_MASK			0xFF
> +#define AXD_DCPP_CTRL_EQ_BANDS_SHIFT			17
> +#define AXD_DCPP_CTRL_EQ_BANDS_BITS			\
> +	(AXD_DCPP_CTRL_EQ_BANDS_MASK << AXD_DCPP_CTRL_EQ_BANDS_SHIFT)
> +#define AXD_DCPP_CTRL_SUBBAND_ENABLE_MASK		0x1
> +#define AXD_DCPP_CTRL_SUBBAND_ENABLE_SHIFT		16
> +#define AXD_DCPP_CTRL_SUBBAND_ENABLE_BITS		\
> +	(AXD_DCPP_CTRL_SUBBAND_ENABLE_MASK << AXD_DCPP_CTRL_SUBBAND_ENABLE_SHIFT)
> +#define AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_MASK		0xFF
> +#define AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_SHIFT	8
> +#define AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_BITS		\
> +	(AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_MASK << AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_SHIFT)
> +#define AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_MASK		0xFF
> +#define AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_SHIFT		0
> +#define AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_BITS		\
> +	(AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_MASK << AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_SHIFT)
> +
> +#define AXD_DCPP_CHANNEL_CTRL_CHANNEL_MASK	0xFF
> +#define AXD_DCPP_CHANNEL_CTRL_CHANNEL_SHIFT	24
> +#define AXD_DCPP_CHANNEL_CTRL_CHANNEL_BITS	\
> +	(AXD_DCPP_CHANNEL_CTRL_CHANNEL_MASK << AXD_DCPP_CHANNEL_CTRL_CHANNEL_SHIFT)
> +#define AXD_DCPP_CHANNEL_CTRL_SUBBAND_MASK	0x1
> +#define AXD_DCPP_CHANNEL_CTRL_SUBBAND_SHIFT	23
> +#define AXD_DCPP_CHANNEL_CTRL_SUBBAND_BITS	\
> +	(AXD_DCPP_CHANNEL_CTRL_SUBBAND_MASK << AXD_DCPP_CHANNEL_CTRL_SUBBAND_SHIFT)
> +
All these should really be ASoC codec/DSP register map and let DAPM and ASoC
infrastructure handle these much better than you have done here

> +/* set the presentation time stamp (pts) for the buffer to be sent next */
> +static void set_next_pts(struct axd_dev *axd, unsigned int pipe, u64 pts)
> +{
> +	int ret;
> +
> +	if (!axd_get_flag(&axd->cmd.started_flg)) {
> +		if (axd_ts_reset)
> +			axd_ts_reset();
> +		axd_set_flag(&axd->cmd.started_flg, 1);
> +	}
> +
> +	if (axd_ts_adjust) {
> +		ret = axd_ts_adjust(&pts);
> +		if (ret)
> +			dev_err(axd->dev, "Timestamp adjust failed\n");
> +	}
> +
> +	axd->cmd.in_pipes[pipe].current_ts_high = pts >> 32;
> +	axd->cmd.in_pipes[pipe].current_ts_low = pts & 0xffffffff;
> +}
how is this different from ALSA timestamp and new work being done at to add
start_at() APIs??

> +
> +/*
> + * note if we plan to support more than 1 AXD instance this will need to become
> + * an array indexed by device id.
> + */
> +static struct axd_dev *__axd;
> +
> +/*
> + * only a single process can open an input/output device node at a time. And
> + * only that process can release that device node.
> + *
> + * semaphores ensure this behaviour.
> + */
> +static int axd_open(struct inode *inode, struct file *filp)
> +{
> +	struct axd_dev *axd = container_of(inode->i_cdev, struct axd_dev, cdev);
> +	unsigned int minor = MINOR(inode->i_rdev);
> +	int type = minor_to_devtype(minor);
> +	int ret;
> +	int i;
> +
> +	/* save the inode for other methods */
> +	filp->private_data = inode;
> +
> +	if (axd_get_flag(&axd->cmd.fw_stopped_flg))
> +		return -EAGAIN;
> +
> +	switch (type) {
> +	case AXD_CTRL:
> +		/* nothing to do in here */
> +		break;
> +	case AXD_INPUT:
> +		if ((filp->f_flags & O_ACCMODE) != O_WRONLY)
> +			return -EPERM;
> +
> +		axd->cmd.nonblock = filp->f_flags & O_NONBLOCK;
> +
> +		ret = down_trylock(&axd->input_locks[MINOR_TO_INPUT(minor)]);
> +		if (ret)
> +			return -EBUSY;
> +
> +		/* Are any pipes running? */
> +		for (i = 0; i < AXD_MAX_PIPES; i++) {
> +			if (axd_cmd_inpipe_active(&axd->cmd, i))
> +				goto pipes_running;
> +		}
> +
> +		/* Invalidate any clock tracking from previous use */
> +		axd_set_flag(&axd->cmd.started_flg, 0);
> +pipes_running:
> +
> +		ret = axd_cmd_inpipe_start(&axd->cmd, MINOR_TO_INPUT(minor));
> +		if (ret) {
> +			up(&axd->input_locks[MINOR_TO_INPUT(minor)]);
> +			return ret;
> +		}
> +
> +		break;
> +	case AXD_OUTPUT:
> +		if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
> +			return -EPERM;
> +
> +		axd->cmd.nonblock = filp->f_flags & O_NONBLOCK;
> +
> +		ret = down_trylock(&axd->output_locks[MINOR_TO_OUTPUT(minor)]);
> +		if (ret)
> +			return -EBUSY;
> +		ret = axd_cmd_outpipe_start(&axd->cmd, MINOR_TO_OUTPUT(minor));
> +		if (ret) {
> +			up(&axd->output_locks[MINOR_TO_OUTPUT(minor)]);
> +			return ret;
> +		}
> +		break;
> +	default:
> +		dev_err(axd->dev, "Unknown device type\n");
> +		return -EINVAL;
> +	}
> +	return 0;
ALSA does all this and much more, sigh!


> +static ssize_t axd_read(struct file *filp, char __user *buff, size_t count,
> +								loff_t *offp)
> +{
> +	struct inode *inode = filp->private_data;
> +	struct axd_dev *axd = container_of(inode->i_cdev, struct axd_dev, cdev);
> +	unsigned int minor = MINOR(inode->i_rdev);
> +	unsigned int pipe = MINOR_TO_OUTPUT(minor);
> +	ssize_t read = 0;
> +
> +	if (axd_get_flag(&axd->cmd.fw_stopped_flg))
> +		return 0;
> +
> +	/* read the log when it's the ctrl device */
> +	if (!minor)
> +		return axd_read_log(axd, buff, count, offp);
> +
> +	if (axd_get_flag(&axd->timestamps_out_flg)) {
> +		copy_to_user(buff, &axd->cmd.out_pipes[pipe].current_ts_low, 8);
> +		read += 8;
> +		buff += 8;
> +	}
> +
> +	read += axd_cmd_recv_buffer(&axd->cmd, pipe, buff, count);
> +	if (read > 0)
> +		*offp += read;
> +	return read;
> +}
> +
> +static ssize_t axd_write(struct file *filp, const char __user *buff,
> +						size_t count, loff_t *offp)
> +{
> +	struct inode *inode = filp->private_data;
> +	struct axd_dev *axd = container_of(inode->i_cdev, struct axd_dev, cdev);
> +	unsigned int minor = MINOR(inode->i_rdev);
> +	unsigned int pipe = MINOR_TO_INPUT(minor);
> +	ssize_t written;
> +	struct axd_sync_data sync_data;
> +
> +	if (axd_get_flag(&axd->cmd.fw_stopped_flg))
> +		return 0;
> +
> +	/* can't write ctrl device */
> +	if (!minor)
> +		return count;
> +
> +	if (count == sizeof(struct axd_sync_data)) {
> +		/* Read sync data */
> +		copy_from_user(&sync_data, buff, sizeof(sync_data));
> +
> +		/* Validate sync data */
> +		if (sync_data.magic != SYNC_MGCNUM) {
> +			/* Not valid sync data -- must be normal stream data */
> +			goto stream_data;
> +		}
> +
> +		set_next_pts(axd, pipe, sync_data.pts_us);
> +		written = count;
> +	} else {
> +stream_data:
> +		written = axd_cmd_send_buffer(&axd->cmd, pipe, buff, count);
> +	}
> +
> +	if (written > 0)
> +		*offp += written;
> +	return written;
> +}
ALSA does data copy too!

-- 
~Vinod

