Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaFNNKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:10:38 -0400
Received: from mail1.windriver.com ([147.11.146.13]:32979 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaFNNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:10:37 -0400
Message-ID: <539C49B3.7000606@windriver.com>
Date: Sat, 14 Jun 2014 21:10:11 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <mina86@mina86.com>, <andrzej.p@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406130935500.1059-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406130935500.1059-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 09:39 PM, Alan Stern wrote:
> On Fri, 13 Jun 2014, Yang,Wei wrote:
>
>> On 06/09/2014 02:19 PM, Wei.Yang@windriver.com wrote:
>>> From: Yang Wei <Wei.Yang@windriver.com>
>>>
>>> While loading g_mass_storage module, the following warning
>>> is triggered.
>>>
>>> WARNING: at drivers/usb/gadget/composite.c:
>>> usb_composite_setup_continue: Unexpected call
>>> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
>>> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
>>> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
>>> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
>>> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
>>> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
>>> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
>>> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
>>> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
>>>
>>> The root cause is that the existing code fails to take into
>>> account the possibility that common->new_fsg can change while
>>> do_set_interface() is running, because the spinlock isn't held
>>> at this point.
>>>
>>> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
>>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>>> ---
>>>    drivers/usb/gadget/f_mass_storage.c |    6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> Hi Alan,
>>>
>>> Thanks for your review, there are a few changes in v3:
>>>
>>> 1) Fix a coding style issue.
>>> 2) Refine the commit log
>>>
>>> Regards
>>> Wei
>> Ping, Alan, What do you think of it?
> You should not have added my "Signed-off-by:"; I did not give you
> permission to do that.

Sorry for it, I considered that you give me a few advice and hep me to 
refine the commit log,
so I added your signed off. Sorry again!

>
> Michal's comment about common->new_fsg not being protected by the lock
> is a good one.  It would be better for the patch description to say:
>
> 	The value of common->new_fsg that gets tested after
> 	do_set_interface() returns needs to be the same as the value
> 	used by do_set_interface().
>
> With that change, you may add
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Okay, I would use the above description in v4.

Regards
Wei
>
> Alan Stern
>
>
>

