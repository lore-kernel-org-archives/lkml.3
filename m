Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3FYOxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:53:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3FYOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:53:44 -0400
Date: Tue, 25 Jun 2013 07:54:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navinp@cdac.in>
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: replace pr_warning() with pr_warn()
Message-ID: <20130625145428.GA19101@kroah.com>
References: <CAPV97yePEe4K_yLKjvY2fmjgeL_xvbka=qi-EsoSJasmFtidVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97yePEe4K_yLKjvY2fmjgeL_xvbka=qi-EsoSJasmFtidVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:27:18PM +0530, navin patidar wrote:
> On Tue, Jun 25, 2013, Greg KH <gregkh@linuxfoundation.org> said:
> 
> > On Fri, Jun 21, 2013 at 03:01:04PM +0530, navin patidar wrote:
> >> pr_warn() is preferred over pr_warning().
> >
> > And dev_warn() is preferred over both of them, can you convert the code
> > to use that instead?
> >
> 
> struct device is not available in usbip_start_eh()  which is required
> for dev_warn().
> 
> usbip_device's containers struct stub_device and struct  vhci_device
> both have member structure usb_device but inside usbip_start_eh(), it
> is difficult to determine  to which container struct usbip_device
> belongs, thus container_of() can not be used here to get struct
> usb_device.

Then the code should be reworked in order to be able to properly
determine that.

greg k-h
