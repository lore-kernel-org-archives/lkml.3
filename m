Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3HRTiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:38:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3HRTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:38:20 -0400
Date: Sun, 18 Aug 2013 12:40:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yann Droneaud <yann@droneaud.fr>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Wei Shuai <cpuwolf@gmail.com>,
        Frans Klaver <frans.klaver@xsens.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: fix stringify operator in usb-serial-simple
Message-ID: <20130818194005.GA19107@kroah.com>
References: <1376854140-16904-1-git-send-email-yann@droneaud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376854140-16904-1-git-send-email-yann@droneaud.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 09:29:00PM +0200, Yann Droneaud wrote:
> From: Yann Droneaud <ydroneaud@opteya.com>
> 
> usb-serial-simple uses an unknown stringify macro that make
> all drivers being named "stringify(vendor)".
> 
> This can be a problem when two drivers have the same (wrong) name:
> 
>     kernel: usbcore: registered new interface driver usb_serial_simple
>     kernel: usbserial: USB Serial support registered for stringify(vendor)
>     kernel Error: Driver 'stringify(vendor)' is already registered, aborting...
>     kernel: usbserial: problem -16 when registering driver stringify(vendor)
>     kernel: usbserial: USB Serial deregistering driver stringify(vendor)
>     kernel: usbcore: deregistering interface driver usb_serial_simple
> 

Ugh, sorry about that, I thought there used to be a stringify() macro
that used to do this.  Nice patch, I'll queue it up.

greg k-h
