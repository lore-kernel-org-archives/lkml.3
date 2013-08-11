Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3HKRQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:16:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51504 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3HKRQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:16:05 -0400
Date: Sun, 11 Aug 2013 10:15:35 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Vince Weaver <vince@deater.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] powerpc/perf: Define big-endian version of
 perf_mem_data_src
Message-ID: <20130811171535.GA31780@us.ibm.com>
References: <20130810174831.GA15551@us.ibm.com>
 <20130810175153.GF15551@us.ibm.com>
 <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081117-3620-0000-0000-000003E5707C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver [vince@deater.net] wrote:
| On Sat, 10 Aug 2013, Sukadev Bhattiprolu wrote:
| 
| > 
| >  include/uapi/linux/perf_event.h |   55 +++++++++++++++++++++++++++++++++++++++
| >  1 files changed, 55 insertions(+), 0 deletions(-)
| 
| > +#define __PERF_LE	1234
| > +#define __PERF_BE	4321
| > +
| > +#if defined(__KERNEL__)
| 
| I could be wrong, but I thought files under uapi weren't supposed to 
| contain __KERNEL__ code.  Wasn't that the whole point of uapi?
| 
| Also having the perf_event interface depend on endianess just seems like a 
| complicated mess.  Can't we just declare the interface to be a certain 
| endianess and have the kernel byte-swap as necessary?

Except for the __KERNEL__ check, it looked like this approach would keep
the kernel and user code same. Would it complicate user space ?

I tried to avoid the __KERNEL__ check hack, but like I tried to explain
in the patch, user space and kernel do the endian check differently. 
And, there are about ~300 sites in the kernel with __*ENDIAN checks

Sukadev

