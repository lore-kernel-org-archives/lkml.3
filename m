Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3ATV6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:58:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47753 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab3ATV6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:58:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Remove useless type argument of driver .remove() operation
Date: Sun, 20 Jan 2013 23:04:47 +0100
Message-ID: <1518653.CUpDmbmCI3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The second argument of ACPI driver .remove() operation is only used
by the ACPI processor driver and the value passed to that driver
through it is always available from the given struct acpi_device
object's removal_type field.  For this reason, the second ACPI driver
.remove() argument is in fact useless, so drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/ac.c                        |    4 ++--
 drivers/acpi/acpi_memhotplug.c           |    4 ++--
 drivers/acpi/acpi_pad.c                  |    3 +--
 drivers/acpi/battery.c                   |    2 +-
 drivers/acpi/button.c                    |    4 ++--
 drivers/acpi/container.c                 |    4 ++--
 drivers/acpi/ec.c                        |    2 +-
 drivers/acpi/fan.c                       |    4 ++--
 drivers/acpi/hed.c                       |    2 +-
 drivers/acpi/pci_link.c                  |    4 ++--
 drivers/acpi/pci_root.c                  |    4 ++--
 drivers/acpi/processor_driver.c          |    6 +++---
 drivers/acpi/sbs.c                       |    6 +++---
 drivers/acpi/sbshc.c                     |    4 ++--
 drivers/acpi/scan.c                      |    5 ++---
 drivers/acpi/thermal.c                   |    4 ++--
 drivers/acpi/video.c                     |    4 ++--
 drivers/char/hpet.c                      |    2 +-
 drivers/char/sonypi.c                    |    2 +-
 drivers/hwmon/acpi_power_meter.c         |    2 +-
 drivers/hwmon/asus_atk0110.c             |    4 ++--
 drivers/i2c/busses/i2c-scmi.c            |    2 +-
 drivers/input/misc/atlas_btns.c          |    2 +-
 drivers/platform/x86/asus-laptop.c       |    2 +-
 drivers/platform/x86/classmate-laptop.c  |    8 ++++----
 drivers/platform/x86/eeepc-laptop.c      |    2 +-
 drivers/platform/x86/fujitsu-laptop.c    |    4 ++--
 drivers/platform/x86/fujitsu-tablet.c    |    2 +-
 drivers/platform/x86/hp_accel.c          |    2 +-
 drivers/platform/x86/ideapad-laptop.c    |    2 +-
 drivers/platform/x86/intel_menlow.c      |    2 +-
 drivers/platform/x86/panasonic-laptop.c  |    4 ++--
 drivers/platform/x86/sony-laptop.c       |    4 ++--
 drivers/platform/x86/topstar-laptop.c    |    2 +-
 drivers/platform/x86/toshiba_acpi.c      |    4 ++--
 drivers/platform/x86/toshiba_bluetooth.c |    4 ++--
 drivers/platform/x86/wmi.c               |    4 ++--
 drivers/platform/x86/xo15-ebook.c        |    2 +-
 drivers/staging/quickstart/quickstart.c  |    2 +-
 drivers/video/backlight/apple_bl.c       |    2 +-
 drivers/xen/xen-acpi-pad.c               |    3 +--
 include/acpi/acpi_bus.h                  |    2 +-
 42 files changed, 67 insertions(+), 70 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -89,7 +89,7 @@ struct acpi_device;
  */
 
 typedef int (*acpi_op_add) (struct acpi_device * device);
-typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
+typedef int (*acpi_op_remove) (struct acpi_device * device);
 typedef int (*acpi_op_start) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 
Index: linux-pm/drivers/acpi/ec.c
===================================================================
--- linux-pm.orig/drivers/acpi/ec.c
+++ linux-pm/drivers/acpi/ec.c
@@ -852,7 +852,7 @@ static int acpi_ec_add(struct acpi_devic
 	return ret;
 }
 
-static int acpi_ec_remove(struct acpi_device *device, int type)
+static int acpi_ec_remove(struct acpi_device *device)
 {
 	struct acpi_ec *ec;
 	struct acpi_ec_query_handler *handler, *tmp;
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -46,7 +46,7 @@ ACPI_MODULE_NAME("pci_root");
 #define ACPI_PCI_ROOT_CLASS		"pci_bridge"
 #define ACPI_PCI_ROOT_DEVICE_NAME	"PCI Root Bridge"
 static int acpi_pci_root_add(struct acpi_device *device);
-static int acpi_pci_root_remove(struct acpi_device *device, int type);
+static int acpi_pci_root_remove(struct acpi_device *device);
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
 				| OSC_ACTIVE_STATE_PWR_SUPPORT \
@@ -609,7 +609,7 @@ end:
 	return result;
 }
 
-static int acpi_pci_root_remove(struct acpi_device *device, int type)
+static int acpi_pci_root_remove(struct acpi_device *device)
 {
 	acpi_status status;
 	acpi_handle handle;
Index: linux-pm/drivers/acpi/pci_link.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_link.c
+++ linux-pm/drivers/acpi/pci_link.c
@@ -54,7 +54,7 @@ ACPI_MODULE_NAME("pci_link");
 #define ACPI_PCI_LINK_MAX_POSSIBLE	16
 
 static int acpi_pci_link_add(struct acpi_device *device);
-static int acpi_pci_link_remove(struct acpi_device *device, int type);
+static int acpi_pci_link_remove(struct acpi_device *device);
 
 static const struct acpi_device_id link_device_ids[] = {
 	{"PNP0C0F", 0},
@@ -766,7 +766,7 @@ static void irqrouter_resume(void)
 	}
 }
 
-static int acpi_pci_link_remove(struct acpi_device *device, int type)
+static int acpi_pci_link_remove(struct acpi_device *device)
 {
 	struct acpi_pci_link *link;
 
Index: linux-pm/drivers/char/hpet.c
===================================================================
--- linux-pm.orig/drivers/char/hpet.c
+++ linux-pm/drivers/char/hpet.c
@@ -1041,7 +1041,7 @@ static int hpet_acpi_add(struct acpi_dev
 	return hpet_alloc(&data);
 }
 
-static int hpet_acpi_remove(struct acpi_device *device, int type)
+static int hpet_acpi_remove(struct acpi_device *device)
 {
 	/* XXX need to unregister clocksource, dealloc mem, etc */
 	return -EINVAL;
Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -52,7 +52,7 @@ MODULE_DESCRIPTION("ACPI container drive
 MODULE_LICENSE("GPL");
 
 static int acpi_container_add(struct acpi_device *device);
-static int acpi_container_remove(struct acpi_device *device, int type);
+static int acpi_container_remove(struct acpi_device *device);
 
 static const struct acpi_device_id container_device_ids[] = {
 	{"ACPI0004", 0},
@@ -125,7 +125,7 @@ static int acpi_container_add(struct acp
 	return 0;
 }
 
-static int acpi_container_remove(struct acpi_device *device, int type)
+static int acpi_container_remove(struct acpi_device *device)
 {
 	acpi_status status = AE_OK;
 	struct acpi_container *pc = NULL;
Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -81,7 +81,7 @@ MODULE_DESCRIPTION("ACPI Processor Drive
 MODULE_LICENSE("GPL");
 
 static int acpi_processor_add(struct acpi_device *device);
-static int acpi_processor_remove(struct acpi_device *device, int type);
+static int acpi_processor_remove(struct acpi_device *device);
 static void acpi_processor_notify(struct acpi_device *device, u32 event);
 static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr);
 static int acpi_processor_handle_eject(struct acpi_processor *pr);
@@ -610,7 +610,7 @@ err_free_pr:
 	return result;
 }
 
-static int acpi_processor_remove(struct acpi_device *device, int type)
+static int acpi_processor_remove(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 
@@ -623,7 +623,7 @@ static int acpi_processor_remove(struct
 	if (pr->id >= nr_cpu_ids)
 		goto free;
 
-	if (type == ACPI_BUS_REMOVAL_EJECT) {
+	if (device->removal_type == ACPI_BUS_REMOVAL_EJECT) {
 		if (acpi_processor_handle_eject(pr))
 			return -EINVAL;
 	}
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -617,8 +617,7 @@ static int acpi_device_probe(struct devi
 			ret = acpi_device_install_notify_handler(acpi_dev);
 			if (ret) {
 				if (acpi_drv->ops.remove)
-					acpi_drv->ops.remove(acpi_dev,
-						     acpi_dev->removal_type);
+					acpi_drv->ops.remove(acpi_dev);
 				return ret;
 			}
 		}
@@ -640,7 +639,7 @@ static int acpi_device_remove(struct dev
 		if (acpi_drv->ops.notify)
 			acpi_device_remove_notify_handler(acpi_dev);
 		if (acpi_drv->ops.remove)
-			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
+			acpi_drv->ops.remove(acpi_dev);
 	}
 	acpi_dev->driver = NULL;
 	acpi_dev->driver_data = NULL;
Index: linux-pm/drivers/acpi/button.c
===================================================================
--- linux-pm.orig/drivers/acpi/button.c
+++ linux-pm/drivers/acpi/button.c
@@ -75,7 +75,7 @@ static const struct acpi_device_id butto
 MODULE_DEVICE_TABLE(acpi, button_device_ids);
 
 static int acpi_button_add(struct acpi_device *device);
-static int acpi_button_remove(struct acpi_device *device, int type);
+static int acpi_button_remove(struct acpi_device *device);
 static void acpi_button_notify(struct acpi_device *device, u32 event);
 
 #ifdef CONFIG_PM_SLEEP
@@ -433,7 +433,7 @@ static int acpi_button_add(struct acpi_d
 	return error;
 }
 
-static int acpi_button_remove(struct acpi_device *device, int type)
+static int acpi_button_remove(struct acpi_device *device)
 {
 	struct acpi_button *button = acpi_driver_data(device);
 
Index: linux-pm/drivers/acpi/fan.c
===================================================================
--- linux-pm.orig/drivers/acpi/fan.c
+++ linux-pm/drivers/acpi/fan.c
@@ -45,7 +45,7 @@ MODULE_DESCRIPTION("ACPI Fan Driver");
 MODULE_LICENSE("GPL");
 
 static int acpi_fan_add(struct acpi_device *device);
-static int acpi_fan_remove(struct acpi_device *device, int type);
+static int acpi_fan_remove(struct acpi_device *device);
 
 static const struct acpi_device_id fan_device_ids[] = {
 	{"PNP0C0B", 0},
@@ -172,7 +172,7 @@ static int acpi_fan_add(struct acpi_devi
 	return result;
 }
 
-static int acpi_fan_remove(struct acpi_device *device, int type)
+static int acpi_fan_remove(struct acpi_device *device)
 {
 	struct thermal_cooling_device *cdev = acpi_driver_data(device);
 
Index: linux-pm/drivers/acpi/sbs.c
===================================================================
--- linux-pm.orig/drivers/acpi/sbs.c
+++ linux-pm/drivers/acpi/sbs.c
@@ -130,7 +130,7 @@ struct acpi_sbs {
 
 #define to_acpi_sbs(x) container_of(x, struct acpi_sbs, charger)
 
-static int acpi_sbs_remove(struct acpi_device *device, int type);
+static int acpi_sbs_remove(struct acpi_device *device);
 static int acpi_battery_get_state(struct acpi_battery *battery);
 
 static inline int battery_scale(int log)
@@ -949,11 +949,11 @@ static int acpi_sbs_add(struct acpi_devi
 	acpi_smbus_register_callback(sbs->hc, acpi_sbs_callback, sbs);
       end:
 	if (result)
-		acpi_sbs_remove(device, 0);
+		acpi_sbs_remove(device);
 	return result;
 }
 
-static int acpi_sbs_remove(struct acpi_device *device, int type)
+static int acpi_sbs_remove(struct acpi_device *device)
 {
 	struct acpi_sbs *sbs;
 	int id;
Index: linux-pm/drivers/acpi/ac.c
===================================================================
--- linux-pm.orig/drivers/acpi/ac.c
+++ linux-pm/drivers/acpi/ac.c
@@ -60,7 +60,7 @@ static int acpi_ac_open_fs(struct inode
 #endif
 
 static int acpi_ac_add(struct acpi_device *device);
-static int acpi_ac_remove(struct acpi_device *device, int type);
+static int acpi_ac_remove(struct acpi_device *device);
 static void acpi_ac_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id ac_device_ids[] = {
@@ -337,7 +337,7 @@ static int acpi_ac_resume(struct device
 }
 #endif
 
-static int acpi_ac_remove(struct acpi_device *device, int type)
+static int acpi_ac_remove(struct acpi_device *device)
 {
 	struct acpi_ac *ac = NULL;
 
Index: linux-pm/drivers/acpi/video.c
===================================================================
--- linux-pm.orig/drivers/acpi/video.c
+++ linux-pm/drivers/acpi/video.c
@@ -88,7 +88,7 @@ module_param(use_bios_initial_backlight,
 
 static int register_count = 0;
 static int acpi_video_bus_add(struct acpi_device *device);
-static int acpi_video_bus_remove(struct acpi_device *device, int type);
+static int acpi_video_bus_remove(struct acpi_device *device);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id video_device_ids[] = {
@@ -1740,7 +1740,7 @@ static int acpi_video_bus_add(struct acp
 	return error;
 }
 
-static int acpi_video_bus_remove(struct acpi_device *device, int type)
+static int acpi_video_bus_remove(struct acpi_device *device)
 {
 	struct acpi_video_bus *video = NULL;
 
Index: linux-pm/drivers/hwmon/acpi_power_meter.c
===================================================================
--- linux-pm.orig/drivers/hwmon/acpi_power_meter.c
+++ linux-pm/drivers/hwmon/acpi_power_meter.c
@@ -911,7 +911,7 @@ exit:
 	return res;
 }
 
-static int acpi_power_meter_remove(struct acpi_device *device, int type)
+static int acpi_power_meter_remove(struct acpi_device *device)
 {
 	struct acpi_power_meter_resource *resource;
 
Index: linux-pm/drivers/input/misc/atlas_btns.c
===================================================================
--- linux-pm.orig/drivers/input/misc/atlas_btns.c
+++ linux-pm/drivers/input/misc/atlas_btns.c
@@ -121,7 +121,7 @@ static int atlas_acpi_button_add(struct
 	return err;
 }
 
-static int atlas_acpi_button_remove(struct acpi_device *device, int type)
+static int atlas_acpi_button_remove(struct acpi_device *device)
 {
 	acpi_status status;
 
Index: linux-pm/drivers/i2c/busses/i2c-scmi.c
===================================================================
--- linux-pm.orig/drivers/i2c/busses/i2c-scmi.c
+++ linux-pm/drivers/i2c/busses/i2c-scmi.c
@@ -406,7 +406,7 @@ err:
 	return -EIO;
 }
 
-static int acpi_smbus_cmi_remove(struct acpi_device *device, int type)
+static int acpi_smbus_cmi_remove(struct acpi_device *device)
 {
 	struct acpi_smbus_cmi *smbus_cmi = acpi_driver_data(device);
 
Index: linux-pm/drivers/acpi/thermal.c
===================================================================
--- linux-pm.orig/drivers/acpi/thermal.c
+++ linux-pm/drivers/acpi/thermal.c
@@ -97,7 +97,7 @@ module_param(psv, int, 0644);
 MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");
 
 static int acpi_thermal_add(struct acpi_device *device);
-static int acpi_thermal_remove(struct acpi_device *device, int type);
+static int acpi_thermal_remove(struct acpi_device *device);
 static void acpi_thermal_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id  thermal_device_ids[] = {
@@ -1115,7 +1115,7 @@ end:
 	return result;
 }
 
-static int acpi_thermal_remove(struct acpi_device *device, int type)
+static int acpi_thermal_remove(struct acpi_device *device)
 {
 	struct acpi_thermal *tz = NULL;
 
Index: linux-pm/drivers/acpi/battery.c
===================================================================
--- linux-pm.orig/drivers/acpi/battery.c
+++ linux-pm/drivers/acpi/battery.c
@@ -1111,7 +1111,7 @@ fail:
 	return result;
 }
 
-static int acpi_battery_remove(struct acpi_device *device, int type)
+static int acpi_battery_remove(struct acpi_device *device)
 {
 	struct acpi_battery *battery = NULL;
 
Index: linux-pm/drivers/acpi/sbshc.c
===================================================================
--- linux-pm.orig/drivers/acpi/sbshc.c
+++ linux-pm/drivers/acpi/sbshc.c
@@ -33,7 +33,7 @@ struct acpi_smb_hc {
 };
 
 static int acpi_smbus_hc_add(struct acpi_device *device);
-static int acpi_smbus_hc_remove(struct acpi_device *device, int type);
+static int acpi_smbus_hc_remove(struct acpi_device *device);
 
 static const struct acpi_device_id sbs_device_ids[] = {
 	{"ACPI0001", 0},
@@ -296,7 +296,7 @@ static int acpi_smbus_hc_add(struct acpi
 
 extern void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
 
-static int acpi_smbus_hc_remove(struct acpi_device *device, int type)
+static int acpi_smbus_hc_remove(struct acpi_device *device)
 {
 	struct acpi_smb_hc *hc;
 
Index: linux-pm/drivers/acpi/hed.c
===================================================================
--- linux-pm.orig/drivers/acpi/hed.c
+++ linux-pm/drivers/acpi/hed.c
@@ -70,7 +70,7 @@ static int acpi_hed_add(struct acpi_devi
 	return 0;
 }
 
-static int acpi_hed_remove(struct acpi_device *device, int type)
+static int acpi_hed_remove(struct acpi_device *device)
 {
 	hed_handle = NULL;
 	return 0;
Index: linux-pm/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_memhotplug.c
+++ linux-pm/drivers/acpi/acpi_memhotplug.c
@@ -54,7 +54,7 @@ MODULE_LICENSE("GPL");
 #define MEMORY_POWER_OFF_STATE	2
 
 static int acpi_memory_device_add(struct acpi_device *device);
-static int acpi_memory_device_remove(struct acpi_device *device, int type);
+static int acpi_memory_device_remove(struct acpi_device *device);
 
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
@@ -415,7 +415,7 @@ static int acpi_memory_device_add(struct
 	return result;
 }
 
-static int acpi_memory_device_remove(struct acpi_device *device, int type)
+static int acpi_memory_device_remove(struct acpi_device *device)
 {
 	struct acpi_memory_device *mem_device = NULL;
 	int result;
Index: linux-pm/drivers/acpi/acpi_pad.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_pad.c
+++ linux-pm/drivers/acpi/acpi_pad.c
@@ -482,8 +482,7 @@ static int acpi_pad_add(struct acpi_devi
 	return 0;
 }
 
-static int acpi_pad_remove(struct acpi_device *device,
-	int type)
+static int acpi_pad_remove(struct acpi_device *device)
 {
 	mutex_lock(&isolated_cpus_lock);
 	acpi_pad_idle_cpus(0);
Index: linux-pm/drivers/char/sonypi.c
===================================================================
--- linux-pm.orig/drivers/char/sonypi.c
+++ linux-pm/drivers/char/sonypi.c
@@ -1142,7 +1142,7 @@ static int sonypi_acpi_add(struct acpi_d
 	return 0;
 }
 
-static int sonypi_acpi_remove(struct acpi_device *device, int type)
+static int sonypi_acpi_remove(struct acpi_device *device)
 {
 	sonypi_acpi_device = NULL;
 	return 0;
Index: linux-pm/drivers/hwmon/asus_atk0110.c
===================================================================
--- linux-pm.orig/drivers/hwmon/asus_atk0110.c
+++ linux-pm/drivers/hwmon/asus_atk0110.c
@@ -190,7 +190,7 @@ struct atk_acpi_input_buf {
 };
 
 static int atk_add(struct acpi_device *device);
-static int atk_remove(struct acpi_device *device, int type);
+static int atk_remove(struct acpi_device *device);
 static void atk_print_sensor(struct atk_data *data, union acpi_object *obj);
 static int atk_read_value(struct atk_sensor_data *sensor, u64 *value);
 static void atk_free_sensors(struct atk_data *data);
@@ -1416,7 +1416,7 @@ out:
 	return err;
 }
 
-static int atk_remove(struct acpi_device *device, int type)
+static int atk_remove(struct acpi_device *device)
 {
 	struct atk_data *data = device->driver_data;
 	dev_dbg(&device->dev, "removing...\n");
Index: linux-pm/drivers/platform/x86/asus-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/asus-laptop.c
+++ linux-pm/drivers/platform/x86/asus-laptop.c
@@ -1910,7 +1910,7 @@ fail_platform:
 	return result;
 }
 
-static int asus_acpi_remove(struct acpi_device *device, int type)
+static int asus_acpi_remove(struct acpi_device *device)
 {
 	struct asus_laptop *asus = acpi_driver_data(device);
 
Index: linux-pm/drivers/platform/x86/classmate-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/classmate-laptop.c
+++ linux-pm/drivers/platform/x86/classmate-laptop.c
@@ -668,7 +668,7 @@ failed_file:
 	return error;
 }
 
-static int cmpc_accel_remove(struct acpi_device *acpi, int type)
+static int cmpc_accel_remove(struct acpi_device *acpi)
 {
 	struct input_dev *inputdev;
 	struct cmpc_accel *accel;
@@ -753,7 +753,7 @@ static int cmpc_tablet_add(struct acpi_d
 					   cmpc_tablet_idev_init);
 }
 
-static int cmpc_tablet_remove(struct acpi_device *acpi, int type)
+static int cmpc_tablet_remove(struct acpi_device *acpi)
 {
 	return cmpc_remove_acpi_notify_device(acpi);
 }
@@ -1000,7 +1000,7 @@ out_bd:
 	return retval;
 }
 
-static int cmpc_ipml_remove(struct acpi_device *acpi, int type)
+static int cmpc_ipml_remove(struct acpi_device *acpi)
 {
 	struct ipml200_dev *ipml;
 
@@ -1079,7 +1079,7 @@ static int cmpc_keys_add(struct acpi_dev
 					   cmpc_keys_idev_init);
 }
 
-static int cmpc_keys_remove(struct acpi_device *acpi, int type)
+static int cmpc_keys_remove(struct acpi_device *acpi)
 {
 	return cmpc_remove_acpi_notify_device(acpi);
 }
Index: linux-pm/drivers/platform/x86/eeepc-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/eeepc-laptop.c
+++ linux-pm/drivers/platform/x86/eeepc-laptop.c
@@ -1501,7 +1501,7 @@ fail_platform:
 	return result;
 }
 
-static int eeepc_acpi_remove(struct acpi_device *device, int type)
+static int eeepc_acpi_remove(struct acpi_device *device)
 {
 	struct eeepc_laptop *eeepc = acpi_driver_data(device);
 
Index: linux-pm/drivers/platform/x86/fujitsu-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/fujitsu-laptop.c
+++ linux-pm/drivers/platform/x86/fujitsu-laptop.c
@@ -733,7 +733,7 @@ err_stop:
 	return result;
 }
 
-static int acpi_fujitsu_remove(struct acpi_device *device, int type)
+static int acpi_fujitsu_remove(struct acpi_device *device)
 {
 	struct fujitsu_t *fujitsu = acpi_driver_data(device);
 	struct input_dev *input = fujitsu->input;
@@ -938,7 +938,7 @@ err_stop:
 	return result;
 }
 
-static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
+static int acpi_fujitsu_hotkey_remove(struct acpi_device *device)
 {
 	struct fujitsu_hotkey_t *fujitsu_hotkey = acpi_driver_data(device);
 	struct input_dev *input = fujitsu_hotkey->input;
Index: linux-pm/drivers/platform/x86/fujitsu-tablet.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/fujitsu-tablet.c
+++ linux-pm/drivers/platform/x86/fujitsu-tablet.c
@@ -431,7 +431,7 @@ static int acpi_fujitsu_add(struct acpi_
 	return 0;
 }
 
-static int acpi_fujitsu_remove(struct acpi_device *adev, int type)
+static int acpi_fujitsu_remove(struct acpi_device *adev)
 {
 	free_irq(fujitsu.irq, fujitsu_interrupt);
 	release_region(fujitsu.io_base, fujitsu.io_length);
Index: linux-pm/drivers/platform/x86/hp_accel.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/hp_accel.c
+++ linux-pm/drivers/platform/x86/hp_accel.c
@@ -337,7 +337,7 @@ static int lis3lv02d_add(struct acpi_dev
 	return ret;
 }
 
-static int lis3lv02d_remove(struct acpi_device *device, int type)
+static int lis3lv02d_remove(struct acpi_device *device)
 {
 	if (!device)
 		return -EINVAL;
Index: linux-pm/drivers/platform/x86/ideapad-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/ideapad-laptop.c
+++ linux-pm/drivers/platform/x86/ideapad-laptop.c
@@ -834,7 +834,7 @@ platform_failed:
 	return ret;
 }
 
-static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
+static int ideapad_acpi_remove(struct acpi_device *adevice)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int i;
Index: linux-pm/drivers/platform/x86/intel_menlow.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/intel_menlow.c
+++ linux-pm/drivers/platform/x86/intel_menlow.c
@@ -200,7 +200,7 @@ static int intel_menlow_memory_add(struc
 
 }
 
-static int intel_menlow_memory_remove(struct acpi_device *device, int type)
+static int intel_menlow_memory_remove(struct acpi_device *device)
 {
 	struct thermal_cooling_device *cdev = acpi_driver_data(device);
 
Index: linux-pm/drivers/platform/x86/panasonic-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/panasonic-laptop.c
+++ linux-pm/drivers/platform/x86/panasonic-laptop.c
@@ -176,7 +176,7 @@ enum SINF_BITS { SINF_NUM_BATTERIES = 0,
 /* R1 handles SINF_AC_CUR_BRIGHT as SINF_CUR_BRIGHT, doesn't know AC state */
 
 static int acpi_pcc_hotkey_add(struct acpi_device *device);
-static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type);
+static int acpi_pcc_hotkey_remove(struct acpi_device *device);
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id pcc_device_ids[] = {
@@ -663,7 +663,7 @@ static int __init acpi_pcc_init(void)
 	return 0;
 }
 
-static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type)
+static int acpi_pcc_hotkey_remove(struct acpi_device *device)
 {
 	struct pcc_acpi *pcc = acpi_driver_data(device);
 
Index: linux-pm/drivers/platform/x86/sony-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/sony-laptop.c
+++ linux-pm/drivers/platform/x86/sony-laptop.c
@@ -2740,7 +2740,7 @@ outwalk:
 	return result;
 }
 
-static int sony_nc_remove(struct acpi_device *device, int type)
+static int sony_nc_remove(struct acpi_device *device)
 {
 	struct sony_nc_value *item;
 
@@ -4111,7 +4111,7 @@ found:
  *  ACPI driver
  *
  *****************/
-static int sony_pic_remove(struct acpi_device *device, int type)
+static int sony_pic_remove(struct acpi_device *device)
 {
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;
Index: linux-pm/drivers/platform/x86/topstar-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/topstar-laptop.c
+++ linux-pm/drivers/platform/x86/topstar-laptop.c
@@ -157,7 +157,7 @@ add_err:
 	return -ENODEV;
 }
 
-static int acpi_topstar_remove(struct acpi_device *device, int type)
+static int acpi_topstar_remove(struct acpi_device *device)
 {
 	struct topstar_hkey *tps_hkey = acpi_driver_data(device);
 
Index: linux-pm/drivers/platform/x86/toshiba_acpi.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/toshiba_acpi.c
+++ linux-pm/drivers/platform/x86/toshiba_acpi.c
@@ -1118,7 +1118,7 @@ static int toshiba_acpi_setup_backlight(
 	return 0;
 }
 
-static int toshiba_acpi_remove(struct acpi_device *acpi_dev, int type)
+static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
 
@@ -1250,7 +1250,7 @@ static int toshiba_acpi_add(struct acpi_
 	return 0;
 
 error:
-	toshiba_acpi_remove(acpi_dev, 0);
+	toshiba_acpi_remove(acpi_dev);
 	return ret;
 }
 
Index: linux-pm/drivers/platform/x86/toshiba_bluetooth.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/toshiba_bluetooth.c
+++ linux-pm/drivers/platform/x86/toshiba_bluetooth.c
@@ -32,7 +32,7 @@ MODULE_LICENSE("GPL");
 
 
 static int toshiba_bt_rfkill_add(struct acpi_device *device);
-static int toshiba_bt_rfkill_remove(struct acpi_device *device, int type);
+static int toshiba_bt_rfkill_remove(struct acpi_device *device);
 static void toshiba_bt_rfkill_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id bt_device_ids[] = {
@@ -122,7 +122,7 @@ static int toshiba_bt_rfkill_add(struct
 	return result;
 }
 
-static int toshiba_bt_rfkill_remove(struct acpi_device *device, int type)
+static int toshiba_bt_rfkill_remove(struct acpi_device *device)
 {
 	/* clean up */
 	return 0;
Index: linux-pm/drivers/platform/x86/wmi.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/wmi.c
+++ linux-pm/drivers/platform/x86/wmi.c
@@ -92,7 +92,7 @@ module_param(debug_dump_wdg, bool, 0444)
 MODULE_PARM_DESC(debug_dump_wdg,
 		 "Dump available WMI interfaces [0/1]");
 
-static int acpi_wmi_remove(struct acpi_device *device, int type);
+static int acpi_wmi_remove(struct acpi_device *device);
 static int acpi_wmi_add(struct acpi_device *device);
 static void acpi_wmi_notify(struct acpi_device *device, u32 event);
 
@@ -917,7 +917,7 @@ static void acpi_wmi_notify(struct acpi_
 	}
 }
 
-static int acpi_wmi_remove(struct acpi_device *device, int type)
+static int acpi_wmi_remove(struct acpi_device *device)
 {
 	acpi_remove_address_space_handler(device->handle,
 				ACPI_ADR_SPACE_EC, &acpi_wmi_ec_space_handler);
Index: linux-pm/drivers/platform/x86/xo15-ebook.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/xo15-ebook.c
+++ linux-pm/drivers/platform/x86/xo15-ebook.c
@@ -150,7 +150,7 @@ static int ebook_switch_add(struct acpi_
 	return error;
 }
 
-static int ebook_switch_remove(struct acpi_device *device, int type)
+static int ebook_switch_remove(struct acpi_device *device)
 {
 	struct ebook_switch *button = acpi_driver_data(device);
 
Index: linux-pm/drivers/staging/quickstart/quickstart.c
===================================================================
--- linux-pm.orig/drivers/staging/quickstart/quickstart.c
+++ linux-pm/drivers/staging/quickstart/quickstart.c
@@ -296,7 +296,7 @@ fail_config:
 	return ret;
 }
 
-static int quickstart_acpi_remove(struct acpi_device *device, int type)
+static int quickstart_acpi_remove(struct acpi_device *device)
 {
 	acpi_status status;
 	struct quickstart_acpi *quickstart;
Index: linux-pm/drivers/video/backlight/apple_bl.c
===================================================================
--- linux-pm.orig/drivers/video/backlight/apple_bl.c
+++ linux-pm/drivers/video/backlight/apple_bl.c
@@ -196,7 +196,7 @@ static int apple_bl_add(struct acpi_devi
 	return 0;
 }
 
-static int apple_bl_remove(struct acpi_device *dev, int type)
+static int apple_bl_remove(struct acpi_device *dev)
 {
 	backlight_device_unregister(apple_backlight_device);
 
Index: linux-pm/drivers/xen/xen-acpi-pad.c
===================================================================
--- linux-pm.orig/drivers/xen/xen-acpi-pad.c
+++ linux-pm/drivers/xen/xen-acpi-pad.c
@@ -140,8 +140,7 @@ static int acpi_pad_add(struct acpi_devi
 	return 0;
 }
 
-static int acpi_pad_remove(struct acpi_device *device,
-	int type)
+static int acpi_pad_remove(struct acpi_device *device)
 {
 	mutex_lock(&xen_cpu_lock);
 	xen_acpi_pad_idle_cpus(0);

