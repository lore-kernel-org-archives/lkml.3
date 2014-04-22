Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaDVLUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:20:50 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49549 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaDVLUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <16597012.pEkDc99HDN@wuerfel>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<5354AD36.5090809@zytor.com>
	<CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
	<16597012.pEkDc99HDN@wuerfel>
Date: Tue, 22 Apr 2014 19:20:45 +0800
X-Google-Sender-Auth: DWPPIU4w6cMp9Js5BtjRplDHwc4
Message-ID: <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>> Hi Arnd and Peter Anvin,
>>
>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>> that we don't need to have 64 bit off_t? See detail in link below.
>> I can submit the patches for 64-bit time changes
>> (include/asm-generic/posix_types.h and other archs) if everyone is
>> agreed on this.
>
> Yes.
Okay, will doing that.

>
>> Excerpt from https://lkml.org/lkml/2012/11/14/358 :
>> "Obviously, we want to use 64-bit off_t, but this is achieved already
>> through loff_t, which is used in all places in the asm-generic
>> ABI anyway (the syscalls using off_t are stripped out). I don't
>> think we want to have the other ones set to 64 bit on ARC or Meta,
>> although I'm not 100% sure about ino_t and nlink_t. "
>
> This is all still true. You should have no syscall using 'off_t',
> only loff_t.
>
> I still don't know whether we would want 32 or 64 bit ino_t and nlink_t
> for new architectures. It seems it would gain very little, but have
> a noticeable overhead.
Anyone have comment on this?
Chung-Lin (in CC list) is our nios2 toolchain maintainer. Do you have
any comment for 32 or 64 bit ino_t and nlink_t?
We will update the toolchain to support 64-bit time_t, so we hope that
any other toolchain change can happen in one time.

Thanks

Regards
Ley Foon
