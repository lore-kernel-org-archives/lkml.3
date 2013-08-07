Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3HGUUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:20:17 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:47023 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756928Ab3HGUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:20:16 -0400
Message-ID: <5202ABEF.10107@akamai.com>
Date: Wed, 07 Aug 2013 16:19:59 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
References: <20130807173606.872055511@goodmis.org> <1375898048.6848.18.camel@gandalf.local.home> <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
In-Reply-To: <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:22 PM, Linus Torvalds wrote:
> On Wed, Aug 7, 2013 at 10:54 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On another box, using a distro config, I had even better results:
>>
>> [    2.352448] short jumps: 193
>> [    2.355407]  long jumps: 219
> .. well, another way of looking at this is to say that all of this
> effort saves just 579 bytes.
>
> Yes, maybe some of those bytes are in really hot paths, but the other
> side of *that* coin is that the 2-vs-5 byte jump doesn't much matter
> if it's already cached.
>
> So I'd vote for not doing this. If we had some simple way to do the
> short jumps, I think it would be lovely. Or if we had to parse the ELF
> files and do instruction rewriting for various other reasons, and the
> jump rewriting was just one small detail.
>
> But using 576 new lines (the diffstat for your patch 1/2 that adds the
> infrastructure to do the rewriting) in order to same just about
> exactly that many bytes in the binary - the effort just doesn't work
> out, imnsho.
>
>               Linus

The whole point of the thread started with wanting to move the default
'disabled' branch further out-of-line. We could get there with better
compiler support for the 'cold' label attribute. Thus, in theory the
whole 2-byte jmp is just an intermediate step. (Yeah, I know that
support doesn't seem to be happening anytime soon...)

Thanks,

-Jason


