Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3JCP1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:27:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45970 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab3JCP1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:27:49 -0400
Date: Thu, 3 Oct 2013 08:27:25 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9][v5] powerpc/perf: Define big-endian version of
 perf_mem_data_src
Message-ID: <20131003152725.GA1383@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-7-git-send-email-sukadev@linux.vnet.ibm.com>
 <20131003053944.GD17237@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003053944.GD17237@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100315-0320-0000-0000-0000013A514D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Tue, Oct 01, 2013 at 05:15:07PM -0700, Sukadev Bhattiprolu wrote:
| > perf_mem_data_src is an union that is initialized via the ->val field
| > and accessed via the bitmap fields. For this to work on big endian
| > platforms, we also need a big-endian represenation of perf_mem_data_src.
| > 
| > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
| > index ca1d90b..846f399 100644
| > --- a/include/uapi/linux/perf_event.h
| > +++ b/include/uapi/linux/perf_event.h
| > @@ -19,6 +19,50 @@
| >  #include <asm/byteorder.h>
| >  
| >  /*
| > + * Kernel and userspace check for endianness in incompatible ways.
| > + * In user space, <endian.h> defines both __BIG_ENDIAN and __LITTLE_ENDIAN
| > + * but sets __BYTE_ORDER to one or the other. So user space uses checks are:
| 
| 
| Why can't you use __BIG_ENDIAN_BITFIELD ?

BTW, any clues on why there are so many different ways of checking endianness ?

Any standards related stuff or just evolution ?

Sukadev

