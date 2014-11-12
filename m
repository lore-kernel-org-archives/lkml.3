Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaKLBVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:21:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaKLBVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 033/319] ASoC: core: fix use after free in snd_soc_remove_platform()
Date: Wed, 12 Nov 2014 10:12:51 +0900
Message-Id: <20141112010958.160221725@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

commit decc27b01d584c985c231e73d3b493de6ec07af8 upstream.

Coverity spotted an use-after-free condition in snd_soc_remove_platform().
Fix this by moving snd_soc_component_cleanup() after the debug print
statement which uses the component's string.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4315,10 +4315,10 @@ void snd_soc_remove_platform(struct snd_
 	snd_soc_component_del_unlocked(&platform->component);
 	mutex_unlock(&client_mutex);
 
-	snd_soc_component_cleanup(&platform->component);
-
 	dev_dbg(platform->dev, "ASoC: Unregistered platform '%s'\n",
 		platform->component.name);
+
+	snd_soc_component_cleanup(&platform->component);
 }
 EXPORT_SYMBOL_GPL(snd_soc_remove_platform);
 


