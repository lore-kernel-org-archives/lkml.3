Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaDWCxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:53:16 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44062 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaDWCxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140422162432.GA17674@ravnborg.org>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-5-git-send-email-lftan@altera.com>
	<20140422142443.GB15745@arch.cereza>
	<20140422151458.GC1053@distanz.ch>
	<20140422153522.GF15745@arch.cereza>
	<20140422162432.GA17674@ravnborg.org>
Date: Wed, 23 Apr 2014 10:53:13 +0800
Message-ID: <CAFiDJ59ewAxAXFYe5EAt1sd+nTr9f53EkV4d9+gJM9PPOcUtvw@mail.gmail.com>
Subject: Re: [PATCH 06/28] nios2: Memory management
From: "LF.Tan" <lftan.linux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:24 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> Other than being "pretty" the above fix is to remove a mismatch type
>> warning. You can get rid of the warning in different ways:
>>
>> ifdef __ASSEMBLY__
>> define PAGE_SIZE       4096
>> else
>> define PAGE_SIZE       4096UL
>> endif
>
> The usual way to do this is as follows:
> #include <linux/const.h>
>
> #define PAGE_SHIFT   12
> #define PAGE_SIZE    (_AC(1, UL) << PAGE_SHIFT)
> #define PAGE_MASK    (~(PAGE_SIZE-1))
>
> _AC(1, UL) expands to 1 for assembler and 1UL for C code.
>
> This is also what was suggested above.
>
> Please follow this scheme for nios2 too.
>
>         Sam
Sure, will change to this way.

Thanks.

Ley Foon
