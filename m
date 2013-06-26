Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3FZI7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:59:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47120 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3FZI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:58:59 -0400
X-Spam-Score: -100.8
Message-ID: <51CAAD1D.8050801@asianux.com>
Date: Wed, 26 Jun 2013 16:58:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jeff Dike <jdike@addtoit.com>, Arnd Bergmann <arnd@arndb.de>,
        dhsharp@google.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at>
In-Reply-To: <51CAA8D6.9000505@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:39 PM, Richard Weinberger wrote:
>>>>> >>>> The drivers internal code has already check the related return value,
>>>>> >>>> so it is the architecture's duty to 'tell' the driver whether support
>>>>> >>>> io memory (e.g. define ioremap, but return NULL).
>>> >> It does so already by setting CONFIG_HAS_IOMEM=n
>> > 
>> > Excuse me, I use "grep -rn ioremap *" under "include/" and "arch/um/"
>> > directory, but can not find the related definition for 'ioremap'.
>> > 
>> > Is there another declaration or definition way which I don't know ?
>> > (maybe it is).
> Both UML and s390 (in the !CONFIG_PCI) do not define ioremap() because
> without io memory you cannot have a ioremap().
> 

I assume if ioremap() return NULL, it means "without io memory", is it
correct ?

If it is correct, "define a dummy ioremap(), and return NULL" is just
the meaning that you mentioned above.

If so, for UML, it is not requirement, but recommend to define a dummy
ioremap() which return NULL, so can be generic enough to mach all cases.


>> > For our case, the ".config" file does not define 'CONFIG_HAS_IOMEM', can
>> > I assume it means "CONFIG_HAS_IOMEM=n" ?
> If I'm not mistaken it works the other way around.
> All archs except UML and s390 set CONFIG_HAS_IOMEM=y.

I guess so, too.


Thanks.
-- 
Chen Gang

Asianux Corporation
