Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaBEQ1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:27:11 -0500
Received: from www.sr71.net ([198.145.64.142]:60354 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbaBEQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:27:10 -0500
Message-ID: <52F2665C.6040802@sr71.net>
Date: Wed, 05 Feb 2014 08:27:08 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Kconfig: organize memory-related config options
References: <20140102202014.CA206E9B@viggo.jf.intel.com> <20140102202017.9D167747@viggo.jf.intel.com> <20140205142820.GD2425@dhcp22.suse.cz>
In-Reply-To: <20140205142820.GD2425@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 06:28 AM, Michal Hocko wrote:
> On Thu 02-01-14 12:20:17, Dave Hansen wrote:
>> This continues in a series of patches to clean up the
>> configuration menus.  I believe they've become really hard to
>> navigate and there are some simple things we can do to make
>> things easier to find.
>>
>> This creates a "Memory Options" menu and moves some things like
>> swap and slab configuration under them.  It also moves SLUB_DEBUG
>> to the debugging menu.
>>
>> After this patch, the menu has the following options:
>>
>>   [ ] Memory placement aware NUMA scheduler
>>   [*] Enable VM event counters for /proc/vmstat
>>   [ ] Disable heap randomization
>>   [*] Support for paging of anonymous memory (swap)
>>       Choose SLAB allocator (SLUB (Unqueued Allocator))
>>   [*] SLUB per cpu partial cache
>>   [*] SLUB: attempt to use double-cmpxchg operations
> 
> Is there any reason to keep them in init/Kconfig rather than
> mm/Kconfig? It would sound like a logical place to have them all, no?

These options are the memory-related ones that fall under the "General
setup" menu and the mm/Kconfig ones fall in to "Processor type and
features".  I've been hesitant to move these over to mm/Kconfig just
because I don't want to put more stuff in the arch-specific menus.

You raise a good point, though, that there isn't a great logical
separation about what should go where.  Things like zram and KSM end up
in "Processor type and features" when they're really pretty
architecture-neutral.
