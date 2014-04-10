Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314AbaDJDmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:42:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074AbaDJDWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 110/134] ALSA: pcsp: Fix the order of input device unregistration
Date: Wed,  9 Apr 2014 20:23:46 -0700
Message-Id: <20140410032313.769762281@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6408eac2665955343cd0e4bcd7d6237ce39611ed upstream.

The current code may access to the already freed object.  The input
device must be accessed and unregistered before freeing the top level
sound object.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/drivers/pcsp/pcsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -187,8 +187,8 @@ static int __devinit pcsp_probe(struct p
 static int __devexit pcsp_remove(struct platform_device *dev)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
-	alsa_card_pcsp_exit(chip);
 	pcspkr_input_remove(chip->input_dev);
+	alsa_card_pcsp_exit(chip);
 	platform_set_drvdata(dev, NULL);
 	return 0;
 }


