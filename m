Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3GAUXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:23:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3GAUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jaganath Kanakkassery <jaganath.k@samsung.com>,
        Chan-Yeol Park <chanyeol.park@samsung.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 05/26] Bluetooth: Fix invalid length check in l2cap_information_rsp()
Date: Mon,  1 Jul 2013 13:10:00 -0700
Message-Id: <20130701200730.503765752@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaganath Kanakkassery <jaganath.k@samsung.com>

commit 3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112 upstream.

The length check is invalid since the length varies with type of
info response.

This was introduced by the commit cb3b3152b2f5939d67005cff841a1ca748b19888

Because of this, l2cap info rsp is not handled and command reject is sent.

> ACL data: handle 11 flags 0x02 dlen 16
        L2CAP(s): Info rsp: type 2 result 0
          Extended feature mask 0x00b8
            Enhanced Retransmission mode
            Streaming mode
            FCS Option
            Fixed Channels
< ACL data: handle 11 flags 0x00 dlen 10
        L2CAP(s): Command rej: reason 0
          Command not understood

Signed-off-by: Jaganath Kanakkassery <jaganath.k@samsung.com>
Signed-off-by: Chan-Yeol Park <chanyeol.park@samsung.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4224,7 +4224,7 @@ static inline int l2cap_information_rsp(
 	struct l2cap_info_rsp *rsp = (struct l2cap_info_rsp *) data;
 	u16 type, result;
 
-	if (cmd_len != sizeof(*rsp))
+	if (cmd_len < sizeof(*rsp))
 		return -EPROTO;
 
 	type   = __le16_to_cpu(rsp->type);


