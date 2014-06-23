Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaFWJ3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:29:49 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55860 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaFWJ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:29:46 -0400
Date: Mon, 23 Jun 2014 02:29:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: plug false-positive warning in get_prompt_str()
 seen with gcc-4.9
In-Reply-To: <20140623054813.GG13440@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1406230228370.8821@chino.kir.corp.google.com>
References: <20140525164751.28577.74072.stgit@zurg> <20140623054813.GG13440@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1459598461-1403515783=:8821"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1459598461-1403515783=:8821
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 23 Jun 2014, Uwe Kleine-König wrote:

> > scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> > scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >      jump->offset = strlen(r->s);
> >                   ^
> > scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
> >   struct jump_key *jump;
> >                    ^
> 
> I'm seeing that problem with a 4.8.2 toolchain on next-20140623 with
> ARCH=arm, too.
> 
> Maybe better use uninitialized_var? And point out the commit that
> introduced the issue please.
> 

If the compiler can't figure out if a variable is always intialized before 
its referenced, then it indicates the code is poorly written and isn't 
clear to the code reader either.  uninitialized_var() would be a lazy way 
to solve this particular issue.
--531381512-1459598461-1403515783=:8821--
