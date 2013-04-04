Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243Ab3DDHw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763871Ab3DDHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:52:57 -0400
Message-ID: <515D312A.8000909@redhat.com>
Date: Thu, 04 Apr 2013 09:52:10 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3.7+] HID: magicmouse: fix race between input_register()
 and probe()
References: <1364893912-29578-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1304040951020.30938@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1304040951020.30938@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 09:51 AM, Jiri Kosina wrote:
> On Tue, 2 Apr 2013, Benjamin Tissoires wrote:
> 
>> Since kernel 3.7, it appears that the input registration occured before
>> the end of magicmouse_setup_input(). This is shown by receiving a lot of
>> "EV_SYN SYN_REPORT 1" instead of normal "EV_SYN SYN_REPORT 0".
>> This value means that the output buffer is full, and the user space
>> is loosing events.
>>
>> Using .input_configured guarantees that the race is not occuring, and that
>> the call of "input_set_events_per_packet(input, 60)" is taken into account
>> by input_register().
>>
>> Fixes:
>> https://bugzilla.redhat.com/show_bug.cgi?id=908604
>>
>> Reported-and-Tested-By: Clarke Wixon <cwixon@usa.net>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>
>> Hi Jiri,
>>
>> this one can goes to stable (so 3.8) as well.
> 
> Applied, and will push for 3.9 still.

Ok, thanks Jiri.

Cheers,
Benjamin

> 
> Thanks.
> 

