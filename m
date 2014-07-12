Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaGLSwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:52:07 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaGLSwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:52:04 -0400
Date: Sat, 12 Jul 2014 20:52:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
Message-ID: <20140712185202.GX18735@two.firstfloor.org>
References: <cover.1405095200.git.luto@amacapital.net>
 <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
 <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
 <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com>
 <20140712183748.GW18735@two.firstfloor.org>
 <0795204d-575c-40b9-b5b0-75ab14eee330@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0795204d-575c-40b9-b5b0-75ab14eee330@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:40:03AM -0700, H. Peter Anvin wrote:
> Because you are doing something weird (like Pin, for example) and take an asynchronous fault?

But even for pin that would need executing 16 bit code, or really weird
32bit code. AFAIK for 32bit the only good use case was NX emulation
(and old virtualization) which are both completely obsolete.

I don't think it's worth messing with the signal handlers for 16bit
code. If there's any problem with saving/restoring state that emulator 
can always handle it by itself.

-Andi
