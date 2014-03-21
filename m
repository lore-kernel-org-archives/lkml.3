Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbaCULrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:47:12 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48610 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaCULrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1403131017430.1292-100000@iolanthe.rowland.org>
References: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
	<Pine.LNX.4.44L0.1403131017430.1292-100000@iolanthe.rowland.org>
Date: Fri, 21 Mar 2014 17:17:09 +0530
Message-ID: <CAOAoqGuiBrg_tYhdNXd3r48YC9KQ5GNm7jrV4ttNiMjNkrCKRA@mail.gmail.com>
Subject: Re: Check if usb device is suspended
From: Jagdish Gedia <jvgediya@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>, oneukum@suse.de
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to resume the usb device on some event, so i want to check if
it is suspended. I think by above method i can check if the device is
already suspended, but may be i will miss to resume the device if it
is suspending. Is there any way through which i can check if device is
suspending?

On Thu, Mar 13, 2014 at 7:50 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Mar 2014, Jagdish Gedia wrote:
>
>> Hi,
>> I want to check in my driver if usb device is suspended or not?
>
> Why do you need to check?  Your driver gets told every time the device
> suspends and every time it resumes.  Therefore it should already know
> the answer.
>
>> currently i am doing it like
>>
>> if(udev->state==USB_STATE_SUSPENDED)
>>
>> Is this the proper way? Is this enough?
>
> Aside from the fact that the device's state may change immediately
> after you make this test, as Oliver pointed out, you also should
> realize that this test might not give the correct answer if the device
> is in the middle of suspending or resuming when the test runs.
>
> Alan Stern
>
