Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaFFUpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:45:17 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:59169 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaFFUpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUCKMv+56TWJP3gOrpKJETz0+G8U-+=0pxF7mZyCnrjUQ@mail.gmail.com>
References: <CACkGtriM1jwP9OSED21mNrKWPubeJp9YjL-8uetLqhjqfoH=Lg@mail.gmail.com>
	<CACkGtrincr-oEu5Aq2EpYmbJDVSzuzwLguOaUvRY4uBqz=5-6A@mail.gmail.com>
	<53920B05.9010602@mit.edu>
	<CACkGtrhbOYAEGF=c1Mii9ssXzLMb2YEcnwNdh6PW1Djnyb_QxA@mail.gmail.com>
	<CALCETrUCKMv+56TWJP3gOrpKJETz0+G8U-+=0pxF7mZyCnrjUQ@mail.gmail.com>
Date: Fri, 6 Jun 2014 13:45:14 -0700
Message-ID: <CACkGtriVsYdk77frWD16MfzpENYy_-azch2LH2RBCWi7zKLa-w@mail.gmail.com>
Subject: Re: "." in vmlinux.lds.S
From: =?UTF-8?B?SMOhbiBTaMSbbiAo5rKI5ra1KQ==?= <shenhan@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, this changes "Ndx" field for the symbol. For example, one of
the symbol '__end_rodata_hpage_align' in symtab, the contents changed
from
    50206: ffffffff81800000     0 NOTYPE  GLOBAL DEFAULT  ABS
__end_rodata_hpage_align
which is correct, to
    50206: ffffffff81800000     0 NOTYPE  GLOBAL DEFAULT   25
__end_rodata_hpage_align
(25 is the index to section '.data')
which is wrong.

Han



On Fri, Jun 6, 2014 at 12:08 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 6, 2014 at 11:53 AM, Hán Shěn (沈涵) <shenhan@google.com> wrote:
>> Yeah, the symbol "__end_rodata_hpage_align" is defined as absolute in
>> older binutils, the newer binutils making it relative seems
>> meaningless in this context.
>
> What I mean is: what actually changes in the linker output when the
> symbol is relative?
>
> --Andy
>
>>
>> On Fri, Jun 6, 2014 at 11:40 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On 06/06/2014 10:08 AM, Hán Shěn (沈涵) wrote:
>>>> A gentle ping?
>>>>
>>>> On Tue, Jun 3, 2014 at 2:46 PM, Hán Shěn (沈涵) <shenhan@google.com> wrote:
>>>>> Hi we are trying to boot up a x86_64 chrome book using binutils 2.24 and
>>>>> kernel 3.8, but failed.
>>>>>
>>>>> After some triage work, we found that a 2-year-old binutil CL changed the
>>>>> interpretation of "." in linker script （short story: absolute -> relative,
>>>>> long story: https://sourceware.org/ml/binutils/2012-06/msg00155.html).
>>>>>
>>>>> After some further work, we are able to boot the kernel with a kernel patch
>>>>> pasted at EOM. I am curious, why the upstream kernel is never hit by this
>>>>> behavior? We enabled "CONFIG_DEBUG_RODATA", so we were hit, is this some
>>>>> macro not usually turned on?
>>>
>>> What does a section-relative symbol do?
>>>
>>> --Andy
>>
>>
>>
>> --
>> Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC



-- 
Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
