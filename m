Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbaFJAWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbaFJAV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:21:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jaganath Kanakkassery <jaganath.k@samsung.com>,
        Chan-Yeol Park <chanyeol.park@samsung.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 19/88] Bluetooth: Fix invalid length check in l2cap_information_rsp()
Date: Mon,  9 Jun 2014 17:24:29 -0700
Message-Id: <20140610002425.164224690@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Cc: stable@vger.kernel.org
Signed-off-by: Jaganath Kanakkassery <jaganath.k@samsung.com>
Signed-off-by: Chan-Yeol Park <chanyeol.park@samsung.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3445,7 +3445,7 @@ static inline int l2cap_move_channel_con
 	struct l2cap_move_chan_cfm_rsp *rsp = data;
 	u16 icid;
 
-	if (cmd_len != sizeof(*rsp))
+	if (cmd_len < sizeof(*rsp))
 		return -EPROTO;
 
 	icid = le16_to_cpu(rsp->icid);


