Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaANWSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:18:38 -0500
Received: from www.sr71.net ([198.145.64.142]:54366 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaANWSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:18:37 -0500
Message-ID: <52D5B762.3090209@sr71.net>
Date: Tue, 14 Jan 2014 14:17:06 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 3/9] mm: page->pfmemalloc only used by slab/skb
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180051.0181E467@viggo.jf.intel.com> <alpine.DEB.2.10.1401141348130.19618@nuc>
In-Reply-To: <alpine.DEB.2.10.1401141348130.19618@nuc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:49 AM, Christoph Lameter wrote:
> On Tue, 14 Jan 2014, Dave Hansen wrote:
>> page->pfmemalloc does not deserve a spot in 'struct page'.  It is
>> only used transiently _just_ after a page leaves the buddy
>> allocator.
> 
> Why would we need to do this if we are removing the cmpxchg_double?

Why do we need the patch?

'struct page' is a mess.  It's really hard to follow, and the space in
the definition is a limited resource.  We should not waste that space on
such a transient and unimportant value as pfmemalloc.
