Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaIYPFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:05:01 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:50779 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbaIYPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:04:59 -0400
Message-ID: <54242F17.5010503@nexus-software.ie>
Date: Thu, 25 Sep 2014 16:04:55 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie> <20140925045755.GA20431@gmail.com> <5423E1F7.5010000@nexus-software.ie> <20140925145126.GA4434@gmail.com>
In-Reply-To: <20140925145126.GA4434@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It talks about:
>
> +       /*
> +        * Locate the page directory and flush the TLB.
> +        * On Quark X1000 rewriting CR3 flushes the TLB no if/else is required
> +        * to choose between __flush_tlb() and __flush_tlb_all()
> +        */
>          load_cr3(swapper_pg_dir);
>          __flush_tlb_all();
>
> But it is completely silent on the real reason for why we don't
> need a Quark quirk here, which would be something like:
>
> 	/*
> 	 * On Quark CPUs we still have the PGE bit set so
> 	 * __flush_tlb_all() is not yet doing what it says - but
> 	 * accidentally we have a cr3 flush here which is what is
> 	 * needed - so there's no need to add a Quark quirk here.
> 	 */
>
> Right?

OK.

IMO.

If we're adding a comment though the first thing the comment ought to 
say is what the code does for everybody else - stuff CR3 and flush the 
TLB, then it should comment on the exception for Quark.

/*
  * Locate the page directory and flush the TLB.
  *
  * On Quark CPUs we still have the PGE bit set so
  * __flush_tlb_all() is not yet doing what it says - but
  * accidentally we have a cr3 flush here which is what is
  * needed - so there's no need to add a Quark quirk here.
  */

?
