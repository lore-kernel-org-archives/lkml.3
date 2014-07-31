Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaGaQTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:19:00 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58509 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGaQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140731150753.3f12fc2f@alan.etchedpixels.co.uk>
References: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com> <20140731150753.3f12fc2f@alan.etchedpixels.co.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 31 Jul 2014 18:13:10 +0200
Message-ID: <CAPybu_3-Ve2cy3e8Az521cT_v0zfeNnnCoB_hy83=L17pUi9GA@mail.gmail.com>
Subject: Re: [PATCH 1/2] serial/8250: Add support for RS485 IOCTLs
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

> Is there any reasons we can't have uart_ops.rs485_config and the RS485
> ioctl logic in the serial_core, or even push rs485_get/put into the tty
> ioctl handler and tty ops so it's not duplicated everywhere ?

What about a step by step approach. First we add this code to the
8250_core, and then I remove all the specific driver
TIOCSRS485 handling and manage it through serial_core.c

Right now these are the drivers using it:

drivers/tty/serial/8250/8250_core.c:    case TIOCSRS485:
drivers/tty/serial/atmel_serial.c:      case TIOCSRS485:
drivers/tty/serial/crisv10.c:   case TIOCSRS485:
drivers/tty/serial/max310x.c:   case TIOCSRS485:
drivers/tty/serial/mcf.c:       case TIOCSRS485: {
drivers/tty/serial/omap-serial.c:       case TIOCSRS485:
rivers/tty/serial/sc16is7xx.c: case TIOCSRS485:

Regards!



-- 
Ricardo Ribalda
