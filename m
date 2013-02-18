Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3BRUkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:40:08 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50985 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab3BRUkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:40:05 -0500
Message-ID: <5122918A.8090307@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 14:39:38 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Ric Mason <ric.masonn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 4/8] zswap: add to mm/
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com> <1360780731-11708-5-git-send-email-sjenning@linux.vnet.ibm.com> <511F0536.5030802@gmail.com> <51227FDA.7040000@linux.vnet.ibm.com> <0fb2af92-575f-4f5d-a115-829a3cf035e5@default>
In-Reply-To: <0fb2af92-575f-4f5d-a115-829a3cf035e5@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021820-9360-0000-0000-000010BE2EDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 01:55 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [PATCHv5 4/8] zswap: add to mm/
>>
>> On 02/15/2013 10:04 PM, Ric Mason wrote:
>>> On 02/14/2013 02:38 AM, Seth Jennings wrote:
>> <snip>
>>>> + * The statistics below are not protected from concurrent access for
>>>> + * performance reasons so they may not be a 100% accurate.  However,
>>>> + * the do provide useful information on roughly how many times a
>>>
>>> s/the/they
>>
>> Ah yes, thanks :)
>>
>>>
>>>> + * certain event is occurring.
>>>> +*/
>>>> +static u64 zswap_pool_limit_hit;
>>>> +static u64 zswap_reject_compress_poor;
>>>> +static u64 zswap_reject_zsmalloc_fail;
>>>> +static u64 zswap_reject_kmemcache_fail;
>>>> +static u64 zswap_duplicate_entry;
>>>> +
>>>> +/*********************************
>>>> +* tunables
>>>> +**********************************/
>>>> +/* Enable/disable zswap (disabled by default, fixed at boot for
>>>> now) */
>>>> +static bool zswap_enabled;
>>>> +module_param_named(enabled, zswap_enabled, bool, 0);
>>>
>>> please document in Documentation/kernel-parameters.txt.
>>
>> Will do.
> 
> Is that a good idea?  Konrad's frontswap/cleancache patches
> to fix frontswap/cleancache initialization so that backends
> can be built/loaded as modules may be merged for 3.9.
> AFAIK, module parameters are not included in kernel-parameters.txt.

This is true.  However, the frontswap/cleancache init stuff isn't the
only reason zswap is built-in only.  The writeback code depends on
non-exported kernel symbols:

swapcache_free
__swap_writepage
__add_to_swap_cache
swapcache_prepare
swapper_space
end_swap_bio_write

I know a fix is as trivial as exporting them, but I didn't want to
take on that debate right now.

Seth

