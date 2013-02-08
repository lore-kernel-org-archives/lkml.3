Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947075Ab3BHUs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:48:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36531 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947017Ab3BHUs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:48:56 -0500
Message-ID: <51156494.3050300@zytor.com>
Date: Fri, 08 Feb 2013 12:48:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@alien8.de,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 2/2] make /dev/kmem return error for highmem
References: <20130208202813.62965F25@kernel.stglabs.ibm.com> <20130208202814.E1196596@kernel.stglabs.ibm.com>
In-Reply-To: <20130208202814.E1196596@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 12:28 PM, Dave Hansen wrote:
> I was auding the /dev/mem code for more questionable uses of
> __pa(), and ran across this.
>
> My assumption is that if you use /dev/kmem, you expect to be
> able to read the kernel virtual mappings.  However, those
> mappings _stop_ as soon as we hit high memory.  The
> pfn_valid() check in here is good for memory holes, but since
> highmem pages are still valid, it does no good for those.
>
> Also, since we are now checking that __pa() is being done on
> valid virtual addresses, this might have tripped the new
> check.  Even with the new check, this code would have been
> broken with the NUMA remapping code had we not ripped it
> out:
>

It would be great if you could take a stab at fixing /dev/mem and 
/dev/kmem... there are a bunch of problems with both which seem to 
really translate to "HIGHMEM was never properly implemented"...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

