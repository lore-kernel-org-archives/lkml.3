Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaLRPll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:41:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:57288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRPlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:41:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,601,1413270000"; 
   d="scan'208";a="626031232"
Message-ID: <5492F474.5090606@intel.com>
Date: Thu, 18 Dec 2014 07:36:20 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Glenn Williamson <glenn.p.williamson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com> <54921EF2.9070004@intel.com> <alpine.DEB.2.11.1412180850290.2593@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1412180850290.2593@gentwo.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 06:52 AM, Christoph Lameter wrote:
> On Wed, 17 Dec 2014, Dave Hansen wrote:
>> > IOW, do *ALL* of the sl*b allocators in all of their forms with all of
>> > their debugging options guarantee 32-byte alignment when allocating
>> > 256-byte objects?
> No. For that the arch has to set a macro call ARCH_KMALLOC_MINALIGN or
> ARCH_DMA_MINALIGN. Default alignment is to a word boundary.

OK, sounds like this is going to need its own slab.  It will make the
patch a bit bigger but shouldn't be all that much more complicated.

