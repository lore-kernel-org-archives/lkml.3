Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaKNFdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:33:52 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:54253 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaKNFdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAOpNGcsgX0wVOgMN77+RuKVsb_iHQ7XQk8U_05-up__wC6zuZQ@mail.gmail.com>
References: <1412919926-13123-1-git-send-email-vvijayan@mvista.com>
 <20141015020811.7904E14011B@ozlabs.org> <CAOpNGcsgX0wVOgMN77+RuKVsb_iHQ7XQk8U_05-up__wC6zuZQ@mail.gmail.com>
From: Vineeth Vijayan <vvijayan@mvista.com>
Date: Fri, 14 Nov 2014 11:03:30 +0530
Message-ID: <CAOpNGcsQX1d4=MpHKKKnBotBb11dq55_kQp4PG8OA++U6peqKg@mail.gmail.com>
Subject: Re: powerpc: Fix Text randomization
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping !

any update on this ? As i understand, only powerpc and s390 uses the
randomize_et_dyn call; for all other architecture this is an obsolete
function call.

this call for another patch where randomize_et_dyn is removed.

On Wed, Oct 15, 2014 at 12:08 PM, Vineeth Vijayan <vvijayan@mvista.com> wrote:
> On Wed, Oct 15, 2014 at 7:38 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> On Fri, 2014-10-10 at 05:45:26 UTC, Vineeth Vijayan wrote:
>>> Right now there is no way to disable TEXT randomization on a PPC32
>>> machine. text randomization happens even in the case of "echo 0 >
>>> /proc/sys/kernel/randomize_va_space"
>>
>> Yeah it seems to happen on ppc64 too.
>>
>>> This happens due to the incorrect definition of ELF_ET_DYN_BASE at
>>> arch/powerpc/include/asm/elf.h
>>
>> What is incorrect about it? We are not the only arch that does that.
>>
>
> I think we are one of the arch which does it.
> The same has been tested on x86 and arm, where ELF_ET_DYN_BASE doesn’t
> use randomize_et_dyn call, and it works properly as per the user-space
> definition of randomization;
>
> (i.e when at "echo 0 > /proc/sys/kernel/randomize_va_space", TEXT
> randomization should not happen.)
>
>> I'm not clear on what has changed to break this?
>>
>> cheers
