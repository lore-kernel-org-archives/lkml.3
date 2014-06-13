Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaFMFYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:24:08 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33963 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaFMFYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <539A890A.5090206@zytor.com>
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
 <539A890A.5090206@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 22:23:44 -0700
Message-ID: <CALCETrX9Og2LR3d8HZrcn4uGAgLfxbv51LK4Tsq-gDZKGpsjYw@mail.gmail.com>
Subject: Re: vdso feature requests from the Go people
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
>>
>> If we were to implement both, maybe we'd actually want to provide
>> something like:
>>
>> struct vdso_entry {
>>   unsigned long vdso_entry_struct_size;  /* so we can add fields later on */
>>   void *func;
>>   unsigned int max_stack;  /* zero if not known */
>> };
>>
>
> How different is this really from the .dynsym table -- other than that
> you have to find the latter via the dynamic segment?
>
> The hash part is just to speed up lookup...

As far as I know, there's no reliable way to just read the dynsym
table -- the thing doesn't have a specified length, which is what
broke Go in the first place.

Parsing the ELF dynamic tables is kind of annoyingly complicated, and
understanding the format is a real PITA -- the documentation I've been
able to find is outright terrible.

--Andy
