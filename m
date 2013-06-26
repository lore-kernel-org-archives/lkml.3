Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FZKB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:01:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19571 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3FZKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:01:53 -0400
X-Spam-Score: -100.8
Message-ID: <51CABBDD.403@asianux.com>
Date: Wed, 26 Jun 2013 18:01:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        Arnd Bergmann <arnd@arndb.de>, David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com>
In-Reply-To: <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:48 PM, Geert Uytterhoeven wrote:
> On Wed, Jun 26, 2013 at 11:38 AM, Richard Weinberger <richard@nod.at> wrote:
>>> >> Since the API itself already contents the meaning: "return NULL means
>>> >> the arch has no related io memory",
> No, NULL means it could not map the I/O memory.
> 

"it could not map the I/O memory" includes "has no related io memory".
So it is enough for our case.

>>> >> Why not define a generic dummy one in "include/asm-generic/io.h" instead
>>> >> of "HAS_IOMEM" (which has already spread many various places, and also,
>>> >> most of new drivers have to know about it).
>>> >>
>>> >> e.g: in "include/asm-generic/io.h", if "CONFIG_HAS_IOMEM=n", define a
>>> >> dummy ioremap() which return NULL ... (also need consider more details).
>> >
>> > Because we don't even want to build these drivers and not make them fail while
>> > executing io memory related functions.
> Indeed, it doesn't make sense to build drivers that cannot work.
> And they may fail in a very bad way.

That is our 'platform' guys feeling, not the 'module' guys, as
'platform' guys, it is better to provide the choice to 'module' guys,
and let them decide by themselves, not forced by us.


Thanks.
-- 
Chen Gang

Asianux Corporation
