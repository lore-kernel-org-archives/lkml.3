Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3EVKBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:01:07 -0400
Received: from mx10.gouders.net ([89.244.147.155]:46073 "EHLO mx10.gouders.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab3EVKBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:01:03 -0400
Authentication-Results: mx10.gouders.net; dkim=none reason="no signature";
	dkim-adsp=discard
From: Dirk Gouders <dirk@gouders.net>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 22 May 2013 12:00:21 +0200
Message-ID: <giy5b7uyfe.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

I am having problems with building liblk, but opposed to the recent
problem that Jiri noticed (commit b28b130719af6 Fix _FORTIFY_SOURCE
builds) I am getting errors because _FORTIFY_SOURCE is redefined:

<command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
debugfs.c:1:0: note: this is the location of the previous definition
cc1: all warnings being treated as errors

I guess this is because of different gcc versions being in use.
With gcc-4.7.2 _FORTIFY_SOURCE is defined as

$ gcc -E -dM - < /dev/null | grep -i fortify
#define _FORTIFY_SOURCE ((defined __OPTIMIZE__ && __OPTIMIZE__ > 0) ? 2 : 0)

gcc-4.6.4 uses

#define _FORTIFY_SOURCE 2

and would complain if we set _FORTIFY_SOURCE to something other than 2.

gcc-4.2.2 seems to use no definition of _FORTIFY_SOURCE, by default.

What probably might help in any case is undefining _FORTIFY_SOURCE before
defining it, because as far as I know, there is no problem with
undefining something that is not yet defined, but I could imagine,
others might have more elegant suggestions:

CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC

Dirk
