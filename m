Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3KFJwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:52:37 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:10750 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3KFJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:52:35 -0500
Message-ID: <527A112F.6070908@nsn.com>
Date: Wed, 06 Nov 2013 10:51:43 +0100
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: ext Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
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
Subject: Re: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1838
X-purgate-ID: 151667::1383731511-00004A43-AA4ED47B/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05.11.2013 19:41, ext Pantelis Antoniou wrote:
> Add a runtime interface to /proc to enable generic device tree overlay
> usage.
> 
> Two new /proc files are added:
> 
> /proc/device-tree-overlay & /proc/device-tree-overlay-status
> 
> /proc/device-tree-overlay accepts a stream of a device tree objects and
> applies it to the running kernel's device tree.
> 
> 	$ cat ~/BB-UART2-00A0.dtbo >device-tree-overlay
> 	overlay_proc_release: Applied #2 overlay segments @0
> 
> /proc/device-tree-overlay-status displays the the overlays added using
> the /proc interface
> 
> 	$ cat device-tree-overlay-status
> 	0: 861 bytes BB-UART2:00A0
> 
> The format of the status line is
> 	<ID>: <SIZE> bytes <part-number>:<version>
> 
> <ID> is the id of the overlay
> <SIZE> is the size of the overlay in bytes
> <part-number>, <version> are (optional) root level properties of the DTBO
> 
> You can remove an overlay by echoing the <ID> number of the overlay
> precedded with a '-'
> 
> So
> 	$ echo "-0" >device-tree-overlay-status
> 

Wouldn't it be easier if echo "-BB-UART2-00A0" > device-tree-overlay-status was
supported also? That way one doesn't need to know the order in which the
overlays were applied or parse the status file to get the <ID>.

> Removes the overlay.
> 
> Note that this seldom works on most platforms since platform_device
> removal is something that almost never works without extra patches.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

It would be very helpful to me if I would have a notification mechanism
for overlay add and remove operations based on blocking_notifier_call_chain(),.
This way other drivers can be notified when the dt changes.

But I guess that could be added in the future with another patch.

Thanks,
Ionut
