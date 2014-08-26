Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbaHZMWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:22:30 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36336 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaHZMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:22:28 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: ctxfi: fix broken user-visible string
Date: Tue, 26 Aug 2014 17:52:14 +0530
Message-Id: <1409055734-2777-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <[PATCH] sound: pci: ctxfi: prink replacement>
References: <[PATCH] sound: pci: ctxfi: prink replacement>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed broken user visible strings

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

I am not exactly sure about the patch as some lines after fixing has crossed the limit of 80 characters.
But the coding style says :
"never break user-visible strings such as printk messages, because that breaks the ability to grep for them"

 sound/pci/ctxfi/ctatc.c      | 18 +++++++-----------
 sound/pci/ctxfi/cthw20k1.c   |  3 +--
 sound/pci/ctxfi/cthw20k2.c   | 11 +++++------
 sound/pci/ctxfi/ctmixer.c    |  6 ++----
 sound/pci/ctxfi/ctresource.c | 20 ++++++++------------
 sound/pci/ctxfi/ctvmem.c     |  6 ++----
 sound/pci/ctxfi/xfi.c        |  6 ++----
 7 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index ce9061a..d92a08c 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -185,7 +185,7 @@ static unsigned int convert_format(snd_pcm_format_t snd_format)
 	case SNDRV_PCM_FORMAT_FLOAT_LE:
 		return SRC_SF_F32;
 	default:
-		pr_err("ctxfi: not recognized snd format is %d \n",
+		pr_err("ctxfi: not recognized snd format is %d\n",
 			snd_format);
 		return SRC_SF_S16;
 	}
@@ -1282,8 +1282,7 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
 	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
 	if (p) {
 		if (p->value < 0) {
-			pr_err("ctxfi: "
-			       "Device %04x:%04x is black-listed\n",
+			pr_err("ctxfi: Device %04x:%04x is black-listed\n",
 			       vendor_id, device_id);
 			return -ENOENT;
 		}
@@ -1315,8 +1314,7 @@ int ct_atc_create_alsa_devs(struct ct_atc *atc)
 		err = alsa_dev_funcs[i].create(atc, i,
 				alsa_dev_funcs[i].public_name);
 		if (err) {
-			pr_err("ctxfi: "
-			       "Creating alsa device %d failed!\n", i);
+			pr_err("ctxfi: Creating alsa device %d failed!\n", i);
 			return err;
 		}
 	}
@@ -1351,8 +1349,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 
 		err = rsc_mgr_funcs[i].create(atc->hw, &atc->rsc_mgrs[i]);
 		if (err) {
-			pr_err("ctxfi: "
-			       "Failed to create rsc_mgr %d!!!\n", i);
+			pr_err("ctxfi: Failed to create rsc_mgr %d!!!\n", i);
 			return err;
 		}
 	}
@@ -1399,8 +1396,8 @@ static int atc_get_resources(struct ct_atc *atc)
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
 		if (err) {
-			pr_err("ctxfi: Failed to get DAIO "
-					"resource %d!!!\n", i);
+			pr_err("ctxfi: Failed to get DAIO resource %d!!!\n",
+				i);
 			return err;
 		}
 		atc->n_daio++;
@@ -1603,8 +1600,7 @@ static int atc_resume(struct ct_atc *atc)
 	/* Do hardware resume. */
 	err = atc_hw_resume(atc);
 	if (err < 0) {
-		pr_err("ctxfi: pci_enable_device failed, "
-		       "disabling device\n");
+		pr_err("ctxfi: pci_enable_device failed, disabling device\n");
 		snd_card_disconnect(atc->card);
 		return err;
 	}
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index 782641e..71d496f 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1911,8 +1911,7 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("architecture does not support PCI "
-				"busmaster DMA with mask 0x%llx\n",
+		pr_err("architecture does not support PCI busmaster DMA with mask 0x%llx\n",
 		       CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index 8a72fac..df2d8c5 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -1246,8 +1246,7 @@ static int hw_trn_init(struct hw *hw, const struct trn_conf *info)
 
 	/* Set up device page table */
 	if ((~0UL) == info->vm_pgt_phys) {
-		pr_alert("ctxfi: "
-		       "Wrong device page table page address!!!\n");
+		pr_alert("ctxfi: Wrong device page table page address!!!\n");
 		return -1;
 	}
 
@@ -1890,8 +1889,8 @@ static int hw_adc_init(struct hw *hw, const struct adc_conf *info)
 		hw20k2_i2c_write(hw, MAKE_WM8775_ADDR(WM8775_MMC, 0x0A),
 						MAKE_WM8775_DATA(0x0A));
 	} else {
-		pr_alert("ctxfi: Invalid master sampling "
-				  "rate (msr %d)!!!\n", info->msr);
+		pr_alert("ctxfi: Invalid master sampling rate (msr %d)!!!\n",
+			info->msr);
 		err = -EINVAL;
 		goto error;
 	}
@@ -2034,8 +2033,8 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("ctxfi: architecture does not support PCI "
-		"busmaster DMA with mask 0x%llx\n", CT_XFI_DMA_MASK);
+		pr_err("ctxfi: architecture does not support PCI busmaster DMA with mask 0x%llx\n",
+			CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
 	}
diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 8d986e4..017fa91 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -854,8 +854,7 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_SUMS * CHN_NUM); i++) {
 		err = sum_mgr->get_sum(sum_mgr, &sum_desc, &sum);
 		if (err) {
-			pr_err("ctxfi:Failed to get sum resources for "
-					  "front output!\n");
+			pr_err("ctxfi:Failed to get sum resources for front output!\n");
 			break;
 		}
 		mixer->sums[i] = sum;
@@ -869,8 +868,7 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_AMIXERS * CHN_NUM); i++) {
 		err = amixer_mgr->get_amixer(amixer_mgr, &am_desc, &amixer);
 		if (err) {
-			pr_err("ctxfi:Failed to get amixer resources "
-			       "for mixer obj!\n");
+			pr_err("ctxfi:Failed to get amixer resources for mixer obj!\n");
 			break;
 		}
 		mixer->amixers[i] = amixer;
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index 11ac934..e49d2be 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -162,14 +162,12 @@ int rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, void *hw)
 	case DAIO:
 		break;
 	default:
-		pr_err(
-		       "ctxfi: Invalid resource type value %d!\n", type);
+		pr_err("ctxfi: Invalid resource type value %d!\n", type);
 		return -EINVAL;
 	}
 
 	if (err) {
-		pr_err(
-		       "ctxfi: Failed to get resource control block!\n");
+		pr_err("ctxfi: Failed to get resource control block!\n");
 		return err;
 	}
 
@@ -192,8 +190,8 @@ int rsc_uninit(struct rsc *rsc)
 		case DAIO:
 			break;
 		default:
-			pr_err("ctxfi: "
-			       "Invalid resource type value %d!\n", rsc->type);
+			pr_err("ctxfi: Invalid resource type value %d!\n",
+				rsc->type);
 			break;
 		}
 
@@ -235,15 +233,13 @@ int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
 	case SUM:
 		break;
 	default:
-		pr_err(
-		       "ctxfi: Invalid resource type value %d!\n", type);
+		pr_err("ctxfi: Invalid resource type value %d!\n", type);
 		err = -EINVAL;
 		goto error;
 	}
 
 	if (err) {
-		pr_err(
-		       "ctxfi: Failed to get manager control block!\n");
+		pr_err("ctxfi: Failed to get manager control block!\n");
 		goto error;
 	}
 
@@ -286,8 +282,8 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
 		case SUM:
 			break;
 		default:
-			pr_err("ctxfi: "
-			       "Invalid resource type value %d!\n", mgr->type);
+			pr_err("ctxfi: Invalid resource type value %d!\n",
+				mgr->type);
 			break;
 		}
 
diff --git a/sound/pci/ctxfi/ctvmem.c b/sound/pci/ctxfi/ctvmem.c
index 5ea015b..38163f5 100644
--- a/sound/pci/ctxfi/ctvmem.c
+++ b/sound/pci/ctxfi/ctvmem.c
@@ -36,8 +36,7 @@ get_vm_block(struct ct_vm *vm, unsigned int size)
 
 	size = CT_PAGE_ALIGN(size);
 	if (size > vm->size) {
-		pr_err("ctxfi: Fail! No sufficient device virtual "
-				  "memory space available!\n");
+		pr_err("ctxfi: Fail! No sufficient device virtual memory space available!\n");
 		return NULL;
 	}
 
@@ -132,8 +131,7 @@ ct_vm_map(struct ct_vm *vm, struct snd_pcm_substream *substream, int size)
 
 	block = get_vm_block(vm, size);
 	if (block == NULL) {
-		pr_err("ctxfi: No virtual memory block that is big "
-				  "enough to allocate!\n");
+		pr_err("ctxfi: No virtual memory block that is big enough to allocate!\n");
 		return NULL;
 	}
 
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
index af8c498..35e85ba 100644
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -78,15 +78,13 @@ ct_card_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	if ((reference_rate != 48000) && (reference_rate != 44100)) {
 		pr_err("ctxfi: Invalid reference_rate value %u!!!\n",
 		       reference_rate);
-		pr_err("ctxfi: The valid values for reference_rate "
-		       "are 48000 and 44100, Value 48000 is assumed.\n");
+		pr_err("ctxfi: The valid values for reference_rate are 48000 and 44100, Value 48000 is assumed.\n");
 		reference_rate = 48000;
 	}
 	if ((multiple != 1) && (multiple != 2) && (multiple != 4)) {
 		pr_err("ctxfi: Invalid multiple value %u!!!\n",
 		       multiple);
-		pr_err("ctxfi: The valid values for multiple are "
-		       "1, 2 and 4, Value 2 is assumed.\n");
+		pr_err("ctxfi: The valid values for multiple are 1, 2 and 4, Value 2 is assumed.\n");
 		multiple = 2;
 	}
 	err = ct_atc_create(card, pci, reference_rate, multiple,
-- 
1.8.1.2

