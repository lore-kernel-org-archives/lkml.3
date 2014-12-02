Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaLBSSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:18:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaLBSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:18:11 -0500
Date: Tue, 2 Dec 2014 10:18:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB driver fixes for 3.18-rc7
Message-ID: <20141202181810.GB15869@kroah.com>
References: <20141128224028.GA29538@kroah.com>
 <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 11:47:20AM -0800, Linus Torvalds wrote:
> Hmm, Greg.
> 
> I seem to get this problem possibly more commonly at boot these days:
> 
>   usb 1-6: new full-speed USB device number 2 using xhci_hcd
>   usb 1-6: device descriptor read/64, error -71
>   xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
>   usb 1-6: hub failed to enable device, error -22
>   usb 1-6: new full-speed USB device number 3 using xhci_hcd
>   usb 1-6: device descriptor read/64, error -71
>   usb 1-6: hub failed to enable device, error -22
>   usb 1-6: new full-speed USB device number 4 using xhci_hcd
>   usb 1-6: Device not responding to setup address.
>   usb 1-6: Device not responding to setup address.
>   usb 1-6: device not accepting address 4, error -71
>   usb 1-6: new full-speed USB device number 5 using xhci_hcd
>   usb 1-6: Device not responding to setup address.
>   usb 1-6: Device not responding to setup address.
>   usb 1-6: device not accepting address 5, error -71
>  usb usb1-port6: unable to enumerate USB device
> 
> and my keyboard doesn't work. I then unplug and re-plug it, and get
> 
>   usb 1-6: new full-speed USB device number 9 using xhci_hcd
>   usb 1-6: New USB device found, idVendor=2516, idProduct=0020
>   usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>   usb 1-6: Product: Quickfire Rapid i
>   usb 1-6: Manufacturer: CM Storm
> 
> Any ideas? Some setup delay that isn't long enough at boot time for a
> slightly finicky device? It has happened before, but now I've gotten
> it twice within a couple of days:
> 
>   Nov 02 12:18:56 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
>   Nov 28 16:54:06 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
>   Nov 30 11:26:35 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
> 
> (I've had this keyboard since mid-September, and looking at the logs
> this machine has been rebooted 41 times since, with those three
> failures..)

I've been seeing this occasionally recently as well, but was blaming a
"bad" USB 3 hub I have here that I use, and the problem goes away with a
replug.

Mathias, any ideas what is going on here?

thanks,

greg k-h

> 
>               Linus
