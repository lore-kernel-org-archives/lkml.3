Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3FCJky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:40:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21487 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3FCJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:40:52 -0400
X-Spam-Score: -100.8
Message-ID: <51AC6472.3060606@asianux.com>
Date: Mon, 03 Jun 2013 17:40:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: schmitz <schmitz@biophys.uni-duesseldorf.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        schmitz@debian.org, Sam Ravnborg <sam@ravnborg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl'
 and 'outsl' need '<< 2'
References: <51A71E49.1000707@asianux.com> <CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com> <51A93FA0.1050203@biophys.uni-duesseldorf.de> <51A94281.7050708@biophys.uni-duesseldorf.de>
In-Reply-To: <51A94281.7050708@biophys.uni-duesseldorf.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 08:38 AM, schmitz wrote:
> All,
>> Geert ,
>>>>
>>>> The related git number:
>>>>   for parport.h: "4914802 m68k,m68knommu: merge header files" in 2009
>>>>   for io_mm.h: "84b16b7 m68k/atari: ROM port ISA adapter support" in
>>>> Apr 6 2013
>>>>
>>>> The related warning (make EXTRA_CFLAG=-W ARCH=m68k allmodconfig):
>>>>   arch/m68k/include/asm/parport.h:14:0: warning: "insl" redefined
>>>> [enabled by default]
>>>>   arch/m68k/include/asm/io_mm.h:403:0: note: this is the location of
>>>> the previous definition
>>>>   arch/m68k/include/asm/parport.h:15:0: warning: "outsl" redefined
>>>> [enabled by default]
>>>>   arch/m68k/include/asm/io_mm.h:406:0: note: this is the location of
>>>> the previous definition
>>>>     
>> Is that the same problem Thorsten reported recently? parport.h should
>> either use what the arch io.h include defined, or (in the case of Q40
>> on m68k) undef and redefine as needed.
> It appears this is the same issue, see message ID
> loom.20130511T171757-995@post.gmane.org to linux-m68k (May 12th, by
> Thorsten Glaser).
> 
> This _only_ applies to use of insl/outsl macros in parport_pc.h, which
> is only used by Q40 on m68k. I see no reason to change anything in io.h
> to cope with this warning.

It sounds reasonable.

And excuse me, could you provide the related link directly ?  I don't
know how to see the detail of 'loom.20130511T171757-995@post.gmane.org'.


Thanks.
-- 
Chen Gang

Asianux Corporation
