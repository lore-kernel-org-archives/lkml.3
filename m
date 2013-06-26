Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3FZKRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:17:25 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751513Ab3FZKRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:17:23 -0400
Message-ID: <51CABFAC.1040505@nod.at>
Date: Wed, 26 Jun 2013 12:17:16 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Jeff Dike <jdike@addtoit.com>,
        Arnd Bergmann <arnd@arndb.de>, David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com> <51CABBDD.403@asianux.com>
In-Reply-To: <51CABBDD.403@asianux.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2013 12:01, schrieb Chen Gang:
> On 06/26/2013 05:48 PM, Geert Uytterhoeven wrote:
>> On Wed, Jun 26, 2013 at 11:38 AM, Richard Weinberger <richard@nod.at> wrote:
>>>>>> Since the API itself already contents the meaning: "return NULL means
>>>>>> the arch has no related io memory",
>> No, NULL means it could not map the I/O memory.
>>
> 
> "it could not map the I/O memory" includes "has no related io memory".
> So it is enough for our case.
> 
>>>>>> Why not define a generic dummy one in "include/asm-generic/io.h" instead
>>>>>> of "HAS_IOMEM" (which has already spread many various places, and also,
>>>>>> most of new drivers have to know about it).
>>>>>>
>>>>>> e.g: in "include/asm-generic/io.h", if "CONFIG_HAS_IOMEM=n", define a
>>>>>> dummy ioremap() which return NULL ... (also need consider more details).
>>>>
>>>> Because we don't even want to build these drivers and not make them fail while
>>>> executing io memory related functions.
>> Indeed, it doesn't make sense to build drivers that cannot work.
>> And they may fail in a very bad way.
> 
> That is our 'platform' guys feeling, not the 'module' guys, as
> 'platform' guys, it is better to provide the choice to 'module' guys,
> and let them decide by themselves, not forced by us.

FYI, this is my last reply to this thread.

As Geert and I said, drivers which need io memory have to depend on HAS_IOMEM=y.
If an arch does not have io memory these drivers cannot work and therefore we don't
want them built.

Over and out,
//richard
