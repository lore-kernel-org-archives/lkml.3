Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaCIQ6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 12:58:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaCIQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 12:58:03 -0400
Date: Sun, 9 Mar 2014 09:58:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, Andy Grover <andy.grover@gmail.com>,
        ihadzic@research.bell-labs.com
Subject: Re: [PATCH 00/18] Resend of usbip-utils migration patches and
 various other fixes
Message-ID: <20140309165841.GA30196@kroah.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
 <20140309065059.GA10398@kroah.com>
 <CABdoFFco0zSDZ_21FbErKjPyX_R-kz+7WY-VuYa2q=KgRbX6vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdoFFco0zSDZ_21FbErKjPyX_R-kz+7WY-VuYa2q=KgRbX6vg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 05:53:51PM +0200, Valentina Manea wrote:
> I was notified that one of the patches in the series (staging: usbip:
> claim ports used by shared devices) breaks the build.
> I take full responsability for this as I haven't compiled the kernel
> with allyesconfig and I am sorry.

No worries, it happens to all of us :)

> This can be fixed by moving struct dev_state, usb_hub_claim_port() and
> usb_hub_release_port() declarations from include/linux/usb.h to
> usbip/stub.h, and leaving the declarations in usb/core/usb.h
> untouched.
> 
> Should the fix come as a separate patch or v2 of the broken one?

No, I can't redo the patch that I've already committed.

As "dev_state" is a very generic term, how about we just rename it to
something more USB specific, like usb_dev_state?  That way it would fix
the build issue, and keep it from being a problem in the future in other
drivers.

thanks,

greg k-h
