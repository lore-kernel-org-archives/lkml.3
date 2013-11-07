Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3KGSvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:51:14 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60361 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KGSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
References: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
	<Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
Date: Thu, 7 Nov 2013 10:51:11 -0800
X-Google-Sender-Auth: b5_LpdUkY8x-mtXx8HHxyLFAOhA
Message-ID: <CAODwPW_bCirtddPssYQ8MFE8_6M47Fcs-sYH8Xb7TuuGysGL=Q@mail.gmail.com>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know either.  But Sarah has said that ports can spontaneously
> go into Compliance Mode for no apparent reason.  If that can happen,
> maybe it can happen while the port is in U3 and the device is
> suspended.  In such cases, though, you'd need to do a reset-resume
> rather than a simple reset.

Okay. Looks like this is a more complicated question so let's keep it
out of this patch. We could always add another check to handle
USB_STATE_SUSPENDED later.

> I think keeping dev_dbg() is best.  If you're searching for the
> solution to a problem, you should have debugging enabled and so you
> ought to see the message.

Sure, I'll submit a second version in a moment.
