Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaK3TrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:47:23 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:41005 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3TrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:47:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141128224028.GA29538@kroah.com>
References: <20141128224028.GA29538@kroah.com>
Date: Sun, 30 Nov 2014 11:47:20 -0800
X-Google-Sender-Auth: M4Kid1Ulz0E_4K0izz0RGvTgIo8
Message-ID: <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
Subject: Re: [GIT PULL] USB driver fixes for 3.18-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, Greg.

I seem to get this problem possibly more commonly at boot these days:

  usb 1-6: new full-speed USB device number 2 using xhci_hcd
  usb 1-6: device descriptor read/64, error -71
  xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
  usb 1-6: hub failed to enable device, error -22
  usb 1-6: new full-speed USB device number 3 using xhci_hcd
  usb 1-6: device descriptor read/64, error -71
  usb 1-6: hub failed to enable device, error -22
  usb 1-6: new full-speed USB device number 4 using xhci_hcd
  usb 1-6: Device not responding to setup address.
  usb 1-6: Device not responding to setup address.
  usb 1-6: device not accepting address 4, error -71
  usb 1-6: new full-speed USB device number 5 using xhci_hcd
  usb 1-6: Device not responding to setup address.
  usb 1-6: Device not responding to setup address.
  usb 1-6: device not accepting address 5, error -71
 usb usb1-port6: unable to enumerate USB device

and my keyboard doesn't work. I then unplug and re-plug it, and get

  usb 1-6: new full-speed USB device number 9 using xhci_hcd
  usb 1-6: New USB device found, idVendor=2516, idProduct=0020
  usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
  usb 1-6: Product: Quickfire Rapid i
  usb 1-6: Manufacturer: CM Storm

Any ideas? Some setup delay that isn't long enough at boot time for a
slightly finicky device? It has happened before, but now I've gotten
it twice within a couple of days:

  Nov 02 12:18:56 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
  Nov 28 16:54:06 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
  Nov 30 11:26:35 i7.lan kernel: usb 1-6: device descriptor read/64, error -71

(I've had this keyboard since mid-September, and looking at the logs
this machine has been rebooted 41 times since, with those three
failures..)

              Linus
