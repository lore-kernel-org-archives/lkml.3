Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaB0NUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:20:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaB0NUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:20:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140218205418.GH18768@katana>
References: <20140218205418.GH18768@katana> <20140109214954.25590.73057.stgit@warthog.procyon.org.uk> <20140109215002.25590.51609.stgit@warthog.procyon.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dhowells@redhat.com, wolfram@the-dreams.de, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS
Date: Thu, 27 Feb 2014 13:19:38 +0000
Message-ID: <11165.1393507178@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> wrote:

> Although SMBus has no 10-bit addresses, we probably should also use %03x
> there for consistency reasons?

Done.

> Also, the I2C tracing has first 'f' then 'a', that should be consistent,
> too.

Flags first or address first?  Do you have a preference (for both)?

> 'flags' should be %04x again

Done.

> and I'd prefer %*ph (or %*phD) for the buffer.

Again, I'm not so certain.

> Can we have something like this for 'flags'?

There's a __print_flags() which should work.  One thing I'm concerned about
there is how do we handle more flags being added - does that count as an ABI
break if the printed format changes?

SMBus flags are basically the same as I2C flags, right?

David
