Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaBRW4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:56:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaBRWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 20/40] ALSA: hda - Add missing mixer widget for AD1983
Date: Tue, 18 Feb 2014 14:47:21 -0800
Message-Id: <20140218224433.906700631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c7579fed1f1b2567529aea64ef19871337403ab3 upstream.

The mixer widget on AD1983 at NID 0x0e was missing in the commit
[f2f8be43c5c9: ALSA: hda - Add aamix NID to AD codecs].

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -497,6 +497,7 @@ static int patch_ad1983(struct hda_codec
 		return err;
 	spec = codec->spec;
 
+	spec->gen.mixer_nid = 0x0e;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
 	err = ad198x_parse_auto_config(codec, false);


