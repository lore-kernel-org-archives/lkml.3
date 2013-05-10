Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3EJO3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:29:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57265 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936Ab3EJOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Dylan Reid" <dgreid@chromium.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.688831168@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [038/118] ASoC: max98088: Fix logging of hardware revision.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit 98682063549bedd6e2d2b6b7222f150c6fbce68c upstream.

The hardware revision of the codec is based at 0x40.  Subtract that
before convering to ASCII.  The same as it is done for 98095.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/max98088.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2007,7 +2007,7 @@ static int max98088_probe(struct snd_soc
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 

