Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaFBQsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:48:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:58888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbaFBQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,957,1392192000"; 
   d="scan'208";a="550310497"
Message-ID: <538CAA13.2080708@intel.com>
Date: Mon, 02 Jun 2014 09:45:07 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: akpm@linux-foundation.org, koct9i@gmail.com, fengguang.wu@intel.com,
        acme@redhat.com, bp@alien8.de, kirill@shutemov.name,
        hannes@cmpxchg.org, rusty@rustcorp.com.au, davem@davemloft.net,
        andres@2ndquadrant.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] replace PAGECACHE_TAG_* definition with enumeration
References: <20140521193336.5df90456.akpm@linux-foundation.org> <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1401686699-9723-2-git-send-email-n-horiguchi@ah.jp.nec.com> <538CA269.6010300@intel.com> <1401727052-f7v7kykv@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401727052-f7v7kykv@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 09:37 AM, Naoya Horiguchi wrote:
> On Mon, Jun 02, 2014 at 09:12:25AM -0700, Dave Hansen wrote:
>> > On 06/01/2014 10:24 PM, Naoya Horiguchi wrote:
>>> > > -#define PAGECACHE_TAG_DIRTY	0
>>> > > -#define PAGECACHE_TAG_WRITEBACK	1
>>> > > -#define PAGECACHE_TAG_TOWRITE	2
>>> > > +enum {
>>> > > +	PAGECACHE_TAG_DIRTY,
>>> > > +	PAGECACHE_TAG_WRITEBACK,
>>> > > +	PAGECACHE_TAG_TOWRITE,
>>> > > +	__NR_PAGECACHE_TAGS,
>>> > > +};
>> > 
>> > Doesn't this end up exposing kernel-internal values out to a userspace
>> > interface?  Wouldn't that lock these values in to the ABI?
> Yes, that would. I hope these PAGECACHE_TAG_* stuff is very basic
> things and will never change drastically in the future (only added),
> so it's unlikely to bother people about ABI breakage things.

OK, so if I'm writing a userspace program, which header do I include
pull these values in to my program?
