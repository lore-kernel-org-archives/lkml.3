Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966524AbaCUBPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:15:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760518AbaCUAD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 051/149] ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
Date: Thu, 20 Mar 2014 17:03:34 -0700
Message-Id: <20140321000438.736245406@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c5eda4c1bf6214332c46fb2f4e7c42a85e5e5643 upstream.

The mixer widget (NID 0x20) of AD1884 and AD1984 codecs isn't
connected directly to the actual I/O paths but only via another mixer
widget (NID 0x21).  We need a similar fix as we did for AD1882.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1091,6 +1091,7 @@ static int patch_ad1884(struct hda_codec
 	spec = codec->spec;
 
 	spec->gen.mixer_nid = 0x20;
+	spec->gen.mixer_merge_nid = 0x21;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
 


