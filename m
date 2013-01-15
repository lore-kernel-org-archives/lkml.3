Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3AORLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:11:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab3AORLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:11:00 -0500
Message-ID: <50F58C31.3020105@redhat.com>
Date: Tue, 15 Jan 2013 12:04:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFCv3][PATCH 1/3] create slow_virt_to_phys()
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
In-Reply-To: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:59 PM, Dave Hansen wrote:
> Broadening the cc list here a bit...  This bug is still present,
> and I still need these patches to boot 32-bit NUMA kernels.  They
> might be obscure, but if we don't care about them any more, perhaps
> we should go remove the NUMA remapping code instead of this.
>
> --
>
> This is necessary because __pa() does not work on some kinds of
> memory, like vmalloc() or the alloc_remap() areas on 32-bit
> NUMA systems.  We have some functions to do conversions _like_
> this in the vmalloc() code (like vmalloc_to_page()), but they
> do not work on sizes other than 4k pages.  We would potentially
> need to be able to handle all the page sizes that we use for
> the kernel linear mapping (4k, 2M, 1G).

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
