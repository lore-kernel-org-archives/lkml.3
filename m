Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3GYKdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:33:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51446 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3GYKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:33:42 -0400
Message-ID: <51F0FEF4.9030309@ozlabs.ru>
Date: Thu, 25 Jul 2013 20:33:24 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] powerpc: Prepare to support kernel handling of IOMMU
 map/unmap
References: <1374707624.6142.16.camel@pasglop> <1374747961-28501-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1374747961-28501-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 08:26 PM, Alexey Kardashevskiy wrote:
> The current VFIO-on-POWER implementation supports only user mode
> driven mapping, i.e. QEMU is sending requests to map/unmap pages.
> However this approach is really slow, so we want to move that to KVM.
> Since H_PUT_TCE can be extremely performance sensitive (especially with
> network adapters where each packet needs to be mapped/unmapped) we chose
> to implement that as a "fast" hypercall directly in "real
> mode" (processor still in the guest context but MMU off).
> 
> To be able to do that, we need to provide some facilities to
> access the struct page count within that real mode environment as things
> like the sparsemem vmemmap mappings aren't accessible.
> 
> This adds an API to get page struct when MMU is off.
> 
> This adds to MM a new function put_page_unless_one() which drops a page
> if counter is bigger than 1. It is going to be used when MMU is off
> (real mode on PPC64 is the first user) and we want to make sure that page
> release will not happen in real mode as it may crash the kernel in
> a horrible way.


Yes, my english needs to be polished, I even know where :)


-- 
Alexey
