Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbaGRGHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:07:46 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63025 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaGRGHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <12323898.sHjczXbE7P@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<alpine.DEB.2.10.1407151201170.24854@nanos>
	<CAFiDJ5-UQ4pu1Hkc444yaA6cbttTXM7KM2eProGUkYgjqvOSUg@mail.gmail.com>
	<12323898.sHjczXbE7P@wuerfel>
Date: Fri, 18 Jul 2014 14:07:42 +0800
X-Google-Sender-Auth: rmla86D5tHV-4uyWCRgoZBKyXzA
Message-ID: <CAFiDJ5-uDPCZha-s2-DrLbHLjezBkLTEjJ0nbnsMocof7kO=1Q@mail.gmail.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 7:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The get_user/put_user functions really need to be annotated might_fault(),
> because that's what they do.
>
> The whole point of get_user() is to access an unchecked user space
> pointer, which  can do a number of things based on what the pointer
> points to:
>
> - access a user space variable that resides in memory
> - access a kernel pointer and fail because of the access_ok()
>   check
> - access a user space pointer that is not mapped and return
>   through the __ex_table fixup.
> - access a user space pointer that has a valid VMA but not PTE,
>   causing a page fault to be resolved.
>
> It's the last case that breaks here.
So, do you mean that we can't use get_user/put_user in futex support?
BTW, some architectures like sh,parisc, m68k use get_user in futex
function as well.
Any recommendation way to support futex if we can't use get_user.
Note, nios2 doesn't have atomic instruction.
Thanks.

Regards
Ley Foon
