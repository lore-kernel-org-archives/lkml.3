Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3AKNkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:40:41 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:55846 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3AKNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:40:39 -0500
Date: Fri, 11 Jan 2013 05:41:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel driver vs libusb performance
Message-ID: <20130111134118.GB19224@kroah.com>
References: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 11:53:36AM +0200, Ozan Çağlayan wrote:
> Hi,
> 
> I have a device which I'm currently accessing using libusb. It's
> basically a HID compliant USB device. It reports 32bytes of data with
> a time resolution of 128Hz, e.g. I have to read and store 32bytes each
> 1/128 second. One performance drawback is that those 32bytes chunks
> are encrypted with AES so once I receive them through the USB endpoint
> I first decrypt them.
> 
> So 128Hz is quite a low polling frequency and can be handled in a
> single-thread using a modern CPU, but I'm planning to run this loop on
> a Raspberry Pi or namely low-end, cheap embedded processors. I'm also
> using Python which is significantly slow on Raspberry Pi.

Ah, my sympathies, USB on a rpi is horrible, and you will have all sorts
of nasty issues, no matter how you end up doing this (in the kernel or
userspace).

> So I wonder whether writing a kernel driver which decrypts the packets
> using in-kernel crypto API and then exposing them through a character
> device node would bring a performance gain at all. At least on the
> userspace side I may get rid of all the bus searching, crypto key
> generation, fetching and decrypting boilerplate, am I in the wrong
> way?

Test it out and see.  I really don't think that user vs. kernel space is
going to be the issue here, I think you are going to see some very real
problems with the hardware itself in this area.

Best of luck,

greg k-h
