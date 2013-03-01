Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3CAUOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:14:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3CATpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 44/77] media: cx18/ivtv: fix regression: remove __init from a non-init function
Date: Fri,  1 Mar 2013 11:44:29 -0800
Message-Id: <20130301194356.625874002@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit cfb046cb800ba306b211fbbe4ac633486e11055f upstream.

Commits 5e6e81b2890db3969527772a8350825a85c22d5c (cx18) and
2aebbf6737212265b917ed27c875c59d3037110a (ivtv) added an __init
annotation to the cx18-alsa-load and ivtv-alsa-load functions. However,
these functions are called *after* initialization by the main cx18/ivtv
driver. By that time the memory containing those functions is already
freed and your machine goes BOOM.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx18/cx18-alsa-main.c |    2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.h  |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -197,7 +197,7 @@ err_exit:
 	return ret;
 }
 
-static int __init cx18_alsa_load(struct cx18 *cx)
+static int cx18_alsa_load(struct cx18 *cx)
 {
 	struct v4l2_device *v4l2_dev = &cx->v4l2_dev;
 	struct cx18_stream *s;
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.h
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.h
@@ -20,7 +20,7 @@
  *  02111-1307  USA
  */
 
-int __init snd_cx18_pcm_create(struct snd_cx18_card *cxsc);
+int snd_cx18_pcm_create(struct snd_cx18_card *cxsc);
 
 /* Used by cx18-mailbox to announce the PCM data to the module */
 void cx18_alsa_announce_pcm_data(struct snd_cx18_card *card, u8 *pcm_data,
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -205,7 +205,7 @@ err_exit:
 	return ret;
 }
 
-static int __init ivtv_alsa_load(struct ivtv *itv)
+static int ivtv_alsa_load(struct ivtv *itv)
 {
 	struct v4l2_device *v4l2_dev = &itv->v4l2_dev;
 	struct ivtv_stream *s;
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.h
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.h
@@ -20,4 +20,4 @@
  *  02111-1307  USA
  */
 
-int __init snd_ivtv_pcm_create(struct snd_ivtv_card *itvsc);
+int snd_ivtv_pcm_create(struct snd_ivtv_card *itvsc);


