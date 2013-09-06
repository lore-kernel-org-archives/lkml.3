Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab3IFJrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:47:22 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38621 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3IFJrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:47:20 -0400
Date: Fri, 6 Sep 2013 11:47:15 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
Message-ID: <20130906094715.GD3271@free.fr>
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
 <5228510C.1020906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5228510C.1020906@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-09-05 11:38 +0200, Michal Marek spake thusly:
> On 3.9.2013 23:04, Yann E. MORIN wrote:
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > Currently, the 'MODULES' symbol is hard-coded to be the default symbol
> > that enables/disables tristates, if no other symbol was declared with
> > 'option modules'.
> > 
> > While this used to be needed for the Linux kernel, we now have an
> > explicit 'option modules' attached to the 'MODULES' symbol (since
> > cset 11097a036), so we no longer need to special-case it in the
> > kconfig code.
> > 
> > Furthermore, kconfig is extensively used out of the Linux kernel, and
> > other projects may have another meaning for a symbol named 'MODULES'.
> > 
> > This patch changes the way we enable/disable tristates: if a symbol was
> > found with 'option modules' attached to it, then that symbol controls
> > enabling tristates. Otherwise, tristates are disabled, even if a symbol
> > named 'MODULES' exists.
> 
> Wasn't this change supposed to fix allmodconfig with KCONFIG_ALLCONFIG
> (http://lkml.org/lkml/2013/8/8/573)? Or is there still more to do?

This is part of the fix, and there are still things to change, yes.

I'm not done with it yet, since I was unavailable for some time, and I
just wanted this part to be reviewed/upstreamed before continuing, just
in case I was going the wrong way.

I'll be further working on this, and hope to have something at the
beginning of next week.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
