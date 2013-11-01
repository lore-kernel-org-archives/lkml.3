Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3KAWP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:15:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3KAWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Szymon=20Aceda=C5=84ski?= <accek@mimuw.edu.pl>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.11 58/66] ALSA: hda - Fix inverted internal mic not indicated on some machines
Date: Fri,  1 Nov 2013 15:07:34 -0700
Message-Id: <20131101220650.843448918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit ccb041571b73888785ef7828a276e380125891a4 upstream.

The create_bind_cap_vol_ctl does not create any control indicating
that an inverted dmic is present. Therefore, create multiple
capture volumes in this scenario, so we always have some indication
that the internal mic is inverted.

This happens on the Lenovo Ideapad U310 as well as the Lenovo Yoga 13
(both are based on the CX20590 codec), but the fix is generic and
could be needed for other codecs/machines too.

Thanks to Szymon Acedański for the pointer and a draft patch.

BugLink: https://bugs.launchpad.net/bugs/1239392
BugLink: https://bugs.launchpad.net/bugs/1227491
Reported-by: Szymon Acedański <accek@mimuw.edu.pl>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3505,7 +3505,7 @@ static int create_capture_mixers(struct
 		if (!multi)
 			err = create_single_cap_vol_ctl(codec, n, vol, sw,
 							inv_dmic);
-		else if (!multi_cap_vol)
+		else if (!multi_cap_vol && !inv_dmic)
 			err = create_bind_cap_vol_ctl(codec, n, vol, sw);
 		else
 			err = create_multi_cap_vol_ctl(codec);


