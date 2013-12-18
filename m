Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3LRVUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:20:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3LRVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.12 104/118] Input: elantech - add support for newer (August 2013) devices
Date: Wed, 18 Dec 2013 13:12:21 -0800
Message-Id: <20131218211222.390592413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Walker <matt.g.d.walker@gmail.com>

commit 9cb80b965eaf7af1369f6e16f48a05fbaaccc021 upstream.

Added detection for newer Elantech touchpads, so that kernel doesn't
fall-back to default PS/2 driver. Supports touchpads released after
~August 2013.  Fixes bug:
https://lists.launchpad.net/kernel-packages/msg18481.html

Tested on an Acer Aspire S7-392-6302.

Signed-off by: Matt Walker <matt.g.d.walker@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1313,6 +1313,7 @@ static int elantech_set_properties(struc
 			break;
 		case 6:
 		case 7:
+		case 8:
 			etd->hw_version = 4;
 			break;
 		default:


