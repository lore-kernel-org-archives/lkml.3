Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaIKMsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:48:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51606 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Axel Lin" <axel.lin@ingics.com>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.478628018@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 056/131] hwmon: (ads1015) Fix out-of-bounds array access
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit e981429557cbe10c780fab1c1a237cb832757652 upstream.

Current code uses data_rate as array index in ads1015_read_adc() and uses pga
as array index in ads1015_reg_to_mv, so we must make sure both data_rate and
pga settings are in valid value range.
Return -EINVAL if the setting is out-of-range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/ads1015.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -200,6 +200,7 @@ static int ads1015_get_channels_config_o
 				dev_err(&client->dev,
 					"invalid gain on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 
@@ -210,6 +211,7 @@ static int ads1015_get_channels_config_o
 				dev_err(&client->dev,
 					"invalid data_rate on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 

