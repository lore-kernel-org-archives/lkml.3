Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaLGN6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:58:39 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39550 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaLGN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:58:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: asihpi: hpifunc.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 15:01:15 +0100
Message-Id: <1417960875-11753-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
hpi_subsys_get_version_ex() hpi_instream_wait_start()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/asihpi/hpi.h     |    4 ----
 sound/pci/asihpi/hpifunc.c |   27 ---------------------------
 2 files changed, 31 deletions(-)

diff --git a/sound/pci/asihpi/hpi.h b/sound/pci/asihpi/hpi.h
index 2088724..8338b6e 100644
--- a/sound/pci/asihpi/hpi.h
+++ b/sound/pci/asihpi/hpi.h
@@ -1164,8 +1164,6 @@ u16 hpi_stream_estimate_buffer_size(struct hpi_format *pF,
 /* SubSystem */
 /*************/
 
-u16 hpi_subsys_get_version_ex(u32 *pversion_ex);
-
 u16 hpi_subsys_get_num_adapters(int *pn_num_adapters);
 
 u16 hpi_subsys_get_adapter(int iterator, u32 *padapter_index,
@@ -1289,8 +1287,6 @@ u16 hpi_instream_read_buf(u32 h_instream, u8 *pb_read_buf, u32 bytes_to_read);
 
 u16 hpi_instream_start(u32 h_instream);
 
-u16 hpi_instream_wait_start(u32 h_instream);
-
 u16 hpi_instream_stop(u32 h_instream);
 
 u16 hpi_instream_reset(u32 h_instream);
diff --git a/sound/pci/asihpi/hpifunc.c b/sound/pci/asihpi/hpifunc.c
index 510e56c..8fd02dd 100644
--- a/sound/pci/asihpi/hpifunc.c
+++ b/sound/pci/asihpi/hpifunc.c
@@ -93,18 +93,6 @@ static inline void hpi_send_recvV1(struct hpi_message_header *m,
 	hpi_send_recv((struct hpi_message *)m, (struct hpi_response *)r);
 }
 
-u16 hpi_subsys_get_version_ex(u32 *pversion_ex)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_SUBSYSTEM,
-		HPI_SUBSYS_GET_VERSION);
-	hpi_send_recv(&hm, &hr);
-	*pversion_ex = hr.u.s.data;
-	return hr.error;
-}
-
 u16 hpi_subsys_get_num_adapters(int *pn_num_adapters)
 {
 	struct hpi_message hm;
@@ -950,21 +938,6 @@ u16 hpi_instream_start(u32 h_instream)
 	return hr.error;
 }
 
-u16 hpi_instream_wait_start(u32 h_instream)
-{
-	struct hpi_message hm;
-	struct hpi_response hr;
-
-	hpi_init_message_response(&hm, &hr, HPI_OBJ_ISTREAM,
-		HPI_ISTREAM_WAIT_START);
-	if (hpi_handle_indexes(h_instream, &hm.adapter_index, &hm.obj_index))
-		return HPI_ERROR_INVALID_HANDLE;
-
-	hpi_send_recv(&hm, &hr);
-
-	return hr.error;
-}
-
 u16 hpi_instream_stop(u32 h_instream)
 {
 	struct hpi_message hm;
-- 
1.7.10.4

