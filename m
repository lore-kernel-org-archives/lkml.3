Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaLNKG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 05:06:27 -0500
Received: from ozlabs.org ([103.22.144.67]:39875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaLNKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 05:06:00 -0500
In-Reply-To: <1418151413-6141-2-git-send-email-shreyas@linux.vnet.ibm.com>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [v4, 1/4] powerpc: powernv: Switch off MMU before entering nap/sleep/rvwinkle mode
Message-Id: <20141214100559.278C71400EA@ozlabs.org>
Date: Sun, 14 Dec 2014 21:05:59 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-12 at 18:56:50 UTC, "Shreyas B. Prabhu" wrote:
> From: Paul Mackerras <paulus@samba.org>
> 
> Currently, when going idle, we set the flag indicating that we are in
> nap mode (paca->kvm_hstate.hwthread_state) and then execute the nap
> (or sleep or rvwinkle) instruction, all with the MMU on.  This is bad
> for two reasons: (a) the architecture specifies that those instructions
> must be executed with the MMU off, and in fact with only the SF, HV, ME
> and possibly RI bits set, and (b) this introduces a race, because as
> soon as we set the flag, another thread can switch the MMU to a guest
> context.  If the race is lost, this thread will typically start looping
> on relocation-on ISIs at 0xc...4400.
> 
> This fixes it by setting the MSR as required by the architecture before
> setting the flag or executing the nap/sleep/rvwinkle instruction.
> 
> [ shreyas@linux.vnet.ibm.com: Edited to handle LE ]
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

I'm going to CC this to stable unless anyone objects. It's not something people
are likely to hit, but the result is fairly catastrophic.

cheers
