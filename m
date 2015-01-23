Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbbAWDrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:47:24 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43487 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbbAWDrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:47:23 -0500
Message-ID: <54C1C411.2080703@linux.vnet.ibm.com>
Date: Fri, 23 Jan 2015 09:16:25 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 1/2] powerpc: Add helpers for LPCR PECE1 operations
References: <1421654727-31656-1-git-send-email-shreyas@linux.vnet.ibm.com> <1421982392.24984.9.camel@ellerman.id.au>
In-Reply-To: <1421982392.24984.9.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012303-0013-0000-0000-000000B8A174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 23 January 2015 08:36 AM, Michael Ellerman wrote:
> On Mon, 2015-01-19 at 13:35 +0530, Shreyas B. Prabhu wrote:
>> PECE1 bit in LPCR is used to control whether decrementer can cause exit
>> from powersaving states. PECE1 bit is cleared before entering fastsleep
>> or deeper powersaving state and it is set on waking up. Since both
>> cpuidle and cpu offline operations use these powersaving states, add
>> helper functions to be used in both these places.
> 
> Thanks.
> 
> That isn't really much clearer than the original, so in the end I just merged
> your original fix.
> 
> I'll think if there's a bigger consolidation we can do that makes it clearer.
> 
> cheers
> 
> 
Helper could have been this :

#define   LPCR_CLEAR_PECE1	(mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1)

This perhaps would make it more clearer, but it will end up using additional mfspr here-

    static int fastsleep_loop(struct cpuidle_device *dev,
    				struct cpuidle_driver *drv,
    				int index)
    {
    	...
    
    	new_lpcr = old_lpcr;
    	/* Do not exit powersave upon decrementer as we've setup the timer
    	 * offload.
    	 */
    	new_lpcr &= ~LPCR_PECE1;
    
    	mtspr(SPRN_LPCR, new_lpcr);

