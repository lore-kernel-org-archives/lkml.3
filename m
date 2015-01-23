Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbbAWEU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:20:27 -0500
Received: from ozlabs.org ([103.22.144.67]:58105 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbbAWEUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:20:23 -0500
Message-ID: <1421986821.24984.12.camel@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] powerpc: Add helpers for LPCR PECE1 operations
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Fri, 23 Jan 2015 15:20:21 +1100
In-Reply-To: <54C1C411.2080703@linux.vnet.ibm.com>
References: <1421654727-31656-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1421982392.24984.9.camel@ellerman.id.au>
	 <54C1C411.2080703@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 09:16 +0530, Shreyas B Prabhu wrote:
> 
> On Friday 23 January 2015 08:36 AM, Michael Ellerman wrote:
> > On Mon, 2015-01-19 at 13:35 +0530, Shreyas B. Prabhu wrote:
> >> PECE1 bit in LPCR is used to control whether decrementer can cause exit
> >> from powersaving states. PECE1 bit is cleared before entering fastsleep
> >> or deeper powersaving state and it is set on waking up. Since both
> >> cpuidle and cpu offline operations use these powersaving states, add
> >> helper functions to be used in both these places.
> > 
> > Thanks.
> > 
> > That isn't really much clearer than the original, so in the end I just merged
> > your original fix.
> > 
> > I'll think if there's a bigger consolidation we can do that makes it clearer.
>
> Helper could have been this :
> 
> #define   LPCR_CLEAR_PECE1	(mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1)
> 
> This perhaps would make it more clearer, but it will end up using additional mfspr here-
 
Yeah.

Maybe we just leave it open coded, I'll have a think about it.

cheers


