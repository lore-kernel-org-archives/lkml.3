Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaHVJYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:24:11 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:37306 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaHVJYJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 22 Aug 2014 05:24:09 -0400
Message-Id: <53F72856020000780002C93D@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 22 Aug 2014 10:24:06 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Toshi Kani" <toshi.kani@hp.com>, "Juergen Gross" <JGross@suse.com>
Cc: <stefan.bader@canonical.com>, <x86@kernel.org>,
        <ville.syrjala@linux.intel.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH RFC 1/3] x86: Make page cache mode a
 real type
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
 <1408454745-32358-2-git-send-email-jgross@suse.com>
 <1408562787.28990.65.camel@misato.fc.hp.com> <53F5BC2F.8050609@suse.com>
In-Reply-To: <53F5BC2F.8050609@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.08.14 at 11:30, <JGross@suse.com> wrote:
> On 08/20/2014 09:26 PM, Toshi Kani wrote:
>> On Tue, 2014-08-19 at 15:25 +0200, jgross@suse.com wrote:
>>> --- a/arch/x86/mm/init.c
>>> +++ b/arch/x86/mm/init.c
>>> @@ -27,6 +27,35 @@
>>>
>>>   #include "mm_internal.h"
>>>
>>> +/*
>>> + * Tables translating between page_cache_type_t and pte encoding.
>>> + * Minimal supported modes are defined statically, modified if more supported
>>> + * cache modes are available.
>>> + * Index into __cachemode2pte_tbl is the cachemode.
>>> + * Index into __pte2cachemode_tbl are the caching attribute bits of the pte
>>> + * (_PAGE_PWT, _PAGE_PCD, _PAGE_PAT) at index bit positions 0, 1, 2.
>>> + */
>>> +uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
>>> +	[_PAGE_CACHE_MODE_WB]		= 0,
>>> +	[_PAGE_CACHE_MODE_WC]		= _PAGE_PWT,
>>> +	[_PAGE_CACHE_MODE_UC_MINUS]	= _PAGE_PCD,
>>> +	[_PAGE_CACHE_MODE_UC]		= _PAGE_PCD | _PAGE_PWT,
>>> +	[_PAGE_CACHE_MODE_WT]		= _PAGE_PWT,
>>> +	[_PAGE_CACHE_MODE_WP]		= _PAGE_PWT,
>>> +};
>>
>> I think WT and WP should be set to _PAGE_PCD (UC_MINUS) for safe.
> 
> Oh, you are right.

Actually I suppose the original comment was about WC and WP;
defaulting WT to _PAGE_PWT seems quite correct to me.

Jan

