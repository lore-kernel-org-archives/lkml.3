Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaIOTeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:34:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaIOT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 083/158] ASoC: max98090: Fix missing free_irq
Date: Mon, 15 Sep 2014 12:25:22 -0700
Message-Id: <20140915192545.380988037@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 4adeb0ccf86a5af1825bbfe290dee9e60a5ab870 upstream.

max98090.c doesn't free the threaded interrupt it requests. This causes
an oops when doing "cat /proc/interrupts" after snd-soc-max98090.ko is
unloaded.

Fix this by requesting the interrupt by using devm_request_threaded_irq().

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2284,7 +2284,7 @@ static int max98090_probe(struct snd_soc
 	/* Register for interrupts */
 	dev_dbg(codec->dev, "irq = %d\n", max98090->irq);
 
-	ret = request_threaded_irq(max98090->irq, NULL,
+	ret = devm_request_threaded_irq(codec->dev, max98090->irq, NULL,
 		max98090_interrupt, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 		"max98090_interrupt", codec);
 	if (ret < 0) {


