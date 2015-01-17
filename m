Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbbAQQcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 11:32:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63965 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbAQQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 11:32:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eliot Blennerhassett <eliot@blennerhassett.gen.nz>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Benoit Taine <benoit.taine@lip6.fr>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: asihpi: asihpi: Remove unused function
Date: Sat, 17 Jan 2015 17:35:28 +0100
Message-Id: <1421512528-14864-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function hpi_stream_group_get_map() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/asihpi/asihpi.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e9273fb..920b15e 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -271,15 +271,6 @@ static inline u16 hpi_stream_group_reset(u32 h_stream)
 		return hpi_instream_group_reset(h_stream);
 }
 
-static inline u16 hpi_stream_group_get_map(
-				u32 h_stream, u32 *mo, u32 *mi)
-{
-	if (hpi_handle_object(h_stream) ==  HPI_OBJ_OSTREAM)
-		return hpi_outstream_group_get_map(h_stream, mo, mi);
-	else
-		return hpi_instream_group_get_map(h_stream, mo, mi);
-}
-
 static u16 handle_error(u16 err, int line, char *filename)
 {
 	if (err)
-- 
1.7.10.4

