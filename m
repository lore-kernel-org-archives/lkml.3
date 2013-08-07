Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3HGT2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:28:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53000 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab3HGT2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:28:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
References: <20130807173606.872055511@goodmis.org> <1375898048.6848.18.camel@gandalf.local.home> <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short jumps used
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 07 Aug 2013 12:27:51 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Message-ID: <2e3a4a90-2915-4b75-b807-b0e802e4955f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well we do... both to extract relocations and to sort the exception table.  Perhaps we need to merge those kinds of postprocessing tools?

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Wed, Aug 7, 2013 at 10:54 AM, Steven Rostedt <rostedt@goodmis.org>
>wrote:
>>
>> On another box, using a distro config, I had even better results:
>>
>> [    2.352448] short jumps: 193
>> [    2.355407]  long jumps: 219
>
>.. well, another way of looking at this is to say that all of this
>effort saves just 579 bytes.
>
>Yes, maybe some of those bytes are in really hot paths, but the other
>side of *that* coin is that the 2-vs-5 byte jump doesn't much matter
>if it's already cached.
>
>So I'd vote for not doing this. If we had some simple way to do the
>short jumps, I think it would be lovely. Or if we had to parse the ELF
>files and do instruction rewriting for various other reasons, and the
>jump rewriting was just one small detail.
>
>But using 576 new lines (the diffstat for your patch 1/2 that adds the
>infrastructure to do the rewriting) in order to same just about
>exactly that many bytes in the binary - the effort just doesn't work
>out, imnsho.
>
>              Linus

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
