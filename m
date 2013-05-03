Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3ECJzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:55:20 -0400
Received: from mail.nanl.de ([217.115.11.12]:40146 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762976Ab3ECJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305022303510.2891@ionos>
References: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
 <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com> <alpine.LFD.2.02.1305022303510.2891@ionos>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 3 May 2013 11:54:43 +0200
Message-ID: <CAOiHx=khrx+kx_Dv8-DOtm2U9Pv5qW+9HUZyFZQ1joHKY+91-w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Enable interrupts before WAIT instruction.
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 11:04 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>
> On Thu, 2 May 2013, David Daney wrote:
>
>> From: David Daney <david.daney@cavium.com>
>>
>> As noted by Thomas Gleixner:
>>
>>    commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
>>    not realize that MIPS wants to invoke the wait instructions with
>>    interrupts enabled.
>>
>> Instead of enabling interrupts in arch_cpu_idle() as Thomas' initial
>> patch does, we follow Linus' suggestion of doing it in the assembly
>> code to prevent the compiler from rearranging things.
>
> Yeah, that looks way more sane.

In a first quick test I can also confirm that it seems to work (as an
alternative to the other fix).


Jonas
