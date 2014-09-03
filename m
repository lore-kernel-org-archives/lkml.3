Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbaICWSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933758AbaICWSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.16 045/125] hwmon: (ads1015) Fix out-of-bounds array access
Date: Wed,  3 Sep 2014 15:06:42 -0700
Message-Id: <20140903220625.001856142@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit e981429557cbe10c780fab1c1a237cb832757652 upstream.

Current code uses data_rate as array index in ads1015_read_adc() and uses pga
as array index in ads1015_reg_to_mv, so we must make sure both data_rate and
pga settings are in valid value range.
Return -EINVAL if the setting is out-of-range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ads1015.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -212,6 +212,7 @@ static int ads1015_get_channels_config_o
 				dev_err(&client->dev,
 					"invalid gain on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 
@@ -222,6 +223,7 @@ static int ads1015_get_channels_config_o
 				dev_err(&client->dev,
 					"invalid data_rate on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 


