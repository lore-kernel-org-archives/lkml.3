Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaFFSxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:53:32 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62537 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaFFSx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <53920B05.9010602@mit.edu>
References: <CACkGtriM1jwP9OSED21mNrKWPubeJp9YjL-8uetLqhjqfoH=Lg@mail.gmail.com>
	<CACkGtrincr-oEu5Aq2EpYmbJDVSzuzwLguOaUvRY4uBqz=5-6A@mail.gmail.com>
	<53920B05.9010602@mit.edu>
Date: Fri, 6 Jun 2014 11:53:29 -0700
Message-ID: <CACkGtrhbOYAEGF=c1Mii9ssXzLMb2YEcnwNdh6PW1Djnyb_QxA@mail.gmail.com>
Subject: Re: "." in vmlinux.lds.S
From: =?UTF-8?B?SMOhbiBTaMSbbiAo5rKI5ra1KQ==?= <shenhan@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, the symbol "__end_rodata_hpage_align" is defined as absolute in
older binutils, the newer binutils making it relative seems
meaningless in this context.

On Fri, Jun 6, 2014 at 11:40 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 06/06/2014 10:08 AM, Hán Shěn (沈涵) wrote:
>> A gentle ping?
>>
>> On Tue, Jun 3, 2014 at 2:46 PM, Hán Shěn (沈涵) <shenhan@google.com> wrote:
>>> Hi we are trying to boot up a x86_64 chrome book using binutils 2.24 and
>>> kernel 3.8, but failed.
>>>
>>> After some triage work, we found that a 2-year-old binutil CL changed the
>>> interpretation of "." in linker script （short story: absolute -> relative,
>>> long story: https://sourceware.org/ml/binutils/2012-06/msg00155.html).
>>>
>>> After some further work, we are able to boot the kernel with a kernel patch
>>> pasted at EOM. I am curious, why the upstream kernel is never hit by this
>>> behavior? We enabled "CONFIG_DEBUG_RODATA", so we were hit, is this some
>>> macro not usually turned on?
>
> What does a section-relative symbol do?
>
> --Andy



-- 
Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
