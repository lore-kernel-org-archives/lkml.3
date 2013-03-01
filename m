Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3CAUOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:14:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3CATpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Saranya Gopal <saranya.gopal@intel.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [ 64/77] bq27x00_battery: Fix bugs introduced with BQ27425 support
Date: Fri,  1 Mar 2013 11:44:49 -0800
Message-Id: <20130301194358.754709800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit bde83b9a6b44c1e0fd872e57ecc869cfcf88538f upstream.

commit a66f59ba2e994bf70274ef0513e24e0e7ae20c63

    bq27x00_battery: Add support for BQ27425 chip

introduced 2 bugs.

1/ 'chip' was set to BQ27425 unconditionally - breaking support for
   other devices;

2/ BQ27425 does not support cycle count, how the code still tries to
   get the cycle count for BQ27425, and now does it twice for other chips.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Saranya Gopal <saranya.gopal@intel.com>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq27x00_battery.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -448,7 +448,6 @@ static void bq27x00_update(struct bq27x0
 		cache.temperature = bq27x00_battery_read_temperature(di);
 		if (!is_bq27425)
 			cache.cycle_count = bq27x00_battery_read_cyct(di);
-		cache.cycle_count = bq27x00_battery_read_cyct(di);
 		cache.power_avg =
 			bq27x00_battery_read_pwr_avg(di, BQ27x00_POWER_AVG);
 
@@ -696,7 +695,6 @@ static int bq27x00_powersupply_init(stru
 	int ret;
 
 	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
-	di->chip = BQ27425;
 	if (di->chip == BQ27425) {
 		di->bat.properties = bq27425_battery_props;
 		di->bat.num_properties = ARRAY_SIZE(bq27425_battery_props);


