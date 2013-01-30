Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3A3IYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:24:31 -0500
Received: from canardo.mork.no ([148.122.252.1]:53681 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3A3IY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:24:29 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniele Palmas <dnlplm@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: option: add support for Telit LE920
Organization: m
References: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
	<1359479958.1635.8.camel@dcbw.foobar.com>
	<871ud3q4sr.fsf@nemi.mork.no>
	<CAGRyCJFxe4sg_GhimQjTG+jSb8CYJRP3wGcJDEJSq6Uek0Y_iQ@mail.gmail.com>
Date: Wed, 30 Jan 2013 09:23:43 +0100
In-Reply-To: <CAGRyCJFxe4sg_GhimQjTG+jSb8CYJRP3wGcJDEJSq6Uek0Y_iQ@mail.gmail.com>
	(Daniele Palmas's message of "Wed, 30 Jan 2013 08:13:28 +0100")
Message-ID: <87txpznkog.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> The output of lsusb for interface #1 is the following:
>
> Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass     66
>       bInterfaceProtocol      1
>       iInterface              0
>
> It should be an adb device, so probably it is not needed to blacklist
> it. Should I resend a new patch with only interface #5 reserved?

You could have used USB_DEVICE_AND_INTERFACE_INFO() matching on all
ff/ff/ff to avoid blacklisting the adb interface, but IMHO the patch is
fine as it is.

This being an Android device raises another question though: Are these
interface numbers static?  I assume you can e.g. disable adb?  What
happens to the descriptors then?  Does the device change pid, or are the
interfaces renumbered?


Bjørn
