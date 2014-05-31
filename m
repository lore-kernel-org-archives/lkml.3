Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaEaHJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 03:09:53 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55355 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaEaHJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 03:09:52 -0400
Message-ID: <53898034.4030400@ahsoftware.de>
Date: Sat, 31 May 2014 09:09:40 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: [PATCH 1/2] bluetooth: don't include local processing of HCI
 commands in the command timeout
References: <1400076025-5103-1-git-send-email-holler@ahsoftware.de> <C2044AE9-519F-4A3D-BA6D-1076318AA4F5@holtmann.org> <53897A95.6030904@ahsoftware.de>
In-Reply-To: <53897A95.6030904@ahsoftware.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.05.2014 08:45, schrieb Alexander Holler:
> Am 31.05.2014 07:28, schrieb Marcel Holtmann:

>> so I actually wonder if we should move away from timer and move to a delayed work item to handle the timeout and if that would actually fix this issue.
>
> The problem is that I have absolutely no clue where these timeouts do
> come from. They appear for different commands and almost always only at
> boot. If the machine did come up without hci command timeouts, there
> never was one afterwards. So I digged in the dark and the above patch
> was one of the results. But I still had to increase the command timeout.
> And I can't do much testing as I use this box. I just experience this
> problem almost always when I boot it (to do kernel updates) and since a
> very long time (more than a year I think).

And I should mention that I had these timeouts with a different dongle 
too (I switched from a bt 3.x dongle to a bt 4.x dongle around a year 
ago). But as said, in the commit msg, the old behaviour might have 
masked different problems like deadlocks or similiar too, so I just 
might have experienced several different problems.

Regards,

Alexander Holler

.

