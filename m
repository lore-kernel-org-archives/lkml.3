Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbbA0Tw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:52:26 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:44714 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbbA0TwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:52:21 -0500
Date: Tue, 27 Jan 2015 20:52:13 +0100
From: Rabin Vincent <rabin@rab.in>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: set ksymtab/kcrctab* section addresses to 0x0
Message-ID: <20150127195213.GA3151@dator>
References: <1422305155-23136-1-git-send-email-rabin.vincent@axis.com>
 <87d261rtiv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d261rtiv.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:20:32AM +1030, Rusty Russell wrote:
> Rabin Vincent <rabin.vincent@axis.com> writes:
> > These __ksymtab*/__kcrctab* sections currently have non-zero addresses.
> > Non-zero section addresses in a relocatable ELF confuse GDB and it ends
> > up not relocating all symbols when add-symbol-file is used on modules
> > which have exports.  The kernel's module loader does not care about
> > these addresses, so let's just set them to zero.
> 
>         You're right, we don't use sh_addr.  This should be safe, I've
> applied it for the next merge window.

Thanks.

> AFAICT this would have always been a problem; wonder if it should be
> CC:stable?  I don't use gdb on modules so haven't got a good feel for
> how many people this would be hurting.

I've no opinion on -stable.  This method of debugging kernel modules is
described in for example LDD3, so it would be nice if it worked in all
cases, but I guess most people won't be affected even if they use it
since it only affects modules with exported symbols.
