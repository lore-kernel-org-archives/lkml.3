Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaGLC1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:27:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaGLC1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:27:17 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net> <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 11 Jul 2014 19:26:50 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <0b46d9d7-30f7-4aee-be9e-dd83cf8056d9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our current handling of fs/vs is really weird.  The best may very well be to explicitly save and restore both fs and he as part of Andi's patchset to support wrxsbase.

On July 11, 2014 7:21:54 PM PDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Fri, Jul 11, 2014 at 9:29 AM, Andy Lutomirski <luto@amacapital.net>
>wrote:
>> As far as I can tell, these fields have been set to zero on save and
>> ignored on restore since Linux was imported into git.  Rename them
>> '__pad1' and '__pad2' to avoid confusion and to allow them to be
>> recycled some day.
>
>Shouldn't we actually try to save/restore gs/fs properly? Admittedly,
>changing them in the signal handler would be insane, but still.. See
>our context switching code  with the whole segment selector vs base
>save/restore code. Hmm?
>
>            Linus

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
