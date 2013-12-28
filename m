Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3L1Dnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 22:43:46 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62466 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3L1Dnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 22:43:45 -0500
X-Nat-Received: from [202.181.97.72]:55254 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388202211.4376
To: akpm@linux-foundation.org
Cc: jkosina@suse.cz, joe@perches.com, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	<20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
In-Reply-To: <20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
Message-Id: <201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 28 Dec 2013 12:43:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 27122013 #7178503, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> which is painful, so we also provide the new vsprintf token as a
> convenience:
> 
> 	pr_warn("%|: hair on fire\n");
> 
> but I don't know what we can use in place of %|.

We are using %pEXTENSION where EXTENSION is [A-Za-z0-9]* because compiler does
not need to understand what EXTENSION does; compiler needs to care about what
character follows the % character and check type of corresponding argument if
__printf() attribute is given.

If we introduce a character which compiler does not know that follows the %
character, compiler would be confused when checking type of corresponding
argument.

> I wonder if there's some way in which we can invent a vsprintf token
> which means "insert corrent->comm here" and which doesn't require that
> the caller pass in the additional argument?

Therefore, if we want to omit passing corresponding argument, we should not
introduce new character which compiler does not know that follows the %
character.

Also, % is the only character which everybody knows that it is reserved for the
beginning of format specifier and %% is the only characters which everybody
knows that it is reserved for literal % character.

Therefore, what we could do for printing current thread's attributes would be
either reserve a new character and add EXTENSION like

  pr_warn("$comm$: hair on fire\n");
  pr_warn("Process $pid$: hair on fire\n");

or add EXTENSION after the %% characters like

  pr_warn("%%comm%%: hair on fire\n");
  pr_warn("Process %%pid%%: hair on fire\n");

.
