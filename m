Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaIZPB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:01:26 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:35999 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbaIZPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:01:03 -0400
Message-ID: <54257FAB.6010208@nexus-software.ie>
Date: Fri, 26 Sep 2014 16:00:59 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86, setup: add __flush_tlb() for Intel Quark X1000
References: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com> <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com> <5424FA7C.6020303@intel.com> <54252756.6000001@nexus-software.ie> <54257627.5090303@intel.com> <54257884.2080401@nexus-software.ie>
In-Reply-To: <54257884.2080401@nexus-software.ie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +    /*
> +     * Locate the page directory and flush the TLB.
> +     *
> +     * On Quark X1000 CPUs we still have the PGE bit incorrectly set
> +     * due to a processor erratum, so __flush_tlb_all() is not yet
> +     * doing what it says.  Fortunately we have a cr3 flush here,
> +     * which is what is needed in this processor to flush TLBs, so
> +     * there's no need to add a Quark X1000 quirk here.
> +     *
> +     * early_init_intel will unset the X86_FEATURE_PGE flag later
> +     * and __flush_tlb_all() will flush via cr3
> +     */
> +    __flush_tlb();
>
> With the extra __flush_tlb(); on the end.

Scatch that.

ACK Ong Boon Leong's patch
