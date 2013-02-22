Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3BVVwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:52:13 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40339 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3BVVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:52:11 -0500
Date: Fri, 22 Feb 2013 22:51:58 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130222215158.GA4723@balto.lan>
References: <20130222085954.GA4352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222085954.GA4352@redhat.com>
X-Operating-System: Linux balto 3.8.0-rc2-00017-ge0ebda2 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 03:59:54AM -0500, Dave Jones wrote:
> On Thu, Feb 21, 2013 at 10:40:10AM -0800, Greg KH wrote:
> 
>  > USB patches for 3.9-rc1
>  > 
>  > Here's the big USB merge for 3.9-rc1
>  > 
>  > Nothing major, lots of gadget fixes, and of course, xhci stuff.
> 
> I get no USB devices recognised when I insert them any more, which
> I think is pretty major.  I suspect it has something to do with this ?
> 
>  > Lan Tianyu (12):
>  >       usb: add runtime pm support for usb port device
>  >       usb: add usb port auto power off mechanism
> 
> It looks like every port on my laptop is powered down, as I can't
> even charge devices with it.

Hi Dave,

I have the same problem (and almost the same laptop, Thinkpad T430
here), all external USB ports without power - even the always-on one
:-).

The bug seems to be ACPI related, I bisected it down to this patch:

f95988d ACPI / scan: Treat power resources in a special way

In the dmesg I have some error like these:

ACPI: Power Resource [PUBS] (on)
...
pci 0000:00:14.0: System wakeup disabled by ACPI

for the USB controllers in the broken kernel, there are some in your
dmesg too.  I'll try to come up with a fix for current mainline, but all
the acpi stuff is quite obscure to me and the patch does not revert
cleanly, maybe Rafael (in CC) has some idea!

Fabio

-- 
Fabio Baltieri
