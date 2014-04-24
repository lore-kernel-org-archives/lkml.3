Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbaDXWD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:03:57 -0400
Received: from www.sr71.net ([198.145.64.142]:55197 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbaDXWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:03:54 -0400
Message-ID: <53598A48.2090909@sr71.net>
Date: Thu, 24 Apr 2014 15:03:52 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, alex.shi@linaro.org, dave.hansen@linux.intel.com,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: mm: new tunable for single vs full TLB flush
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182426.D6DD1E8F@viggo.jf.intel.com> <20140424103727.GT23991@suse.de> <53594920.8030203@sr71.net> <53594FB3.9050505@redhat.com>
In-Reply-To: <53594FB3.9050505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:53 AM, Rik van Riel wrote:
>> I do agree that it's ambiguous at best.  I'll go see if anybody cares to
>> update that bit.
> 
> I suspect that IF the TLB actually uses a 2MB entry for the
> translation, a single INVLPG will work.
> 
> However, the CPU is free to cache the translations for a 2MB
> region with a bunch of 4kB entries, if it wanted to, so in
> the end we have no guarantee that an INVLPG will actually do
> the right thing...
> 
> The same is definitely true for 1GB vs 2MB entries, with
> some CPUs being capable of parsing page tables with 1GB
> entries, but having no TLB entries for 1GB translations.

I believe we _do_ have such a guarantee.  There's another bit in the SDM
that someone pointed out to me in a footnote in "4.10.4.1":

	1. If the paging structures map the linear address using a page
	larger than 4 KBytes and there are multiple TLB entries for
	that page (see Section 4.10.2.3), the instruction invalidates
	all of them.

While that's not in the easiest-to-find place in the documents, it looks
pretty clear.
