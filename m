Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbaGRUJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:09:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44258 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbaGRUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:09:13 -0400
MIME-Version: 1.0
In-Reply-To: <53C97E0F.6090601@zytor.com>
References: <20140718150005.73db8eb9@canb.auug.org.au> <53C97287.5020509@zytor.com>
 <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com> <53C97E0F.6090601@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 18 Jul 2014 13:08:51 -0700
Message-ID: <CALCETrXP+Rz8wi_N2G7WLwnGuFMC8zeo5o+jgGmvpZkndrM+2Q@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/18/2014 12:57 PM, Andy Lutomirski wrote:
>>
>> This particular warning is IMO in a particularly dumb category: GCC
>> optimizes some code and then warns about a construct that wasn't there
>> in the original code.  In this case, I think it unrolled a loop and
>> discovered that one iteration contained a test that was always true.
>> Big deal.
>>
>> (OTOH, the code in question was buggy, but not all for the reason that
>> GCC thought it was.)
>>
>
>                 if (syms[sym_vvar_start] > syms[i] + 4096)
>                         fail("%s underruns begin_vvar\n",
>                              required_syms[i].name);
>
> if i == sym_vvar_start then this is at least a valid warning.  It could
> easily be quieted by chaning syms[] to an unsigned array.

Hah -- fooled you, too :)

i isn't an index in to the syms array at all.  This code is completely
wrong.  See the patch I sent in reply to Stephen's original email.

But, to your earlier point, presumably this could warn:

for (int i = 0; i < 10; i++)
  if (array[i] > array[5] + 1)
    fail();

I think that's absurd.  There's nothing wrong with that code.  A given
test should have to be always true or always false on *all* loop
iterations to be flagged, I think.

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
