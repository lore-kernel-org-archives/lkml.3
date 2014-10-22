Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbaJVLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:35:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56590 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbaJVLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:35:22 -0400
Date: Wed, 22 Oct 2014 13:35:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, ijc+devicetree@hellion.org.uk, jason@lakedameon.net,
        linux@roeck-us.net, matti.vaittinen@nsn.com, robh+dt@kernel.org,
        mike@bfo.com, kernel list <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com
Subject: [patch] rtc: bq3000: fix register value
Message-ID: <20141022113520.GA32184@amd>
References: <543d6974.2KPlDgEZUrUl6vsa%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543d6974.2KPlDgEZUrUl6vsa%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix register value in bq32000 trickle charging. 

Mike reported that I'm using wrong value in one trickle-charging case,
and after checking docs, I must admit he's right.
    
Signed-off-by: Pavel Machek <pavel@denx.de>
Reported-by: Mike Bremford <mike@bfo.com>

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index c02e246..54e9f7a 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -160,7 +160,7 @@ static int trickle_charger_of_init(struct device *dev, struct device_node *node)
 			dev_err(dev, "bq32k: diode and resistor mismatch\n");
 			return -EINVAL;
 		}
-		reg = 0x25;
+		reg = 0x45;
 		break;
 
 	default:

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
