Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaDWVQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:16:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56056 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaDWVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:16:21 -0400
Date: Wed, 23 Apr 2014 22:16:09 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        pmladek@suse.cz, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140423221609.0d3b536f@alan.etchedpixels.co.uk>
In-Reply-To: <20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
	<20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
	<20140422112259.5f106a44@alan.etchedpixels.co.uk>
	<20140423110847.GB17824@quack.suse.cz>
	<20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem of course will be in sizing the driver's queue.  Perhaps we
> can have a driver which uses a huge queue, temporarily use that driver
> during boot then switch over to a conventional console driver?

It depends how early in boot you are but this is true equally of kernel
threads and other stuff.

The big problem doing it early is that we have no mechanism to "open" a
tty port without having a tty. We do now have the split for this for
queueing input and to some extent output, but not all of the "open"
aspect. The output buffering is also quite limited for most devices but
that bit *is* easy to fix if needed.

Given this all only affects huge boxes and the only fix we have right now
is hideously ugly I'd rather it stayed in the vendor hacks to their
trees, until someone is inspired to sort it properly.

On the plus side having a queueing console that can use tty methods would
mean you could make any tty a console and special hacks for support would
be improving reliability/early functionality rather than enabling.

Essentially you can create tty_port_kopen()/tty_port_kclose() and use
the tty device write methods with a tty_port, it's just a matter of
continuing to clean up the tty/tty_port split properly.

It's not a small job though.

Alan
