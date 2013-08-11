Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3HKX6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 19:58:07 -0400
Received: from ozlabs.org ([203.10.76.45]:33244 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3HKX6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 19:58:01 -0400
Date: Mon, 12 Aug 2013 09:57:58 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vince@deater.net>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] powerpc/perf: Define big-endian version of
 perf_mem_data_src
Message-ID: <20130811235758.GA29824@concordia>
References: <20130810174831.GA15551@us.ibm.com>
 <20130810175153.GF15551@us.ibm.com>
 <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 10:34:58PM -0400, Vince Weaver wrote:
> On Sat, 10 Aug 2013, Sukadev Bhattiprolu wrote:
> 
> > 
> >  include/uapi/linux/perf_event.h |   55 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 55 insertions(+), 0 deletions(-)
> 
> > +#define __PERF_LE	1234
> > +#define __PERF_BE	4321
> > +
> > +#if defined(__KERNEL__)
> 
> I could be wrong, but I thought files under uapi weren't supposed to 
> contain __KERNEL__ code.  Wasn't that the whole point of uapi?

Yes.
 
> Also having the perf_event interface depend on endianess just seems like a 
> complicated mess.  Can't we just declare the interface to be a certain 
> endianess and have the kernel byte-swap as necessary?

Yes I think so. The interface is already defined and it's little endian,
so on big endian we just need to swap.

The only part I'm not clear on is how things are handled in perf
userspace, it seems to already do some byte swapping.

cheers
