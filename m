Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab3EFXAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:00:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3EFW7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dylan Reid <dgreid@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 29/46] ASoC: max98088: Fix logging of hardware revision.
Date: Mon,  6 May 2013 15:58:35 -0700
Message-Id: <20130506225823.726934699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit 98682063549bedd6e2d2b6b7222f150c6fbce68c upstream.

The hardware revision of the codec is based at 0x40.  Subtract that
before convering to ASCII.  The same as it is done for 98095.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98088.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1998,7 +1998,7 @@ static int max98088_probe(struct snd_soc
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 


