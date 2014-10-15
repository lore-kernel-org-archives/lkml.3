Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaJOGiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:38:51 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49164 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJOGiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141015020811.7904E14011B@ozlabs.org>
References: <1412919926-13123-1-git-send-email-vvijayan@mvista.com> <20141015020811.7904E14011B@ozlabs.org>
From: Vineeth Vijayan <vvijayan@mvista.com>
Date: Wed, 15 Oct 2014 12:08:29 +0530
Message-ID: <CAOpNGcsgX0wVOgMN77+RuKVsb_iHQ7XQk8U_05-up__wC6zuZQ@mail.gmail.com>
Subject: Re: powerpc: Fix Text randomization
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 7:38 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Fri, 2014-10-10 at 05:45:26 UTC, Vineeth Vijayan wrote:
>> Right now there is no way to disable TEXT randomization on a PPC32
>> machine. text randomization happens even in the case of "echo 0 >
>> /proc/sys/kernel/randomize_va_space"
>
> Yeah it seems to happen on ppc64 too.
>
>> This happens due to the incorrect definition of ELF_ET_DYN_BASE at
>> arch/powerpc/include/asm/elf.h
>
> What is incorrect about it? We are not the only arch that does that.
>

I think we are one of the arch which does it.
The same has been tested on x86 and arm, where ELF_ET_DYN_BASE doesn’t
use randomize_et_dyn call, and it works properly as per the user-space
definition of randomization;

(i.e when at "echo 0 > /proc/sys/kernel/randomize_va_space", TEXT
randomization should not happen.)

> I'm not clear on what has changed to break this?
>
> cheers
