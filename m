Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3EVLWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:22:30 -0400
Received: from mx10.gouders.net ([89.244.147.155]:46152 "EHLO mx10.gouders.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab3EVLW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:22:28 -0400
Authentication-Results: mx10.gouders.net; dkim=none reason="no signature";
	dkim-adsp=discard
From: Dirk Gouders <dirk@gouders.net>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
In-Reply-To: <giy5b7uyfe.fsf@karga.hank.lab> (Dirk Gouders's message of "Wed,
	22 May 2013 12:00:21 +0200")
References: <giy5b7uyfe.fsf@karga.hank.lab>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 22 May 2013 13:22:14 +0200
Message-ID: <gitxlvuumx.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <dirk@gouders.net> writes:

> What probably might help in any case is undefining _FORTIFY_SOURCE before
> defining it, because as far as I know, there is no problem with
> undefining something that is not yet defined, but I could imagine,
> others might have more elegant suggestions:
>
> CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -U_FORTIFY_SOURCE
> -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC

More elegant would probably be to look at tools/perf/Makefile and handle
the problem as is done there:

CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC

ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
               CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
endif

I tested it here and it works well.

Dirk
