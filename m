Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaCaNnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:43:10 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30439 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCaNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:43:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,765,1389772800"; 
   d="scan'208";a="21932708"
Message-ID: <533970DF.70303@broadcom.com>
Date: Mon, 31 Mar 2014 15:42:55 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, Franky Lin <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] brcm80211: deinline brcmf_chip_cr4_enterdl, save
 440 bytes
References: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com> <53391B89.7010304@broadcom.com> <53394F23.6080805@redhat.com>
In-Reply-To: <53394F23.6080805@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/14 13:18, Denys Vlasenko wrote:
> On 03/31/2014 09:38 AM, Arend van Spriel wrote:
>> On 30/03/14 23:31, Denys Vlasenko wrote:
>>> Automated script discovered that without forced inlining,
>>> gcc-4.7 generates smaller code for this function.
>>>
>>> There is no need to declare static functions inline anyway:
>>> nowadays gcc detects single-callsite static functions
>>> which benefit from inlining.
>>
>> These patches look awfully familiar. I tend to object, but I don't know the details of this automated script.
>
> The script removes "static" keyword, recompiles the .c file,
> compares the sizes, and if code size went down,
> creates a patch
>
>> How about execution time or is this only compile tested?
>
> The change adds one pair of call/return instructions -
> probably around 5-10 CPU cycles.
>
> The function in question is a part of firmware download logic,
> which is nowhere near being hot path/.

True. My remarks are on all four patches and I just replied to the first 
patch. The other patches are in interrupt handling code, ie. interrupt 
or bottom-halve context.

>> The other thing is that you seem to rely on a specific gcc version.
>> What about pre-4.7? How about different architectures.
>> Was this determined on x86, arm, sparc, mips.
>> All these questions make me say 'nay'.
>
> Not making functions inline unless there is a good reason
> is a general good coding practice. It is not a compiler-
> or architecture-specific optimization.

Agree, but you seem to assume that in this case there is no good reason.

Regards,
Arend


