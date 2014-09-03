Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbaICXkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:40:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbaICWGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.10 40/55] mei: reset client state on queued connect request
Date: Wed,  3 Sep 2014 15:05:30 -0700
Message-Id: <20140903220500.373847693@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 73ab4232388b7a08f17c8d08141ff2099fa0b161 upstream.

If connect request is queued (e.g. device in pg) set client state
to initializing, thus avoid preliminary exit in wait if current
state is disconnected.

This is regression from:

commit e4d8270e604c3202131bac607969605ac397b893
Author: Alexander Usyskin <alexander.usyskin@intel.com>
mei: set connecting state just upon connection request is sent to the fw

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -512,6 +512,7 @@ int mei_cl_connect(struct mei_cl *cl, st
 		cl->timer_count = MEI_CONNECT_TIMEOUT;
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
+		cl->state = MEI_FILE_INITIALIZING;
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
 


