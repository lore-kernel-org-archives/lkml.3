Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaCMOUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:20:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42591 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752262AbaCMOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:20:08 -0400
Date: Thu, 13 Mar 2014 10:20:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jagdish Gedia <jvgediya@gmail.com>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Check if usb device is suspended
In-Reply-To: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403131017430.1292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Jagdish Gedia wrote:

> Hi,
> I want to check in my driver if usb device is suspended or not?

Why do you need to check?  Your driver gets told every time the device 
suspends and every time it resumes.  Therefore it should already know 
the answer.

> currently i am doing it like
> 
> if(udev->state==USB_STATE_SUSPENDED)
> 
> Is this the proper way? Is this enough?

Aside from the fact that the device's state may change immediately 
after you make this test, as Oliver pointed out, you also should 
realize that this test might not give the correct answer if the device 
is in the middle of suspending or resuming when the test runs.

Alan Stern

