Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaEEHN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:13:58 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:49003 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaEEHNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:13:55 -0400
MIME-Version: 1.0
In-Reply-To: <5393488.r5N1ijHzS4@wuerfel>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
	<CAFiDJ58MT1z-hw6_ZWBc5QcCJoEdNCdaVPfVgXE2BpUr9c9ztA@mail.gmail.com>
	<5393488.r5N1ijHzS4@wuerfel>
Date: Mon, 5 May 2014 15:13:54 +0800
X-Google-Sender-Auth: JliL2dwM6GL0vVS_2W_moWfifZY
Message-ID: <CAFiDJ5-p5ROcB80899Kh0cO_pVihgA1zZONtcmCZErGYnN_BuQ@mail.gmail.com>
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 8:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> I would recommend just doing all of this in out-of-line implementations
>> >> rather than macros and inline functions.
>> > Okay. Will move the macros to out-of-line function.
>>
>> I'm start working on this and found that it is better to keep it as
>> macros. This is because the input arguments "a" and "b" can be
>> byte/short/int pointers. Otherwise, we need to have separate function
>> calls for byte/short/int.
>
> But with the inline implementation, you have a separate instance for each
> caller, which seems more wasteful.
>
> You can put the function into a "lib" file to make sure it doesn't get linked
> in if there are no callers though. And of course you can keep the macro
> in the file implementing it so you don't have to write the same code
> three times.
I think we need to link these functions always (and export symbol)
because they might used by loadable module.
So, will keep these as macros and change the inline functions to
out-of-line implementation.

Thanks.

Regards
Ley Foon
