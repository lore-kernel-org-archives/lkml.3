Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaLSI7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:59:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaLSIze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:34 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-02-5493e8034752
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 01/11] power: charger-manager: Use alarmtimer for battery
 monitoring in suspend.
Date: Fri, 19 Dec 2014 17:55:13 +0900
Message-id: <1418979323-7188-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkSJf5xeQQg8s7BC0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZWy/fY+l4E5BxYn13awN
	jOuiuhg5OSQETCT6f/5hhrDFJC7cW8/WxcjFISSwlFFi3Y5ORpiia83bmCES0xklbs44wATh
	tDFJzPzxF6yKTUBH4v++m+wgtoiAgsTm3mesIEXMAleAOhavZwJJCAukSix8cY4VxGYRUJW4
	/WgLWAOvgLvEmXtbgOIcQOsUJOZMsgEJcwp4SPw5uQWsVQiopHHLd3aIi/axSyy7agsxRkDi
	2+RDLBCtshKbDkB9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBMbE
	6X/PJuxgvHfA+hCjAAejEg/vg+LJIUKsiWXFlbmHGE2BNkxklhJNzgdGXl5JvKGxmZGFqYmp
	sZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhnJRzinnUhUKOf5Za0xNdN
	W1hqryuJulaqt4q7CnwWeNF9y8b0wUqvh6GbHa0tg0L6W/9+/eH70/Wn8ZbbCqnLw6+9bJvv
	nOucy3PYhOVjzYXANyqXEv2Ya+rO7Zh6OqGps9Ha02v1v1zbqceOS/0NmTtpboXfdG2/s9FH
	WW31DK24P4kYLVJiKc5INNRiLipOBABIYzzyhAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDHbeYrU4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFj++17LAV3CipOrO9mbWBcF9XFyMkhIWAica15GzOELSZx4d56ti5GLg4hgemM
	EjdnHGCCcNqYJGb++MsIUsUmoCPxf99NdhBbREBBYnPvM1aQImaBK0Adi9czgSSEBVIlFr44
	xwpiswioStx+tAWsgVfAXeLMvS1AcQ6gdQoScybZgIQ5BTwk/pzcAtYqBFTSuOU7+wRG3gWM
	DKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPumfQOxlUNFocYBTgYlXh4OwonhwixJpYV
	V+YeYpTgYFYS4XU8DhTiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGA6yCuJNzQ2MTOyNDI3
	tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYPT4VC11gu2w+T3/2ZfeS4ue4nun92LC
	d/Wo+c//tmaWTVG8Fnlo5Zz0z35nFjNx6xw9fVUhNebgL8XN9qriBzKvXL29q6JM6OW+1WHv
	lErnetgFX5I588S39veBo7LGfLIvt5XvyzrTpHUh71bgoX0+i5j3JtzJWXZwRXIH86cWXrab
	9kc3t99XYinOSDTUYi4qTgQAJLe3vs8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To guerantee proper charing and managing batteries even in suspend,
charger-manager has used rtc device with rtc framework interface.
However, it is better to use alarmtimer for cleaner and more appropriate
operation.
This patch makes driver to use alamtimer for polling work in suspend and
removes all deprecated codes related with using rtc interface.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/Kconfig                 |    2 +-
 drivers/power/charger-manager.c       |  288 ++++++++++-----------------------
 include/linux/power/charger-manager.h |   32 +---
 3 files changed, 84 insertions(+), 238 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0108c2a..8ff2511 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -315,7 +315,7 @@ config CHARGER_GPIO
 
 config CHARGER_MANAGER
 	bool "Battery charger manager for multiple chargers"
-	depends on REGULATOR && RTC_CLASS
+	depends on REGULATOR
 	select EXTCON
 	help
           Say Y to enable charger-manager support, which allows multiple
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index ef8094a..22246b9 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -69,16 +69,11 @@ static LIST_HEAD(cm_list);
 static DEFINE_MUTEX(cm_list_mtx);
 
 /* About in-suspend (suspend-again) monitoring */
-static struct rtc_device *rtc_dev;
-/*
- * Backup RTC alarm
- * Save the wakeup alarm before entering suspend-to-RAM
- */
-static struct rtc_wkalrm rtc_wkalarm_save;
+static struct alarm *cm_timer;
+
 /* Backup RTC alarm time in terms of seconds since 01-01-1970 00:00:00 */
-static unsigned long rtc_wkalarm_save_time;
 static bool cm_suspended;
-static bool cm_rtc_set;
+static bool cm_timer_set;
 static unsigned long cm_suspend_duration_ms;
 
 /* About normal (not suspended) monitoring */
@@ -87,9 +82,6 @@ static unsigned long next_polling; /* Next appointed polling time */
 static struct workqueue_struct *cm_wq; /* init at driver add */
 static struct delayed_work cm_monitor_work; /* init at driver add */
 
-/* Global charger-manager description */
-static struct charger_global_desc *g_desc; /* init with setup_charger_manager */
-
 /**
  * is_batt_present - See if the battery presents in place.
  * @cm: the Charger Manager representing the battery.
@@ -1047,10 +1039,13 @@ static bool cm_setup_timer(void)
 {
 	struct charger_manager *cm;
 	unsigned int wakeup_ms = UINT_MAX;
-	bool ret = false;
+	int timer_req = 0;
 
-	mutex_lock(&cm_list_mtx);
+	if (time_after(next_polling, jiffies))
+		CM_MIN_VALID(wakeup_ms,
+			jiffies_to_msecs(next_polling - jiffies));
 
+	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
 		unsigned int fbchk_ms = 0;
 
@@ -1070,162 +1065,38 @@ static bool cm_setup_timer(void)
 		/* Skip if polling is not required for this CM */
 		if (!is_polling_required(cm) && !cm->emergency_stop)
 			continue;
+		timer_req++;
 		if (cm->desc->polling_interval_ms == 0)
 			continue;
 		CM_MIN_VALID(wakeup_ms, cm->desc->polling_interval_ms);
 	}
-
 	mutex_unlock(&cm_list_mtx);
 
-	if (wakeup_ms < UINT_MAX && wakeup_ms > 0) {
-		pr_info("Charger Manager wakeup timer: %u ms\n", wakeup_ms);
-		if (rtc_dev) {
-			struct rtc_wkalrm tmp;
-			unsigned long time, now;
-			unsigned long add = DIV_ROUND_UP(wakeup_ms, 1000);
-
-			/*
-			 * Set alarm with the polling interval (wakeup_ms)
-			 * except when rtc_wkalarm_save comes first.
-			 * However, the alarm time should be NOW +
-			 * CM_RTC_SMALL or later.
-			 */
-			tmp.enabled = 1;
-			rtc_read_time(rtc_dev, &tmp.time);
-			rtc_tm_to_time(&tmp.time, &now);
-			if (add < CM_RTC_SMALL)
-				add = CM_RTC_SMALL;
-			time = now + add;
+	if (timer_req && cm_timer) {
+		ktime_t now, add;
 
-			ret = true;
+		/*
+		 * Set alarm with the polling interval (wakeup_ms)
+		 * The alarm time should be NOW + CM_RTC_SMALL or later.
+		 */
+		if (wakeup_ms == UINT_MAX ||
+			wakeup_ms < CM_RTC_SMALL * MSEC_PER_SEC)
+			wakeup_ms = 2 * CM_RTC_SMALL * MSEC_PER_SEC;
 
-			if (rtc_wkalarm_save.enabled &&
-			    rtc_wkalarm_save_time &&
-			    rtc_wkalarm_save_time < time) {
-				if (rtc_wkalarm_save_time < now + CM_RTC_SMALL)
-					time = now + CM_RTC_SMALL;
-				else
-					time = rtc_wkalarm_save_time;
+		pr_info("Charger Manager wakeup timer: %u ms\n", wakeup_ms);
 
-				/* The timer is not appointed by CM */
-				ret = false;
-			}
+		now = ktime_get_boottime();
+		add = ktime_set(wakeup_ms / MSEC_PER_SEC,
+				(wakeup_ms % MSEC_PER_SEC) * NSEC_PER_MSEC);
+		alarm_start(cm_timer, ktime_add(now, add));
 
-			pr_info("Waking up after %lu secs\n", time - now);
+		cm_suspend_duration_ms = wakeup_ms;
 
-			rtc_time_to_tm(time, &tmp.time);
-			rtc_set_alarm(rtc_dev, &tmp);
-			cm_suspend_duration_ms += wakeup_ms;
-			return ret;
-		}
+		return true;
 	}
-
-	if (rtc_dev)
-		rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
 	return false;
 }
 
-static void _cm_fbchk_in_suspend(struct charger_manager *cm)
-{
-	unsigned long jiffy_now = jiffies;
-
-	if (!cm->fullbatt_vchk_jiffies_at)
-		return;
-
-	if (g_desc && g_desc->assume_timer_stops_in_suspend)
-		jiffy_now += msecs_to_jiffies(cm_suspend_duration_ms);
-
-	/* Execute now if it's going to be executed not too long after */
-	jiffy_now += CM_JIFFIES_SMALL;
-
-	if (time_after_eq(jiffy_now, cm->fullbatt_vchk_jiffies_at))
-		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
-}
-
-/**
- * cm_suspend_again - Determine whether suspend again or not
- *
- * Returns true if the system should be suspended again
- * Returns false if the system should be woken up
- */
-bool cm_suspend_again(void)
-{
-	struct charger_manager *cm;
-	bool ret = false;
-
-	if (!g_desc || !g_desc->rtc_only_wakeup || !g_desc->rtc_only_wakeup() ||
-	    !cm_rtc_set)
-		return false;
-
-	if (cm_monitor())
-		goto out;
-
-	ret = true;
-	mutex_lock(&cm_list_mtx);
-	list_for_each_entry(cm, &cm_list, entry) {
-		_cm_fbchk_in_suspend(cm);
-
-		if (cm->status_save_ext_pwr_inserted != is_ext_pwr_online(cm) ||
-		    cm->status_save_batt != is_batt_present(cm)) {
-			ret = false;
-			break;
-		}
-	}
-	mutex_unlock(&cm_list_mtx);
-
-	cm_rtc_set = cm_setup_timer();
-out:
-	/* It's about the time when the non-CM appointed timer goes off */
-	if (rtc_wkalarm_save.enabled) {
-		unsigned long now;
-		struct rtc_time tmp;
-
-		rtc_read_time(rtc_dev, &tmp);
-		rtc_tm_to_time(&tmp, &now);
-
-		if (rtc_wkalarm_save_time &&
-		    now + CM_RTC_SMALL >= rtc_wkalarm_save_time)
-			return false;
-	}
-	return ret;
-}
-EXPORT_SYMBOL_GPL(cm_suspend_again);
-
-/**
- * setup_charger_manager - initialize charger_global_desc data
- * @gd: pointer to instance of charger_global_desc
- */
-int setup_charger_manager(struct charger_global_desc *gd)
-{
-	if (!gd)
-		return -EINVAL;
-
-	if (rtc_dev)
-		rtc_class_close(rtc_dev);
-	rtc_dev = NULL;
-	g_desc = NULL;
-
-	if (!gd->rtc_only_wakeup) {
-		pr_err("The callback rtc_only_wakeup is not given\n");
-		return -EINVAL;
-	}
-
-	if (gd->rtc_name) {
-		rtc_dev = rtc_class_open(gd->rtc_name);
-		if (IS_ERR_OR_NULL(rtc_dev)) {
-			rtc_dev = NULL;
-			/* Retry at probe. RTC may be not registered yet */
-		}
-	} else {
-		pr_warn("No wakeup timer is given for charger manager.  "
-			"In-suspend monitoring won't work.\n");
-	}
-
-	g_desc = gd;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(setup_charger_manager);
-
 /**
  * charger_extcon_work - enable/diable charger according to the state
  *			of charger cable
@@ -1719,6 +1590,12 @@ static inline struct charger_desc *cm_get_drv_data(struct platform_device *pdev)
 	return dev_get_platdata(&pdev->dev);
 }
 
+static enum alarmtimer_restart cm_timer_func(struct alarm *alarm, ktime_t now)
+{
+	cm_timer_set = false;
+	return ALARMTIMER_NORESTART;
+}
+
 static int charger_manager_probe(struct platform_device *pdev)
 {
 	struct charger_desc *desc = cm_get_drv_data(pdev);
@@ -1728,16 +1605,6 @@ static int charger_manager_probe(struct platform_device *pdev)
 	union power_supply_propval val;
 	struct power_supply *fuel_gauge;
 
-	if (g_desc && !rtc_dev && g_desc->rtc_name) {
-		rtc_dev = rtc_class_open(g_desc->rtc_name);
-		if (IS_ERR_OR_NULL(rtc_dev)) {
-			rtc_dev = NULL;
-			dev_err(&pdev->dev, "Cannot get RTC %s\n",
-				g_desc->rtc_name);
-			return -ENODEV;
-		}
-	}
-
 	if (IS_ERR(desc)) {
 		dev_err(&pdev->dev, "No platform data (desc) found\n");
 		return -ENODEV;
@@ -1752,6 +1619,12 @@ static int charger_manager_probe(struct platform_device *pdev)
 	cm->dev = &pdev->dev;
 	cm->desc = desc;
 
+	/* Initialize alarm timer */
+	if (alarmtimer_get_rtcdev()) {
+		cm_timer = devm_kzalloc(cm->dev, sizeof(*cm_timer), GFP_KERNEL);
+		alarm_init(cm_timer, ALARM_BOOTTIME, cm_timer_func);
+	}
+
 	/*
 	 * The following two do not need to be errors.
 	 * Users may intentionally ignore those two features.
@@ -1993,38 +1866,41 @@ static int cm_suspend_noirq(struct device *dev)
 	return ret;
 }
 
+static bool cm_need_to_awake(void)
+{
+	struct charger_manager *cm;
+
+	if (cm_timer)
+		return false;
+
+	mutex_lock(&cm_list_mtx);
+	list_for_each_entry(cm, &cm_list, entry) {
+		if (is_charging(cm)) {
+			mutex_unlock(&cm_list_mtx);
+			return true;
+		}
+	}
+	mutex_unlock(&cm_list_mtx);
+
+	return false;
+}
+
 static int cm_suspend_prepare(struct device *dev)
 {
 	struct charger_manager *cm = dev_get_drvdata(dev);
 
-	if (!cm_suspended) {
-		if (rtc_dev) {
-			struct rtc_time tmp;
-			unsigned long now;
-
-			rtc_read_alarm(rtc_dev, &rtc_wkalarm_save);
-			rtc_read_time(rtc_dev, &tmp);
+	if (cm_need_to_awake())
+		return -EBUSY;
 
-			if (rtc_wkalarm_save.enabled) {
-				rtc_tm_to_time(&rtc_wkalarm_save.time,
-					       &rtc_wkalarm_save_time);
-				rtc_tm_to_time(&tmp, &now);
-				if (now > rtc_wkalarm_save_time)
-					rtc_wkalarm_save_time = 0;
-			} else {
-				rtc_wkalarm_save_time = 0;
-			}
-		}
+	if (!cm_suspended)
 		cm_suspended = true;
-	}
 
-	cancel_delayed_work(&cm->fullbatt_vchk_work);
-	cm->status_save_ext_pwr_inserted = is_ext_pwr_online(cm);
-	cm->status_save_batt = is_batt_present(cm);
+	cm_timer_set = cm_setup_timer();
 
-	if (!cm_rtc_set) {
-		cm_suspend_duration_ms = 0;
-		cm_rtc_set = cm_setup_timer();
+	if (cm_timer_set) {
+		cancel_work_sync(&setup_polling);
+		cancel_delayed_work_sync(&cm_monitor_work);
+		cancel_delayed_work(&cm->fullbatt_vchk_work);
 	}
 
 	return 0;
@@ -2034,18 +1910,21 @@ static void cm_suspend_complete(struct device *dev)
 {
 	struct charger_manager *cm = dev_get_drvdata(dev);
 
-	if (cm_suspended) {
-		if (rtc_dev) {
-			struct rtc_wkalrm tmp;
-
-			rtc_read_alarm(rtc_dev, &tmp);
-			rtc_wkalarm_save.pending = tmp.pending;
-			rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
-		}
+	if (cm_suspended)
 		cm_suspended = false;
-		cm_rtc_set = false;
+
+	if (cm_timer_set) {
+		ktime_t remain;
+
+		alarm_cancel(cm_timer);
+		cm_timer_set = false;
+		remain = alarm_expires_remaining(cm_timer);
+		cm_suspend_duration_ms -= ktime_to_ms(remain);
+		schedule_work(&setup_polling);
 	}
 
+	_cm_monitor(cm);
+
 	/* Re-enqueue delayed work (fullbatt_vchk_work) */
 	if (cm->fullbatt_vchk_jiffies_at) {
 		unsigned long delay = 0;
@@ -2060,21 +1939,18 @@ static void cm_suspend_complete(struct device *dev)
 		}
 
 		/*
-		 * Account for cm_suspend_duration_ms if
-		 * assume_timer_stops_in_suspend is active
+		 * Account for cm_suspend_duration_ms with assuming that
+		 * timer stops in suspend.
 		 */
-		if (g_desc && g_desc->assume_timer_stops_in_suspend) {
-			if (delay > cm_suspend_duration_ms)
-				delay -= cm_suspend_duration_ms;
-			else
-				delay = 0;
-		}
+		if (delay > cm_suspend_duration_ms)
+			delay -= cm_suspend_duration_ms;
+		else
+			delay = 0;
 
 		queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
 				   msecs_to_jiffies(delay));
 	}
 	device_set_wakeup_capable(cm->dev, false);
-	uevent_notify(cm, NULL);
 }
 
 static const struct dev_pm_ops charger_manager_pm = {
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index e97fc65..416ebeb 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -17,6 +17,7 @@
 
 #include <linux/power_supply.h>
 #include <linux/extcon.h>
+#include <linux/alarmtimer.h>
 
 enum data_source {
 	CM_BATTERY_PRESENT,
@@ -45,29 +46,6 @@ enum cm_event_types {
 };
 
 /**
- * struct charger_global_desc
- * @rtc_name: the name of RTC used to wake up the system from suspend.
- * @rtc_only_wakeup:
- *	If the system is woken up by waekup-sources other than the RTC or
- *	callbacks, Charger Manager should recognize with
- *	rtc_only_wakeup() returning false.
- *	If the RTC given to CM is the only wakeup reason,
- *	rtc_only_wakeup should return true.
- * @assume_timer_stops_in_suspend:
- *	Assume that the jiffy timer stops in suspend-to-RAM.
- *	When enabled, CM does not rely on jiffies value in
- *	suspend_again and assumes that jiffies value does not
- *	change during suspend.
- */
-struct charger_global_desc {
-	char *rtc_name;
-
-	bool (*rtc_only_wakeup)(void);
-
-	bool assume_timer_stops_in_suspend;
-};
-
-/**
  * struct charger_cable
  * @extcon_name: the name of extcon device.
  * @name: the name of charger cable(external connector).
@@ -266,22 +244,14 @@ struct charger_manager {
 	char psy_name_buf[PSY_NAME_MAX + 1];
 	struct power_supply charger_psy;
 
-	bool status_save_ext_pwr_inserted;
-	bool status_save_batt;
-
 	u64 charging_start_time;
 	u64 charging_end_time;
 };
 
 #ifdef CONFIG_CHARGER_MANAGER
-extern int setup_charger_manager(struct charger_global_desc *gd);
-extern bool cm_suspend_again(void);
 extern void cm_notify_event(struct power_supply *psy,
 				enum cm_event_types type, char *msg);
 #else
-static inline int setup_charger_manager(struct charger_global_desc *gd)
-{ return 0; }
-static inline bool cm_suspend_again(void) { return false; }
 static inline void cm_notify_event(struct power_supply *psy,
 				enum cm_event_types type, char *msg) { }
 #endif
-- 
1.7.9.5

