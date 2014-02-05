Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBERgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:36:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33308 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaBERgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:36:20 -0500
Message-ID: <52F27683.8090404@zytor.com>
Date: Wed, 05 Feb 2014 09:36:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Meelis Roos <mroos@linux.ee>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at 00000000b4343e88
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee> <20140121141037.f76dba61212c5597ff733207@linux-foundation.org> <alpine.SOC.1.00.1401221731150.3033@math.ut.ee> <52E26EF3.1090901@linux.vnet.ibm.com> <alpine.SOC.1.00.1401242249540.16252@math.ut.ee> <52E68111.6010005@linux.vnet.ibm.com> <alpine.SOC.1.00.1401280832500.5459@math.ut.ee> <52E918C9.7030408@linux.vnet.ibm.com> <alpine.SOC.1.00.1401292242390.12718@math.ut.ee> <52EBC65C.5020404@linux.vnet.ibm.com> <52F26E21.8000101@linux.vnet.ibm.com>
In-Reply-To: <52F26E21.8000101@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 09:00 AM, Peter Oberparleiter wrote:
> 
> Could you give this patch a try? It is a variation of the approach
> proposed in the discussion mentioned earlier and fixes the problem
> on my system.
> 

I would rather suggest that we explicitly disable gcov etc. from these
kinds of small, magic primitives.  Honestly, you're just trying to put a
bandaid on a gaping wound.

The real thing here is that hweight.c is not a normal C file, and we
shouldn't treat is as such.  It is a constrained environment, and trying
to tack crap like gcov to it is bound to lose, simply because gcov
doesn't know the rules it has to play by.

Even with the below change, if gcov clobbers, say, %rdx we're still screwed.

	-hpa

