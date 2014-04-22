Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaDVOuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:50:18 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:61657 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbaDVOs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:48:27 -0400
Message-ID: <53568130.7050003@codesourcery.com>
Date: Tue, 22 Apr 2014 22:48:16 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<5354AD36.5090809@zytor.com>	<CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>	<16597012.pEkDc99HDN@wuerfel> <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
In-Reply-To: <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2014 14:48:18.0839 (UTC) FILETIME=[E6626A70:01CF5E39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>> Hi Arnd and Peter Anvin,
>>>
>>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>> that we don't need to have 64 bit off_t? See detail in link below.
>>> I can submit the patches for 64-bit time changes
>>> (include/asm-generic/posix_types.h and other archs) if everyone is
>>> agreed on this.
>>
>> Yes.
> Okay, will doing that.
> 
>>
>>> Excerpt from https://lkml.org/lkml/2012/11/14/358 :
>>> "Obviously, we want to use 64-bit off_t, but this is achieved already
>>> through loff_t, which is used in all places in the asm-generic
>>> ABI anyway (the syscalls using off_t are stripped out). I don't
>>> think we want to have the other ones set to 64 bit on ARC or Meta,
>>> although I'm not 100% sure about ino_t and nlink_t. "
>>
>> This is all still true. You should have no syscall using 'off_t',
>> only loff_t.
>>
>> I still don't know whether we would want 32 or 64 bit ino_t and nlink_t
>> for new architectures. It seems it would gain very little, but have
>> a noticeable overhead.
> Anyone have comment on this?
> Chung-Lin (in CC list) is our nios2 toolchain maintainer. Do you have
> any comment for 32 or 64 bit ino_t and nlink_t?
> We will update the toolchain to support 64-bit time_t, so we hope that
> any other toolchain change can happen in one time.

For ino_t, 32-bit users of linux-generic glibc already use struct
stat64, stat64(), etc. to align with 64-bit targets, so in terms of the
glibc/kernel interface it doesn't matter much.  The in-kernel usage of
the ino_t type should be of more concern here.

nlink_t appears to be always defined as u32 in <linux/types.h>, not sure
if changing it to arch-overridable is reasonable.

Chung-Lin



