Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3HFGmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:42:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47512 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3HFGmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:42:09 -0400
Date: Tue, 6 Aug 2013 08:42:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Message-ID: <20130806064201.GR19750@two.firstfloor.org>
References: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
 <20130805225949.82a82dda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805225949.82a82dda.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:59:49PM -0700, Andrew Morton wrote:
> On Mon,  5 Aug 2013 15:09:35 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Use standard gcc __attribute__((alias(foo))) to define
> > the syscall aliases instead of custom assembler macros.
> > 
> > This is far cleaner, and also fixes my LTO kernel build.
> 
> I wonder what gcc version this was added in.  Seems fairly longstanding.

Seems to be already in 2.95, so every kernel compiler

http://gcc.gnu.org/onlinedocs/gcc-2.95.3/gcc_4.html#SEC90

> 
> >  	{								\
> >  		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
> >  	}								\
> > -	SYSCALL_ALIAS(compat_sys##name, compat_SyS##name);		\
> 
> I think we can remove the SYSCALL_ALIAS definitions?

Yes will send a followon patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
