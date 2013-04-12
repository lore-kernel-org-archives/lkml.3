Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3DLPIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:08:44 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:42540 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3DLPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
Date: Fri, 12 Apr 2013 18:08:41 +0300
Message-ID: <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
Subject: Re: memcmp in modules
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI.

I have an issue with memcmp, but it seems I didn't get what is
happening there. Let's consider the details.

I have a module which has one call of memcmp and licensed as Dual BSD/GPL.

#include <linux/string.h>
...
if (memcmp(...))
...
MODULE_LICENSE("Dual BSD/GPL");

I compile it for ARCH=i386 together with kernel and try to load it.

modprobe test-string_helpers

[   25.134433] test_string_helpers: no symbol version for memcmp
[   25.140156] test_string_helpers: Unknown symbol memcmp (err -22)

Then I've changed string_32.h a bit (I think it's not a solution of the issue)

-#define memcmp __builtin_memcmp
+#define memcmp(a, b, n) __builtin_memcmp(a, b, n)

And in this case:
modprobe test_string_helpers
[   15.391589] test_string_helpers: Running tests...

What did I miss?

--
With Best Regards,
Andy Shevchenko
