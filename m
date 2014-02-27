Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaB0DqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:46:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbaB0DqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:46:11 -0500
X-IronPort-AV: E=Sophos;i="4.97,551,1389715200"; 
   d="scan'208";a="9612983"
Message-ID: <530EB4EF.8080800@cn.fujitsu.com>
Date: Thu, 27 Feb 2014 11:45:51 +0800
From: Li Guang <lig.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20120421 Iceape/2.0.11
MIME-Version: 1.0
To: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
CC: Kieran Clancy <clancy.kieran@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com> <530EA3E5.3010102@gmail.com> <530EAD92.6020807@cn.fujitsu.com> <530EB176.1050402@gmail.com>
In-Reply-To: <530EB176.1050402@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 11:43:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 11:43:44,
	Serialize complete at 2014/02/27 11:43:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juan Manuel Cabo wrote:
> On 02/27/2014 12:14 AM, Li Guang wrote:
>    
>> oh, sorry, I'm referring internal EC firmware code
>> for Q event queuing, not ACPI SPEC, ;-)
>> for machine you tested, 8 is the queue size,
>> but for some unknown also nasty EC firmwares(let's suppose it exists),
>> it may queue more Q events.
>> and I saw several firmwares queued 32 events by default,
>> then, let's say, they be used for some samsung products,
>> and also they also forgot to deal with sleep/resume state,
>> then, we'll also leave stale Q event there.
>>
>> Thanks!
>>
>>      
> We tested each on our different samsung models (intel, amd), and it
> was 8 across. But you're right, there might be more in the future.
>
>       I even saw a bug report in ubuntu's launchpad of an HP with a similar
> sounding problem, ( https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/89860 )
> which I have no idea if it was caused by the same issue, but if in the future,
> the flag ec_clear_on_resume is used to match other DMI's, it might
> be a good idea to make the max iteration count bigger.
>
>        The only reason that there is a max iteration count, was to prevent
> an unexpected case in which an unknown EC never returns 0 after
> queue emptied. So far it hasn't been the case. Can we count on it?.
> The loop currently does finish early when there are no more events.
>
> I guess changing it 255 or 1000 would be enough, right?
>
>    

can't imagine 1K bytes be dissipated on Q event,
EC's ram is usually expensive,
I think 255 is really enough. :-)

Thanks!



