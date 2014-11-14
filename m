Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaKNIs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:48:28 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40256 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaKNIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:48:27 -0500
MIME-Version: 1.0
In-Reply-To: <1415946050.26378.3.camel@concordia>
References: <1412919926-13123-1-git-send-email-vvijayan@mvista.com>
 <20141015020811.7904E14011B@ozlabs.org> <CAOpNGcsgX0wVOgMN77+RuKVsb_iHQ7XQk8U_05-up__wC6zuZQ@mail.gmail.com>
 <CAOpNGcsQX1d4=MpHKKKnBotBb11dq55_kQp4PG8OA++U6peqKg@mail.gmail.com> <1415946050.26378.3.camel@concordia>
From: Vineeth Vijayan <vvijayan@mvista.com>
Date: Fri, 14 Nov 2014 14:18:06 +0530
Message-ID: <CAOpNGcu5UDP93FSoKSKJZJYBL_dK7i3KHn3OGzORR67odGjgzA@mail.gmail.com>
Subject: Re: powerpc: Fix Text randomization
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:50 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Fri, 2014-11-14 at 11:03 +0530, Vineeth Vijayan wrote:
>> ping !
>>
>> any update on this ? As i understand, only powerpc and s390 uses the
>> randomize_et_dyn call; for all other architecture this is an obsolete
>> function call.
>
> I asked:
>
>> >> I'm not clear on what has changed to break this?
>

Disabling PIE randomization was added in the commit
a3defbe5c337dbc6da911f8cc49ae3cc3b49b453
(binfmt_elf: fix PIE execution with randomization disabled). The
randomization is decided as
per the randomize_va_space sysctl flag.

As i understand, the randomization of the base address is implemented
at elf_map and not from the
arch/<>/include/asm/elf.h

Now, for powerpc, there's no support to disable the PIE randomization,
even after we disable the
same form randomize_va_space sysctl.This patch gives the support to
disable PIE randomization in
case it is disabled from this sysctl.

> And you didn't tell me.
>
>> this call for another patch where randomize_et_dyn is removed.
>
> Patches welcome :)
>

i will follow up with the patch.

> cheers
>
>
