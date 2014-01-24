Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaAXUbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:31:07 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55404 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaAXUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:31:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140124190831.GA6449@saruman.home>
References: <CA+5PVA7P=3b6oGG4pwR-q-Uy+V2hu5N-f5-fO4NdsB8ytvLz7w@mail.gmail.com>
	<20140124190831.GA6449@saruman.home>
Date: Fri, 24 Jan 2014 15:31:04 -0500
X-Google-Sender-Auth: kjrve4GMzEjqmbe0vkSqwumS_JA
Message-ID: <CA+5PVA5XSQY8GpwpPfQXr_JWM+wBqD2dHK4vxMJZP6Yq1U2EKg@mail.gmail.com>
Subject: Re: Odd 'unable to find transceiver' messages from USB with
 v3.13-3260-g03d11a0 and later
From: Josh Boyer <jwboyer@fedoraproject.org>
To: balbi@ti.com
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        valentine.barshak@cogentembedded.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 2:08 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Jan 24, 2014 at 08:47:07AM -0500, Josh Boyer wrote:
>> We've had a report [1] of the USB layer throwing out 'unable to find
>> transceiver' messages during boot with the 3.14 merge window kernels.
>> I've seen this on my personal machine as well and included the dmesg
>> section below.  This does not happen with the 3.13 kernel.
>>
>> There are only a handful of files in git that have that error, but I
>> haven't seen anything that immediately strikes me as causing this.
>> From the dmesg output it looks like it is spit out right before a host
>> controller is registered?  USB seems to be still working OK in my
>> minimal testing, so the error message is confusing.
>>
>> Thoughts?
>
> looks like it was caused because of this commit:
>
> commit 1ae5799ef63176cc75ec10e545cb65f620a82747
> Author: Valentine Barshak <valentine.barshak@cogentembedded.com>
> Date:   Wed Dec 4 01:42:22 2013 +0400
>
>     usb: hcd: Initialize USB phy if needed

Yeah, I'm pretty sure my bisect agrees with you.

> usb_get_phy_device() will pr_err() when a PHY isn't found. Looks like
> that should be pr_debug() since everything still works even without a
> PHY.

Seems correct.  Who should write up the patch?

josh
