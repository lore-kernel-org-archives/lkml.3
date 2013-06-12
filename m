Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3FLRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:01:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59161 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3FLRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLoSLu7Yp9Rc=SFp55UxeKT26=Cn+zuCb_Scnuc+gPFNQ@mail.gmail.com>
References: <20130611185846.GA23707@www.outflux.net>
	<CAOJsxLHW6JE81hBWM2UEWbCLQtyhRok0YWtF=CRPBjTbfYagXw@mail.gmail.com>
	<CAGXu5jLoSLu7Yp9Rc=SFp55UxeKT26=Cn+zuCb_Scnuc+gPFNQ@mail.gmail.com>
Date: Wed, 12 Jun 2013 20:01:25 +0300
X-Google-Sender-Auth: vKkhi-MqmBIXUX5URwuXHF4sxCg
Message-ID: <CAOJsxLH0VSoSS6eskyzG1roR3=GeHR4OcfBapq7nNFXqom6UNQ@mail.gmail.com>
Subject: Re: [PATCH] x86, relocs: move ELF relocation handling to C
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 maintainers <x86@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 7:26 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jun 11, 2013 at 11:27 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> Hello Kees,
>>
>> On Tue, Jun 11, 2013 at 9:58 PM, Kees Cook <keescook@chromium.org> wrote:
>>> Moves the relocation handling into C, after decompression. This requires
>>> that the decompressed size is passed to the decompression routine as
>>> well so that relocations can be found. Only kernels that need relocation
>>> support will use the code.
>>>
>>> Based on work by Neill Clift and Michael Davidson.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> How does the kernel benefit from this? Are there problems with the current
>> assembly code? Are you planning to improve the relocation code?
>
> Yes, this is continuing the work needed for 64-bit relocations,
> ultimately needed by KASLR. As part of the work, I was asked to move
> the relocation logic from assembly into C. Doing this means that there
> isn't any need for duplicating the logic in the 64-bit path (e.g.
> head_64.S).
>
> Since the other relocation work is already in the tree, I wanted to
> get these last two pieces in (one was a fix for the __vvar_page --
> separate patch, the other is this one, allowing 64-bit relocations to
> operate while also moving the logic into C).

OK, that's definitely changelog material.

I'm not that familiar with the code your touching but FWIW:

Reviewed-by: Pekka Enberg <penberg@kernel.org>
