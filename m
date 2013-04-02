Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278Ab3DBU3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:29:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab3DBU3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:29:36 -0400
Message-ID: <515B3F98.5020101@zytor.com>
Date: Tue, 02 Apr 2013 13:29:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com> <20130402191012.GC3314@dhcp-26-164.brq.redhat.com>
In-Reply-To: <20130402191012.GC3314@dhcp-26-164.brq.redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 12:10 PM, Frantisek Hrbata wrote:
> 
> Hi, this is exactly what the patch is doing imho. Note that the
> valid_phys_addr_range(), which is using the high_memory, is the same as the
> default one in drivers/char/mem.c(#ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE). I
> just added x86 specific check for valid_mmap_phys_addr_range and moved both
> functions to arch/x86/mm/mmap.c, rather then modifying the default generic ones.
> This is how other archs(arm) are doing it.
> 
> Also valid_phys_addr_range is used just in read|write_mem and
> valid_mmap_phys_addr_range is checked in mmap_mem and it calls phys_addr_valid
> 
> static inline int phys_addr_valid(resource_size_t addr)
> {
> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> 	return !(addr >> boot_cpu_data.x86_phys_bits);
> #else
>         return 1;
> #endif
> }                          
> 
> I for sure could overlooked something, but this seems right to me.
> 

OK, this is really confusing ... which isn't a *huge* surprise (the
entire /dev/mem code has some gigantic bugs in it.)

I think I need to do more of an in-depth review.  The other question is
why we don't call phys_addr_valid() everywhere.

	-hpa


