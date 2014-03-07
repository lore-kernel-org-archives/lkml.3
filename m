Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaCGRTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:19:14 -0500
Received: from www.sr71.net ([198.145.64.142]:48893 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaCGRTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:19:13 -0500
Message-ID: <5319FF8D.1080107@sr71.net>
Date: Fri, 07 Mar 2014 09:19:09 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 5/7] x86: mm: new tunable for single vs full TLB flush
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>	 <20140306004527.6C232C54@viggo.jf.intel.com> <1394156230.2555.19.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1394156230.2555.19.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:37 PM, Davidlohr Bueso wrote:
> On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>> +
>> +If you believe that invlpg is being called too often, you can
>> +lower the tunable:
>> +
>> +	/sys/debug/kernel/x86/tlb_single_page_flush_ceiling
>> +
> 
> Whenever this tunable needs to be updated, most users will not know what
> a invlpg is and won't think in terms of pages either. How about making
> this in units of Kb instead? But then again most of those users won't be
> looking into tlb flushing issues anyways, so...

Yeah, talking about the instruction directly in the documentation is
probably going a bit far.  I'll see if I can uplevel it a bit.

It's obviously not a big deal to change it to be pages vs. kb, but for
something that's as *COMPLETELY* developer-focused, I think we can keep
it in pages.  We don't want users fooling with this.

> While obvious, tt should also mention that this does not apply to
> hugepages.

Good point.

