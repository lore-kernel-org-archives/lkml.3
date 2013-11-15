Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3KOCMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:12:35 -0500
Received: from intranet.asianux.com ([58.214.24.6]:56508 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3KOCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:12:26 -0500
X-Spam-Score: -100.8
Message-ID: <5285838C.6070508@asianux.com>
Date: Fri, 15 Nov 2013 10:14:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>
Subject: Re: [PATCH] arch: um: kernel: skas: mmu: remove pmd_free() and pud_free()
 for failure processing in init_stub_pte()
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils> <528308E8.8040203@asianux.com> <alpine.LNX.2.00.1311132041200.1785@eggly.anvils> <52847237.5030405@asianux.com> <52847CD5.1030105@asianux.com>
In-Reply-To: <52847CD5.1030105@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 03:33 PM, Chen Gang wrote:
> On 11/14/2013 02:48 PM, Chen Gang wrote:
>>> >From the look of it, if an error did occur in init_stub_pte(),
>>>> then the special mapping of STUB_CODE and STUB_DATA would not
>>>> be installed, so this area would be invisible to munmap and exit,
>>>> and with your patch then the pages allocated likely to be leaked.
>>>>
>> It sounds reasonable to me: "although 'pgd' related with 'mm', but they
>> are not installed". But just like you said originally: "better get ACK
>> from some mm guys".
>>
>>
>> Hmm... is it another issue: "after STUB_CODE succeeds, but STUB_DATA
>> fails, the STUB_CODE will be leaked".
>>
>>
>>>> Which is not to say that the existing code is actually correct:
>>>> you're probably right that it's technically wrong.  But it would
>>>> be very hard to get init_stub_pte() to fail, and has anyone
>>>> reported a problem with it?  My guess is not, and my own
>>>> inclination to dabble here is zero.
>>>>
>> Yeah.
>>
> 
> If we can not get ACK from any mm guys, and we have no enough time
> resource to read related source code, for me, I still recommend to
> remove p?d_free() in failure processing.
> 

Oh, I am very sorry to Hugh and Richard, I make a mistake in common
sense: I recognized incorrect members (I treated Hugh as Richard), Hugh
is "mm guys".

Next time, I should see the mail carefully, not only for contents, but
also for senders.

Sorry again to both of you.

Thanks.

> In the worst cases, we will leak a little memory, and no any other
> negative effect, it is an executable way which is no any risks.
> 
> For current mm implementation, it seems we can not assume any thing,
> although they sounds (or should be) reasonable (include what you said
> about mm).
> 
> 
> Thanks.
> 


-- 
Chen Gang
