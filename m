Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3KLIlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:41:04 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:54248 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530Ab3KLIks convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:40:48 -0500
Subject: Re: [PATCH v3 3/3] DT: proc: Add runtime overlay interface in /proc
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131111184736.3DE20C4234E@trevor.secretlab.ca>
Date: Tue, 12 Nov 2013 09:40:38 +0100
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <86657251-2872-4FB2-B71A-519A685B458A@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com> <20131111184736.3DE20C4234E@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 11, 2013, at 7:47 PM, Grant Likely wrote:

> On Fri,  8 Nov 2013 17:06:10 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Add a runtime interface to /proc to enable generic device tree overlay
>> usage.
>> 
>> Two new /proc files are added:
>> 
>> /proc/device-tree-overlay & /proc/device-tree-overlay-status
>> 
>> /proc/device-tree-overlay accepts a stream of a device tree objects and
>> applies it to the running kernel's device tree.
>> 
>> 	$ cat ~/BB-UART2-00A0.dtbo >device-tree-overlay
>> 	overlay_proc_release: Applied #2 overlay segments @0
>> 
>> /proc/device-tree-overlay-status displays the the overlays added using
>> the /proc interface
>> 
>> 	$ cat device-tree-overlay-status
>> 	0: 861 bytes BB-UART2:00A0
>> 
>> The format of the status line is
>> 	<ID>: <SIZE> bytes <part-number>:<version>
>> 
>> <ID> is the id of the overlay
>> <SIZE> is the size of the overlay in bytes
>> <part-number>, <version> are (optional) root level properties of the DTBO
>> 
>> You can remove an overlay by echoing the <ID> number of the overlay
>> precedded with a '-'
>> 
>> So
>> 	$ echo "-0" >device-tree-overlay-status
>> 
>> Removes the overlay.
>> 
>> Note that this seldom works on most platforms since platform_device
>> removal is something that almost never works without extra patches.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Why /proc? Did you consider using the firmware loading mechanism? While
> I expressed concerned about the capebus approach, the loading of
> overlays needs to remain under the control of either a driver or the
> platform. By default it should not be possible to drop an arbitrary
> overlay into /proc/device-tree-overlay and have things change in the
> base tree. Along the same lines, I would expect for the device driver or
> platform to be able to filter or limit the parts of the tree that are
> allowed to be modified.
> 

The firmware loading mechanism is the preferred way to handle it, and is
in fact what is used in practice by the whole cape manager mechanism.
But that's part of specific board support, and this is more like a general
way to use overlays, in any kind of DT enabled system.

I agree this is a) completely dangerous and b) /proc is a bad place to put
it. I put it here in order to get the ball rolling, about the proper place
to put device tree related interfaces.

The good thing about this interface is that it's always available, and
it is good for debugging (especially loading/unloading debugging).
 

> A side benefit of the firmware loader is that the kernel can obtain the
> overlay on its own if needed at boot time without userspace involvement.
> 

Yes, that is correct, and it is the way we use it on the beaglebone.
The root fs device is present on a overlay, which is built into the kernel's
firmware.


> g.
> 

Regards

-- Pantelis

