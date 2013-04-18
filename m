Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966438Ab3DRHx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398Ab3DRHx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:53:26 -0400
Message-ID: <516FA648.20207@redhat.com>
Date: Thu, 18 Apr 2013 09:52:40 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] HID: debugfs rework
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1304171041070.31201@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1304171041070.31201@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 07:44 PM, Jiri Kosina wrote:
> On Wed, 17 Apr 2013, Benjamin Tissoires wrote:
> 
>> Hi Jiri,
>>
>> This is a small rework of the HID debugfs.
>> I encountered a problem with multitouch devices: they have too much usages to
>> fit into the fixed size output buffer of 512.
>> So I digg a little, and end up with those 4 patches.
> 
> Hi Benjamin,
> 
> thanks, I will look into it and see whether I would be able to apply it 
> still for 3.10 merge window.

Thanks. I think patches 1 and 2 of this series are pretty straightforward.
Patches 3 and 4 will maybe require a little bit more attention.

I don't mind if it's postponed to 3.11 (given the long time this has
been broken for devices with big reports).
I just need to access HID debugfs for hid-replay when hidraw does not
send anything. But as I'm also willing to use hid-replay with current
kernels, I still need a way to use the best option (hidraw or hid
debugfs) for current kernels.

> 
> I also have a locking fix for HID-debugfs which I am going to apply 
> shortly, but I am travelling this week, so I am in a bit degraded mode.
> 
> For reference, locking fix below.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: protect hid_debug_list
> 
> Accesses to hid_device->hid_debug_list are not serialized properly, which
> could result in SMP concurrency issues when HID debugfs events are accessesed

s/accessesed/accessed ?

> by multiple userspace processess.

s/processess/processes ?

> 
> Serialize all the list operations by a mutex.
> 
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I also have a patch regarding forcing hidraw output even if raw_event
returns > 0, but I'll send it over a new thread. This thread will start
to be quite complicate to follow otherwise... :)

Cheers,
Benjamin
