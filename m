Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3LTKU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:20:56 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45971 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3LTKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:20:15 -0500
Message-ID: <52B419DE.8050706@gmail.com>
Date: Fri, 20 Dec 2013 18:20:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: rostedt@goodmis.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-metag@vger.kernel.org
Subject: Re: [PATCH] arch: metag: lib: add "umoddi3.S" file for __umoddi3()
References: <52B2E0FA.7090805@gmail.com> <52B2E3DB.7010008@imgtec.com> <52B2F6B7.1050802@gmail.com> <52B2F8DC.8060006@imgtec.com> <52B3A0EA.9010801@gmail.com> <52B40E44.9040603@imgtec.com>
In-Reply-To: <52B40E44.9040603@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 05:30 PM, James Hogan wrote:
> On 20/12/13 01:44, Chen Gang wrote:
>> On 12/19/2013 09:47 PM, James Hogan wrote:
>>> No, I believe there shouldn't be any use of the C 64bit division/modulo
>>> operations in generic kernel code in the first place, so like I said
>>> before the code in question should be fixed to use the proper functions
>>> in <linux/math64.h>.
>>>
>>
>> OK, thanks, your idea is one of fix ways.
>>
>> Hmm... for me, it is still not a bad idea to add "__umoddi3" to metag.
> 
> NAK
> 
> Please read this:
> http://yarchive.net/comp/linux/64bit_divide.html
> 

OK, thanks, that sounds reasonable to me. For kernel, we really need
treat it carefully.

Hmm... but do you know why we need some 64-bit functions which are
implemented under "arch/metag/lib/*.S"? can we use <linux/math64.h>
instead of them? (e.g 64-bit '/').

And for me, 64-bit '/' and '%' are related operations, if provide one,
we also need provide the other (or neither of them are provided).


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
