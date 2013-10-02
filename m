Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3JBRsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:48:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab3JBRse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:48:34 -0400
Message-ID: <524C5BFB.5050501@zytor.com>
Date: Wed, 02 Oct 2013 10:46:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com, akpm@linux-foundation.org,
        dave.hansen@intel.com
Subject: Re: [RESEND PATCH] x86: add phys addr validity check for /dev/mem
 mmap
References: <20131002160514.GA25471@localhost.localdomain>
In-Reply-To: <20131002160514.GA25471@localhost.localdomain>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 09:05 AM, Frantisek Hrbata wrote:
> +
> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> +{
> +	return addr + count <= __pa(high_memory);
> +}
> +
> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> +{
> +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
> +	return phys_addr_valid(addr);
> +}
> 

The latter has overflow problems.

The former I realize matches the current /dev/mem, but it is still just
plain wrong in multiple ways.

	-hpa

