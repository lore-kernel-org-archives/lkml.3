Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3HBSK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:10:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41246 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3HBSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:10:26 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Thomas Renninger <trenn@suse.de>, Hannes Reinecke <hare@suse.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ming Lei <ming.lei@canonical.com>,
        =?UTF-8?q?T=C3=BClin=20=C4=B0zer?= <tulinizer@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Julius Werner <jwerner@chromium.org>,
        Yuanhan Liu <yliu.null@gmail.com>,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] usb: fix some scripts/kernel-doc warnings
Date: Fri,  2 Aug 2013 20:10:04 +0200
Message-Id: <1375467004-2623-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
following type of warnings:

Warning(drivers/usb/core/usb.c:76): No description found for return value of
'usb_find_alt_setting'

Fix them by:
- adding some missing descriptions of return values
- using "Return" sections for those descriptions

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---

 Applied to b3a3a9c441e2c8f6b6760de9331023a7906a4ac6

 drivers/usb/core/buffer.c  |    5 ++--
 drivers/usb/core/driver.c  |   22 ++++++++++++++--
 drivers/usb/core/file.c    |    2 +-
 drivers/usb/core/hcd-pci.c |    2 ++
 drivers/usb/core/hcd.c     |   37 +++++++++++++++++++--------
 drivers/usb/core/hub.c     |   37 +++++++++++++++++++--------
 drivers/usb/core/message.c |   49 ++++++++++++++++++++----------------
 drivers/usb/core/urb.c     |   34 ++++++++++++++++---------
 drivers/usb/core/usb.c     |   60 +++++++++++++++++++++++++++-----------------
 include/linux/usb.h        |   12 ++++++---
 10 files changed, 173 insertions(+), 87 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index b0585e6..2355974 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -43,10 +43,11 @@ static const size_t	pool_max[HCD_BUFFER_POOLS] = {
  *
  * Call this as part of initializing a host controller that uses the dma
  * memory allocators.  It initializes some pools of dma-coherent memory that
- * will be shared by all drivers using that controller, or returns a negative
- * errno value on error.
+ * will be shared by all drivers using that controller.
  *
  * Call hcd_buffer_destroy() to clean up after using those pools.
+ *
+ * Return: 0 if successful. A negative errno value otherwise.
  */
 int hcd_buffer_create(struct usb_hcd *hcd)
 {
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 7609ac4..124bcc5 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -117,6 +117,8 @@ static DRIVER_ATTR(new_id, S_IRUGO | S_IWUSR, show_dynids, store_new_id);
  * @count: input size
  *
  * Removes a dynamic usb device ID from this driver.
+ *
+ * Return: @count on success. A negative error code otherwise.
  */
 static ssize_t
 store_remove_id(struct device_driver *driver, const char *buf, size_t count)
@@ -457,6 +459,8 @@ static int usb_unbind_interface(struct device *dev)
  * Callers must own the device lock, so driver probe() entries don't need
  * extra locking, but other call contexts may need to explicitly claim that
  * lock.
+ *
+ * Return: 0 on success.
  */
 int usb_driver_claim_interface(struct usb_driver *driver,
 				struct usb_interface *iface, void *priv)
@@ -658,6 +662,8 @@ EXPORT_SYMBOL_GPL(usb_match_one_id);
  * These device tables are exported with MODULE_DEVICE_TABLE, through
  * modutils, to support the driver loading functionality of USB hotplugging.
  *
+ * Return: The first matching usb_device_id, or %NULL.
+ *
  * What Matches:
  *
  * The "match_flags" element in a usb_device_id controls which
@@ -823,7 +829,8 @@ static int usb_uevent(struct device *dev, struct kobj_uevent_env *env)
  * Registers a USB device driver with the USB core.  The list of
  * unattached devices will be rescanned whenever a new driver is
  * added, allowing the new driver to attach to any recognized devices.
- * Returns a negative error code on failure and 0 on success.
+ *
+ * Return: A negative error code on failure and 0 on success.
  */
 int usb_register_device_driver(struct usb_device_driver *new_udriver,
 		struct module *owner)
@@ -879,7 +886,8 @@ EXPORT_SYMBOL_GPL(usb_deregister_device_driver);
  * Registers a USB interface driver with the USB core.  The list of
  * unattached interfaces will be rescanned whenever a new driver is
  * added, allowing the new driver to attach to any recognized interfaces.
- * Returns a negative error code on failure and 0 on success.
+ *
+ * Return: A negative error code on failure and 0 on success.
  *
  * NOTE: if you want your driver to use the USB major number, you must call
  * usb_register_dev() to enable that functionality.  This function no longer
@@ -1213,6 +1221,8 @@ done:
  * unpredictable times.
  *
  * This routine can run only in process context.
+ *
+ * Return: 0 if the suspend succeeded.
  */
 static int usb_suspend_both(struct usb_device *udev, pm_message_t msg)
 {
@@ -1294,6 +1304,8 @@ static int usb_suspend_both(struct usb_device *udev, pm_message_t msg)
  * unpredictable times.
  *
  * This routine can run only in process context.
+ *
+ * Return: 0 on success.
  */
 static int usb_resume_both(struct usb_device *udev, pm_message_t msg)
 {
@@ -1491,6 +1503,8 @@ void usb_autosuspend_device(struct usb_device *udev)
  * The caller must hold @udev's device lock.
  *
  * This routine can run only in process context.
+ *
+ * Return: 0 on success. A negative error code otherwise.
  */
 int usb_autoresume_device(struct usb_device *udev)
 {
@@ -1600,6 +1614,8 @@ EXPORT_SYMBOL_GPL(usb_autopm_put_interface_no_suspend);
  * However if the autoresume fails then the counter is re-decremented.
  *
  * This routine can run only in process context.
+ *
+ * Return: 0 on success.
  */
 int usb_autopm_get_interface(struct usb_interface *intf)
 {
@@ -1633,6 +1649,8 @@ EXPORT_SYMBOL_GPL(usb_autopm_get_interface);
  * resumed.
  *
  * This routine can run in atomic context.
+ *
+ * Return: 0 on success. A negative error code otherwise.
  */
 int usb_autopm_get_interface_async(struct usb_interface *intf)
 {
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 6a4c407..7421888 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -153,7 +153,7 @@ void usb_major_cleanup(void)
  * usb_deregister_dev() must be called when the driver is done with
  * the minor numbers given out by this function.
  *
- * Returns -EINVAL if something bad happens with trying to register a
+ * Return: -EINVAL if something bad happens with trying to register a
  * device, and 0 on success.
  */
 int usb_register_dev(struct usb_interface *intf,
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index caeb8d6..b9d3c43 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -171,6 +171,8 @@ static void ehci_wait_for_companions(struct pci_dev *pdev, struct usb_hcd *hcd,
  * through the hotplug entry's driver_data.
  *
  * Store this function in the HCD's struct pci_driver as probe().
+ *
+ * Return: 0 if successful.
  */
 int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 014dc99..dc1346f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -378,9 +378,10 @@ MODULE_PARM_DESC(authorized_default,
  * @buf: Buffer for USB string descriptor (header + UTF-16LE)
  * @len: Length (in bytes; may be odd) of descriptor buffer.
  *
- * The return value is the number of bytes filled in: 2 + 2*strlen(s) or
- * buflen, whichever is less.
+ * Return: The number of bytes filled in: 2 + 2*strlen(s) or @len,
+ * whichever is less.
  *
+ * Note:
  * USB String descriptors can contain at most 126 characters; input
  * strings longer than that are truncated.
  */
@@ -416,7 +417,8 @@ ascii2desc(char const *s, u8 *buf, unsigned len)
  *
  * Produces either a manufacturer, product or serial number string for the
  * virtual root hub device.
- * Returns the number of bytes filled in: the length of the descriptor or
+ *
+ * Return: The number of bytes filled in: the length of the descriptor or
  * of the provided buffer, whichever is less.
  */
 static unsigned
@@ -938,6 +940,8 @@ static void usb_bus_init (struct usb_bus *bus)
  *
  * Assigns a bus number, and links the controller into usbcore data
  * structures so that it can be seen by scanning the bus list.
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 static int usb_register_bus(struct usb_bus *bus)
 {
@@ -1002,6 +1006,8 @@ static void usb_deregister_bus (struct usb_bus *bus)
  * the device properly in the device tree and then calls usb_new_device()
  * to register the usb device.  It also assigns the root hub's USB address
  * (always 1).
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 static int register_root_hub(struct usb_hcd *hcd)
 {
@@ -1108,7 +1114,9 @@ EXPORT_SYMBOL_GPL(usb_hcd_end_port_resume);
  * @isoc: true for isochronous transactions, false for interrupt ones
  * @bytecount: how many bytes in the transaction.
  *
- * Returns approximate bus time in nanoseconds for a periodic transaction.
+ * Return: Approximate bus time in nanoseconds for a periodic transaction.
+ *
+ * Note:
  * See USB 2.0 spec section 5.11.3; only periodic transfers need to be
  * scheduled in software, this function is only used for such scheduling.
  */
@@ -1166,7 +1174,7 @@ EXPORT_SYMBOL_GPL(usb_calc_bus_time);
  * be disabled.  The actions carried out here are required for URB
  * submission, as well as for endpoint shutdown and for usb_kill_urb.
  *
- * Returns 0 for no error, otherwise a negative error code (in which case
+ * Return: 0 for no error, otherwise a negative error code (in which case
  * the enqueue() method must fail).  If no error occurs but enqueue() fails
  * anyway, it must call usb_hcd_unlink_urb_from_ep() before releasing
  * the private spinlock and returning.
@@ -1221,7 +1229,7 @@ EXPORT_SYMBOL_GPL(usb_hcd_link_urb_to_ep);
  * be disabled.  The actions carried out here are required for making
  * sure than an unlink is valid.
  *
- * Returns 0 for no error, otherwise a negative error code (in which case
+ * Return: 0 for no error, otherwise a negative error code (in which case
  * the dequeue() method must fail).  The possible error codes are:
  *
  *	-EIDRM: @urb was not submitted or has already completed.
@@ -1784,7 +1792,7 @@ rescan:
  * pass in the current alternate interface setting in cur_alt,
  * and pass in the new alternate interface setting in new_alt.
  *
- * Returns an error if the requested bandwidth change exceeds the
+ * Return: An error if the requested bandwidth change exceeds the
  * bus bandwidth or host controller internal resources.
  */
 int usb_hcd_alloc_bandwidth(struct usb_device *udev,
@@ -1954,9 +1962,12 @@ void usb_hcd_reset_endpoint(struct usb_device *udev,
  * @num_streams:	number of streams to allocate.
  * @mem_flags:		flags hcd should use to allocate memory.
  *
- * Sets up a group of bulk endpoints to have num_streams stream IDs available.
+ * Sets up a group of bulk endpoints to have @num_streams stream IDs available.
  * Drivers may queue multiple transfers to different stream IDs, which may
  * complete in a different order than they were queued.
+ *
+ * Return: On success, the number of allocated streams. On failure, a negative
+ * error code.
  */
 int usb_alloc_streams(struct usb_interface *interface,
 		struct usb_host_endpoint **eps, unsigned int num_eps,
@@ -2201,6 +2212,8 @@ EXPORT_SYMBOL_GPL(usb_hcd_resume_root_hub);
  * khubd identifying and possibly configuring the device.
  * This is needed by OTG controller drivers, where it helps meet
  * HNP protocol timing requirements for starting a port reset.
+ *
+ * Return: 0 if successful.
  */
 int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num)
 {
@@ -2235,6 +2248,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
  *
  * If the controller isn't HALTed, calls the driver's irq handler.
  * Checks whether the controller is now dead.
+ *
+ * Return: %IRQ_HANDLED if the IRQ was handled. %IRQ_NONE otherwise.
  */
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
@@ -2320,7 +2335,8 @@ EXPORT_SYMBOL_GPL (usb_hc_died);
  * HC driver's private data.  Initialize the generic members of the
  * hcd structure.
  *
- * If memory is unavailable, returns NULL.
+ * Return: On success, a pointer to the created and initialized HCD structure.
+ * On failure (e.g. if memory is unavailable), %NULL.
  */
 struct usb_hcd *usb_create_shared_hcd(const struct hc_driver *driver,
 		struct device *dev, const char *bus_name,
@@ -2384,7 +2400,8 @@ EXPORT_SYMBOL_GPL(usb_create_shared_hcd);
  * HC driver's private data.  Initialize the generic members of the
  * hcd structure.
  *
- * If memory is unavailable, returns NULL.
+ * Return: On success, a pointer to the created and initialized HCD
+ * structure. On failure (e.g. if memory is unavailable), %NULL.
  */
 struct usb_hcd *usb_create_hcd(const struct hc_driver *driver,
 		struct device *dev, const char *bus_name)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 4191db3..b22cbf8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -725,6 +725,8 @@ static void hub_tt_work(struct work_struct *work)
  *
  * call this function to control port's power via setting or
  * clearing the port's PORT_POWER feature.
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 int usb_hub_set_port_power(struct usb_device *hdev, struct usb_hub *hub,
 			   int port1, bool set)
@@ -753,6 +755,8 @@ int usb_hub_set_port_power(struct usb_device *hdev, struct usb_hub *hub,
  *
  * It may not be possible for that hub to handle additional full (or low)
  * speed transactions until that state is fully cleared out.
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 int usb_hub_clear_tt_buffer(struct urb *urb)
 {
@@ -955,6 +959,8 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
  * see that the device has been disconnected.  When the device is
  * physically unplugged and something is plugged in, the events will
  * be received and processed normally.
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 int usb_remove_device(struct usb_device *udev)
 {
@@ -2107,6 +2113,8 @@ static inline void announce_device(struct usb_device *udev) { }
  * @udev: newly addressed device (in ADDRESS state)
  *
  * Finish enumeration for On-The-Go devices
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 static int usb_enumerate_device_otg(struct usb_device *udev)
 {
@@ -2189,6 +2197,8 @@ fail:
  * If the device is WUSB and not authorized, we don't attempt to read
  * the string descriptors, as they will be errored out by the device
  * until it has been authorized.
+ *
+ * Return: 0 if successful. A negative error code otherwise.
  */
 static int usb_enumerate_device(struct usb_device *udev)
 {
@@ -2269,13 +2279,14 @@ static void set_usb_port_removable(struct usb_device *udev)
  * udev has already been installed, but udev is not yet visible through
  * sysfs or other filesystem code.
  *
- * It will return if the device is configured properly or not.  Zero if
- * the interface was registered with the driver core; else a negative
- * errno value.
- *
  * This call is synchronous, and may not be used in an interrupt context.
  *
  * Only the hub driver or root-hub registrar should ever call this.
+ *
+ * Return: Whether the device is configured properly or not. Zero if the
+ * interface was registered with the driver core; else a negative errno
+ * value.
+ *
  */
 int usb_new_device(struct usb_device *udev)
 {
@@ -2383,6 +2394,8 @@ fail:
  *
  * We share a lock (that we have) with device_del(), so we need to
  * defer its call.
+ *
+ * Return: 0.
  */
 int usb_deauthorize_device(struct usb_device *usb_dev)
 {
@@ -5002,10 +5015,11 @@ static int descriptors_changed(struct usb_device *udev,
  * re-connected.  All drivers will be unbound, and the device will be
  * re-enumerated and probed all over again.
  *
- * Returns 0 if the reset succeeded, -ENODEV if the device has been
+ * Return: 0 if the reset succeeded, -ENODEV if the device has been
  * flagged for logical disconnection, or some other negative error code
  * if the reset wasn't even attempted.
  *
+ * Note:
  * The caller must own the device lock.  For example, it's safe to use
  * this from a driver probe() routine after downloading new firmware.
  * For calls that might not occur during probe(), drivers should lock
@@ -5161,8 +5175,9 @@ re_enumerate:
  * method), performs the port reset, and then lets the drivers know that
  * the reset is over (using their post_reset method).
  *
- * Return value is the same as for usb_reset_and_verify_device().
+ * Return: The same as for usb_reset_and_verify_device().
  *
+ * Note:
  * The caller must own the device lock.  For example, it's safe to use
  * this from a driver probe() routine after downloading new firmware.
  * For calls that might not occur during probe(), drivers should lock
@@ -5300,7 +5315,7 @@ EXPORT_SYMBOL_GPL(usb_queue_reset_device);
  * USB drivers call this function to get hub's child device
  * pointer.
  *
- * Return NULL if input param is invalid and
+ * Return: %NULL if input param is invalid and
  * child's usb_device pointer if non-NULL.
  */
 struct usb_device *usb_hub_find_child(struct usb_device *hdev,
@@ -5334,8 +5349,8 @@ void usb_set_hub_port_connect_type(struct usb_device *hdev, int port1,
  * @hdev: USB device belonging to the usb hub
  * @port1: port num of the port
  *
- * Return connect type of the port and if input params are
- * invalid, return USB_PORT_CONNECT_TYPE_UNKNOWN.
+ * Return: The connect type of the port if successful. Or
+ * USB_PORT_CONNECT_TYPE_UNKNOWN if input params are invalid.
  */
 enum usb_port_connect_type
 usb_get_hub_port_connect_type(struct usb_device *hdev, int port1)
@@ -5395,8 +5410,8 @@ void usb_hub_adjust_deviceremovable(struct usb_device *hdev,
  * @hdev: USB device belonging to the usb hub
  * @port1: port num of the port
  *
- * Return port's acpi handle if successful, NULL if params are
- * invaild.
+ * Return: Port's acpi handle if successful, %NULL if params are
+ * invalid.
  */
 acpi_handle usb_get_hub_port_acpi_handle(struct usb_device *hdev,
 	int port1)
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index e7ee1e4..d2bc45b 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -119,15 +119,15 @@ static int usb_internal_control_msg(struct usb_device *usb_dev,
  * This function sends a simple control message to a specified endpoint and
  * waits for the message to complete, or timeout.
  *
- * If successful, it returns the number of bytes transferred, otherwise a
- * negative error number.
- *
  * Don't use this function from within an interrupt context, like a bottom half
  * handler.  If you need an asynchronous message, or need to send a message
  * from within interrupt context, use usb_submit_urb().
  * If a thread in your driver uses this call, make sure your disconnect()
  * method can wait for it to complete.  Since you don't have a handle on the
  * URB used, you can't cancel the request.
+ *
+ * Return: If successful, the number of bytes transferred. Otherwise, a negative
+ * error number.
  */
 int usb_control_msg(struct usb_device *dev, unsigned int pipe, __u8 request,
 		    __u8 requesttype, __u16 value, __u16 index, void *data,
@@ -170,15 +170,16 @@ EXPORT_SYMBOL_GPL(usb_control_msg);
  * This function sends a simple interrupt message to a specified endpoint and
  * waits for the message to complete, or timeout.
  *
- * If successful, it returns 0, otherwise a negative error number.  The number
- * of actual bytes transferred will be stored in the actual_length paramater.
- *
  * Don't use this function from within an interrupt context, like a bottom half
  * handler.  If you need an asynchronous message, or need to send a message
  * from within interrupt context, use usb_submit_urb() If a thread in your
  * driver uses this call, make sure your disconnect() method can wait for it to
  * complete.  Since you don't have a handle on the URB used, you can't cancel
  * the request.
+ *
+ * Return:
+ * If successful, 0. Otherwise a negative error number. The number of actual
+ * bytes transferred will be stored in the @actual_length paramater.
  */
 int usb_interrupt_msg(struct usb_device *usb_dev, unsigned int pipe,
 		      void *data, int len, int *actual_length, int timeout)
@@ -203,9 +204,6 @@ EXPORT_SYMBOL_GPL(usb_interrupt_msg);
  * This function sends a simple bulk message to a specified endpoint
  * and waits for the message to complete, or timeout.
  *
- * If successful, it returns 0, otherwise a negative error number.  The number
- * of actual bytes transferred will be stored in the actual_length paramater.
- *
  * Don't use this function from within an interrupt context, like a bottom half
  * handler.  If you need an asynchronous message, or need to send a message
  * from within interrupt context, use usb_submit_urb() If a thread in your
@@ -217,6 +215,11 @@ EXPORT_SYMBOL_GPL(usb_interrupt_msg);
  * users are forced to abuse this routine by using it to submit URBs for
  * interrupt endpoints.  We will take the liberty of creating an interrupt URB
  * (with the default interval) if the target is an interrupt endpoint.
+ *
+ * Return:
+ * If successful, 0. Otherwise a negative error number. The number of actual
+ * bytes transferred will be stored in the @actual_length paramater.
+ *
  */
 int usb_bulk_msg(struct usb_device *usb_dev, unsigned int pipe,
 		 void *data, int len, int *actual_length, int timeout)
@@ -341,9 +344,9 @@ static void sg_complete(struct urb *urb)
  * 	send every byte identified in the list.
  * @mem_flags: SLAB_* flags affecting memory allocations in this call
  *
- * Returns zero for success, else a negative errno value.  This initializes a
- * scatter/gather request, allocating resources such as I/O mappings and urb
- * memory (except maybe memory used by USB controller drivers).
+ * This initializes a scatter/gather request, allocating resources such as
+ * I/O mappings and urb memory (except maybe memory used by USB controller
+ * drivers).
  *
  * The request must be issued using usb_sg_wait(), which waits for the I/O to
  * complete (or to be canceled) and then cleans up all resources allocated by
@@ -351,6 +354,8 @@ static void sg_complete(struct urb *urb)
  *
  * The request may be canceled with usb_sg_cancel(), either before or after
  * usb_sg_wait() is called.
+ *
+ * Return: Zero for success, else a negative errno value.
  */
 int usb_sg_init(struct usb_sg_request *io, struct usb_device *dev,
 		unsigned pipe, unsigned	period, struct scatterlist *sg,
@@ -623,7 +628,7 @@ EXPORT_SYMBOL_GPL(usb_sg_cancel);
  *
  * This call is synchronous, and may not be used in an interrupt context.
  *
- * Returns the number of bytes received on success, or else the status code
+ * Return: The number of bytes received on success, or else the status code
  * returned by the underlying usb_control_msg() call.
  */
 int usb_get_descriptor(struct usb_device *dev, unsigned char type,
@@ -671,7 +676,7 @@ EXPORT_SYMBOL_GPL(usb_get_descriptor);
  *
  * This call is synchronous, and may not be used in an interrupt context.
  *
- * Returns the number of bytes received on success, or else the status code
+ * Return: The number of bytes received on success, or else the status code
  * returned by the underlying usb_control_msg() call.
  */
 static int usb_get_string(struct usb_device *dev, unsigned short langid,
@@ -805,7 +810,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
  *
  * This call is synchronous, and may not be used in an interrupt context.
  *
- * Returns length of the string (>= 0) or usb_control_msg status (< 0).
+ * Return: length of the string (>= 0) or usb_control_msg status (< 0).
  */
 int usb_string(struct usb_device *dev, int index, char *buf, size_t size)
 {
@@ -853,8 +858,8 @@ EXPORT_SYMBOL_GPL(usb_string);
  * @udev: the device whose string descriptor is being read
  * @index: the descriptor index
  *
- * Returns a pointer to a kmalloc'ed buffer containing the descriptor string,
- * or NULL if the index is 0 or the string could not be read.
+ * Return: A pointer to a kmalloc'ed buffer containing the descriptor string,
+ * or %NULL if the index is 0 or the string could not be read.
  */
 char *usb_cache_string(struct usb_device *udev, int index)
 {
@@ -934,7 +939,7 @@ int usb_get_device_descriptor(struct usb_device *dev, unsigned int size)
  *
  * This call is synchronous, and may not be used in an interrupt context.
  *
- * Returns the number of bytes received on success, or else the status code
+ * Return: The number of bytes received on success, or else the status code
  * returned by the underlying usb_control_msg() call.
  */
 int usb_get_status(struct usb_device *dev, int type, int target, void *data)
@@ -975,7 +980,7 @@ EXPORT_SYMBOL_GPL(usb_get_status);
  *
  * This call is synchronous, and may not be used in an interrupt context.
  *
- * Returns zero on success, or else the status code returned by the
+ * Return: Zero on success, or else the status code returned by the
  * underlying usb_control_msg() call.
  */
 int usb_clear_halt(struct usb_device *dev, int pipe)
@@ -1272,7 +1277,7 @@ void usb_enable_interface(struct usb_device *dev,
  * endpoints in that interface; all such urbs must first be completed
  * (perhaps forced by unlinking).
  *
- * Returns zero on success, or else the status code returned by the
+ * Return: Zero on success, or else the status code returned by the
  * underlying usb_control_msg() call.
  */
 int usb_set_interface(struct usb_device *dev, int interface, int alternate)
@@ -1426,7 +1431,7 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
  *
  * The caller must own the device lock.
  *
- * Returns zero on success, else a negative error code.
+ * Return: Zero on success, else a negative error code.
  */
 int usb_reset_configuration(struct usb_device *dev)
 {
@@ -1968,7 +1973,7 @@ static void cancel_async_set_config(struct usb_device *udev)
  * routine gets around the normal restrictions by using a work thread to
  * submit the change-config request.
  *
- * Returns 0 if the request was successfully queued, error code otherwise.
+ * Return: 0 if the request was successfully queued, error code otherwise.
  * The caller has no way to know whether the queued request will eventually
  * succeed.
  */
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 16927fa..e88a99f 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -54,12 +54,12 @@ EXPORT_SYMBOL_GPL(usb_init_urb);
  * Creates an urb for the USB driver to use, initializes a few internal
  * structures, incrementes the usage counter, and returns a pointer to it.
  *
- * If no memory is available, NULL is returned.
- *
  * If the driver want to use this urb for interrupt, control, or bulk
  * endpoints, pass '0' as the number of iso packets.
  *
  * The driver must call usb_free_urb() when it is finished with the urb.
+ *
+ * Return: A pointer to the new urb, or %NULL if no memory is available.
  */
 struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags)
 {
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(usb_free_urb);
  * host controller driver.  This allows proper reference counting to happen
  * for urbs.
  *
- * A pointer to the urb with the incremented reference counter is returned.
+ * Return: A pointer to the urb with the incremented reference counter.
  */
 struct urb *usb_get_urb(struct urb *urb)
 {
@@ -199,13 +199,12 @@ EXPORT_SYMBOL_GPL(usb_unanchor_urb);
  * the particular kind of transfer, although they will not initialize
  * any transfer flags.
  *
- * Successful submissions return 0; otherwise this routine returns a
- * negative error number.  If the submission is successful, the complete()
- * callback from the URB will be called exactly once, when the USB core and
- * Host Controller Driver (HCD) are finished with the URB.  When the completion
- * function is called, control of the URB is returned to the device
- * driver which issued the request.  The completion handler may then
- * immediately free or reuse that URB.
+ * If the submission is successful, the complete() callback from the URB
+ * will be called exactly once, when the USB core and Host Controller Driver
+ * (HCD) are finished with the URB.  When the completion function is called,
+ * control of the URB is returned to the device driver which issued the
+ * request.  The completion handler may then immediately free or reuse that
+ * URB.
  *
  * With few exceptions, USB device drivers should never access URB fields
  * provided by usbcore or the HCD until its complete() is called.
@@ -240,6 +239,9 @@ EXPORT_SYMBOL_GPL(usb_unanchor_urb);
  * that are standardized in the USB 2.0 specification.  For bulk
  * endpoints, a synchronous usb_bulk_msg() call is available.
  *
+ * Return:
+ * 0 on successful submissions. A negative error number otherwise.
+ *
  * Request Queuing:
  *
  * URBs may be submitted to endpoints before previous ones complete, to
@@ -564,6 +566,9 @@ EXPORT_SYMBOL_GPL(usb_submit_urb);
  * particular, when a driver calls this routine, it must insure that the
  * completion handler cannot deallocate the URB.
  *
+ * Return: -EINPROGRESS on success. See description for other values on
+ * failure.
+ *
  * Unlinking and Endpoint Queues:
  *
  * [The behaviors and guarantees described below do not apply to virtual
@@ -838,6 +843,8 @@ EXPORT_SYMBOL_GPL(usb_unlink_anchored_urbs);
  *
  * Call this is you want to be sure all an anchor's
  * URBs have finished
+ *
+ * Return: Non-zero if the anchor became unused. Zero on timeout.
  */
 int usb_wait_anchor_empty_timeout(struct usb_anchor *anchor,
 				  unsigned int timeout)
@@ -851,8 +858,11 @@ EXPORT_SYMBOL_GPL(usb_wait_anchor_empty_timeout);
  * usb_get_from_anchor - get an anchor's oldest urb
  * @anchor: the anchor whose urb you want
  *
- * this will take the oldest urb from an anchor,
+ * This will take the oldest urb from an anchor,
  * unanchor and return it
+ *
+ * Return: The oldest urb from @anchor, or %NULL if @anchor has no
+ * urbs associated with it.
  */
 struct urb *usb_get_from_anchor(struct usb_anchor *anchor)
 {
@@ -901,7 +911,7 @@ EXPORT_SYMBOL_GPL(usb_scuttle_anchored_urbs);
  * usb_anchor_empty - is an anchor empty
  * @anchor: the anchor you want to query
  *
- * returns 1 if the anchor has no urbs associated with it
+ * Return: 1 if the anchor has no urbs associated with it.
  */
 int usb_anchor_empty(struct usb_anchor *anchor)
 {
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 7dad603..0a6ee2e 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -68,6 +68,8 @@ MODULE_PARM_DESC(autosuspend, "default autosuspend delay");
  * @alt_num: alternate interface setting number to search for.
  *
  * Search the configuration's interface cache for the given alt setting.
+ *
+ * Return: The alternate setting, if found. %NULL otherwise.
  */
 struct usb_host_interface *usb_find_alt_setting(
 		struct usb_host_config *config,
@@ -103,8 +105,7 @@ EXPORT_SYMBOL_GPL(usb_find_alt_setting);
  * @ifnum: the desired interface
  *
  * This walks the device descriptor for the currently active configuration
- * and returns a pointer to the interface with that particular interface
- * number, or null.
+ * to find the interface object with the particular interface number.
  *
  * Note that configuration descriptors are not required to assign interface
  * numbers sequentially, so that it would be incorrect to assume that
@@ -115,6 +116,9 @@ EXPORT_SYMBOL_GPL(usb_find_alt_setting);
  *
  * Don't call this function unless you are bound to one of the interfaces
  * on this device or you have locked the device!
+ *
+ * Return: A pointer to the interface that has @ifnum as interface number,
+ * if found. %NULL otherwise.
  */
 struct usb_interface *usb_ifnum_to_if(const struct usb_device *dev,
 				      unsigned ifnum)
@@ -139,8 +143,7 @@ EXPORT_SYMBOL_GPL(usb_ifnum_to_if);
  * @altnum: the desired alternate setting number
  *
  * This searches the altsetting array of the specified interface for
- * an entry with the correct bAlternateSetting value and returns a pointer
- * to that entry, or null.
+ * an entry with the correct bAlternateSetting value.
  *
  * Note that altsettings need not be stored sequentially by number, so
  * it would be incorrect to assume that the first altsetting entry in
@@ -149,6 +152,9 @@ EXPORT_SYMBOL_GPL(usb_ifnum_to_if);
  *
  * Don't call this function unless you are bound to the intf interface
  * or you have locked the device!
+ *
+ * Return: A pointer to the entry of the altsetting array of @intf that
+ * has @altnum as the alternate setting number. %NULL if not found.
  */
 struct usb_host_interface *usb_altnum_to_altsetting(
 					const struct usb_interface *intf,
@@ -191,6 +197,8 @@ static int __find_interface(struct device *dev, void *data)
  * This walks the bus device list and returns a pointer to the interface
  * with the matching minor and driver.  Note, this only works for devices
  * that share the USB major number.
+ *
+ * Return: A pointer to the interface with the matching major and @minor.
  */
 struct usb_interface *usb_find_interface(struct usb_driver *drv, int minor)
 {
@@ -390,6 +398,9 @@ static unsigned usb_bus_is_wusb(struct usb_bus *bus)
  * controllers) should ever call this.
  *
  * This call may not be used in a non-sleeping context.
+ *
+ * Return: On success, a pointer to the allocated usb device. %NULL on
+ * failure.
  */
 struct usb_device *usb_alloc_dev(struct usb_device *parent,
 				 struct usb_bus *bus, unsigned port1)
@@ -501,7 +512,7 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
  * their probe() methods, when they bind to an interface, and release
  * them by calling usb_put_dev(), in their disconnect() methods.
  *
- * A pointer to the device with the incremented reference counter is returned.
+ * Return: A pointer to the device with the incremented reference counter.
  */
 struct usb_device *usb_get_dev(struct usb_device *dev)
 {
@@ -535,8 +546,7 @@ EXPORT_SYMBOL_GPL(usb_put_dev);
  * their probe() methods, when they bind to an interface, and release
  * them by calling usb_put_intf(), in their disconnect() methods.
  *
- * A pointer to the interface with the incremented reference counter is
- * returned.
+ * Return: A pointer to the interface with the incremented reference counter.
  */
 struct usb_interface *usb_get_intf(struct usb_interface *intf)
 {
@@ -589,7 +599,7 @@ EXPORT_SYMBOL_GPL(usb_put_intf);
  * disconnect; in some drivers (such as usb-storage) the disconnect()
  * or suspend() method will block waiting for a device reset to complete.
  *
- * Returns a negative error code for failure, otherwise 0.
+ * Return: A negative error code for failure, otherwise 0.
  */
 int usb_lock_device_for_reset(struct usb_device *udev,
 			      const struct usb_interface *iface)
@@ -628,14 +638,15 @@ EXPORT_SYMBOL_GPL(usb_lock_device_for_reset);
  * usb_get_current_frame_number - return current bus frame number
  * @dev: the device whose bus is being queried
  *
- * Returns the current frame number for the USB host controller
- * used with the given USB device.  This can be used when scheduling
+ * Return: The current frame number for the USB host controller used
+ * with the given USB device. This can be used when scheduling
  * isochronous requests.
  *
- * Note that different kinds of host controller have different
- * "scheduling horizons".  While one type might support scheduling only
- * 32 frames into the future, others could support scheduling up to
- * 1024 frames into the future.
+ * Note: Different kinds of host controller have different "scheduling
+ * horizons". While one type might support scheduling only 32 frames
+ * into the future, others could support scheduling up to 1024 frames
+ * into the future.
+ *
  */
 int usb_get_current_frame_number(struct usb_device *dev)
 {
@@ -685,11 +696,12 @@ EXPORT_SYMBOL_GPL(__usb_get_extra_descriptor);
  * @mem_flags: affect whether allocation may block
  * @dma: used to return DMA address of buffer
  *
- * Return value is either null (indicating no buffer could be allocated), or
- * the cpu-space pointer to a buffer that may be used to perform DMA to the
+ * Return: Either null (indicating no buffer could be allocated), or the
+ * cpu-space pointer to a buffer that may be used to perform DMA to the
  * specified device.  Such cpu-space buffers are returned along with the DMA
  * address (through the pointer provided).
  *
+ * Note:
  * These buffers are used with URB_NO_xxx_DMA_MAP set in urb->transfer_flags
  * to avoid behaviors like using "DMA bounce buffers", or thrashing IOMMU
  * hardware during URB completion/resubmit.  The implementation varies between
@@ -735,17 +747,18 @@ EXPORT_SYMBOL_GPL(usb_free_coherent);
  * usb_buffer_map - create DMA mapping(s) for an urb
  * @urb: urb whose transfer_buffer/setup_packet will be mapped
  *
- * Return value is either null (indicating no buffer could be mapped), or
- * the parameter.  URB_NO_TRANSFER_DMA_MAP is
- * added to urb->transfer_flags if the operation succeeds.  If the device
- * is connected to this system through a non-DMA controller, this operation
- * always succeeds.
+ * URB_NO_TRANSFER_DMA_MAP is added to urb->transfer_flags if the operation
+ * succeeds. If the device is connected to this system through a non-DMA
+ * controller, this operation always succeeds.
  *
  * This call would normally be used for an urb which is reused, perhaps
  * as the target of a large periodic transfer, with usb_buffer_dmasync()
  * calls to synchronize memory and dma state.
  *
  * Reverse the effect of this call with usb_buffer_unmap().
+ *
+ * Return: Either %NULL (indicating no buffer could be mapped), or @urb.
+ *
  */
 #if 0
 struct urb *usb_buffer_map(struct urb *urb)
@@ -850,9 +863,10 @@ EXPORT_SYMBOL_GPL(usb_buffer_unmap);
  * @sg: the scatterlist to map
  * @nents: the number of entries in the scatterlist
  *
- * Return value is either < 0 (indicating no buffers could be mapped), or
- * the number of DMA mapping array entries in the scatterlist.
+ * Return: Either < 0 (indicating no buffers could be mapped), or the
+ * number of DMA mapping array entries in the scatterlist.
  *
+ * Note:
  * The caller is responsible for placing the resulting DMA addresses from
  * the scatterlist into URB transfer buffer pointers, and for setting the
  * URB_NO_TRANSFER_DMA_MAP transfer flag in each of those URBs.
diff --git a/include/linux/usb.h b/include/linux/usb.h
index a232b7e..9fd0111 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -719,7 +719,10 @@ extern int usb_driver_claim_interface(struct usb_driver *driver,
  * usb_interface_claimed - returns true iff an interface is claimed
  * @iface: the interface being checked
  *
- * Returns true (nonzero) iff the interface is claimed, else false (zero).
+ * Return: %true (nonzero) iff the interface is claimed, else %false
+ * (zero).
+ *
+ * Note:
  * Callers must own the driver model's usb bus readlock.  So driver
  * probe() entries don't need extra locking, but other call contexts
  * may need to explicitly claim that lock.
@@ -756,8 +759,9 @@ extern struct usb_host_interface *usb_find_alt_setting(
  * @buf: where to put the string
  * @size: how big is "buf"?
  *
- * Returns length of the string (> 0) or negative if size was too small.
+ * Return: Length of the string (> 0) or negative if size was too small.
  *
+ * Note:
  * This identifier is intended to be "stable", reflecting physical paths in
  * hardware such as physical bus addresses for host controllers or ports on
  * USB hubs.  That makes it stay the same until systems are physically
@@ -1581,7 +1585,7 @@ extern int usb_anchor_empty(struct usb_anchor *anchor);
  * usb_urb_dir_in - check if an URB describes an IN transfer
  * @urb: URB to be checked
  *
- * Returns 1 if @urb describes an IN transfer (device-to-host),
+ * Return: 1 if @urb describes an IN transfer (device-to-host),
  * otherwise 0.
  */
 static inline int usb_urb_dir_in(struct urb *urb)
@@ -1593,7 +1597,7 @@ static inline int usb_urb_dir_in(struct urb *urb)
  * usb_urb_dir_out - check if an URB describes an OUT transfer
  * @urb: URB to be checked
  *
- * Returns 1 if @urb describes an OUT transfer (host-to-device),
+ * Return: 1 if @urb describes an OUT transfer (host-to-device),
  * otherwise 0.
  */
 static inline int usb_urb_dir_out(struct urb *urb)
-- 
1.7.10.4

