Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbbA2BY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:59 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47127 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbbA2BY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Vladimir A. Nazarenko" <naszar@ya.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: jr3_pci: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:35:46 +0100
Message-Id: <1422484546-9045-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/jr3_pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 81fab2d..5d4cca7 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -520,10 +520,9 @@ static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice
 			result = poll_delay_min_max(20, 100);
 		} else {
 			/* Set full scale */
-			struct six_axis_t min_full_scale;
 			struct six_axis_t max_full_scale;
 
-			min_full_scale = get_min_full_scales(channel);
+			get_min_full_scales(channel);
 			max_full_scale = get_max_full_scales(channel);
 			set_full_scales(channel, max_full_scale);
 
-- 
1.7.10.4

