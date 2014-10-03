Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaJCXFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:05:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbaJCWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.14 213/238] media: adv7604: fix inverted condition
Date: Fri,  3 Oct 2014 14:32:08 -0700
Message-Id: <20141003212920.471355594@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 77639ff2b3404a913b8037d230a384798b854bae upstream.

The log_status function should show HDMI information, but the test checking for
an HDMI input was inverted. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/adv7604.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1984,7 +1984,7 @@ static int adv7604_log_status(struct v4l
 	v4l2_info(sd, "HDCP keys read: %s%s\n",
 			(hdmi_read(sd, 0x04) & 0x20) ? "yes" : "no",
 			(hdmi_read(sd, 0x04) & 0x10) ? "ERROR" : "");
-	if (!is_hdmi(sd)) {
+	if (is_hdmi(sd)) {
 		bool audio_pll_locked = hdmi_read(sd, 0x04) & 0x01;
 		bool audio_sample_packet_detect = hdmi_read(sd, 0x18) & 0x01;
 		bool audio_mute = io_read(sd, 0x65) & 0x40;


