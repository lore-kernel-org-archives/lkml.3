Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaGLSkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:40:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49190 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaGLSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:40:42 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140712183748.GW18735@two.firstfloor.org>
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net> <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com> <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com> <20140712183748.GW18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 12 Jul 2014 11:40:03 -0700
To: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>
Message-ID: <0795204d-575c-40b9-b5b0-75ab14eee330@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because you are doing something weird (like Pin, for example) and take an asynchronous fault?

On July 12, 2014 11:37:48 AM PDT, Andi Kleen <andi@firstfloor.org> wrote:
>> This seems like it's asking for trouble.  I think wxe'd have to
>> separately save the selectors and the base registers to avoid
>breaking
>> something, especially once wrgsbase, etc are enabled.
>
>I agree, it would likely break existing code.
>
>> Linus, for context, the other patch in this series saves and restores
>> SS. 
>
>> Without that, 64-bit sigreturn to a nondefault stack segment is
>> basically impossible.  
>
>Why would you ever want to do that?
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
