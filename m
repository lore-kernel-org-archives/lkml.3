Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaAPWao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:30:44 -0500
Received: from www.sr71.net ([198.145.64.142]:44324 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaAPWak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:30:40 -0500
Message-ID: <52D85D33.4080509@sr71.net>
Date: Thu, 16 Jan 2014 14:29:07 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 5/9] mm: rearrange struct page
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180055.21691733@viggo.jf.intel.com> <alpine.DEB.2.10.1401161233060.30036@nuc>
In-Reply-To: <alpine.DEB.2.10.1401161233060.30036@nuc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 10:34 AM, Christoph Lameter wrote:
> On Tue, 14 Jan 2014, Dave Hansen wrote:
>> This makes it *MUCH* more clear how the first few fields of
>> 'struct page' get used by the slab allocators.
> 
> I think this adds to the confusion. What you want to know is which other
> fields overlap a certain field. After this patch you wont have that
> anymore.

Why does it matter *specifically* that "index shares space with
freelist", or that "mapping shares space with s_mem"?  No data is ever
handed off in those fields.

All that matters is that we know the _set_ of fields that gets reused,
and that we preserve the ones which *need* their contents preserved
(only flags and _count as far as I can tell).
