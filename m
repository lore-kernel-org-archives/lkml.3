Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaAMRRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:17:37 -0500
Received: from www.sr71.net ([198.145.64.142]:42506 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaAMRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:17:33 -0500
Message-ID: <52D41F52.5020805@sr71.net>
Date: Mon, 13 Jan 2014 09:16:02 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
References: <20140103180147.6566F7C1@viggo.jf.intel.com> <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org> <20140106043237.GE696@lge.com> <52D05D90.3060809@sr71.net> <20140110153913.844e84755256afd271371493@linux-foundation.org> <52D0854F.5060102@sr71.net> <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com> <alpine.DEB.2.10.1401111854580.6036@nuc> <20140113014408.GA25900@lge.com>
In-Reply-To: <20140113014408.GA25900@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 05:44 PM, Joonsoo Kim wrote:
> We only touch one struct page on small allocation.
> In 64-byte case, we always use one cacheline for touching struct page, since
> it is aligned to cacheline size. However, in 56-byte case, we possibly use
> two cachelines because struct page isn't aligned to cacheline size.

I think you're completely correct that this can _happen_, but I'm a bit
unconvinced that what you're talking about is the thing which dominates
the results.  I'm sure it plays a role, but the tests I was doing were
doing tens of millions of allocations and touching a _lot_ of 'struct
pages'.  I would not expect these effects to be observable across such a
large sample of pages.
