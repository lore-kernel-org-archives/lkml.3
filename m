Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaILRwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:52:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:49297 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaILRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:52:48 -0400
Date: Fri, 12 Sep 2014 19:52:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <541223B1.5040705@zytor.com>
Message-ID: <alpine.DEB.2.10.1409121949460.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos> <5412230A.6090805@intel.com> <541223B1.5040705@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, H. Peter Anvin wrote:

> On 09/11/2014 03:32 PM, Dave Hansen wrote:
> > On 09/11/2014 03:18 PM, Thomas Gleixner wrote:
> >> On Thu, 11 Sep 2014, Qiaowei Ren wrote:
> >>> This patch sets bound violation fields of siginfo struct in #BR
> >>> exception handler by decoding the user instruction and constructing
> >>> the faulting pointer.
> >>>
> >>> This patch does't use the generic decoder, and implements a limited
> >>> special-purpose decoder to decode MPX instructions, simply because the
> >>> generic decoder is very heavyweight not just in terms of performance
> >>> but in terms of interface -- because it has to.
> >>
> >> And why is that an argument to add another special purpose decoder?
> > 
> > Peter asked for it to be done this way specifically:
> > 
> > 	https://lkml.org/lkml/2014/6/19/411
> > 
> 
> Specifically because marshaling the data in and out of the generic
> decoder was more complex than a special-purpose decoder.

Well, I did not see the trainwreck which tried to use the generic
decoder, but as I explained in the other mail, there is no reason not
to use it and I can't see any complexity in retrieving the data beyond
calling insn_get_length(insn);

Thanks,

	tglx
