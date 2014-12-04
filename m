Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaLDWra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:47:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaLDWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:47:29 -0500
Date: Thu, 4 Dec 2014 14:47:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Generate uppercase hex for modalias var in uevent
Message-ID: <20141204224728.GA26134@kroah.com>
References: <1417538104-27341-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417538104-27341-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:35:04PM +0100, Ricardo Ribalda Delgado wrote:
> Some implementations of modprobe fail to load the driver for a PCI device
> automatically because the "interface" part of the modalias from the kernel
> is lowercase, and the modalias from file2alias is uppercase.
> 
> The "interface" is the low-order byte of the Class Code, defined in PCI
> r3.0, Appendix D.  Most interface types defined in the spec do not use
> alpha characters, so they won't be affected.  For example, 00h, 01h, 10h,
> 20h, etc. are unaffected.
> 
> Print the "interface" byte of the Class Code in uppercase hex, as we
> already do for the Vendor ID, Device ID, Class, etc.
> 
> Commit 89ec3dcf17fd ("PCI: Generate uppercase hex for modalias
> interface class") fixed only half of the problem. Some udev
> implementations relays on the uevent file and not in the modalias file.
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Fixes: d1ded203adf1 ("PCI: add MODALIAS to hotplug event for pci devices")
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> 
> Modified line is >80 char, but I believe that it is better than breaking
> the string or indent it bad.


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
