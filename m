Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaHNRyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaHNRyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:54:24 -0400
Date: Thu, 14 Aug 2014 19:53:46 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dvlasenk@redhat.com,
        prarit@redhat.com, lwoodman@redhat.com, hannsj_uhl@de.ibm.com
Subject: Re: [PATCH 1/1] x86: add phys addr validity check for /dev/mem mmap
Message-ID: <20140814175346.GB7575@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>
 <1408025927-16826-2-git-send-email-fhrbata@redhat.com>
 <53ECE573.1030405@intel.com>
 <53ECEFF5.1040800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ECEFF5.1040800@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:20:53AM -0700, H. Peter Anvin wrote:
> On 08/14/2014 09:36 AM, Dave Hansen wrote:
> > Thanks for dredging this back up!
> > 
> > On 08/14/2014 07:18 AM, Frantisek Hrbata wrote:
> >> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> >> +{
> >> +	return addr + count <= __pa(high_memory);
> >> +}
> > 
> > Is this correct on 32-bit?  It would limit /dev/mem to memory below 896MB.
> > 
> 
> Last I checked, /dev/mem was already broken for highmem... which is
> actually a problem.  I would prefer to see it fixed.
> 
> 	-hpa
> 

Hi Peter,

thank you for jumping in again. I'm not going to pretent I fully understand this
code, as proven by Dave :), but wouldn't it help just to move the high_memory
check directly to the xlate_dev_mem_ptr. Meaning no high_memory check in
valid_phys_addr_range for x86. I sent more info in my reply to Dave's mail.

Again many thanks.


-- 
Frantisek Hrbata
