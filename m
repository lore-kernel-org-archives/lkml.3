Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298Ab3IDRZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:25:39 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42287 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763171Ab3IDRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:25:37 -0400
Date: Wed, 4 Sep 2013 13:25:34 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Linux USB List <linux-usb@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Introducing libgadget 0.0.1
Message-ID: <20130904172532.GA10973@ohporter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the move to configfs for creation of arbitrary USB composite gadgets,
I found myself wanting a simple C library to configure and parse gadgets
in a system. It has no other dependencies other than libc itself.

It can be found at:

	git://git.linaro.org/people/mporter/libgadget.git

Doxygen docs on API and examples at:

	http://people.linaro.org/~matt.porter/libgadget/group__libgadget.html
	http://people.linaro.org/~matt.porter/libgadget/examples.html

Output from the examples:

$ mkdir /config
$ mount -t configfs none /config
$ gadget-acm-ecm
$ show-gadgets
ID 1d6b:0104 'g1'
  UDC                   3f120000.usbotg
  bDeviceClass          0x00
  bDeviceSubClass       0x00
  bDeviceProtocol       0x00
  bMaxPacketSize0       0x40
  bcdDevice             0x0311
  bcdUSB                0x0000
  idVendor              0x1d6b
  idProduct             0x0104
  Serial Number         0123456789
  Manufacturer          Foo Inc.
  Product               Bar Gadget
  Function 'acm.usb0'
    port_num            0
  Function 'acm.usb1'
    port_num            1
  Function 'ecm.usb0'
    dev_addr            32:1b:dc:a4:bc:a2
    host_addr           82:b7:58:62:f6:31
    ifname              usb0
    qmult               5
  Configuration 'c.1'
    MaxPower            2
    bmAttributes        0x80
    configuration       CDC 2xACM+ECM
    acm.GS0 -> acm.usb0
    acm.GS1 -> acm.usb0
    ecm.usb0 -> ecm.usb0

Besides things noted in the todo list, I'm working on a gadgettool
on top of libgadget to make life easier for everyday creation of
common composite devices. e.g. gadgettool --create="g1" --function="acm"
--function="ecm" --enable

-Matt
