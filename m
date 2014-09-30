Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaI3Mls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaI3Mlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:41:47 -0400
Date: Tue, 30 Sep 2014 14:41:22 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com, torvalds@linux-foundation.org
Subject: Re: [RESEND PATCH 2/4] x86: add phys addr validity check for
 /dev/mem mmap
Message-ID: <20140930124121.GB3073@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
 <1411990382-11902-3-git-send-email-fhrbata@redhat.com>
 <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:15:28PM +0200, Thomas Gleixner wrote:
> On Mon, 29 Sep 2014, Frantisek Hrbata wrote:
> > V2: fix pfn check in valid_mmap_phys_addr_range, thanks to Dave Hansen
> 
> AFAICT, Dave also asked you to change size_t count into something more
> intuitive, i.e. nr_bytes or such.

Hi,

mea culpa, I for unknown reason changed it from "size" to "count". I guess some
cut&paste mess. The correct prototype used elsewhere in kernel is

int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)

Does it make sense to replace "count" with "size" so it's consistent with the
rest or do you prefer "nr_bytes" or as Dave proposed "len_bytes"?

I will fix this and I'm sorry Dave I did not change it as discussed. It totally
slipped my mind.

Many thanks Thomas.

> 
> > +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> 
> And right he is. I really had to look twice to see that count is
> actually number of bytes and not number of pages, which is what you
> expect after pfn.
> 
> > +{
> > +	return arch_pfn_possible(pfn + (count >> PAGE_SHIFT));
> > +}
> 
> Thanks,
> 
> 	tglx

-- 
Frantisek Hrbata
