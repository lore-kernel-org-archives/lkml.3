Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaLVXCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:02:17 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:38095 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaLVXCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:02:13 -0500
MIME-Version: 1.0
In-Reply-To: <1419288214.8696.14.camel@haakon3.risingtidesystems.com>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
	<1419145899.8696.5.camel@haakon3.risingtidesystems.com>
	<20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
	<alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>
	<1419288214.8696.14.camel@haakon3.risingtidesystems.com>
Date: Mon, 22 Dec 2014 15:02:12 -0800
X-Google-Sender-Auth: KAx9xM1No1Ot_2GKWOXLAY8he50
Message-ID: <CA+55aFxvP8i37MUkioxs6wjT8WKdTPuLrMiV0NZLYyGKpjeomg@mail.gmail.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 2:43 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Mon, 2014-12-22 at 21:56 +0100, Jiri Kosina wrote:
>> On Mon, 22 Dec 2014, Andrew Morton wrote:
>>
>> > On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>> >
>> > > Just hit the following build failure with CONFIG_AUDIT=y:
>> > >
>> > > arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
>> > > arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
>> > > arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
>> > > make[2]: *** [arch/x86/ia32/audit.o] Error 1
>> > > make[1]: *** [arch/x86/ia32] Error 2
>> > > make: *** [arch/x86] Error 2
>> > > make: *** Waiting for unfinished jobs....
>> >
>
> Yep, post 'make mrproper' builds with CONFIG_AUDIT=y don't hit this
> failure.
>
> The previous build was with v3.18-rc2 btw.

Hmm. So it seems that there is something wrong with the dependency
generation for the generated header files. Possibly limited to just
the uapi files.

But I can't seem to recreate it even by trying to first build 3.18-rc2
and then switching to 3.19-rc1. So there's something
not-very-straightforward going on, possibly including some nasty race
in the Makefiles.

                         Linus
