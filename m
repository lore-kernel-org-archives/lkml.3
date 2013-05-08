Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EHTKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:10:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3EHTKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:10:49 -0400
Message-ID: <518AA321.6070900@zytor.com>
Date: Wed, 08 May 2013 12:10:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sonnyrao@chromium.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com> <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
In-Reply-To: <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 03:03 PM, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 2:53 PM, Pierre-Loup A. Griffais
> <pgriffais@valvesoftware.com> wrote:
>>
>> Other than this particular concern, what's the high-level take-away? Is PAE
>> support in the Linux kernel a false promise than distros should not be
>> shipping by default, if at all? Should it be removed from the kernel
>> entirely if these configurations are knowingly broken by commits like this?
> 
> PAE is "make it barely work". The whole concept is fundamentally
> flawed, and anybody who runs a 32-bit kernel with 16GB or RAM doesn't
> even understand *how* flawed and stupid that is.
> 

Let's be straight... the problem isn't PAE per se, the problem is
*HIGHMEM*.  PAE just allows HIGHMEM to stretch further into problematic
territory.

Distros install PAE kernels by default because it is required to support
NX.  That is fine.

The problem is that once your memory crosses the HIGHMEM threshold
-- 896 MiB in the normal configuration -- then you are in "this is going
to hurt" territory.  I have seen HIGHMEM devastate performance without
even crossing the 4 GiB threshold where PAE is required.

We kernel guys have been asking the distros to ship 64-bit kernels even
in their 32-bit distros for many years, but concerns of compat issues
and the desire to deprecate 32-bit userspace seems to have kept that
from happening.

	-hpa


