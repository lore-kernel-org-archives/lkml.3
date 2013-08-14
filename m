Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab3HNVha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:37:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59973 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296Ab3HNVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:37:27 -0400
Message-ID: <520BF88C.6060202@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 14:37:16 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Dave Hansen <dave@sr71.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com> <520BECDF.8060501@sr71.net> <20130814211454.GA17423@variantweb.net>
In-Reply-To: <20130814211454.GA17423@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-7606-0000-0000-00000E58F467
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:14 PM, Seth Jennings wrote:
>> >An existing tool would not work
>> >with this patch (plus boot option) since it would not know how to
>> >show/hide things.  It lets_part_  of those existing tools get reused
>> >since they only have to be taught how to show/hide things.
>> >
>> >I'd find this really intriguing if you found a way to keep even the old
>> >tools working.  Instead of having an explicit show/hide, why couldn't
>> >you just create the entries on open(), for instance?
> Nathan and I talked about this and I'm not sure if sysfs would support
> such a thing, i.e. memory block creation when someone tried to cd into
> the memory block device config.  I wouldn't know where to start on that.
>

Also, I'd expect userspace tools might use readdir() to find out what 
memory blocks a system has (unless they just stat("memory0"), 
stat("memory1")...). I don't think filesystem tricks (at least within 
sysfs) are going to let this magically be solved without breaking the 
userspace API.

