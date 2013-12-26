Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3LZR7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 12:59:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45119 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3LZR7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 12:59:08 -0500
Message-ID: <52BC6E3B.9040703@zytor.com>
Date: Thu, 26 Dec 2013 09:58:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
References: <20131225145447.GA18146@gmail.com>	<20131226100348.GA7751@infradead.org> <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
In-Reply-To: <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 05:52 AM, H.J. Lu wrote:
> 
>>  c) why you suddenly need these changes now and not when the x32 ABI
>>     support was submitted and hopefully heavily tested
> 
> Kernel headers had been wrong for -m32/-mx32 on x86-64
> for a long long time.  Linux/x86-64 normally use header
> files from glibc, which avoids broken kernel header files.
> Kernel uabi header files fix -m32, but not -mx32, which I am
> working on now.
> 

In other words, this work is really part of making *libc make use the
kernel uabi headers, which is a valuable work.  The fact that the kernel
headers never got fully ported to x32 is a big reason why x32 is still
labeled experimental.

MIPS N32 and ARM64 ILP32 are x32-like ABIs which of course need to not
be broken.  However, currently __kernel_[u]long_t is [unsigned] long for
all ABIs other than x32, so changing [unsigned] long to
__kernel_[u]long_t will be a null change for anything but x32.  They
perhaps *SHOULD* be different for N32 or ARM64 ILP32, but that is for
those arch maintainers to set.

However, I believe H.J.'s patches from this morning conditionalizing
this on __BITS_PER_LONG are just plain wrong.

	-hpa


