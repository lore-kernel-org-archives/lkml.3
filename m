Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab3EWUdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:33:25 -0400
Received: from mx10.gouders.net ([89.244.147.155]:49939 "EHLO mx10.gouders.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab3EWUdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:33:23 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
In-Reply-To: <20130522111850.GA15091@pd.tnic> (Borislav Petkov's message of
	"Wed, 22 May 2013 13:18:50 +0200")
References: <giy5b7uyfe.fsf@karga.hank.lab> <20130522111850.GA15091@pd.tnic>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 23 May 2013 22:32:56 +0200
Message-ID: <ghppwh4etj.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

Borislav Petkov <bp@suse.de> writes:

> Hi,
>
> On Wed, May 22, 2013 at 12:00:21PM +0200, Dirk Gouders wrote:
>> CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
>
> it seems someone else hit this already and fixed it too:
>
> commit d2f32479e5526a1ab3b4e43910fcb279871524ce
> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date:   Sun Feb 17 16:03:36 2013 +0100
>
>     perf tools: check if -DFORTIFY_SOURCE=2 is allowed

I thought about this _FORTIFY_SOURCE test and how the above commit
could/should be adopted to lib/lk/Makefile, and I thought that if it
were true that recent versions of gcc define _FORTIFY_SOURCE by default,
that test could probably be modified and just check gcc's builtin macros to
find out if _FORTIFY_SOURCE has to be defined explicitely and I tried to
find out when gcc started to use _FORTIFY_SOURCE builtin definitions...

In short: all what I said in my initial post was tested with gcc
versions on gentoo machines and it is gentoo that patches gcc so that
_FORTIFY_SOURCE becomes a builtin definition.  Unfortunately I don't
have access to machines running other distributions and can only report
about gcc on gentoo, but even with this limited information I would say
it depends on the distribution in use if -D_FORTIFY_SOURCE=2 is needed
and not on the gcc version.

Sorry for the noise if you already noticed my fault, I felt I should
correct my initial misleading information.

Dirk
