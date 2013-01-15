Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab3AOWcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:42590 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab3AOWcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 120/221] regmap: debugfs: Avoid overflows for very small reads
Date: Tue, 15 Jan 2013 10:50:47 -0800
Message-Id: <20130115185006.701616100@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit db04328c167ff8e7c57f4a3532214aeada3a82fd upstream.

If count is less than the size of a register then we may hit integer
wraparound when trying to move backwards to check if we're still in
the buffer. Instead move the position forwards to check if it's still
in the buffer, we are unlikely to be able to allocate a buffer
sufficiently big to overflow here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org

---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -90,7 +90,7 @@ static ssize_t regmap_map_read_file(stru
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >= count - 1 - tot_len)
+			if (buf_pos + 1 + tot_len >= count)
 				break;
 
 			/* Format the register */


