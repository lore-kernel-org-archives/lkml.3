Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaJHA3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:29:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63114 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbaJHA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:29:08 -0400
Date: Tue, 7 Oct 2014 16:48:23 -0700
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix unnecessary elses after return/break
 in rtl8712_efuse.c
Message-ID: <20141007234823.GA25549@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two unnecessary else conditions that were found by checkpatch.pl.

Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
---
 drivers/staging/rtl8712/rtl8712_efuse.c | 41 +++++++++++++++++----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index c9eeb42..0e155d9 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -414,19 +414,19 @@ u8 r8712_efuse_pg_packet_write(struct _adapter *padapter, const u8 offset,
 					bResult = false;
 			}
 			break;
-		} else { /* write header fail */
-			bResult = false;
-			if (0xFF == efuse_data)
-				return bResult; /* nothing damaged. */
-			/* call rescue procedure */
-			if (fix_header(padapter, efuse_data, efuse_addr) ==
-			    false)
-				return false; /* rescue fail */
-
-			if (++repeat_times > _REPEAT_THRESHOLD_) /* fail */
-				break;
-			/* otherwise, take another risk... */
 		}
+		/* write header fail */
+		bResult = false;
+		if (0xFF == efuse_data)
+			return bResult; /* nothing damaged. */
+		/* call rescue procedure */
+		if (fix_header(padapter, efuse_data, efuse_addr) ==
+		    false)
+			return false; /* rescue fail */
+
+		if (++repeat_times > _REPEAT_THRESHOLD_) /* fail */
+			break;
+		/* otherwise, take another risk... */
 	}
 	return bResult;
 }
@@ -541,15 +541,16 @@ u8 r8712_efuse_map_write(struct _adapter *padapter, u16 addr, u16 cnts,
 				}
 				idx++;
 				break;
-			} else {
-				if ((data[idx] != pktdata[i]) || (data[idx+1] !=
-				     pktdata[i+1])) {
-					word_en &= ~BIT(i >> 1);
-					newdata[j++] = data[idx];
-					newdata[j++] = data[idx + 1];
-				}
-				idx += 2;
 			}
+
+			if ((data[idx] != pktdata[i]) || (data[idx+1] !=
+			     pktdata[i+1])) {
+				word_en &= ~BIT(i >> 1);
+				newdata[j++] = data[idx];
+				newdata[j++] = data[idx + 1];
+			}
+			idx += 2;
+
 			if (idx == cnts)
 				break;
 		}
-- 
1.9.3

