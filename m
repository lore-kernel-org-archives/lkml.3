Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbaDJDpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:45:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935037AbaDJDWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 105/134] ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
Date: Wed,  9 Apr 2014 20:23:41 -0700
Message-Id: <20140410032313.271024144@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bd5fe738e388ceaa32e5171481e0d3ec59f0ccfe upstream.

"idx" is controled by the user and can be a negative offset into the
input_names[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/i2c/other/ak4xxx-adda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -571,7 +571,7 @@ static int ak4xxx_capture_source_info(st
 	struct snd_akm4xxx *ak = snd_kcontrol_chip(kcontrol);
 	int mixer_ch = AK_GET_SHIFT(kcontrol->private_value);
 	const char **input_names;
-	int  num_names, idx;
+	unsigned int num_names, idx;
 
 	num_names = ak4xxx_capture_num_inputs(ak, mixer_ch);
 	if (!num_names)


