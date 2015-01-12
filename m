Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbbALXSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:18:36 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57645 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbALXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <54B45514.3070603@linux.intel.com>
References: <cover.1421103159.git.luto@amacapital.net> <602a94627fedaab4e339088d633b72174caf14c9.1421103159.git.luto@amacapital.net>
 <54B45514.3070603@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 15:18:12 -0800
Message-ID: <CALCETrX-BkHkAUpSLkdue7hEve544fBtjmD1F2hffW6XO=T7WQ@mail.gmail.com>
Subject: Re: [PATCH 3.19 v2 1/3] x86: Fix off-by-one in the instruction
 decoder length checks
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 3:13 PM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> On 01/12/2015 03:04 PM, Andy Lutomirski wrote:
>> diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
>> index 2480978b31cc..1313ae6b478b 100644
>> --- a/arch/x86/lib/insn.c
>> +++ b/arch/x86/lib/insn.c
>> @@ -28,7 +28,7 @@
>>
>>  /* Verify next sizeof(t) bytes can be on the same instruction */
>>  #define validate_next(t, insn, n)    \
>> -     ((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
>> +     ((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
>>
>>  #define __get_next(t, insn)  \
>>       ({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
>
> This issue should already be handled by this patch:
>
> http://git.kernel.org/tip/0f363b250b15af0f218bb2876d101fe5cd413f8b

I wasn't paying much attention to the world for the last couple weeks,
and I didn't notice that it was already fixed.

Ingo, etc: I won't send a v3 just to drop this patch from the series.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
