Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3FYXjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:39:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3FYXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:39:12 -0400
Date: Tue, 25 Jun 2013 16:39:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130625233911.GA1087@kroah.com>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
 <20130619225315.GB12282@kroah.com>
 <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
 <20130621235603.GA1603@kroah.com>
 <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 08:54:43PM +0200, Anders Hammarquist wrote:
> In a message of Fri, 21 Jun 2013 16:56:03 -0700, Greg KH writes:
> >Please resend this in a format that I can apply it in (i.e. one that
> >does not require me to edit it by hand...)
> 
> After more fighting with git, I belive I now made it spit out what I
> wanted. Patch 1/2 ahead.
> 
> >> -static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
> >> +static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {
> >
> >That's a mess, why have it be a static array at all?  Just include an
> >empty one at the end.
> 
> Indeed. I'd already had some (failed) thoughts about how to handle it
> nicely. Now I've had another think through, and I have something which
> deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
> without changing the initializer. Patch 2/2

Why don't we just drop the extra id thing entirely?  The usb-serial
subsystem handles new device ids being added dynamically from sysfs for
a long time now.  Removing this module option would clean up the code a
lot, and prevent these errors from ever happening again.

thanks,

greg k-h
