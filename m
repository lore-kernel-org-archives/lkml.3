Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaAUKdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:33:45 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57193 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaAUKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:33:42 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] tty: uartps: Fix kernel-doc errors in the driver
Date: Tue, 21 Jan 2014 11:33:10 +0100
Message-Id: <7d0c02bf2d7eb816eb505d04c3800112805e2b62.1390300383.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-13087-1390300391-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-13087-1390300391-0001

No functional changes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
./scripts/kernel-doc -v -man drivers/tty/serial/xilinx_uartps.c > /dev/null
---
 drivers/tty/serial/xilinx_uartps.c | 109 +++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 60 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index f619ad5..b2f929e 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -163,11 +163,11 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");

 /**
  * struct xuartps - device data
- * @port		Pointer to the UART port
- * @refclk		Reference clock
- * @aperclk		APB clock
- * @baud		Current baud rate
- * @clk_rate_change_nb	Notifier block for clock changes
+ * @port:		Pointer to the UART port
+ * @refclk:		Reference clock
+ * @aperclk:		APB clock
+ * @baud:		Current baud rate
+ * @clk_rate_change_nb:	Notifier block for clock changes
  */
 struct xuartps {
 	struct uart_port	*port;
@@ -183,8 +183,8 @@ struct xuartps {
  * @irq: Irq number
  * @dev_id: Id of the port
  *
- * Returns IRQHANDLED
- **/
+ * Return: IRQHANDLED
+ */
 static irqreturn_t xuartps_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = (struct uart_port *)dev_id;
@@ -325,7 +325,7 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
  * @rbdiv: BDIV value (return value)
  * @rcd: CD value (return value)
  * @div8: Value for clk_sel bit in mod (return value)
- * Returns baud rate, requested baud when possible, or actual baud when there
+ * Return: baud rate, requested baud when possible, or actual baud when there
  *	was too much error, zero if no valid divisors are found.
  *
  * Formula to obtain baud rate is
@@ -384,7 +384,7 @@ static unsigned int xuartps_calc_baud_divs(unsigned int clk, unsigned int baud,
  * xuartps_set_baud_rate - Calculate and set the baud rate
  * @port: Handle to the uart port structure
  * @baud: Baud rate to set
- * Returns baud rate, requested baud when possible, or actual baud when there
+ * Return: baud rate, requested baud when possible, or actual baud when there
  *	   was too much error, zero if no valid divisors are found.
  */
 static unsigned int xuartps_set_baud_rate(struct uart_port *port,
@@ -419,7 +419,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
  * @nb:		Notifier block
  * @event:	Notify event
  * @data:	Notifier data
- * Returns NOTIFY_OK on success, NOTIFY_BAD on error.
+ * Return: NOTIFY_OK on success, NOTIFY_BAD on error.
  */
 static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		unsigned long event, void *data)
@@ -514,8 +514,7 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 /**
  * xuartps_start_tx -  Start transmitting bytes
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_start_tx(struct uart_port *port)
 {
 	unsigned int status, numbytes = port->fifosize;
@@ -562,8 +561,7 @@ static void xuartps_start_tx(struct uart_port *port)
 /**
  * xuartps_stop_tx - Stop TX
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_stop_tx(struct uart_port *port)
 {
 	unsigned int regval;
@@ -577,8 +575,7 @@ static void xuartps_stop_tx(struct uart_port *port)
 /**
  * xuartps_stop_rx - Stop RX
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_stop_rx(struct uart_port *port)
 {
 	unsigned int regval;
@@ -593,8 +590,8 @@ static void xuartps_stop_rx(struct uart_port *port)
  * xuartps_tx_empty -  Check whether TX is empty
  * @port: Handle to the uart port structure
  *
- * Returns TIOCSER_TEMT on success, 0 otherwise
- **/
+ * Return: TIOCSER_TEMT on success, 0 otherwise
+ */
 static unsigned int xuartps_tx_empty(struct uart_port *port)
 {
 	unsigned int status;
@@ -608,8 +605,7 @@ static unsigned int xuartps_tx_empty(struct uart_port *port)
  *			transmitting char breaks
  * @port: Handle to the uart port structure
  * @ctl: Value based on which start or stop decision is taken
- *
- **/
+ */
 static void xuartps_break_ctl(struct uart_port *port, int ctl)
 {
 	unsigned int status;
@@ -636,8 +632,7 @@ static void xuartps_break_ctl(struct uart_port *port, int ctl)
  * @port: Handle to the uart port structure
  * @termios: Handle to the input termios structure
  * @old: Values of the previously saved termios structure
- *
- **/
+ */
 static void xuartps_set_termios(struct uart_port *port,
 				struct ktermios *termios, struct ktermios *old)
 {
@@ -761,8 +756,8 @@ static void xuartps_set_termios(struct uart_port *port,
  * xuartps_startup - Called when an application opens a xuartps port
  * @port: Handle to the uart port structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise
+ */
 static int xuartps_startup(struct uart_port *port)
 {
 	unsigned int retval = 0, status = 0;
@@ -824,8 +819,7 @@ static int xuartps_startup(struct uart_port *port)
 /**
  * xuartps_shutdown - Called when an application closes a xuartps port
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_shutdown(struct uart_port *port)
 {
 	int status;
@@ -844,8 +838,8 @@ static void xuartps_shutdown(struct uart_port *port)
  * xuartps_type - Set UART type to xuartps port
  * @port: Handle to the uart port structure
  *
- * Returns string on success, NULL otherwise
- **/
+ * Return: string on success, NULL otherwise
+ */
 static const char *xuartps_type(struct uart_port *port)
 {
 	return port->type == PORT_XUARTPS ? XUARTPS_NAME : NULL;
@@ -856,8 +850,8 @@ static const char *xuartps_type(struct uart_port *port)
  * @port: Handle to the uart port structure
  * @ser: Handle to the structure whose members are compared
  *
- * Returns 0 if success otherwise -EINVAL
- **/
+ * Return: 0 if success otherwise -EINVAL
+ */
 static int xuartps_verify_port(struct uart_port *port,
 					struct serial_struct *ser)
 {
@@ -880,8 +874,8 @@ static int xuartps_verify_port(struct uart_port *port,
  *				uart_add_one_port()
  * @port: Handle to the uart port structure
  *
- * Returns 0, -ENOMEM if request fails
- **/
+ * Return: 0, -ENOMEM if request fails
+ */
 static int xuartps_request_port(struct uart_port *port)
 {
 	if (!request_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE,
@@ -903,8 +897,7 @@ static int xuartps_request_port(struct uart_port *port)
  *				port, called when the driver removes a xuartps
  *				port via uart_remove_one_port().
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_release_port(struct uart_port *port)
 {
 	release_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE);
@@ -917,8 +910,7 @@ static void xuartps_release_port(struct uart_port *port)
  *				xuartps port
  * @port: Handle to the uart port structure
  * @flags: If any
- *
- **/
+ */
 static void xuartps_config_port(struct uart_port *port, int flags)
 {
 	if (flags & UART_CONFIG_TYPE && xuartps_request_port(port) == 0)
@@ -930,9 +922,8 @@ static void xuartps_config_port(struct uart_port *port, int flags)
  *
  * @port: Handle to the uart port structure
  *
- * Returns the modem control state
- *
- **/
+ * Return: the modem control state
+ */
 static unsigned int xuartps_get_mctrl(struct uart_port *port)
 {
 	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
@@ -1040,8 +1031,8 @@ static struct uart_port xuartps_port[2];
  * xuartps_get_port - Configure the port from the platform device resource
  *			info
  *
- * Returns a pointer to a uart_port or NULL for failure
- **/
+ * Return: a pointer to a uart_port or NULL for failure
+ */
 static struct uart_port *xuartps_get_port(void)
 {
 	struct uart_port *port;
@@ -1078,8 +1069,7 @@ static struct uart_port *xuartps_get_port(void)
 /**
  * xuartps_console_wait_tx - Wait for the TX to be full
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_console_wait_tx(struct uart_port *port)
 {
 	while ((xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY)
@@ -1091,8 +1081,7 @@ static void xuartps_console_wait_tx(struct uart_port *port)
  * xuartps_console_putchar - write the character to the FIFO buffer
  * @port: Handle to the uart port structure
  * @ch: Character to be written
- *
- **/
+ */
 static void xuartps_console_putchar(struct uart_port *port, int ch)
 {
 	xuartps_console_wait_tx(port);
@@ -1101,10 +1090,10 @@ static void xuartps_console_putchar(struct uart_port *port, int ch)

 /**
  * xuartps_console_write - perform write operation
- * @port: Handle to the uart port structure
+ * @co: Console handle
  * @s: Pointer to character array
  * @count: No of characters
- **/
+ */
 static void xuartps_console_write(struct console *co, const char *s,
 				unsigned int count)
 {
@@ -1151,8 +1140,8 @@ static void xuartps_console_write(struct console *co, const char *s,
  * @co: Console handle
  * @options: Initial settings of uart
  *
- * Returns 0, -ENODEV if no device
- **/
+ * Return: 0, -ENODEV if no device
+ */
 static int __init xuartps_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port = &xuartps_port[co->index];
@@ -1190,8 +1179,8 @@ static struct console xuartps_console = {
 /**
  * xuartps_console_init - Initialization call
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise
+ */
 static int __init xuartps_console_init(void)
 {
 	register_console(&xuartps_console);
@@ -1221,7 +1210,7 @@ static struct uart_driver xuartps_uart_driver = {
  * xuartps_suspend - suspend event
  * @device: Pointer to the device structure
  *
- * Returns 0
+ * Return: 0
  */
 static int xuartps_suspend(struct device *device)
 {
@@ -1269,7 +1258,7 @@ static int xuartps_suspend(struct device *device)
  * xuartps_resume - Resume after a previous suspend
  * @device: Pointer to the device structure
  *
- * Returns 0
+ * Return: 0
  */
 static int xuartps_resume(struct device *device)
 {
@@ -1336,8 +1325,8 @@ static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
  * xuartps_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise
+ */
 static int xuartps_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -1437,8 +1426,8 @@ err_out_clk_dis_aper:
  * xuartps_remove - called when the platform driver is unregistered
  * @pdev: Pointer to the platform device structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise
+ */
 static int xuartps_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
@@ -1481,8 +1470,8 @@ static struct platform_driver xuartps_platform_driver = {
 /**
  * xuartps_init - Initial driver registration call
  *
- * Returns whether the registration was successful or not
- **/
+ * Return: whether the registration was successful or not
+ */
 static int __init xuartps_init(void)
 {
 	int retval = 0;
@@ -1502,7 +1491,7 @@ static int __init xuartps_init(void)

 /**
  * xuartps_exit - Driver unregistration call
- **/
+ */
 static void __exit xuartps_exit(void)
 {
 	/* The order of unregistration is important. Unregister the
--
1.8.2.3


--=_mimegpg-monstr-desktop-13087-1390300391-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLeTOcACgkQykllyylKDCE2iQCdFJK7Sdd4cYC45SI5qvS7fl3v
R3AAn3dJG5nly4g1etkRW1vgAZPBnMyk
=SZJO
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-13087-1390300391-0001--
