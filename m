Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaFFVPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:15:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:62136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaFFVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,991,1392192000"; 
   d="scan'208";a="543811448"
Message-ID: <53922F74.20406@linux.intel.com>
Date: Fri, 06 Jun 2014 14:15:32 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
References: <201406042235.s54MZgwP020553@terminus.zytor.com>	<20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>	<CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>	<CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com> <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
In-Reply-To: <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 02:13 PM, Linus Torvalds wrote:
> On Fri, Jun 6, 2014 at 2:09 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> The only real downside to that would be the chance of bitrot if that
>> code isn't getting used on native builds.
> 
> Sure. Does anybody really care?
> 
> You could obviously just open-code the things, but the fact is,
> "le64toh()" isn't exactly a standard function anyway, so now that I
> see it needed I go "yeah, that's clearly completely unacceptable".
> 
> I'd much rather say "screw cross-compiling" (because let's face it,
> nobody sane cross-compiles x86 on anything else) than say "screw old
> machines".
> 

I'm thinking we should just carry the support functions with us, we
already have some of those in tools/include.  Working on a patchset for
this.

	-hpa

