Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaIYSu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:50:28 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:53719 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaIYSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:50:27 -0400
Message-ID: <542463F4.7010904@nexus-software.ie>
Date: Thu, 25 Sep 2014 19:50:28 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie> <20140925045755.GA20431@gmail.com> <5423E1F7.5010000@nexus-software.ie> <20140925145126.GA4434@gmail.com> <54242F17.5010503@nexus-software.ie> <20140925151123.GA4864@gmail.com> <20140925164911.GD10814@khazad-dum.debian.net> <20140925182814.GA6854@gmail.com>
In-Reply-To: <20140925182814.GA6854@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'd have mentioned "erratum" there, otherwise people won't understand why
>> the PGE bit being set would be a problem in the first place.
>>
>> Something like:
>>
>> /*
>>   * Locate the page directory and flush the TLB.
>>   *
>>   * On Quark X1000 CPUs we still have the PGE bit incorrectly set
>>   * due to a processor erratum, so __flush_tlb_all() is not yet
>>   * doing what it says.  Fortunately we have a cr3 flush here,
>>   * which is what is needed in this processor to flush TLBs, so
>>   * there's no need to add a Quark X1000 quirk here.
>>   */
>
> Yeah.
>
> I'd also add the fact that it's an unintended erratum to the
> Quark quirk section of early_init_intel() as well.

OK.

How about.

/*
   * Locate the page directory and flush the TLB.
   *
   * On Quark X1000 CPUs we still have the PGE bit incorrectly set
   * due to a processor erratum, so __flush_tlb_all() is not yet
   * doing what it says.  Fortunately we have a cr3 flush here,
   * which is what is needed in this processor to flush TLBs, so
   * there's no need to add a Quark X1000 quirk here.
   *
   * early_init_intel will unset the X86_FEATURE_PGE flag later
   * and __flush_tlb_all() will flush via cr3
   */
