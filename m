Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LBL1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:27:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:53729 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBL1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:27:45 -0500
X-IronPort-AV: E=Sophos;i="4.93,810,1378857600"; 
   d="scan'208";a="77271418"
Message-ID: <529C6EAC.4030408@citrix.com>
Date: Mon, 2 Dec 2013 11:27:40 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated poweroff
 and XenBus.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com> <528DEA00.7070505@citrix.com> <20131126164552.GF2959@phenom.dumpdata.com>
In-Reply-To: <20131126164552.GF2959@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/13 16:45, Konrad Rzeszutek Wilk wrote:
> On Thu, Nov 21, 2013 at 11:09:52AM +0000, David Vrabel wrote:
>> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
>>> There is a race case where the user does 'poweroff'
>>> and at the same time the system admin does 'xl shutdown'.
>>
>> This isn't a Xen-specific problem is it?  Wouldn't it be better to fix
>> this in generic code?
> 
> Possibly. I believe the reason for the reboot_notifier to exist is
> to provide a means to fix the race.
> 
>>
>> Especially since I don't think this patch actually fixes the race
>> completely.
>>
>>> --- a/drivers/xen/manage.c
>>> +++ b/drivers/xen/manage.c
>> [...]
>>> @@ -222,7 +230,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
>>>  	};
>>>  	static struct shutdown_handler *handler;
>>>  
>>> -	if (shutting_down != SHUTDOWN_INVALID)
>>> +	if (atomic_read(&shutting_down) != SHUTDOWN_INVALID)
>>>  		return;
>>
>> In guest initiated poweroff at this time will still race with this
>> toolstack initiated poweroff.
> 
> No, b/c the reboot notifier would have set 'shutting_down' already.

If the guest initiated power off is started here, the reboot notifier
won't have run yet.

David
