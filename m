Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaGLShw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:37:52 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53817 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaGLShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:37:50 -0400
Date: Sat, 12 Jul 2014 20:37:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
Message-ID: <20140712183748.GW18735@two.firstfloor.org>
References: <cover.1405095200.git.luto@amacapital.net>
 <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
 <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
 <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems like it's asking for trouble.  I think wxe'd have to
> separately save the selectors and the base registers to avoid breaking
> something, especially once wrgsbase, etc are enabled.

I agree, it would likely break existing code.

> Linus, for context, the other patch in this series saves and restores
> SS. 

> Without that, 64-bit sigreturn to a nondefault stack segment is
> basically impossible.  

Why would you ever want to do that?

-Andi
