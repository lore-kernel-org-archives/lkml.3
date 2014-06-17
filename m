Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaFQJPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:15:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52103 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbaFQJPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:15:19 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [RFC PATCH v4 1/7] thermal: document struct thermal_zone_device and thermal_governor
Date: Tue, 17 Jun 2014 10:14:47 +0100
Message-Id: <1402996493-3578-2-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
References: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 17 Jun 2014 09:15:08.0800 (UTC) FILETIME=[A2868800:01CF8A0C]
X-MC-Unique: 114061710151613401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s5H9FUmR005748

Document struct thermal_zone_device and struct thermal_governor fields
and their use by the thermal framework code.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
Hi linux-pm,

This patch is independent of the whole series and can be merged independently

 include/linux/thermal.h | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7ea7d9..0305cde21a74 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -158,6 +158,42 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+/**
+ * struct thermal_zone_device - structure for a thermal zone
+ * @id:		unique id number for each thermal zone
+ * @type:	the thermal zone device type
+ * @device:	&struct device for this thermal zone
+ * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
+ * @trip_type_attrs:	attributes for trip points for sysfs: trip type
+ * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
+ * @devdata:	private pointer for device private data
+ * @trips:	number of trip points the thermal zone supports
+ * @passive_delay:	number of milliseconds to wait between polls when
+ *			performing passive cooling.  Currenty only used by the
+ *			step-wise governor
+ * @polling_delay:	number of milliseconds to wait between polls when
+ *			checking whether trip points have been crossed (0 for
+ *			interrupt driven systems)
+ * @temperature:	current temperature.  This is only for core code,
+ *			drivers should use thermal_zone_get_temp() to get the
+ *			current temperature
+ * @last_temperature:	previous temperature read
+ * @emul_temperature:	emulated temperature when using CONFIG_THERMAL_EMULATION
+ * @passive:		1 if you've crossed a passive trip point, 0 otherwise.
+ *			Currenty only used by the step-wise governor.
+ * @forced_passive:	If > 0, temperature at which to switch on all ACPI
+ *			processor cooling devices.  Currently only used by the
+ *			step-wise governor.
+ * @ops:	operations this &thermal_zone_device supports
+ * @tzp:	thermal zone parameters
+ * @governor:	pointer to the governor for this thermal zone
+ * @thermal_instances:	list of &struct thermal_instance of this thermal zone
+ * @idr:	&struct idr to generate unique id for this zone's cooling
+ *		devices
+ * @lock:	lock to protect thermal_instances list
+ * @node:	node in thermal_tz_list (in thermal_core.c)
+ * @poll_queue:	delayed work for polling
+ */
 struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -179,12 +215,18 @@ struct thermal_zone_device {
 	struct thermal_governor *governor;
 	struct list_head thermal_instances;
 	struct idr idr;
-	struct mutex lock; /* protect thermal_instances list */
+	struct mutex lock;
 	struct list_head node;
 	struct delayed_work poll_queue;
 };
 
-/* Structure that holds thermal governor information */
+/**
+ * struct thermal_governor - structure that holds thermal governor information
+ * @name:	name of the governor
+ * @throttle:	callback called for every trip point even if temperature is
+ *		below the trip point temperature
+ * @governor_list:	node in thermal_governor_list (in thermal_core.c)
+ */
 struct thermal_governor {
 	char name[THERMAL_NAME_LENGTH];
 	int (*throttle)(struct thermal_zone_device *tz, int trip);
-- 
1.9.1


