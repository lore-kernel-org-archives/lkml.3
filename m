Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3FNO5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:57:11 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43217 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab3FNO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:56:54 -0400
From: Bernd Bassimir <bassimir.kernel@gmx.de>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, yamanetoshi@gmail.com, devendra.aaru@gmail.com,
        jslaby@suse.cz, nico.doerr@hawo.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Bernd Bassimir <bassimir.kernel@gmx.de>
Subject: [PATCH 1/2] serqt_usb2: Fixed coding style CamelCases
Date: Fri, 14 Jun 2013 16:55:57 +0200
Message-Id: <1371221758-31589-1-git-send-email-bassimir.kernel@gmx.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed names of several variables, that contained CamelCases.

Signed-off-by: Bernd Bassimir <bassimir.kernel@gmx.de>
Signed-off-by: Nico Doerr <nico.doerr@hawo.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |  288 +++++++++++++++----------------
 1 file changed, 144 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 8a6e5ea..0c87c6f 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -155,10 +155,10 @@ struct quatech_port {
 	struct urb *read_urb;	/* read URB for this port */
 	struct urb *int_urb;
 
-	__u8 shadowLCR;		/* last LCR value received */
-	__u8 shadowMCR;		/* last MCR value received */
-	__u8 shadowMSR;		/* last MSR value received */
-	__u8 shadowLSR;		/* last LSR value received */
+	__u8 shadow_lcr;		/* last LCR value received */
+	__u8 shadow_mcr;		/* last MCR value received */
+	__u8 shadow_msr;		/* last MSR value received */
+	__u8 shadow_lsr;		/* last LSR value received */
 	char open_ports;
 
 	/* Used for TIOCMIWAIT */
@@ -170,12 +170,12 @@ struct quatech_port {
 	struct async_icount icount;
 
 	struct usb_serial_port *port;	/* owner of this object */
-	struct qt_get_device_data DeviceData;
+	struct qt_get_device_data device_data;
 	struct mutex lock;
 	bool read_urb_busy;
-	int RxHolding;
-	int ReadBulkStopped;
-	char closePending;
+	int rx_holding;
+	int read_bulk_stopped;
+	char close_pending;
 };
 
 static int port_paranoia_check(struct usb_serial_port *port,
@@ -238,24 +238,24 @@ static struct usb_serial *get_usb_serial(struct usb_serial_port *port,
 	return port->serial;
 }
 
-static void ProcessLineStatus(struct quatech_port *qt_port,
+static void process_line_status(struct quatech_port *qt_port,
 			      unsigned char line_status)
 {
 
-	qt_port->shadowLSR =
+	qt_port->shadow_lsr =
 	    line_status & (SERIAL_LSR_OE | SERIAL_LSR_PE | SERIAL_LSR_FE |
 			   SERIAL_LSR_BI);
 }
 
-static void ProcessModemStatus(struct quatech_port *qt_port,
+static void process_modem_status(struct quatech_port *qt_port,
 			       unsigned char modem_status)
 {
 
-	qt_port->shadowMSR = modem_status;
+	qt_port->shadow_msr = modem_status;
 	wake_up_interruptible(&qt_port->wait);
 }
 
-static void ProcessRxChar(struct usb_serial_port *port, unsigned char data)
+static void process_rx_char(struct usb_serial_port *port, unsigned char data)
 {
 	struct urb *urb = port->read_urb;
 	if (urb->actual_length)
@@ -291,35 +291,35 @@ static void qt_status_change_check(struct urb *urb,
 {
 	int flag, i;
 	unsigned char *data = urb->transfer_buffer;
-	unsigned int RxCount = urb->actual_length;
+	unsigned int rx_count = urb->actual_length;
 
-	for (i = 0; i < RxCount; ++i) {
+	for (i = 0; i < rx_count; ++i) {
 		/* Look ahead code here */
-		if ((i <= (RxCount - 3)) && (data[i] == 0x1b)
+		if ((i <= (rx_count - 3)) && (data[i] == 0x1b)
 		    && (data[i + 1] == 0x1b)) {
 			flag = 0;
 			switch (data[i + 2]) {
 			case 0x00:
-				if (i > (RxCount - 4)) {
+				if (i > (rx_count - 4)) {
 					dev_dbg(&port->dev,
 						"Illegal escape seuences in received data\n");
 					break;
 				}
 
-				ProcessLineStatus(qt_port, data[i + 3]);
+				process_line_status(qt_port, data[i + 3]);
 
 				i += 3;
 				flag = 1;
 				break;
 
 			case 0x01:
-				if (i > (RxCount - 4)) {
+				if (i > (rx_count - 4)) {
 					dev_dbg(&port->dev,
 						"Illegal escape seuences in received data\n");
 					break;
 				}
 
-				ProcessModemStatus(qt_port, data[i + 3]);
+				process_modem_status(qt_port, data[i + 3]);
 
 				i += 3;
 				flag = 1;
@@ -328,8 +328,8 @@ static void qt_status_change_check(struct urb *urb,
 			case 0xff:
 				dev_dbg(&port->dev, "No status sequence.\n");
 
-				ProcessRxChar(port, data[i]);
-				ProcessRxChar(port, data[i + 1]);
+				process_rx_char(port, data[i]);
+				process_rx_char(port, data[i + 1]);
 
 				i += 2;
 				break;
@@ -354,7 +354,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 	int result;
 
 	if (urb->status) {
-		qt_port->ReadBulkStopped = 1;
+		qt_port->read_bulk_stopped = 1;
 		dev_dbg(&urb->dev->dev,
 			"%s - nonzero write bulk status received: %d\n",
 			__func__, urb->status);
@@ -362,36 +362,36 @@ static void qt_read_bulk_callback(struct urb *urb)
 	}
 
 	dev_dbg(&port->dev,
-		"%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
+		"%s - port->rx_holding = %d\n", __func__, qt_port->rx_holding);
 
 	if (port_paranoia_check(port, __func__) != 0) {
-		qt_port->ReadBulkStopped = 1;
+		qt_port->read_bulk_stopped = 1;
 		return;
 	}
 
 	if (!serial)
 		return;
 
-	if (qt_port->closePending == 1) {
+	if (qt_port->close_pending == 1) {
 		/* Were closing , stop reading */
 		dev_dbg(&port->dev,
-			"%s - (qt_port->closepending == 1\n", __func__);
-		qt_port->ReadBulkStopped = 1;
+			"%s - (qt_port->close_pending == 1\n", __func__);
+		qt_port->read_bulk_stopped = 1;
 		return;
 	}
 
 	/*
-	 * RxHolding is asserted by throttle, if we assert it, we're not
+	 * rx_holding is asserted by throttle, if we assert it, we're not
 	 * receiving any more characters and let the box handle the flow
 	 * control
 	 */
-	if (qt_port->RxHolding == 1) {
-		qt_port->ReadBulkStopped = 1;
+	if (qt_port->rx_holding == 1) {
+		qt_port->read_bulk_stopped = 1;
 		return;
 	}
 
 	if (urb->status) {
-		qt_port->ReadBulkStopped = 1;
+		qt_port->read_bulk_stopped = 1;
 
 		dev_dbg(&port->dev,
 			"%s - nonzero read bulk status received: %d\n",
@@ -455,10 +455,10 @@ static int qt_get_device(struct usb_serial *serial,
 }
 
 /****************************************************************************
- *  BoxSetPrebufferLevel
+ *  box_set_prebuffer_level
    TELLS BOX WHEN TO ASSERT FLOW CONTROL
  ****************************************************************************/
-static int BoxSetPrebufferLevel(struct usb_serial *serial)
+static int box_set_prebuffer_level(struct usb_serial *serial)
 {
 	int result;
 	__u16 buffer_length;
@@ -471,10 +471,10 @@ static int BoxSetPrebufferLevel(struct usb_serial *serial)
 }
 
 /****************************************************************************
- *  BoxSetATC
+ *  box_set_atc
    TELLS BOX WHEN TO ASSERT automatic transmitter control
    ****************************************************************************/
-static int BoxSetATC(struct usb_serial *serial, __u16 n_Mode)
+static int box_set_atc(struct usb_serial *serial, __u16 n_mode)
 {
 	int result;
 	__u16 buffer_length;
@@ -483,7 +483,7 @@ static int BoxSetATC(struct usb_serial *serial, __u16 n_Mode)
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_SET_ATF, 0x40, n_Mode, 0, NULL, 0, 300);
+			    QT_SET_ATF, 0x40, n_mode, 0, NULL, 0, 300);
 
 	return result;
 }
@@ -499,42 +499,42 @@ static int qt_set_device(struct usb_serial *serial,
 {
 	int result;
 	__u16 length;
-	__u16 PortSettings;
+	__u16 port_settings;
 
-	PortSettings = ((__u16) (device_data->portb));
-	PortSettings = (PortSettings << 8);
-	PortSettings += ((__u16) (device_data->porta));
+	port_settings = ((__u16) (device_data->portb));
+	port_settings = (port_settings << 8);
+	port_settings += ((__u16) (device_data->porta));
 
 	length = sizeof(struct qt_get_device_data);
 
 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				 QT_SET_GET_DEVICE, 0x40, PortSettings,
+				 QT_SET_GET_DEVICE, 0x40, port_settings,
 				 0, NULL, 0, 300);
 	return result;
 }
 
-static int qt_open_channel(struct usb_serial *serial, __u16 Uart_Number,
-			   struct qt_open_channel_data *pDeviceData)
+static int qt_open_channel(struct usb_serial *serial, __u16 uart_number,
+			   struct qt_open_channel_data *pdevice_data)
 {
 	int result;
 
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				 QT_OPEN_CLOSE_CHANNEL,
-				 USBD_TRANSFER_DIRECTION_IN, 1, Uart_Number,
-				 pDeviceData,
+				 USBD_TRANSFER_DIRECTION_IN, 1, uart_number,
+				 pdevice_data,
 				 sizeof(struct qt_open_channel_data), 300);
 
 	return result;
 
 }
 
-static int qt_close_channel(struct usb_serial *serial, __u16 Uart_Number)
+static int qt_close_channel(struct usb_serial *serial, __u16 uart_number)
 {
 	int result;
 
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				 QT_OPEN_CLOSE_CHANNEL,
-				 USBD_TRANSFER_DIRECTION_OUT, 0, Uart_Number,
+				 USBD_TRANSFER_DIRECTION_OUT, 0, uart_number,
 				 NULL, 0, 300);
 
 	return result;
@@ -542,12 +542,12 @@ static int qt_close_channel(struct usb_serial *serial, __u16 Uart_Number)
 }
 
 /****************************************************************************
-* BoxGetRegister
+* box_get_register
 *	issuse a GET_REGISTER vendor-spcific request on the default control pipe
-*	If successful, fills in the  pValue with the register value asked for
+*	If successful, fills in the  p_value with the register value asked for
 ****************************************************************************/
-static int BoxGetRegister(struct usb_serial *serial, unsigned short Uart_Number,
-			  unsigned short Register_Num, __u8 *pValue)
+static int box_get_register(struct usb_serial *serial, unsigned short uart_number,
+			  unsigned short register_num, __u8 *p_value)
 {
 	int result;
 	__u16 current_length;
@@ -556,36 +556,36 @@ static int BoxGetRegister(struct usb_serial *serial, unsigned short Uart_Number,
 
 	result =
 	    usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-			    QT_GET_SET_REGISTER, 0xC0, Register_Num,
-			    Uart_Number, (void *)pValue, sizeof(*pValue), 300);
+			    QT_GET_SET_REGISTER, 0xC0, register_num,
+			    uart_number, (void *)p_value, sizeof(*p_value), 300);
 
 	return result;
 }
 
 /****************************************************************************
-* BoxSetRegister
+* box_set_register
 *	issuse a GET_REGISTER vendor-spcific request on the default control pipe
-*	If successful, fills in the  pValue with the register value asked for
+*	If successful, fills in the  p_value with the register value asked for
 ****************************************************************************/
-static int BoxSetRegister(struct usb_serial *serial, unsigned short Uart_Number,
-			  unsigned short Register_Num, unsigned short Value)
+static int box_set_register(struct usb_serial *serial, unsigned short uart_number,
+			  unsigned short register_num, unsigned short value)
 {
 	int result;
-	unsigned short RegAndByte;
+	unsigned short reg_and_byte;
 
-	RegAndByte = Value;
-	RegAndByte = RegAndByte << 8;
-	RegAndByte = RegAndByte + Register_Num;
+	reg_and_byte = value;
+	reg_and_byte = reg_and_byte << 8;
+	reg_and_byte = reg_and_byte + register_num;
 
 /*
 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				 QT_GET_SET_REGISTER, 0xC0, Register_Num,
-				 Uart_Number, NULL, 0, 300);
+				 QT_GET_SET_REGISTER, 0xC0, register_num,
+				 uart_number, NULL, 0, 300);
 */
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_GET_SET_REGISTER, 0x40, RegAndByte, Uart_Number,
+			    QT_GET_SET_REGISTER, 0x40, reg_and_byte, uart_number,
 			    NULL, 0, 300);
 
 	return result;
@@ -596,30 +596,30 @@ static int BoxSetRegister(struct usb_serial *serial, unsigned short Uart_Number,
  * issues a SET_UART vendor-specific request on the default control pipe
  * If successful sets baud rate divisor and LCR value
  */
-static int qt_setuart(struct usb_serial *serial, unsigned short Uart_Number,
-		      unsigned short default_divisor, unsigned char default_LCR)
+static int qt_setuart(struct usb_serial *serial, unsigned short uart_number,
+		      unsigned short default_divisor, unsigned char default_lcr)
 {
 	int result;
-	unsigned short UartNumandLCR;
+	unsigned short uart_num_and_lcr;
 
-	UartNumandLCR = (default_LCR << 8) + Uart_Number;
+	uart_num_and_lcr = (default_lcr << 8) + uart_number;
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			    QT_GET_SET_UART, 0x40, default_divisor,
-			    UartNumandLCR, NULL, 0, 300);
+			    uart_num_and_lcr, NULL, 0, 300);
 
 	return result;
 }
 
-static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int index,
-			     int bSet)
+static int box_set_hw_flow_ctrl(struct usb_serial *serial, unsigned int index,
+			     int b_set)
 {
 	__u8 mcr = 0;
-	__u8 msr = 0, MOUT_Value = 0;
+	__u8 msr = 0, mout_value = 0;
 	unsigned int status;
 
-	if (bSet == 1) {
+	if (b_set == 1) {
 		/* flow control, box will clear RTS line to prevent remote */
 		mcr = SERIAL_MCR_RTS;
 	} /* device from xmitting more chars */
@@ -628,9 +628,9 @@ static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int index,
 		mcr = 0;
 
 	}
-	MOUT_Value = mcr << 8;
+	mout_value = mcr << 8;
 
-	if (bSet == 1) {
+	if (b_set == 1) {
 		/* flow control, box will inhibit xmit data if CTS line is
 		 * asserted */
 		msr = SERIAL_MSR_CTS;
@@ -638,34 +638,34 @@ static int BoxSetHW_FlowCtrl(struct usb_serial *serial, unsigned int index,
 		/* Box will not inhimbe xmit data due to CTS line */
 		msr = 0;
 	}
-	MOUT_Value |= msr;
+	mout_value |= msr;
 
 	status =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_HW_FLOW_CONTROL_MASK, 0x40, MOUT_Value,
+			    QT_HW_FLOW_CONTROL_MASK, 0x40, mout_value,
 			    index, NULL, 0, 300);
 	return status;
 
 }
 
-static int BoxSetSW_FlowCtrl(struct usb_serial *serial, __u16 index,
+static int box_set_sw_flow_ctrl(struct usb_serial *serial, __u16 index,
 			     unsigned char stop_char, unsigned char start_char)
 {
-	__u16 nSWflowout;
+	__u16 n_sw_flow_out;
 	int result;
 
-	nSWflowout = start_char << 8;
-	nSWflowout = (unsigned short)stop_char;
+	n_sw_flow_out = start_char << 8;
+	n_sw_flow_out = (unsigned short)stop_char;
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_SW_FLOW_CONTROL_MASK, 0x40, nSWflowout,
+			    QT_SW_FLOW_CONTROL_MASK, 0x40, n_sw_flow_out,
 			    index, NULL, 0, 300);
 	return result;
 
 }
 
-static int BoxDisable_SW_FlowCtrl(struct usb_serial *serial, __u16 index)
+static int box_disable_sw_flow_ctrl(struct usb_serial *serial, __u16 index)
 {
 	int result;
 
@@ -682,7 +682,7 @@ static int qt_startup(struct usb_serial *serial)
 	struct device *dev = &serial->dev->dev;
 	struct usb_serial_port *port;
 	struct quatech_port *qt_port;
-	struct qt_get_device_data DeviceData;
+	struct qt_get_device_data device_data;
 	int i;
 	int status;
 
@@ -704,22 +704,22 @@ static int qt_startup(struct usb_serial *serial)
 
 	}
 
-	status = qt_get_device(serial, &DeviceData);
+	status = qt_get_device(serial, &device_data);
 	if (status < 0)
 		goto startup_error;
 
-	dev_dbg(dev, "DeviceData.portb = 0x%x\n", DeviceData.portb);
+	dev_dbg(dev, "device_data.portb = 0x%x\n", device_data.portb);
 
-	DeviceData.portb &= ~FULLPWRBIT;
-	dev_dbg(dev, "Changing DeviceData.portb to 0x%x\n", DeviceData.portb);
+	device_data.portb &= ~FULLPWRBIT;
+	dev_dbg(dev, "Changing device_data.portb to 0x%x\n", device_data.portb);
 
-	status = qt_set_device(serial, &DeviceData);
+	status = qt_set_device(serial, &device_data);
 	if (status < 0) {
 		dev_dbg(dev, "qt_set_device failed\n");
 		goto startup_error;
 	}
 
-	status = qt_get_device(serial, &DeviceData);
+	status = qt_get_device(serial, &device_data);
 	if (status < 0) {
 		dev_dbg(dev, "qt_get_device failed\n");
 		goto startup_error;
@@ -734,10 +734,10 @@ static int qt_startup(struct usb_serial *serial)
 	case QUATECH_HSU100B:
 	case QUATECH_HSU100C:
 	case QUATECH_HSU100D:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= RS232_MODE;
+		device_data.porta &= ~(RR_BITS | DUPMODE_BITS);
+		device_data.porta |= CLKS_X4;
+		device_data.portb &= ~(LOOPMODE_BITS);
+		device_data.portb |= RS232_MODE;
 		break;
 
 	case QUATECH_SSU200:
@@ -749,38 +749,38 @@ static int qt_startup(struct usb_serial *serial)
 	case QUATECH_HSU200B:
 	case QUATECH_HSU200C:
 	case QUATECH_HSU200D:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= ALL_LOOPBACK;
+		device_data.porta &= ~(RR_BITS | DUPMODE_BITS);
+		device_data.porta |= CLKS_X4;
+		device_data.portb &= ~(LOOPMODE_BITS);
+		device_data.portb |= ALL_LOOPBACK;
 		break;
 	default:
-		DeviceData.porta &= ~(RR_BITS | DUPMODE_BITS);
-		DeviceData.porta |= CLKS_X4;
-		DeviceData.portb &= ~(LOOPMODE_BITS);
-		DeviceData.portb |= RS232_MODE;
+		device_data.porta &= ~(RR_BITS | DUPMODE_BITS);
+		device_data.porta |= CLKS_X4;
+		device_data.portb &= ~(LOOPMODE_BITS);
+		device_data.portb |= RS232_MODE;
 		break;
 
 	}
 
-	status = BoxSetPrebufferLevel(serial);	/* sets to default value */
+	status = box_set_prebuffer_level(serial);	/* sets to default value */
 	if (status < 0) {
-		dev_dbg(dev, "BoxSetPrebufferLevel failed\n");
+		dev_dbg(dev, "box_set_prebuffer_level failed\n");
 		goto startup_error;
 	}
 
-	status = BoxSetATC(serial, ATC_DISABLED);
+	status = box_set_atc(serial, ATC_DISABLED);
 	if (status < 0) {
-		dev_dbg(dev, "BoxSetATC failed\n");
+		dev_dbg(dev, "box_set_atc failed\n");
 		goto startup_error;
 	}
 
-	dev_dbg(dev, "DeviceData.portb = 0x%x\n", DeviceData.portb);
+	dev_dbg(dev, "device_data.portb = 0x%x\n", device_data.portb);
 
-	DeviceData.portb |= NEXT_BOARD_POWER_BIT;
-	dev_dbg(dev, "Changing DeviceData.portb to 0x%x\n", DeviceData.portb);
+	device_data.portb |= NEXT_BOARD_POWER_BIT;
+	dev_dbg(dev, "Changing device_data.portb to 0x%x\n", device_data.portb);
 
-	status = qt_set_device(serial, &DeviceData);
+	status = qt_set_device(serial, &device_data);
 	if (status < 0) {
 		dev_dbg(dev, "qt_set_device failed\n");
 		goto startup_error;
@@ -848,7 +848,7 @@ static int qt_open(struct tty_struct *tty,
 	struct usb_serial *serial;
 	struct quatech_port *quatech_port;
 	struct quatech_port *port0;
-	struct qt_open_channel_data ChannelData;
+	struct qt_open_channel_data channel_data;
 
 	int result;
 
@@ -870,10 +870,10 @@ static int qt_open(struct tty_struct *tty,
 	usb_clear_halt(serial->dev, port->read_urb->pipe);
 	port0->open_ports++;
 
-	result = qt_get_device(serial, &port0->DeviceData);
+	result = qt_get_device(serial, &port0->device_data);
 
 	/* Port specific setups */
-	result = qt_open_channel(serial, port->number, &ChannelData);
+	result = qt_open_channel(serial, port->number, &channel_data);
 	if (result < 0) {
 		dev_dbg(&port->dev, "qt_open_channel failed\n");
 		return result;
@@ -881,10 +881,10 @@ static int qt_open(struct tty_struct *tty,
 	dev_dbg(&port->dev, "qt_open_channel completed.\n");
 
 /* FIXME: are these needed?  Does it even do anything useful? */
-	quatech_port->shadowLSR = ChannelData.line_status &
+	quatech_port->shadow_lsr = channel_data.line_status &
 	    (SERIAL_LSR_OE | SERIAL_LSR_PE | SERIAL_LSR_FE | SERIAL_LSR_BI);
 
-	quatech_port->shadowMSR = ChannelData.modem_status &
+	quatech_port->shadow_msr = channel_data.modem_status &
 	    (SERIAL_MSR_CTS | SERIAL_MSR_DSR | SERIAL_MSR_RI | SERIAL_MSR_CD);
 
 	/* Set Baud rate to default and turn off (default)flow control here */
@@ -1179,7 +1179,7 @@ static void qt_set_termios(struct tty_struct *tty,
 			   struct ktermios *old_termios)
 {
 	struct ktermios *termios = &tty->termios;
-	unsigned char new_LCR = 0;
+	unsigned char new_lcr = 0;
 	unsigned int cflag = termios->c_cflag;
 	unsigned int index;
 	int baud, divisor, remainder;
@@ -1189,33 +1189,33 @@ static void qt_set_termios(struct tty_struct *tty,
 
 	switch (cflag & CSIZE) {
 	case CS5:
-		new_LCR |= SERIAL_5_DATA;
+		new_lcr |= SERIAL_5_DATA;
 		break;
 	case CS6:
-		new_LCR |= SERIAL_6_DATA;
+		new_lcr |= SERIAL_6_DATA;
 		break;
 	case CS7:
-		new_LCR |= SERIAL_7_DATA;
+		new_lcr |= SERIAL_7_DATA;
 		break;
 	default:
 		termios->c_cflag &= ~CSIZE;
 		termios->c_cflag |= CS8;
 	case CS8:
-		new_LCR |= SERIAL_8_DATA;
+		new_lcr |= SERIAL_8_DATA;
 		break;
 	}
 
 	/* Parity stuff */
 	if (cflag & PARENB) {
 		if (cflag & PARODD)
-			new_LCR |= SERIAL_ODD_PARITY;
+			new_lcr |= SERIAL_ODD_PARITY;
 		else
-			new_LCR |= SERIAL_EVEN_PARITY;
+			new_lcr |= SERIAL_EVEN_PARITY;
 	}
 	if (cflag & CSTOPB)
-		new_LCR |= SERIAL_TWO_STOPB;
+		new_lcr |= SERIAL_TWO_STOPB;
 	else
-		new_LCR |= SERIAL_ONE_STOPB;
+		new_lcr |= SERIAL_ONE_STOPB;
 
 	dev_dbg(&port->dev, "%s - 4\n", __func__);
 
@@ -1237,7 +1237,7 @@ static void qt_set_termios(struct tty_struct *tty,
 	 * Set Baud rate to default and turn off (default)flow control here
 	 */
 	status =
-	    qt_setuart(port->serial, index, (unsigned short)divisor, new_LCR);
+	    qt_setuart(port->serial, index, (unsigned short)divisor, new_lcr);
 	if (status < 0) {
 		dev_dbg(&port->dev, "qt_setuart failed\n");
 		return;
@@ -1249,10 +1249,10 @@ static void qt_set_termios(struct tty_struct *tty,
 			__func__, port->number);
 
 		/* Enable RTS/CTS flow control */
-		status = BoxSetHW_FlowCtrl(port->serial, index, 1);
+		status = box_set_hw_flow_ctrl(port->serial, index, 1);
 
 		if (status < 0) {
-			dev_dbg(&port->dev, "BoxSetHW_FlowCtrl failed\n");
+			dev_dbg(&port->dev, "box_set_hw_flow_ctrl failed\n");
 			return;
 		}
 	} else {
@@ -1261,9 +1261,9 @@ static void qt_set_termios(struct tty_struct *tty,
 			"%s - disabling HW flow control port %d\n",
 			__func__, port->number);
 
-		status = BoxSetHW_FlowCtrl(port->serial, index, 0);
+		status = box_set_hw_flow_ctrl(port->serial, index, 0);
 		if (status < 0) {
-			dev_dbg(&port->dev, "BoxSetHW_FlowCtrl failed\n");
+			dev_dbg(&port->dev, "box_set_hw_flow_ctrl failed\n");
 			return;
 		}
 
@@ -1275,18 +1275,18 @@ static void qt_set_termios(struct tty_struct *tty,
 		unsigned char stop_char = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
 		status =
-		    BoxSetSW_FlowCtrl(port->serial, index, stop_char,
+		    box_set_sw_flow_ctrl(port->serial, index, stop_char,
 				      start_char);
 		if (status < 0)
 			dev_dbg(&port->dev,
-				"BoxSetSW_FlowCtrl (enabled) failed\n");
+				"box_set_sw_flow_ctrl (enabled) failed\n");
 
 	} else {
 		/* disable SW flow control */
-		status = BoxDisable_SW_FlowCtrl(port->serial, index);
+		status = box_disable_sw_flow_ctrl(port->serial, index);
 		if (status < 0)
 			dev_dbg(&port->dev,
-				"BoxSetSW_FlowCtrl (diabling) failed\n");
+				"box_set_sw_flow_ctrl (diabling) failed\n");
 
 	}
 	termios->c_cflag &= ~CMSPAR;
@@ -1334,10 +1334,10 @@ static inline int qt_real_tiocmget(struct tty_struct *tty,
 
 	index = tty->index - serial->minor;
 	status =
-	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
+	    box_get_register(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
 	if (status >= 0) {
 		status =
-		    BoxGetRegister(port->serial, index,
+		    box_get_register(port->serial, index,
 				   MODEM_STATUS_REGISTER, &msr);
 
 	}
@@ -1373,7 +1373,7 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
 
 	index = tty->index - serial->minor;
 	status =
-	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
+	    box_get_register(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
 	if (status < 0)
 		return -ESPIPE;
 
@@ -1390,7 +1390,7 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
 		mcr |= SERIAL_MCR_LOOP;
 
 	status =
-	    BoxSetRegister(port->serial, index, MODEM_CONTROL_REGISTER, mcr);
+	    box_set_register(port->serial, index, MODEM_CONTROL_REGISTER, mcr);
 	if (status < 0)
 		return -ESPIPE;
 	else
@@ -1445,7 +1445,7 @@ static void qt_throttle(struct tty_struct *tty)
 	mutex_lock(&qt_port->lock);
 
 	/* pass on to the driver specific version of this function */
-	qt_port->RxHolding = 1;
+	qt_port->rx_holding = 1;
 
 	mutex_unlock(&qt_port->lock);
 }
@@ -1484,14 +1484,14 @@ static void qt_unthrottle(struct tty_struct *tty)
 
 	mutex_lock(&qt_port->lock);
 
-	if (qt_port->RxHolding == 1) {
-		dev_dbg(&port->dev, "%s -qt_port->RxHolding == 1\n", __func__);
+	if (qt_port->rx_holding == 1) {
+		dev_dbg(&port->dev, "%s -qt_port->rx_holding == 1\n", __func__);
 
-		qt_port->RxHolding = 0;
-		dev_dbg(&port->dev, "%s - qt_port->RxHolding = 0\n", __func__);
+		qt_port->rx_holding = 0;
+		dev_dbg(&port->dev, "%s - qt_port->rx_holding = 0\n", __func__);
 
 		/* if we have a bulk endpoint, start it up */
-		if ((serial->num_bulk_in) && (qt_port->ReadBulkStopped == 1))
+		if ((serial->num_bulk_in) && (qt_port->read_bulk_stopped == 1))
 			qt_submit_urb_from_unthrottle(port, serial);
 	}
 	mutex_unlock(&qt_port->lock);
-- 
1.7.10.4

