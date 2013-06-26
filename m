Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3FZJEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:04:06 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751916Ab3FZJEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:04:04 -0400
Message-ID: <51CAAE7C.9090003@nod.at>
Date: Wed, 26 Jun 2013 11:03:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Jeff Dike <jdike@addtoit.com>, Arnd Bergmann <arnd@arndb.de>,
        dhsharp@google.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com>
In-Reply-To: <51CAAD1D.8050801@asianux.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2013 10:58, schrieb Chen Gang:
> On 06/26/2013 04:39 PM, Richard Weinberger wrote:
>>>>>>>>>> The drivers internal code has already check the related return value,
>>>>>>>>>> so it is the architecture's duty to 'tell' the driver whether support
>>>>>>>>>> io memory (e.g. define ioremap, but return NULL).
>>>>>> It does so already by setting CONFIG_HAS_IOMEM=n
>>>>
>>>> Excuse me, I use "grep -rn ioremap *" under "include/" and "arch/um/"
>>>> directory, but can not find the related definition for 'ioremap'.
>>>>
>>>> Is there another declaration or definition way which I don't know ?
>>>> (maybe it is).
>> Both UML and s390 (in the !CONFIG_PCI) do not define ioremap() because
>> without io memory you cannot have a ioremap().
>>
> 
> I assume if ioremap() return NULL, it means "without io memory", is it
> correct ?
> 
> If it is correct, "define a dummy ioremap(), and return NULL" is just
> the meaning that you mentioned above.
> 
> If so, for UML, it is not requirement, but recommend to define a dummy
> ioremap() which return NULL, so can be generic enough to mach all cases.

No.
Not setting CONFIG_HAS_IOMEM=y means "This arch has no io memory and therefore no
functions to mess with it".

Let's get back to the real problem,
drivers/ptp/ptp_pch.c does not build on UML (and I'm very sure also not on S390).
Fix the issue by making it depend on HAS_IOMEM.

Btw: Did you actually look at this driver? There is *zero* reason to have it on UML.
...like 99.9% of all other drivers which use io memory.

Thanks,
//richard
