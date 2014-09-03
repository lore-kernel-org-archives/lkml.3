Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936319AbaICXtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:49:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaICWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 17/55] hwmon: (sis5595) Prevent overflow problem when writing large limits
Date: Wed,  3 Sep 2014 15:05:07 -0700
Message-Id: <20140903220456.680480651@linuxfoundation.org>
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

From: Axel Lin <axel.lin@ingics.com>

commit cc336546ddca8c22de83720632431c16a5f9fe9a upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/sis5595.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -159,7 +159,7 @@ static inline int TEMP_FROM_REG(s8 val)
 {
 	return val * 830 + 52120;
 }
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval = clamp_val(val, -54120, 157530) ;
 	return nval < 0 ? (nval - 5212 - 415) / 830 : (nval - 5212 + 415) / 830;


