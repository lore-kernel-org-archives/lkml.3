Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3AKJxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:53:39 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:47948 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3AKJxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:53:37 -0500
MIME-Version: 1.0
Date: Fri, 11 Jan 2013 11:53:36 +0200
Message-ID: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
Subject: Kernel driver vs libusb performance
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a device which I'm currently accessing using libusb. It's
basically a HID compliant USB device. It reports 32bytes of data with
a time resolution of 128Hz, e.g. I have to read and store 32bytes each
1/128 second. One performance drawback is that those 32bytes chunks
are encrypted with AES so once I receive them through the USB endpoint
I first decrypt them.

So 128Hz is quite a low polling frequency and can be handled in a
single-thread using a modern CPU, but I'm planning to run this loop on
a Raspberry Pi or namely low-end, cheap embedded processors. I'm also
using Python which is significantly slow on Raspberry Pi.

So I wonder whether writing a kernel driver which decrypts the packets
using in-kernel crypto API and then exposing them through a character
device node would bring a performance gain at all. At least on the
userspace side I may get rid of all the bus searching, crypto key
generation, fetching and decrypting boilerplate, am I in the wrong
way?

Thanks,

-- 
Ozan Çağlayan
Research Assistant
Galatasaray University - Computer Engineering Dept.
http://www.ozancaglayan.com
