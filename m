Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAXSnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:43:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:30660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaAXSm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:42:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,714,1384329600"; 
   d="scan'208";a="472000483"
Message-ID: <52E2B431.5090705@intel.com>
Date: Fri, 24 Jan 2014 10:42:57 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
References: <52E19C7D.7050603@intel.com>	<CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com>	<52E28067.1060507@intel.com>	<CAE9FiQVy+8CF5qwnyL8YGzqwKOJF+y7N_+reAXWw7p8-BaVQPg@mail.gmail.com>	<52E2AC5A.3000005@intel.com>	<CAE9FiQW3DrGjKHLhwBgcK076g7z-6_-0EN2HwtVBLSpKO4m6-Q@mail.gmail.com>	<52E2AEA3.2020907@intel.com> <CAE9FiQU795SWFfnQU=0STbQconSraac8heCNnkMpynY6fbi-4w@mail.gmail.com>
In-Reply-To: <CAE9FiQU795SWFfnQU=0STbQconSraac8heCNnkMpynY6fbi-4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 10:24 AM, Yinghai Lu wrote:
> On Fri, Jan 24, 2014 at 10:19 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>> FWIW, I did turn of memblock=debug.  It eventually booted, but
>> slooooooooooowly.
> 
> then that is not a problem, as you are using 4k page mapping only.
> and that printout is too spew...

This means that, essentially, memblock=debug and
KMEMCHECK/DEBUG_PAGEALLOC can't be used together.  That's a shame
because my DEBUG_PAGEALLOC config *broke* this code a few months ago,
right?  Oh well.

>> How many problems in this code are we tracking, btw?  This is at least
>> 3, right?
> 
> two problems:
> 1. big numa system.
> 2. Andrew's system with swiotlb.

Can I ask politely for some more caution on your part in this area?
This is two consecutive kernels where this code has broken my system.
