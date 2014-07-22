Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaGVWH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:07:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62742 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756924AbaGVWH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:07:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the "freeze" sleep state
Date: Wed, 23 Jul 2014 00:26:20 +0200
Message-ID: <3271848.fNJ1rk2xTa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722121345.GC3935@laptop>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <2866134.Da8PQoU0sW@vostro.rjw.lan> <20140722121345.GC3935@laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2014 02:13:45 PM Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 02:23:03PM +0200, Rafael J. Wysocki wrote:
> > > Doesn't break, doesn't 'work' either.
> > 
> > This probably means that WoL on that machine is not ACPI-based.
> 
> Oh lovely, of course that's an 'option' !
> 
> > > Is there anything I can provide you with to make this easier? lspci output
> > > or anything like that?
> > 
> > Yes, /proc/interrupts from the machine in question would help to start with.
> 
> Be sure to get a _wide_ terminal when viewing ;-)

[cut]

OK, so the "PCIe PME" labels indicate that at least some devices on that system
use native PME signaling, in which case that's what is used for the WoL most
likely.

All of the counts below seem to be 0, though, so I'm not sure if they actually
work.  I guess we'll see. :-)

>   25:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
>   27:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
>   29:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
>   31:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
>   33:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
>   34:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      PCIe PME
>   35:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      PCIe PME

[cut]

> > Also /sys/kernel/debug/wakeup_sources (if /sys/kernel/debug/ is where your debugfs
> > lives) before
> 
> of course not, that's /debug :-)

[cut]

OK, there are several wakeup sources for ACPI devices added by one of the patches
you have tested in there:

> device:2a   	0		0		0		0		0		0		0		1802		0
> device:29   	0		0		0		0		0		0		0		1798		0
> device:10   	0		0		0		0		0		0		0		1763		0
> device:02   	0		0		0		0		0		0		0		1757		0
> device:00   	0		0		0		0		0		0		0		1746		0
> device:01   	0		0		0		0		0		0		0		1735		0
> device:15   	0		0		0		0		0		0		0		1730		0
> device:13   	0		0		0		0		0		0		0		1723		0
> device:12   	0		0		0		0		0		0		0		1718		0
> device:11   	0		0		0		0		0		0		0		1711		0
> device:1f   	0		0		0		0		0		0		0		1705		0
> device:1b   	0		0		0		0		0		0		0		1699		0
> device:19   	0		0		0		0		0		0		0		1693		0
> device:18   	0		0		0		0		0		0		0		1685		0
> device:16   	0		0		0		0		0		0		0		1678		0
> device:28   	0		0		0		0		0		0		0		1616		0
> device:26   	0		0		0		0		0		0		0		1612		0
> device:24   	0		0		0		0		0		0		0		1607		0
> device:22   	0		0		0		0		0		0		0		1602		0
> device:20   	0		0		0		0		0		0		0		1597		0

but since their counts are 0, there are no events signaled via ACPI.

All of that indicates that the machine in question has WoL based on native PCIe
PME signaling.  In that case it doesn't wake up from the "freeze" state, because
some code is missing.

The below is my idea about how to implement that code.

Register an additional wakeup source object for each PCIe PME service
device.  That object will be used to generate wakeups from the "freeze"
sleep state.

For each PCIe port with PME service during the "prepare" phase of
system suspend walk the bus below it and see if any devices on that
bus are configured for wakeup.  If so, mark the port as one that can
be used for system wakeup signaling and handle it differenty going
forward.

Namely, while suspending its PME service, do not disable the PME
interrupt, but configure that interrupt for system wakeup and set
a "suspended" flag for the PME service to make the interrupt handled
behave in a special way, which is to call __pm_wakeup_event() with
the service's wakeup source object as the first argument whenever the
interrupt is triggered.

The "suspended" flag is cleared while resuming the PME service and
the "wakeup" flag is cleared at the "complete" stage of system
resume.

Please check if the patch below makes any difference.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/pme.c          |   96 +++++++++++++++++++++++++++++++++++-----
 drivers/pci/pcie/portdrv.h      |    2 
 drivers/pci/pcie/portdrv_core.c |   45 ++++++++++++++++++
 drivers/pci/pcie/portdrv_pci.c  |    2 
 include/linux/pcieport_if.h     |    2 
 5 files changed, 134 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/pci/pcie/pme.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/pme.c
+++ linux-pm/drivers/pci/pcie/pme.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/pcieport_if.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeup.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -45,7 +46,9 @@ struct pcie_pme_service_data {
 	spinlock_t lock;
 	struct pcie_device *srv;
 	struct work_struct work;
-	bool noirq; /* Don't enable the PME interrupt used by this service. */
+	struct wakeup_source *ws;
+	bool suspended; /* The PME service has been suspended. */
+	bool wakeup; /* The PME interrupt is used for system wakeup. */
 };
 
 /**
@@ -223,7 +226,7 @@ static void pcie_pme_work_fn(struct work
 	spin_lock_irq(&data->lock);
 
 	for (;;) {
-		if (data->noirq)
+		if (data->suspended && !data->wakeup)
 			break;
 
 		pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
@@ -234,6 +237,11 @@ static void pcie_pme_work_fn(struct work
 			 */
 			pcie_clear_root_pme_status(port);
 
+			if (data->wakeup && data->suspended) {
+				__pm_wakeup_event(data->ws, 0);
+				break;
+			}
+
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
 			spin_lock_irq(&data->lock);
@@ -250,7 +258,7 @@ static void pcie_pme_work_fn(struct work
 		spin_lock_irq(&data->lock);
 	}
 
-	if (!data->noirq)
+	if (!data->suspended || data->wakeup)
 		pcie_pme_interrupt_enable(port, true);
 
 	spin_unlock_irq(&data->lock);
@@ -360,6 +368,7 @@ static int pcie_pme_probe(struct pcie_de
 	if (ret) {
 		kfree(data);
 	} else {
+		data->ws = wakeup_source_register(dev_name(&srv->device));
 		pcie_pme_mark_devices(port);
 		pcie_pme_interrupt_enable(port, true);
 	}
@@ -367,6 +376,43 @@ static int pcie_pme_probe(struct pcie_de
 	return ret;
 }
 
+static bool pcie_pme_check_wakeup(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	if (!bus)
+		return false;
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (device_may_wakeup(&dev->dev)
+		    || pcie_pme_check_wakeup(dev->subordinate))
+			return true;
+
+	return false;
+}
+
+/**
+ * pcie_pme_prepare - Prepare system PM transition for PCIe PME service device.
+ * @srv - PCIe service device to handle.
+ *
+ * Check if any devices below the port are configured for wakeup.  If so, set
+ * the service's wakeup flag.
+ */
+static int pcie_pme_prepare(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+	struct pci_dev *port = srv->port;
+
+	if (device_may_wakeup(&port->dev)) {
+		data->wakeup = true;
+	} else {
+		down_read(&pci_bus_sem);
+		data->wakeup = pcie_pme_check_wakeup(port->subordinate);
+		up_read(&pci_bus_sem);
+	}
+	return 0;
+}
+
 /**
  * pcie_pme_suspend - Suspend PCIe PME service device.
  * @srv: PCIe service device to suspend.
@@ -374,12 +420,17 @@ static int pcie_pme_probe(struct pcie_de
 static int pcie_pme_suspend(struct pcie_device *srv)
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
-	struct pci_dev *port = srv->port;
 
 	spin_lock_irq(&data->lock);
-	pcie_pme_interrupt_enable(port, false);
-	pcie_clear_root_pme_status(port);
-	data->noirq = true;
+	if (data->wakeup) {
+		enable_irq_wake(srv->irq);
+	} else {
+		struct pci_dev *port = srv->port;
+
+		pcie_pme_interrupt_enable(port, false);
+		pcie_clear_root_pme_status(port);
+	}
+	data->suspended = true;
 	spin_unlock_irq(&data->lock);
 
 	synchronize_irq(srv->irq);
@@ -394,26 +445,45 @@ static int pcie_pme_suspend(struct pcie_
 static int pcie_pme_resume(struct pcie_device *srv)
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
-	struct pci_dev *port = srv->port;
 
 	spin_lock_irq(&data->lock);
-	data->noirq = false;
-	pcie_clear_root_pme_status(port);
-	pcie_pme_interrupt_enable(port, true);
+	data->suspended = false;
+	if (data->wakeup) {
+		disable_irq_wake(srv->irq);
+	} else {
+		struct pci_dev *port = srv->port;
+
+		pcie_clear_root_pme_status(port);
+		pcie_pme_interrupt_enable(port, true);
+	}
 	spin_unlock_irq(&data->lock);
 
 	return 0;
 }
 
 /**
+ * pcie_pme_resume - Complete system PM transition for PCIe PME service device.
+ * @srv - PCIe service device to handle.
+ */
+static void pcie_pme_complete(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+
+	data->wakeup = false;
+}
+
+/**
  * pcie_pme_remove - Prepare PCIe PME service device for removal.
  * @srv - PCIe service device to remove.
  */
 static void pcie_pme_remove(struct pcie_device *srv)
 {
+	struct pcie_pme_service_data *data = get_service_data(srv);
+
 	pcie_pme_suspend(srv);
 	free_irq(srv->irq, srv);
-	kfree(get_service_data(srv));
+	wakeup_source_unregister(data->ws);
+	kfree(data);
 }
 
 static struct pcie_port_service_driver pcie_pme_driver = {
@@ -422,8 +492,10 @@ static struct pcie_port_service_driver p
 	.service	= PCIE_PORT_SERVICE_PME,
 
 	.probe		= pcie_pme_probe,
+	.prepare	= pcie_pme_prepare,
 	.suspend	= pcie_pme_suspend,
 	.resume		= pcie_pme_resume,
+	.complete	= pcie_pme_complete,
 	.remove		= pcie_pme_remove,
 };
 
Index: linux-pm/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-pm/drivers/pci/pcie/portdrv_core.c
@@ -413,6 +413,27 @@ error_disable:
 }
 
 #ifdef CONFIG_PM
+static int prepare_iter(struct device *dev, void *data)
+{
+	struct pcie_port_service_driver *service_driver;
+
+	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
+		service_driver = to_service_driver(dev->driver);
+		if (service_driver->prepare)
+			service_driver->prepare(to_pcie_device(dev));
+	}
+	return 0;
+}
+
+/**
+ * pcie_port_device_prepare - prepare PCIe port services for system suspend
+ * @dev: PCI Express port to handle
+ */
+int pcie_port_device_prepare(struct device *dev)
+{
+	return device_for_each_child(dev, NULL, prepare_iter);
+}
+
 static int suspend_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
@@ -448,13 +469,35 @@ static int resume_iter(struct device *de
 }
 
 /**
- * pcie_port_device_suspend - resume port services associated with a PCIe port
+ * pcie_port_device_resume - resume port services associated with a PCIe port
  * @dev: PCI Express port to handle
  */
 int pcie_port_device_resume(struct device *dev)
 {
 	return device_for_each_child(dev, NULL, resume_iter);
 }
+
+static int complete_iter(struct device *dev, void *data)
+{
+	struct pcie_port_service_driver *service_driver;
+
+	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
+		service_driver = to_service_driver(dev->driver);
+		if (service_driver->complete)
+			service_driver->complete(to_pcie_device(dev));
+	}
+	return 0;
+}
+
+/**
+ * pcie_port_device_complete - complete system resume for PCIe port services
+ * @dev: PCI Express port to handle
+ */
+void pcie_port_device_complete(struct device *dev)
+{
+	device_for_each_child(dev, NULL, complete_iter);
+}
+
 #endif /* PM */
 
 static int remove_iter(struct device *dev, void *data)
Index: linux-pm/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv.h
+++ linux-pm/drivers/pci/pcie/portdrv.h
@@ -23,8 +23,10 @@
 extern struct bus_type pcie_port_bus_type;
 int pcie_port_device_register(struct pci_dev *dev);
 #ifdef CONFIG_PM
+int pcie_port_device_prepare(struct device *dev);
 int pcie_port_device_suspend(struct device *dev);
 int pcie_port_device_resume(struct device *dev);
+void pcie_port_device_complete(struct device *dev);
 #endif
 void pcie_port_device_remove(struct pci_dev *dev);
 int __must_check pcie_port_bus_register(void);
Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-pm/drivers/pci/pcie/portdrv_pci.c
@@ -165,6 +165,8 @@ static int pcie_port_runtime_idle(struct
 #endif
 
 static const struct dev_pm_ops pcie_portdrv_pm_ops = {
+	.prepare	= pcie_port_device_prepare,
+	.complete	= pcie_port_device_complete,
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
 	.freeze		= pcie_port_device_suspend,
Index: linux-pm/include/linux/pcieport_if.h
===================================================================
--- linux-pm.orig/include/linux/pcieport_if.h
+++ linux-pm/include/linux/pcieport_if.h
@@ -45,8 +45,10 @@ struct pcie_port_service_driver {
 	const char *name;
 	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
+	int (*prepare) (struct pcie_device *dev);
 	int (*suspend) (struct pcie_device *dev);
 	int (*resume) (struct pcie_device *dev);
+	void (*complete) (struct pcie_device *dev);
 
 	/* Service Error Recovery Handler */
 	const struct pci_error_handlers *err_handler;

