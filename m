Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaCAHyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 02:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaCAHyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 02:54:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140228211758.GB2517@katana>
References: <20140228211758.GB2517@katana> <20140218203346.GG18768@katana> <20140109214954.25590.73057.stgit@warthog.procyon.org.uk> <10892.1393506444@warthog.procyon.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dhowells@redhat.com, wolfram@the-dreams.de, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
Date: Sat, 01 Mar 2014 07:54:13 +0000
Message-ID: <24692.1393660453@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> wrote:

> > > And for the buffer: %*phN is difficult to read IMO. What about %*ph? Or
> > > %*phD at least?
> > 
> > My problem with that is that it increases the length of the output by 50%
> > and there's a hard limit on how much output we may produce.
> 
> Is it PAGE_SIZE? How is this handled when the buffer is so big that the
> limit will be reached anyhow? Note that it is really uncommon to
> transfer kilobytes in one go via i2c. Usually, big transfers are split
> up into smaller fragments, say 128-256 byte. So, for readability, I'd
> still favour %*ph.

I was thinking that limited the size of the output field to 64 bytes.  But
reading vsprintf.c again, it appears it's actually the size of the binary blob
that it's converting to hex that's limited to 64 bytes.

I would prefer shorter lines - 128 bytes of hex still isn't entirely readable,
even with separators interpolated, but I'll add this.

David
