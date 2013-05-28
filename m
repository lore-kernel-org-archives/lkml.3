Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3E1U6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:58:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:20184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab3E1U6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,759,1363158000"; 
   d="scan'208";a="320964673"
Date: Tue, 28 May 2013 13:58:42 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Shawn Nematbakhsh <shawnn@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
Message-ID: <20130528205842.GE32085@xanatos>
References: <20130524210503.GC15788@xanatos>
 <Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
 <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 09:57:57AM -0700, Shawn Nematbakhsh wrote:
> Hi Sarah and Alan,
> 
> Thanks for the comments. I will make the following revisions:
> 
> 1. Call pm_runtime_get_noresume only when the first device is connected,
> and call pm_runtime_put when the last device is disconnected.
> 2. Wrap the calls in an ifdef CONFIG_USB_DEFAULT_PERSIST.
> 3. Make sure that all pm_runtime_get_noresume calls have a corresponding
> pm_runtime_put somewhere (originally the intent was to disable runtime
> suspend "forever", but no longer).
> 
> In principle, would the patch be acceptable with these revisions?

Maybe, but I still don't like this approach, because it's too
heavy-handed.

I was considering whether userspace could do something similar to this
approach, but with udev rules instead of within the kernel.   You could
add a udev rule to trigger on USB device insertion, that would disable
runtime PM for the host, and a corresponding rule that re-enabled
runtime PM when the last USB device was disconnected.

I think it could be possible if userspace can get to the DMI information
for the system.  However, then we open the other can of worms by needing
to keep the userspace quirks list in sync with the kernel quirks list.

What if we exposed the xHCI quirks through a new quirks file in
/sys/bus/usb/devices/usbN/?  That would mean userspace doesn't need to
keep the quirks list separately.

Sarah Sharp
