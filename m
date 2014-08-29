Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaH2EIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 00:08:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaH2EIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 00:08:19 -0400
Message-ID: <53FFFCAF.8030409@suse.com>
Date: Fri, 29 Aug 2014 06:08:15 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/3] x86: Enable PAT to use cache mode translation tables
References: <1409033783-12136-1-git-send-email-jgross@suse.com>	 <1409033783-12136-3-git-send-email-jgross@suse.com> <1409268069.28990.120.camel@misato.fc.hp.com>
In-Reply-To: <1409268069.28990.120.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 01:21 AM, Toshi Kani wrote:
> On Tue, 2014-08-26 at 08:16 +0200, Juergen Gross wrote:
>> Update the translation tables from cache mode to pgprot values according to
>> the PAT settings. This enables changing the cache attributes of a PAT index in
>> just one place without having to change at the users side.
>>
>> With this change it is possible to use the same kernel with different PAT
>> configurations, e.g. supporting Xen.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>
> I know I sent my review-by before, but my build test failed...
>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 8981cc8..d7bf551 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1574,6 +1574,7 @@ extern void free_area_init(unsigned long * zones_size);
>>   extern void free_area_init_node(int nid, unsigned long * zones_size,
>>   		unsigned long zone_start_pfn, unsigned long *zholes_size);
>>   extern void free_initmem(void);
>> +extern void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
>
> This new interface cannot be defined in this common header file since
> page_cache_mode is only defined in x86.  It should be defined in x86
> header, such as pat.h.

Oh, right you are.

Thanks,

Juergen

