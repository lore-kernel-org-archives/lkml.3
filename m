Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBZQRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:17:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaBZQRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:17:22 -0500
Message-ID: <530E2518.5090102@suse.de>
Date: Wed, 26 Feb 2014 18:32:08 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sven-Haegar Koch <haegar@sdinet.de>
CC: Dave Hansen <dave.hansen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <530CD443.7010400@intel.com> <4B3C0B08-45E1-48EF-8030-A3365F0E7CF6@suse.de> <530D3102.60504@intel.com> <alpine.DEB.2.10.1402261634010.31425@aurora64.sdinet.de>
In-Reply-To: <alpine.DEB.2.10.1402261634010.31425@aurora64.sdinet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven-Haegar Koch wrote:
> On Tue, 25 Feb 2014, Dave Hansen wrote:
>
>   
>> On 02/25/2014 03:09 PM, Alexander Graf wrote:
>>     
>>>> Couldn't we also (maybe in parallel) just teach the sysctl userspace
>>>> about sysfs?  This way we don't have to do parallel sysctls and sysfs
>>>> for *EVERYTHING* in the kernel:
>>>>
>>>>    sysfs.kernel.mm.transparent_hugepage.enabled=enabled
>>>>         
>>> It's pretty hard to filter this. We definitely do not want to expose all of sysfs through /proc/sys. But how do we know which files are actual configuration and which ones are dynamic system introspection data?
>>>
>>> We could add a filter, but then we can just as well stick with the manual approach I followed here :).
>>>       
>> Maybe not stick it under /proc/sys, but teach sysctl(8) about them.  I
>> guess at the moment, sysctl says that it's tied to /proc/sys:
>>
>>     
>>> DESCRIPTION
>>>        sysctl  is  used to modify kernel parameters at runtime.  The parameters available are those listed under /proc/sys/.  Procfs is required
>>>        for sysctl support in Linux.  You can use sysctl to both read and write sysctl data.
>>>       
>> But surely that's not set in stone just because the manpage says so. :)
>>     
>
> What I still don't get is why you need this?
>
> My distribution (Debian) has a sysfsutils package which provides a 
> /etc/sysfs.conf / /etc/sysfs.d/foo exactly like /etc/sysctl.conf.
>
> Don't other distributions have something like this?
>   

Maybe that's the right answer to the problem, but I still don't
understand why these properties were put into sysfs in the first place.
We're not configuring a dynamic device here, are we?

Also if we do want something like a sysfs.conf and sysfs.d, that should
probably be something that gets properly coordinated between
distributions so that users don't get completely confused. Today
openSUSE does not have a sysfs.conf/.d provided by the sysfsutils
package. Maybe it's something homegrown?


Alex

