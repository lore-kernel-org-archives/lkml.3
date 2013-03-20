Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3CTOt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:49:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757113Ab3CTOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:49:57 -0400
Date: Wed, 20 Mar 2013 10:49:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Vincent Palatin <vpalatin@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Sameer Nanda <snanda@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: Make USB persist default configurable
In-Reply-To: <CAODwPW8bAo-ixwmJjGPT94kDVSb+4qO264mOXyZ5RjmisTkYFQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303201045250.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Julius Werner wrote:

> > Yes, okay, that's true.  If a new USB device is plugged in while the
> > lid is shut, and then the lid is opened very briefly, it's possible
> > that the system could suspend again before the new device's "persist"
> > attribute is updated.  Does that case really matter?  The device isn't
> > likely to be in use at that point.
> 
> It does matter if the device will be used after the next resume,
> because that one would use the persist code. If there was a driver
> problem it would fail, and if it was a USB stick that is swapped with
> a different one of the same model, you could get file system
> corruption.

To be honest, when it comes to filesystem corruption and lost data, you
should be more worried about the consequences of leaving "persist"
turned off than of leaving it on.  Be that as it may...

> I agree with you that buggy drivers should get fixed (and we are
> trying to do that as well), but at the same time we want to be able to
> have a system that can keep its policies at all times. We get a lot of
> USB problems (especially around suspend/resume), and we don't want to
> need to worry every time about which code path we hit and whether one
> of those race conditions could have something to do with it. I'm
> convinced that having this in the kernel is the cleanest solution for
> us, and I just thought it might be useful to standardize a mechanism
> for that (I don't really see the maintenance burden in that config
> option either, as the persist mechanism itself does not look like it
> was going to go away anytime soon).

If you feel strongly about this, I don't have any real objection to 
adding the Kconfig option.  Practically everyone will leave it in its 
default state and ignore the whole thing.

Alternatively, you could keep the patch out of mainline, as an in-house
addition to your own kernels.  That would require more effort on your 
part, though.

Alan Stern

