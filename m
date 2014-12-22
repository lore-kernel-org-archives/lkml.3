Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaLVWni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:43:38 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:46203 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaLVWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:43:37 -0500
Message-ID: <1419288214.8696.14.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>, mmarek@suse.cz
Date: Mon, 22 Dec 2014 14:43:34 -0800
In-Reply-To: <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
	 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
	 <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
	 <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 21:56 +0100, Jiri Kosina wrote:
> On Mon, 22 Dec 2014, Andrew Morton wrote:
> 
> > On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > Just hit the following build failure with CONFIG_AUDIT=y:
> > > 
> > > arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> > > arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> > > arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> > > make[2]: *** [arch/x86/ia32/audit.o] Error 1
> > > make[1]: *** [arch/x86/ia32] Error 2
> > > make: *** [arch/x86] Error 2
> > > make: *** Waiting for unfinished jobs....
> > 
> > Your .config works for me.  Does a `make mrproper' fix it?
> > 
> > I've seen a few reports like this in recent months.  Something's
> > up with the build dependency system.
> 
> Let's add Michal Marek to CC then.
> 

Yep, post 'make mrproper' builds with CONFIG_AUDIT=y don't hit this
failure.

The previous build was with v3.18-rc2 btw.

--nab

