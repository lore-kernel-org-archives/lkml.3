Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaK3WPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:15:30 -0500
Received: from foo.stuge.se ([212.116.89.98]:55441 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaK3WP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:15:28 -0500
Message-ID: <20141130221524.20566.qmail@stuge.se>
Date: Sun, 30 Nov 2014 23:15:24 +0100
From: Peter Stuge <peter@stuge.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB driver fixes for 3.18-rc7
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
References: <20141128224028.GA29538@kroah.com> <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I seem to get this problem possibly more commonly at boot these days:
>   usb 1-6: device descriptor read/64, error -71
>   xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
>   usb 1-6: hub failed to enable device, error -22

Since my upgrade to 98e8d2e0 from something a bit older I also get
-71 error messages on boot and on resume, however this is older
hardware with only ehci-pci.

In my case some of the descriptors coming back from the device are bogus
when the device is first seen. The device then disconnects, and when it
is seen again by the kernel, nearly one second later, the descriptors
are fine and there are no errors. vid/pid change from hardware ODM to
OEM, suggesting that my device simply isn't ready when Linux first
talks with it.


//Peter
