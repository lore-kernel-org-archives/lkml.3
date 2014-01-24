Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaAXK5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:57:48 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25569 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaAXK5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:57:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,712,1384300800"; 
   d="scan'208";a="96121406"
Message-ID: <52E24727.6090809@citrix.com>
Date: Fri, 24 Jan 2014 10:57:43 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <ian.campbell@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        <xen-devel@lists.xenproject.org>, Matt Wilson <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH v6] xen/grant-table: Avoid m2p_override	during
 mapping
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com> <20140124054828.GA18522@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20140124054828.GA18522@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/14 05:48, Matt Wilson wrote:
> On Thu, Jan 23, 2014 at 09:23:44PM +0000, Zoltan Kiss wrote:
>> The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
>> for blkback and future netback patches it just cause a lock contention, as
>> those pages never go to userspace. Therefore this series does the following:
>> - the original functions were renamed to __gnttab_[un]map_refs, with a new
>>   parameter m2p_override
>> - based on m2p_override either they follow the original behaviour, or just set
>>   the private flag and call set_phys_to_machine
>> - gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs with
>>   m2p_override false
>> - a new function gnttab_[un]map_refs_userspace provides the old behaviour
>>
>> It also removes a stray space from page.h and change ret to 0 if
>> XENFEAT_auto_translated_physmap, as that is the only possible return value
>> there.
>>
>> v2:
>> - move the storing of the old mfn in page->index to gnttab_map_refs
>> - move the function header update to a separate patch
>>
>> v3:
>> - a new approach to retain old behaviour where it needed
>> - squash the patches into one
>>
>> v4:
>> - move out the common bits from m2p* functions, and pass pfn/mfn as parameter
>> - clear page->private before doing anything with the page, so m2p_find_override
>>   won't race with this
>>
>> v5:
>> - change return value handling in __gnttab_[un]map_refs
>> - remove a stray space in page.h
>> - add detail why ret = 0 now at some places
>>
>> v6:
>> - don't pass pfn to m2p* functions, just get it locally
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Suggested-by: David Vrabel <david.vrabel@citrix.com>
> 
> Apologies for coming in late on this thread. I'm quite behind on
> xen-devel mail that isn't CC: to me.
> 
> It seems to have been forgotten that Anthony and I proposed a similar
> change last November.
> 
> https://lkml.kernel.org/r/1384307336-5328-1-git-send-email-anthony@codemonkey.ws
> 
> Or am I misunderstanding the change?

Yes, it's equivalent.  There doesn't seem to have been a follow up patch
posted for Anthony's patch so it's not surprising that it's fallen
through the cracks.

David
