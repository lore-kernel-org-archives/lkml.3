Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaJGXnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:43:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbaJGXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.16 03/26] ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Tue,  7 Oct 2014 16:19:19 -0700
Message-Id: <20141007231848.595455581@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <Li.Xiubo@freescale.com>

commit 6596aa047b624aeec2ea321962cfdecf9953a383 upstream.

Since we cannot make sure the 'params->num_regs' will always be none
zero here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3181,7 +3181,7 @@ int snd_soc_bytes_put(struct snd_kcontro
 	unsigned int val, mask;
 	void *data;
 
-	if (!component->regmap)
+	if (!component->regmap || !params->num_regs)
 		return -EINVAL;
 
 	len = params->num_regs * component->val_bytes;


