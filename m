Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3IIXAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:00:51 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:55948 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3IIXAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:00:49 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Pavel Machek <pavel@denx.de>, kernel list <linux-kernel@vger.kernel.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: TODO list for drivers/staging/dwc2?
Thread-Topic: TODO list for drivers/staging/dwc2?
Thread-Index: AQHOqKS3VzRSskVrKEWmyTgxDJyTgZm+BbEA
Date: Mon, 9 Sep 2013 23:00:47 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E00E31@US01WEMBX2.internal.synopsys.com>
References: <20130903125421.GA11846@amd.pavel.ucw.cz>
In-Reply-To: <20130903125421.GA11846@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@denx.de]
> Sent: Tuesday, September 03, 2013 5:54 AM
> 
> Hi!
> 
> Is there TODO list for `subj`? I'll need that code on socfpga cyclone
> 5, so it makes sense to help with cleanups, but it looks in pretty
> good shape already...

Hi Pavel,

Here is the TODO list:

- Need to merge the microframe scheduler patch from Denx/Raspberry Pi
(see http://marc.info/?l=linux-usb&m=137625068103835). I will resubmit
that one after the merge window closes and Greg is taking patches again.
But even after that more scheduling improvements may be needed.

- Should merge the NAK holdoff patch from Raspberry Pi
(http://marc.info/?l=linux-usb&m=137625067103833). But that patch is
incomplete, it needs more investigation to see if it can be made to work
for non-Raspberry Pi platforms that lack the special FIQ interrupt that
the Pi has. Without this, the driver has a high interrupt rate (8K/sec).

- The Raspberry Pi platform needs to have support for its FIQ interrupt
added, to get the same level of functionality as the downstream driver
has. The raspberrypi.org developers have indicated they are willing to
help with that.

- Some of the default driver parameters (see 'struct dwc2_core_params'
in core.h) won't work for many platforms. So DT attributes will need to
be added for some of these. But that can be done as-needed as new
platforms are added.

- Eventually the driver should be merged with the s3c-hsotg peripheral
mode driver, so that both modes of operation can be supported with a
single driver. I think that can wait till after the driver has been
moved to mainline.

- After that, OTG support can be added. I'm not sure how much demand
there is for that, though, so I have that as a low priority.

I think after the first two items are done the driver can be moved to
mainline.

Matthijs, do you have anything to add?

-- 
Paul

