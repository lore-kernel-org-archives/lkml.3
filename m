Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3KFJ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:58:10 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37806 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab3KFJ6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:58:07 -0500
Subject: Re: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <527A112F.6070908@nsn.com>
Date: Wed, 6 Nov 2013 11:57:50 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
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
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FE390E17-5AFB-41AE-9EB3-7EBA3B5D92FF@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com> <527A112F.6070908@nsn.com>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ionut,

On Nov 6, 2013, at 11:51 AM, Ionut Nicu wrote:

> Hi,
> 
> On 05.11.2013 19:41, ext Pantelis Antoniou wrote:
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
> 
> Wouldn't it be easier if echo "-BB-UART2-00A0" > device-tree-overlay-status was
> supported also? That way one doesn't need to know the order in which the
> overlays were applied or parse the status file to get the <ID>.
> 

Unfortunately no since this is a raw bytestream interface; there is no file
information. The patchset does display any root level part-number & version properties
but that's completely options.

We could standardize in a named root property to use on each overlay, and the part-number &
version are as good as any.



>> Removes the overlay.
>> 
>> Note that this seldom works on most platforms since platform_device
>> removal is something that almost never works without extra patches.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> It would be very helpful to me if I would have a notification mechanism
> for overlay add and remove operations based on blocking_notifier_call_chain(),.
> This way other drivers can be notified when the dt changes.
> 

Yes. Some people expressed interest in something similar.

> But I guess that could be added in the future with another patch.
> 

Yep.

> Thanks,
> Ionut

Let's get the basic support in now, and we can fix all of that on later patches.

Regards

-- Pantelis

