Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbaGRTAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:00:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55812 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757195AbaGRTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:00:47 -0400
Date: Fri, 18 Jul 2014 15:00:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Patrik Fimml <patrikf@chromium.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Dmitry Torokhov <dtor@google.com>,
        Bastien Nocera <hadess@hadess.net>, <linux-pm@vger.kernel.org>,
        Benson Leung <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <20140718174712.GA3156@google.com>
Message-ID: <Pine.LNX.4.44L0.1407181439560.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Patrik Fimml wrote:

>  2. Give userspace a way of quiescing a device. Handles to the device
>     stay open, but the device will no longer perform its function and,
>     if possible, power down.

"Quiescing" is the wrong word.  "Quiescing a device" means stopping the
device from doing anything, which isn't what you want.  You want to
ignore any activity the device may generate and reduce the device's
power consumption as much as possible.  A better word would be
"deactivating".

> For input devices, this makes a lot of sense in my opinion.

I agree.

> The notable difference to runtime PM as we have it today is that with
> runtime PM, a device typically goes to a low-power state because it is
> idle. In our scenario, we want to forcibly quiesce it even if it is not
> idle (and if it continues to provide events in a low-power mode, we
> want to ignore them instead of passing them on). So maybe integration
> with runtime PM is not the best fit.
> 
> Perhaps the best way to go forward would be to add a new property for
> all devices that support quiescing so userspace has a uniform way of
> doing things, but have subsystems (and potentially the device driver)
> decide what action is appropriate to quiesce a device. Some subsystems
> might be able to provide a default implementation (e.g. input could just
> skip all events that are reported from the device driver).

You mentioned that handles to the device would remain open.  So when 
the user opens the lid again, the old handles would start functioning, 
right?

This has the disadvantage that the class device could not be
unregistered, because doing so would invalidate the open handles.  
Under such circumestances, how would a userspace video program know not
to list a camera built into the lid among the possible video sources
(an example given earlier in this discussion)?  The program would have
to make an explicit test of the "deactivate" property -- it wouldn't
automatically become aware that the camera wasn't available.

Would it sometimes be okay to unregister the class device and
invalidate the old handles, forcing programs to open new handles when
the lid is opened?  This would reduce the number of changes user 
programs would need.

Alan Stern

