Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaFEEv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:51:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaFEEVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthieu Castet <matthieu.castet@parrot.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 108/214] UBI: erase free PEB with bitflip in EC header
Date: Wed,  4 Jun 2014 21:17:51 -0700
Message-Id: <20140605041654.194197218@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 193819cf2e6e395b1e1be2d36785dc5563a6edca upstream.

Without this patch, these PEB are not scrubbed until we put data in them.
Bitflip can accumulate latter and we can loose the EC header (but VID header
should be intact and allow to recover data).

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -997,7 +997,7 @@ static int process_eb(struct ubi_device
 			return err;
 		goto adjust_mean_ec;
 	case UBI_IO_FF:
-		if (ec_err)
+		if (ec_err || bitflips)
 			err = add_to_list(si, pnum, ec, 1, &si->erase);
 		else
 			err = add_to_list(si, pnum, ec, 0, &si->free);


