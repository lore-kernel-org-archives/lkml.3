Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3EQQIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:08:47 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:46729 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3EQQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:08:46 -0400
Message-ID: <5196560A.1070702@gmail.com>
Date: Fri, 17 May 2013 09:08:42 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: dirk.brandewie@gmail.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add additional supported CPU ID's
References: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com> <CA+55aFwH08aEe3nJRFobofA9C_J5RnRmBWgMMJZyXTMuhP3j4w@mail.gmail.com>
In-Reply-To: <CA+55aFwH08aEe3nJRFobofA9C_J5RnRmBWgMMJZyXTMuhP3j4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 08:47 AM, Linus Torvalds wrote:
> On Fri, May 17, 2013 at 7:38 AM,  <dirk.brandewie@gmail.com> wrote:
>>
>> Add CPU ID's for supported Sandybridge and Ivybrigde processors.
>
> Hmm. Isn't 0x25 "Westmere"?
>

I will update the patch to only include Ivy bridge.  This was a brain fade on my 
part.

> Are the model numbers listed in some doc? I hate this "add random
> numbers (not even in order) without any logic to it".
>

The numbers to marketing name decoding are in system programming manual.
I don't know of a model number to project name list.


> Here's the list we have of family six numbers from
> arch/x86/kernel/cpu/intel.c (used for tlb-flushall crap):
>
>          case 0x60f: /* original 65 nm celeron/pentium/core2/xeon,
> "Merom"/"Conroe" */
>          case 0x616: /* single-core 65 nm celeron/core2solo
> "Merom-L"/"Conroe-L" */
>          case 0x617: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
>          case 0x61d: /* six-core 45 nm xeon "Dunnington" */
>          case 0x61a: /* 45 nm nehalem, "Bloomfield" */
>          case 0x61e: /* 45 nm nehalem, "Lynnfield" */
>          case 0x625: /* 32 nm nehalem, "Clarkdale" */
>          case 0x62c: /* 32 nm nehalem, "Gulftown" */
>          case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
>          case 0x62f: /* 32 nm Xeon E7 */
>          case 0x62a: /* SandyBridge */
>          case 0x62d: /* SandyBridge, "Romely-EP" */
>          case 0x63a: /* Ivybridge */
>
> so it has 0x25 as "Clarkdale" (what's Westmere vs Clarkdale? - Intel
> codenames always seem like a f*cking exercise in trying to confuse
> you). But not SB in any case.
>
> So we used to have the two SB cases listed (2a/2d). Your patch adds
> Clarkdale/Ivybridge (but not in the right order). What about the other
> ones?
>
intel_pstate is intended only for SandyBridge+ CPU's

>                 Linus
>

