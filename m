Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3HTGZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:25:41 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41826 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3HTGZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9dFdvnvk=yg3WWf1gqaFYZ8gm9vnnM7b+-a=bjDBRstBQeuA@mail.gmail.com>
References: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
 <CAB9dFduWPr0n8c7ckZr=2AQ-h4sy4U9YYzTRw335Xaimc4tk-A@mail.gmail.com>
 <CA+55aFwqQBdYUU2MfccDpzc2S+oiP23QKdbPnfJsnVw1TR_H+Q@mail.gmail.com> <CAB9dFdvnvk=yg3WWf1gqaFYZ8gm9vnnM7b+-a=bjDBRstBQeuA@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 20 Aug 2013 08:25:19 +0200
Message-ID: <CACQ1gAjky4wUXhzmn-ppTF6Cw6CSCoeLHjghfOFPhOHKHKOywg@mail.gmail.com>
Subject: Re: [PATCH] proc: return on proc_readdir error
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/20 Marc Dionne <marc.c.dionne@gmail.com>:
> On Mon, Aug 19, 2013 at 7:49 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Aug 19, 2013 at 1:33 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
>>>
>>> By my reading that commit (f0c3b5093add) also made proc_readdir always
>>> return 0, so with this patch the effect I see is that no pid entries
>>> are listed under /proc, breaking ps for instance.  I don't see how
>>> even the previous version of proc_readdir could return a negative
>>> value; looks like 1 and 0 were the only possible return values.
>>
>> Yes, see the other thread. The "return 1" case had gotten lost. I
>> think current git should get everything right, but please do test. I
>> did some testing of my own with a random little getdents test-program
>> (just checking that it got the same results with different (small)
>> buffer sizes), but it was by no means exhaustive.
>>
>>               Linus
>
> It does fix the symptoms I was seeing, thanks.  "ps" now has output
> and the pid entries are now visible again under /proc.
>
> Marc
arg !
I was so focused on getting the non-PID proc entries right that I
didn't even see all the missing PIDs when I tested it !

/me need holidays.
