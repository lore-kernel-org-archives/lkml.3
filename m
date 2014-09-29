Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaI2UPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:15:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:53961 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaI2UPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:15:01 -0400
Date: Mon, 29 Sep 2014 22:15:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frantisek Hrbata <fhrbata@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com, torvalds@linux-foundation.org
Subject: Re: [RESEND PATCH 2/4] x86: add phys addr validity check for /dev/mem
 mmap
In-Reply-To: <1411990382-11902-3-git-send-email-fhrbata@redhat.com>
Message-ID: <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com> <1411990382-11902-3-git-send-email-fhrbata@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Frantisek Hrbata wrote:
> V2: fix pfn check in valid_mmap_phys_addr_range, thanks to Dave Hansen

AFAICT, Dave also asked you to change size_t count into something more
intuitive, i.e. nr_bytes or such.

> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)

And right he is. I really had to look twice to see that count is
actually number of bytes and not number of pages, which is what you
expect after pfn.

> +{
> +	return arch_pfn_possible(pfn + (count >> PAGE_SHIFT));
> +}

Thanks,

	tglx
