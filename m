Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3FXTAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:00:01 -0400
Received: from mail.icid.cu ([200.55.133.90]:35923 "EHLO mail.icid.cu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3FXTAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:00:00 -0400
Message-ID: <51C896E1.1000801@icid.cu>
Date: Mon, 24 Jun 2013 14:58:41 -0400
From: raespi <raespi@icid.cu>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: usb reset issue ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: raespi@icid.cu
X-Spam-Processed: icid.cu, Mon, 24 Jun 2013 14:13:26 -0400
	(not processed: message from valid local sender)
X-MDRemoteIP: 10.10.8.78
X-Return-Path: raespi@icid.cu
X-Envelope-From: raespi@icid.cu
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: icid.cu, Mon, 24 Jun 2013 14:13:27 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ... I'm using an ARM Samsung S3C24XX processor.  I'm interested in 
creating medical equipment using Linux and came onto an issue today.  
I've created an application that connects to two FTDI devices and reads 
continuous data from a medical sensor.  I have a custom based board ( no 
external ports ), and my FTDI devices go directly to the S3C24xx USB 
pins and my app is configured to read from a specific product, vendor 
and device address location.  I've been testing it without problems and 
today it stopped working. Apparently, when checking the *dmesg* 
messages, the kernel disconnected those two USB devices and assigned 
them two new addresses ( 5 and 6 ) different from the original 3 and 4.  
I always noticed on PC's that this issue was somehow related to hardware 
problems and/or disconnection from the USB port.  Also both the 
/dev/ttyUSB0 and /dev/ttyUSB1 devices on the /dev directory dissapeared 
( for now not a problem since I don't access the FTDI device this way 
).  These are the kernel messages:

usb 1-1.3: USB disconnect, device number 3
usb 1-1.4: USB disconnect, device number 4
usb 1-1: reset full speed USB device number 2 using s3c2410-ohci
usb 1-1.3: new full speed USB device number 5 using s3c2410-ohci
usb 1-1.4: new full speed USB device number 6 using s3c2410-ohci

On my board I can't hook up my application again to the new address 
since it's the only parameter identifiable by it.  Both FTDI Devices 
have the same product and vendor numbers:

Bus 001 Device 003: ID 0403:6001
Bus 001 Device 004: ID 0403:6001

The address on which they are on is the only ID I've got.   Is there 
some way to disable the kernel usb reset policy or assign them a 
specific address ?? I'm using *mdev* from userspace but the type of 
address assignment with mdev is the one concerning the device's name 
under the /dev directory AFAIK ...

Thanks ...

