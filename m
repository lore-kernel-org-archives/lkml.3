Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaBUPQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:16:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42536 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755941AbaBUPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:16:38 -0500
Date: Fri, 21 Feb 2014 10:16:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Warning from USC core on kernel 3.13
In-Reply-To: <530671BF.30909@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1402211007140.1273-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Larry Finger wrote:

> Alan,
> 
> The Lenovo Yogi 13 tablet comes with a Realtek RTL8723AU wireless device built 
> in. Realtek sent me a driver that I modified so that it would build on new 
> kernels, and created a GitHub repo so that it would be available to the 
> community. One of the users of this driver is reporting intermittent warnings 
> that say
> 
> WARNING: CPU: 1 PID: 0 at drivers/usb/core/urb.c:452 usb_submit_urb+0x205/0x5d0()
> usb 1-1.4: BOGUS urb xfer, pipe 3 != type 1
> 
> The full splat is available at http://pastebin.com/VcFPd4Yt.
> 
> As no other user has reported this problem, I think this is some kind of problem 
> with the wireless device or the adapter on this box. Even so, I would like to 
> know more about what is happening. In addition, Jes Sorensen at RedHat is 
> working on making the driver suitable for submission to the staging part of the 
> tree. Just in case other uses run into the problem, it would be good to know if 
> a fix is possible.
> 
> Can you suggest any addition logging for when this situation occurs? The user is 
> generating his own kernels, thus we can add any patches we want.

You probably don't need any additional logging.

The WARNING is telling you that the usb_read_interrupt_complete() 
routine in the 8723au driver called usb_submit_urb() with an incorrect 
pipe value.  The URB specified a BULK pipe, but the endpoint in 
question is actually an INTERRUPT endpoint.

Alan Stern

