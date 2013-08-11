Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3HKCd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:33:56 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:34814 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab3HKCdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:33:54 -0400
Date: Sat, 10 Aug 2013 22:34:58 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] powerpc/perf: Define big-endian version of
 perf_mem_data_src
In-Reply-To: <20130810175153.GF15551@us.ibm.com>
Message-ID: <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy>
References: <20130810174831.GA15551@us.ibm.com> <20130810175153.GF15551@us.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.5206F811.0095,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Sukadev Bhattiprolu wrote:

> 
>  include/uapi/linux/perf_event.h |   55 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)

> +#define __PERF_LE	1234
> +#define __PERF_BE	4321
> +
> +#if defined(__KERNEL__)

I could be wrong, but I thought files under uapi weren't supposed to 
contain __KERNEL__ code.  Wasn't that the whole point of uapi?

Also having the perf_event interface depend on endianess just seems like a 
complicated mess.  Can't we just declare the interface to be a certain 
endianess and have the kernel byte-swap as necessary?

Vince
